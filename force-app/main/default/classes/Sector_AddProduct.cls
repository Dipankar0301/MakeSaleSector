public with sharing class Sector_AddProduct  
{
    public static boolean isSandbox= [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
    @AuraEnabled
    public static responseWrapper getOpportunityProductdata(String OppId, String ProductName, String ProductFamily)
    {
        responseWrapper response = new responseWrapper();
        try
        {
            Opportunity opp = [Select Id, Pricebook2Id from Opportunity where Id  = :OppId limit 1];
            String pricebookId = opp.Pricebook2Id;
            response.ProductsList = new List<Products>();
            String queryString ='SELECT Id, Name, Product2.Family, Product2.QuantityUnitOfMeasure,Product2.Id FROM PricebookEntry where Pricebook2Id = :pricebookId ';
            String ProductNamenew = (ProductName != null && ProductName != '') ? '%'+ProductName+'%' : ProductName;
            String ProductFamilynew = (ProductFamily != null && ProductFamily != '') ? '%'+ProductFamily+'%' : ProductFamily;
            queryString = queryString + ((ProductName != null && ProductName != '') ? ' AND Name like :ProductNamenew' : '') + ((ProductFamily != null && ProductFamily != '') ? ' AND Product2.Family like :ProductFamilynew' : '' ) + ' AND IsActive = true AND Product2.IsActive  = true  order by Product_Family__c, Name limit 200';
            
            for(PricebookEntry pbe : Database.query(queryString))
            {
                Products pd = new Products();
                pd.ProductName = pbe.Name;
                pd.ProductId = pbe.Id;
                pd.Product2Id = pbe.Product2.Id;
                pd.ProductFamily = pbe.Product2.Family;
                pd.ProductUnit = pbe.Product2.QuantityUnitOfMeasure;
                response.ProductsList.add(pd);
            }
            response.responseStatus = 'success';
        }
        catch(Exception e)
        {
            response.responseStatus = 'error';
            response.responseMessage = 'Something went wrong. Error: '+e.getMessage()+'. Line number: '+e.getLineNumber()+'. StackTrace: '+e.getStackTraceString()+'. Please try reinitiate the process or contact your system admin.';
        }
        return response;
    }
    
    @AuraEnabled
    public static responseWrapper getEditProductdata(String OppId)
    {
        responseWrapper response = new responseWrapper();
        try
        {
            response.ProductsList = new List<Products>();
            Integer indexn = 0;
            for(OpportunityLineItem pbe : [SELECT Id, PricebookEntry.Id ,PricebookEntry.Product2.QuantityUnitOfMeasure ,PricebookEntry.Product2.Name, Product2.Id,
                                           PricebookEntry.Product2.Family, Volume__c, Revenue__c, Description, Total_Profit__c,Total_CO2_Emissions_Reduction_Tonnes__c,
                                           Total_Carbon_Emissions_Tonnes__c 
                                           FROM OpportunityLineItem where OpportunityId = :OppId order by CreatedDate  ])
            {
                //System.debug('line 50');
                //System.debug(pbe.Product2.Id);
                Products Ole = new Products();
                Ole.ProductName = pbe.PricebookEntry.Product2.Name;
                Ole.ProductId = pbe.PricebookEntry.Id;
                Ole.Product2Id = pbe.Product2.Id;
                Ole.OpportunityLineId = pbe.Id;
                Ole.ProductFamily = pbe.PricebookEntry.Product2.Family;
                Ole.Volume = pbe.Volume__c == null ? 0 : pbe.Volume__c;
                Ole.Revenue = pbe.Revenue__c == null ? 0 : pbe.Revenue__c;
                Ole.ProductProfit = pbe.Total_Profit__c == null ? 0 : pbe.Total_Profit__c;
                Ole.Indexnum = indexn;
                Ole.co2Emission = pbe.Total_CO2_Emissions_Reduction_Tonnes__c == null ? 0 : pbe.Total_CO2_Emissions_Reduction_Tonnes__c;//added
                Ole.carbonEmission = pbe.Total_Carbon_Emissions_Tonnes__c == null ? 0 : pbe.Total_Carbon_Emissions_Tonnes__c;//added
                Ole.ProductDescription = pbe.Description;
                Ole.ProductUnit = pbe.PricebookEntry.Product2.QuantityUnitOfMeasure;
                response.ProductsList.add(Ole);
                indexn++;
            }
            response.responseStatus = 'success';
        }
        catch(Exception e)
        {
            response.responseStatus = 'error';
            response.responseMessage = 'Something went wrong. Error: '+e.getMessage()+'. Line number: '+e.getLineNumber()+'. StackTrace: '+e.getStackTraceString()+'. Please try reinitiate the process or contact your system admin.';
        }
        return response;
    }
    
    
    @AuraEnabled
    public static responseWrapper SaveEditProductdata(String OppId, String EditProductDetails, List<String> DeletOppLineList)
    {
        responseWrapper response = new responseWrapper();
        System.debug('line 84 in saveEditProductDatas');
        system.debug(EditProductDetails);
        System.debug(DeletOppLineList);
        Savepoint sp = Database.setSavepoint();
        try
        {
            
            List<Products> ProductsList = (List<Products>)JSON.deserialize(EditProductDetails, List<Products>.class);	
            List<OpportunityLineItem> opplineupsert = new List<OpportunityLineItem>();
            for(Products producteach : ProductsList)
            {
                OpportunityLineItem opplineeach = new OpportunityLineItem();
                opplineeach.OpportunityId = OppId; 
                opplineeach.PricebookEntryId = producteach.ProductId;
                opplineeach.Product2Id = producteach.Product2Id;
                opplineeach.Quantity = 1;
                opplineeach.UnitPrice = producteach.Revenue;
                opplineeach.Volume__c = producteach.Volume;
                opplineeach.Revenue__c = producteach.Revenue;
                opplineeach.Total_Profit__c = producteach.ProductProfit;
                opplineeach.Total_CO2_Emissions_Reduction_Tonnes__c = producteach.co2Emission;//added
                opplineeach.Total_Carbon_Emissions_Tonnes__c = producteach.carbonEmission;//added
                opplineeach.Id = producteach.OpportunityLineId;
                opplineeach.Description = producteach.ProductDescription;
                opplineupsert.add(opplineeach); 
            }
            System.debug('c');
            System.debug(opplineupsert);
            upsert opplineupsert;
            //list<Database.SaveResult> results = Database.update(opplineupsert);
            //System.debug(results);
            delete [Select Id from OpportunityLineItem where Id in :DeletOppLineList];
            
            Integer indexcoun = 0;
            List<Predicted_Product_Information__c> forecastingeachproduct = new List<Predicted_Product_Information__c>();
            for(Products producteach : ProductsList)
            {
                if(producteach.startyear != null && producteach.endyear != null && producteach.startyear != '' && producteach.endyear != '')
                {
                    for(Integer yeareach = Integer.valueOf(producteach.startyear) ; yeareach <= Integer.valueOf(producteach.endyear) ; yeareach ++ )
                    {
                        Integer numberofyears = (Integer.valueOf(producteach.endyear) - Integer.valueOf(producteach.startyear) ) + 1;
                        Predicted_Product_Information__c temp_ppi = new Predicted_Product_Information__c();
                        temp_ppi.Sales_volume__c = (producteach.Volume/numberofyears).setScale(2, RoundingMode.HALF_UP);
                        temp_ppi.Revenue__c = (producteach.Revenue/numberofyears).setScale(2, RoundingMode.HALF_UP);
                        temp_ppi.Annual_Profit__c = (producteach.ProductProfit/numberofyears).setScale(2, RoundingMode.HALF_UP);
                        temp_ppi.Annual_CO2_Emissions_Reduction_Tonnes__c = (producteach.co2Emission/numberofyears).setScale(2, RoundingMode.HALF_UP);
                        temp_ppi.Annual_CO2_Emissions_Tonnes__c = (producteach.carbonEmission/numberofyears).setScale(2, RoundingMode.HALF_UP);
                        temp_ppi.Name = String.valueOf(yeareach);
                        temp_ppi.Opportunity_Product__c = opplineupsert[indexcoun].Id;  
                        temp_ppi.Opportunity__c = OppId;
                        forecastingeachproduct.add(temp_ppi);  
                    }
                }
                indexcoun++;
            }
            insert forecastingeachproduct;
            
            response.responseMessage = Label.Sector_Product_Selector_Save;
            response.responseStatus = 'success';
        }
        catch(Exception e)
        {
            Database.rollback(sp);
            response.responseStatus = 'error';
            response.responseMessage = 'Something went wrong. Error: '+e.getMessage()+'. Line number: '+e.getLineNumber()+'. StackTrace: '+e.getStackTraceString()+'. Please try reinitiate the process or contact your system admin.';
            if(response.responseMessage.containsIgnoreCase('INSUFFICIENT_ACCESS_OR_READONLY') || response.responseMessage.containsIgnoreCase('INSUFFICIENT_ACCESS_ON_CROSS_REFERENCE_ENTITY'))
                response.responseMessage = Label.Sector_No_Access;
        }
        return response;
    }
    
    @AuraEnabled
    public static Map<String, String> callApi(String EditProductDetails, String OppId){
        
        List<Products> ProductsList = (List<Products>)JSON.deserialize(EditProductDetails, List<Products>.class);
        System.debug('in callApi'+ProductsList);
        System.debug(OppId);
        //to get the regions of the opportunity. But here regions mean opportunity country
        List<Opportunity> opp = [select id,Opportunity_Country__c from Opportunity where id =:OppId];
        System.debug(opp);
        String[] regions;
        if(opp[0].Opportunity_Country__c != null){
            regions= opp[0].Opportunity_Country__c.split(';');
        }
        /** Purpose: Use Platform Cache to handle Access token in Integration. */ 
        //Getting org partition of platform Cache 
        Cache.OrgPartition orgPart = Cache.Org.getPartition('local.StoreOnAirAccessToken');
        String accessToken = (String)orgPart.get('token');
        DateTime expiry = (DateTime)orgPart.get('expiry');
        System.debug(expiry);
        System.debug(accessToken);
        //Check if access token is Null/Expired.Get the access token only when its expired or calling for the first time 
        if( (String.isBlank(accessToken)|| expiry == NULL || expiry < system.now())){ 
            HttpRequest req = new HttpRequest();
            req.setMethod('POST');
            req.setHeader('Content-Type','application/x-www-form-urlencoded');
            Sector_EFL__c settings = isSandbox == true ? Sector_EFL__c.getInstance('Sandbox'): Sector_EFL__c.getInstance('Production');
            String tokenURL = settings.Token_URL__c;
            req.setEndpoint(tokenURL);
            String CLIENT_ID = settings.Client_Id__c;
            String CLIENT_SECRET = settings.Client_secret__c;
            req.setBody('grant_type='+EncodingUtil.urlEncode('client_credentials','UTF-8'));
            
            
            //to set the authorization header
            Blob headerValue = Blob.valueOf(CLIENT_ID+':'+CLIENT_SECRET);
            String authorizationHeader = 'Basic ' + EncodingUtil.base64Encode(headerValue);
            req.setHeader('Authorization', authorizationHeader);
            
            Http http = new Http();
            HTTPResponse response = http.send(req);
            System.debug('Body ' + response.getBody());
            //let's store access token & its expiry time    
            if (response.getStatusCode() == 200) { 
                Map<String, Object> mapResultToken = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                //Storing Access Token and Expiry to Org cache 
                orgPart.put('token',mapResultToken.get('access_token'));
                orgPart.put('expiry',system.now().addSeconds(3600));//please edit the time according to the access token time
                
            } 
        } 
        //If token is updated then getting latest token 
        accessToken = (String)orgPart.get('token');
        expiry = (DateTime)orgPart.get('expiry');
        
        //Map to store the required result send it the Js File
            Map<String, String> theObj = new Map<String, String>();
        
        //Check if access token is not Expired
        if(expiry > system.now()){ 
            HttpRequest httpRequest = new HttpRequest();
            httpRequest.setMethod('POST');
            httpRequest.setHeader('Content-Type','application/x-www-form-urlencoded');
            Sector_EFL__c settings1 = isSandbox == true ? Sector_EFL__c.getInstance('Sandbox'): Sector_EFL__c.getInstance('Production');
            String endPoint = settings1.Endpoint__c;
            httpRequest.setEndpoint(endPoint);
            httpRequest.setBody('grant_type='+EncodingUtil.urlEncode('client_credentials','UTF-8'));
            
            
            //to set the authorization header
            httpRequest.setHeader('Authorization', 'Bearer '+accessToken);
            
            //creating json value
            Map<String, Object> obj = new Map<String, Object>();
            for(Products producteach : ProductsList)
            {
                obj.put('input_quantity', producteach.volume);
                obj.put('input_uom', producteach.ProductUnit);
                obj.put('product', producteach.ProductName);
                if(regions != null)
                    if(regions.size() ==1){
                        obj.put('region',regions[0]);
                    }
                System.debug(obj);
                
                System.debug(JSON.Serialize(obj));
                httpRequest.setBody(JSON.Serialize(obj));
                Http http = new Http();
                HTTPResponse response1 = http.send(httpRequest);
                System.debug('Body ' + response1.getBody());
                Map<String, Object> results = (Map<String, Object>)JSON.deserializeUntyped(response1.getBody());
                System.debug(results);
                if(response1.getStatusCode() != 200){
                    Object a = results.get('error');//to typecast from map values to object
                    String jsonStr = JSON.serialize(a);//convert to json
                    Map<String, Object> results2 = (Map<String, Object>)JSON.deserializeUntyped(jsonStr);//convert to map
                    
                    theObj.put(producteach.ProductId + producteach.Volume,results2.get('message').toString());
                }
                else{
                    //now I am changing the code because we only need well_to_wheel
                    Object a1 = results.get('tank_to_wheel');
                    String jsonStr1 = JSON.serialize(a1);
                    System.debug(a1);
                    Map<String, Object> results2 = (Map<String, Object>)JSON.deserializeUntyped(jsonStr1);
                    system.debug(results2.get('value'));
                    String value1 = String.valueOf(results2.get('value'));
                    Double tank_to_wheel = Double.valueOf(value1);
                    
                    Object a2 = results.get('well_to_tank');
                    String jsonStr2 = JSON.serialize(a2);
                    System.debug(a2);
                    Map<String, Object> results3 = (Map<String, Object>)JSON.deserializeUntyped(jsonStr2);
                    system.debug(results3.get('value'));
                    String value2 = String.valueOf(results3.get('value'));
                    Double well_to_tank = Double.valueOf(value2);
                    
                    Object a3 = results.get('well_to_wheel');
                    String jsonStr3 = JSON.serialize(a3);
                    System.debug(a3);
                    Map<String, Object> results4 = (Map<String, Object>)JSON.deserializeUntyped(jsonStr3);
                    system.debug(results4.get('value'));
                    String value3 = String.valueOf(results4.get('value'));
                    Double well_to_wheel = Double.valueOf(value3);
                    
                    //Double total_value = tank_to_wheel+well_to_tank+well_to_wheel;
                    theObj.put(producteach.ProductId + producteach.Volume,String.valueOf(well_to_wheel));
                }
            }
            
            
            /*httpRequest.setBody('{"input_quantity": 100,"input_uom": "Liters","product": "B10","region": "UK"}');



Http http = new Http();
HTTPResponse response1 = http.send(httpRequest);
System.debug('Body ' + response1.getBody());
Map<String, Object> results = (Map<String, Object>)JSON.deserializeUntyped(response1.getBody());
System.debug(results);





//this is to be use when we are getting the result
Sector_EFLApiResponse result = Sector_EFLApiResponse.parse(response1.getBody()); 
system.debug(result);
//system.debug(result.cls_well_to_tank.value);
//system.debug(result.cls_well_to_tank);
//system.debug(result.cls_well_to_wheel);
*/
        }
        return theObj;
    }
    
    
    public class Products 
    {
        @AuraEnabled public String ProductName;
        @AuraEnabled public String ProductId;
        @AuraEnabled public String OpportunityLineId;
        @AuraEnabled public String ProductFamily;
        @AuraEnabled public String ProductUnit;
        @AuraEnabled public String ProductDescription;
        @AuraEnabled public Decimal Volume;
        @AuraEnabled public Decimal Revenue;
        @AuraEnabled public Decimal ProductProfit;
        @AuraEnabled public Decimal Indexnum;
        @AuraEnabled public Decimal co2Emission; 
        
        @AuraEnabled public String startyear;
        @AuraEnabled public String endyear;
        @AuraEnabled public Decimal carbonEmission;
        @AuraEnabled public String Product2Id;
    }
    public class responseWrapper 
    {
        @AuraEnabled public String responseStatus;
        @AuraEnabled public String responseMessage;
        @AuraEnabled public List<Products> ProductsList;
    }
}