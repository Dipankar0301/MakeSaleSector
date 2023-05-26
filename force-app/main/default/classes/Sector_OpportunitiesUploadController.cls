public with sharing class  Sector_OpportunitiesUploadController 
{
    public static String SectorPricebookID = Label.Sector_PriceBookId;
    public static Integer MaxLimitofrows = Integer.valueof(Label.Sector_BulkUpdate_MaxRows);
    static String csvfilevalidation = '';
    static String csvfileresult = '';
    /**
    1. Checks if the file contain more than 200 records.
	2. Check if the data type is correct in the file.
	3. If the new product is added then check whether the product exist in salesforce
	Forecasting:
	1. Product name & family exist
	2. Product is added only once per opportunity
	3. product should not have same year for an product
	4. check year lies between 2020 and 2120
	5. Excel file has duplicate years
    **/
    @AuraEnabled  // This method will validate the file received 
    public static responseWrapper SectorOpportunityValidateFile(String FileName,String FileContent, String objectname)
    {
        responseWrapper response = new responseWrapper();
        Savepoint sp = Database.setSavepoint();
        
        try
        {
            List<String> headerinfosplit = objectname == Label.Sector_BulkUpdate_OpportunityLabel ? Label.Sector_Bulk_Update_Opportunities_Header.split(',') : (objectname == Label.Sector_BulkUpdate_OpportunityProduct ? Label.Sector_Bulk_Update_Opportunities_Product_Header.split(',') :  Label.Sector_Bulk_Update_Opportunities_Forecasting_Header.split(',') );
            Map<String,String> headerinfo = new Map<String,String>();
            for(Integer i = 0; i < headerinfosplit.size(); i= i+3)
            {
                headerinfo.put(headerinfosplit[i],headerinfosplit[i+1]);
            }
            
            List<List<String>> listofcsvvalue = parseCSVLinetoList(FileContent);
            List<String> headerinfoincsv =  listofcsvvalue.get(0);
            listofcsvvalue.remove(0);
            
            if(listofcsvvalue.size() > MaxLimitofrows)
            {
                response.responseMessage = Label.Sector_BulkUpdate_Limitrecords;
                response.responsemessageinmodal = response.responseMessage;
                response.responseStatus = 'info';
                return response;
            }
            
            csvfilevalidation = '';
            for(String eachheader : headerinfoincsv)
            {
                csvfilevalidation += eachheader+',';
            }
            csvfilevalidation += 'Issue';
            
            response.foundissuestring = false;
            
            // Opportunity Validation
            if(objectname == Label.Sector_BulkUpdate_OpportunityLabel)
            {
                
                if(listofcsvvalue.size() < Integer.valueof(Label.Sector_BulkUpdate_MinOpportunityCount) )
                {
                    response.responseMessage = Label.Sector_BulkUpdate_MinOpportunityMsg;
                    response.responsemessageinmodal = response.responseMessage;
                    response.responseStatus = 'info';
                    return response;
                }  
                
                UpdateOpportunityvalidation(headerinfo, headerinfoincsv, listofcsvvalue, response);
              
            }
            else if(objectname == Label.Sector_BulkUpdate_OpportunityProduct) 
            {
                UpdateOpportunityProductvalidation(headerinfo, headerinfoincsv, listofcsvvalue, response);
            }
            else if(objectname == Label.Sector_BulkUpdate_ProductForecast) 
            {
                UpdateOpportunityForecastingvalidation(headerinfo, headerinfoincsv, listofcsvvalue, response);
            }
            if(response.foundissuestring)
            {
                response.validationforecastoverridemessage = '';
                response.ValidationResultCSV = csvfilevalidation; 
                response.responsemessageinmodal =  Label.Sector_BulkUpdate_Download_Result;
            }
            else
            {
                response.responsemessageinmodal =  Label.Sector_BulkUpdate_StartUpdate;
            }
            response.responseMessage = Label.Sector_BulkUpdate_ValidationComplete;
            response.responseStatus = 'success';
            
        }
        catch(Exception e)
        {
            Database.rollback(sp);
            response.responseStatus = 'error';
            response.responsemessageinmodal = 'Something went wrong. Error: '+e.getMessage()+'. Line number: '+e.getLineNumber()+'. StackTrace: '+e.getStackTraceString()+'. Please try reinitiate the process or contact your system admin.';
        }
        return response;
    }
    

    @AuraEnabled // This method will update the file in salesforce   
    public static responseWrapper SectorUpdateOpportunity(String FileName,String FileContent, String objectname)
    {
        responseWrapper response = new responseWrapper();
        Savepoint sp = Database.setSavepoint();
        try
        {
	
            response.foundissuestring = false;
            List<String> headerinfosplit = objectname == Label.Sector_BulkUpdate_OpportunityLabel ? Label.Sector_Bulk_Update_Opportunities_Header.split(',') : (objectname == Label.Sector_BulkUpdate_OpportunityProduct ? Label.Sector_Bulk_Update_Opportunities_Product_Header.split(',') :  Label.Sector_Bulk_Update_Opportunities_Forecasting_Header.split(',') );
            Map<String,String> headerinfo = new Map<String,String>();
            Map<String,String> headerinfofieldapi = new Map<String,String>();
            for(Integer i = 0; i < headerinfosplit.size(); i= i+3)
            {
                headerinfo.put(headerinfosplit[i],headerinfosplit[i+1]);
                headerinfofieldapi.put(headerinfosplit[i],headerinfosplit[i+2]);
            }
            
            List<List<String>> listofcsvvalue = parseCSVLinetoList(FileContent);
            List<String> headerinfoincsv =  listofcsvvalue.get(0);
            listofcsvvalue.remove(0);
            
            csvfileresult = '';
            for(String eachheader : headerinfoincsv)
            {
                csvfileresult += eachheader+',';
            }
            csvfileresult += 'Success,IsCreated?,Issue';
            
            if(objectname == Label.Sector_BulkUpdate_OpportunityLabel)
            {
                UpdateOpportunity(headerinfo, headerinfoincsv, listofcsvvalue, response, headerinfofieldapi);
            }
            else  if(objectname == Label.Sector_BulkUpdate_OpportunityProduct) 
            {
                UpdateOpportunityProduct(headerinfo, headerinfoincsv, listofcsvvalue, response, headerinfofieldapi);             
            }
            else if(objectname == Label.Sector_BulkUpdate_ProductForecast)
            {
                UpdateOpportunityProductForecasting(headerinfo, headerinfoincsv, listofcsvvalue, response, headerinfofieldapi);
            }
            
            if(response.foundissuestring == true)
                response.responsemessageinmodal =  Label.Sector_BulkUpdate_UpdateResultDownload_SomeIssue;
            else
                response.responsemessageinmodal =  Label.Sector_BulkUpdate_UpdateResultDownload;
            response.responseMessage = Label.Sector_BulkUpdate_UpdationCompleted;
            response.responseStatus = 'success';
            
        }
        catch(Exception e)
        {
            Database.rollback(sp);
            response.responseStatus = 'error';
            response.responsemessageinmodal = 'Something went wrong. Error: '+e.getMessage()+'. Line number: '+e.getLineNumber()+'. StackTrace: '+e.getStackTraceString()+'. Please try reinitiate the process or contact your system admin.';
        }
        return response;
    }
    
    public static List<List<String>> parseCSVLinetoList(String m_CSVData)
    {
        return CSVReader.readCSVFile(m_CSVData,new Parser());
    }
    
    
    
    /*******************     Data check method start ********************/
    
    public static String datachecker(String datatype, String datavalue)
    {
        try
        {
            if(datatype == 'Id')
            {
                ID valueofsobject = Id.valueOf(datavalue);
            }
            else if(datavalue != null && datavalue != '' && datatype == 'Date')
            {
                
                String regex = '^\\d{4}\\-(0[1-9]|1[012])\\-(0[1-9]|[12][0-9]|3[01])$';
                Pattern datePattern = Pattern.compile(regex);
                Matcher matchDate = datePattern.matcher(datavalue);
                if(matchDate.matches() != true)
                    return 'Date format should be YYYY-MM-DD';
                Date valueofsobject = Date.valueOf(datavalue);
            }
            else if(datavalue != null && datavalue != '' &&  datatype == 'Text')
            {
                String valueofsobject = String.valueOf(datavalue);
            }
            else if(datatype == 'Number')
            {
                Double valueofsobject = (datavalue != null && datavalue != '') ? Double.valueOf(datavalue) : 0;
            }
            else if(datatype == 'Year')
            {
                Integer valueofsobject = Integer.valueOf(datavalue);
                if( valueofsobject < 2020 || valueofsobject > 2120 )
                {
                    return Label.Sector_BulkUpdate_YearRange;
                }
            }
        }
        catch(Exception e)
        {
            if(datatype == 'Number' || datatype == 'Year')
                return (''+e.getMessage()).replace('double',datatype).replace('integer',datatype);
           return e.getMessage();
        }
        return '';
    }
    
    public static object datareturn(String datatype, String datavalue)
    {
        object valueofsobject;
        if(datatype == 'Id')
        {
            valueofsobject = Id.valueOf(datavalue);
        }
        else if(datavalue != null && datavalue != '' &&  datatype == 'Date')
        {
            valueofsobject = Date.valueOf(datavalue);
        }
        else if(datavalue != null && datavalue != '' &&  datatype == 'Text')
        {
            valueofsobject = String.valueOf(datavalue);
        }
        else if(datatype == 'Number')
        {
            valueofsobject = (datavalue != null && datavalue != '') ? Double.valueOf(datavalue) : 0;
        }
        else if(datatype == 'Boolean')
        {
            valueofsobject = (datavalue != null && datavalue != '') ? Boolean.valueOf(datavalue) : false;
        }
        else if(datatype == 'Year')
        {
            valueofsobject = Integer.valueOf(datavalue);
        }
        else if(datavalue != null && datavalue != '')
        {
            valueofsobject = datavalue;
        }
        return valueofsobject;
    }
    
    /*******************     Data check methods end ********************/
    


 /*******************     Validation Step methods start ********************/   
    
    // Validation Logic for Bulk Opportunity Update
    public static void UpdateOpportunityvalidation(Map<String,String> headerinfo, List<String> headerinfoincsv, List<List<String>> listofcsvvalue, 
                                                   responseWrapper response)
    {
        for(List<String> eachcsvline : listofcsvvalue)
        {
            String csvfilerow = '';
            csvfilevalidation += '\r\n';
            for(Integer i = 0; i < headerinfoincsv.size() ; i++)
            {
                csvfilevalidation += '"'+eachcsvline[i]+'",';
                String resultofcsvvalue = datachecker(headerinfo.get(headerinfoincsv[i]), eachcsvline[i]);
                if(resultofcsvvalue !=  null && resultofcsvvalue != '')
                {
                    csvfilerow += 'Column '+(i+1)+': '+resultofcsvvalue+'. ';
                }
            }
            if(csvfilerow != null && csvfilerow != '')
            {
                response.foundissuestring = true;
                csvfilevalidation += '"'+csvfilerow+'",';
            }
        }
    }
    
    
    // Validation Logic for Bulk Opportunity Product Update
    public static void UpdateOpportunityProductvalidation(Map<String,String> headerinfo, List<String> headerinfoincsv, List<List<String>> listofcsvvalue, 
                                                          responseWrapper response)
    {
        List<String> productNameFamilylist = new List<String>();
        for(List<String> eachcsvline : listofcsvvalue)
        {
            String productname = '';
            String productfamily = '';
            for(Integer i = 0; i < headerinfoincsv.size() ; i++)
            {
                if(headerinfoincsv[i] == Label.Sector_BulkUpdate_ProductFamilyName)
                    productfamily = eachcsvline[i] != null ? eachcsvline[i].deleteWhitespace().toLowerCase() : '';
                if(headerinfoincsv[i] == Label.Sector_BulkUpdate_ProductName)
                    productname = eachcsvline[i] != null ? eachcsvline[i].deleteWhitespace().toLowerCase() : '';
            }
            productNameFamilylist.add(productname+productfamily);
        }
        
        Map<String,String> productdetails = new Map<String,String>();
        for(PricebookEntry pbe : [SELECT Id, Name, Pricebook2.Name, Product2.Name, Product2.Family, Product_Name_Family__c 
                                  FROM PricebookEntry 
                                  where Pricebook2Id = :SectorPricebookID
                                  and Product_Name_Family__c in :productNameFamilylist])
        {
            productdetails.put(pbe.Product_Name_Family__c, pbe.Id);                   
        }
        
        for(List<String> eachcsvline : listofcsvvalue)
        {
            String productname = '';
            String productfamily = '';
            String csvfilerow = '';
            csvfilevalidation += '\r\n';
            for(Integer i = 0; i < headerinfoincsv.size() ; i++)
            {
                if(headerinfoincsv[i] == Label.Sector_BulkUpdate_ProductFamilyName)
                    productfamily = eachcsvline[i] != null ? eachcsvline[i].deleteWhitespace().toLowerCase() : '';
                if(headerinfoincsv[i] == Label.Sector_BulkUpdate_ProductName)
                    productname = eachcsvline[i] != null ? eachcsvline[i].deleteWhitespace().toLowerCase() : '';
                csvfilevalidation += '"'+eachcsvline[i]+'",';
                String resultofcsvvalue = datachecker(headerinfo.get(headerinfoincsv[i]), eachcsvline[i]);
                if(resultofcsvvalue !=  null && resultofcsvvalue != '')
                {
                    csvfilerow += 'Column '+(i+1)+': '+resultofcsvvalue+'. ';
                }
            }
            if(!productdetails.keyset().contains(productname+productfamily))
            {
                csvfilerow += Label.Sector_BulkUpdate_noProductFound;
            }
            if(csvfilerow != null && csvfilerow != '')
            {
                response.foundissuestring = true;
                csvfilevalidation += '"'+csvfilerow+'",';
            }
        }
    }
    
    
    // Validation Logic for Bulk Opportunity Forecasting Update
    public static void UpdateOpportunityForecastingvalidation(Map<String,String> headerinfo, List<String> headerinfoincsv, List<List<String>> listofcsvvalue, 
                                                              responseWrapper response)
    {
        List<String> YearproductNameFamilyOppIdlist = new List<String>();
        List<String> productNameFamilyOppIdlist = new List<String>();
        List<String> productNameFamilylist = new List<String>();
        List<String> DuplicateYearproductNameFamilyOppIdlist = new List<String>();
        
        for(List<String> eachcsvline : listofcsvvalue)
        {
            String productname = '';
            String productfamily = '';
            String Year = '';
            String OpportunityId = '';
            for(Integer i = 0; i < headerinfoincsv.size() ; i++)
            {
                if(headerinfoincsv[i] == Label.Sector_BulkUpdate_ProductFamilyName)
                    productfamily = eachcsvline[i] != null ? eachcsvline[i].deleteWhitespace().toLowerCase() : '';
                if(headerinfoincsv[i] == Label.Sector_BulkUpdate_ProductName)
                    productname = eachcsvline[i] != null ? eachcsvline[i].deleteWhitespace().toLowerCase() : '';
                if(headerinfoincsv[i] == Label.Sector_BulkUpdate_OpportunityId)
                    OpportunityId = (eachcsvline[i] != null && eachcsvline[i].length() >= 15) ? eachcsvline[i].substring(0, 15) : '';
                if(headerinfoincsv[i] == Label.Sector_BulkUpdate_ForecastingYear)
                    Year = eachcsvline[i] != null ? eachcsvline[i] : '';
            }
            if(!YearproductNameFamilyOppIdlist.contains(Year+productname+productfamily+OpportunityId))
                YearproductNameFamilyOppIdlist.add(Year+productname+productfamily+OpportunityId);
            else
                DuplicateYearproductNameFamilyOppIdlist.add(Year+productname+productfamily+OpportunityId);
            
            productNameFamilylist.add(productname+productfamily);
            productNameFamilyOppIdlist.add(productname+productfamily+OpportunityId);
            
        }
        
        Map<String,String> Predictedproductdetails = new Map<String,String>();
        for(Predicted_Product_Information__c predictedproduct : [SELECT Id, Name, Sector_System_Field_Bulk_Update_Opp__c 
                                                                 FROM Predicted_Product_Information__c
                                                                 where Sector_System_Field_Bulk_Update_Opp__c in :YearproductNameFamilyOppIdlist])
        {
            Predictedproductdetails.put(predictedproduct.Sector_System_Field_Bulk_Update_Opp__c, predictedproduct.Id);                   
        }
        
        Map<String,String> OpportunityProductdetails = new Map<String,String>();
        Map<String,String> DuplicateOpportunityProductdetails = new Map<String,String>();
        for(OpportunityLineItem oppline : [SELECT Id, Sector_System_Field_Bulk_Update_Opp__c 
                                           FROM OpportunityLineItem
                                           where Sector_System_Field_Bulk_Update_Opp__c in :productNameFamilyOppIdlist])
        {
            if(!OpportunityProductdetails.containsKey(oppline.Sector_System_Field_Bulk_Update_Opp__c))
                OpportunityProductdetails.put(oppline.Sector_System_Field_Bulk_Update_Opp__c, oppline.Id);    
            else
                DuplicateOpportunityProductdetails.put(oppline.Sector_System_Field_Bulk_Update_Opp__c, oppline.Id);
        }
        
        
        Map<String,String> productdetails = new Map<String,String>();
        for(PricebookEntry pbe : [SELECT Id, Name, Pricebook2.Name, Product2.Name, Product2.Family, Product_Name_Family__c 
                                  FROM PricebookEntry 
                                  where Pricebook2Id = :SectorPricebookID
                                  and Product_Name_Family__c in :productNameFamilylist])
        {
            productdetails.put(pbe.Product_Name_Family__c, pbe.Id);                   
        }
        
        for(List<String> eachcsvline : listofcsvvalue)
        {
            String productname = '';
            Integer ProductNameIndex;
            String productfamily = '';
            String Year = '';
            String OpportunityId = '';
            String csvfilerow = '';
            csvfilevalidation += '\r\n';
            for(Integer i = 0; i < headerinfoincsv.size() ; i++)
            {
                if(headerinfoincsv[i] == Label.Sector_BulkUpdate_ProductFamilyName)
                    productfamily = eachcsvline[i] != null ? eachcsvline[i].deleteWhitespace().toLowerCase() : '';
                if(headerinfoincsv[i] == Label.Sector_BulkUpdate_ProductName)
                {
                    productname = eachcsvline[i] != null ? eachcsvline[i].deleteWhitespace().toLowerCase() : '';
                    ProductNameIndex = i;
                }
                if(headerinfoincsv[i] == Label.Sector_BulkUpdate_OpportunityId)
                    OpportunityId = (eachcsvline[i] != null && eachcsvline[i].length() >= 15) ? eachcsvline[i].substring(0, 15) : '';
                if(headerinfoincsv[i] == Label.Sector_BulkUpdate_ForecastingYear)
                    Year = eachcsvline[i] != null ? eachcsvline[i] : '';
                csvfilevalidation += '"'+eachcsvline[i]+'",';
                String resultofcsvvalue = datachecker(headerinfo.get(headerinfoincsv[i]), eachcsvline[i]);
                if(resultofcsvvalue !=  null && resultofcsvvalue != '')
                {
                    csvfilerow += 'Column '+(i+1)+': '+resultofcsvvalue+'. ';
                }
            }
            
            // Invalid product name
            if(!productdetails.keyset().contains(productname+productfamily))
            {
                csvfilerow += Label.Sector_BulkUpdate_noProductFound;
            }
            // Product not found related to Opportunity
            else if(!OpportunityProductdetails.containskey(productname+productfamily+OpportunityId))
            {
                csvfilerow += Label.Sector_BulkUpdate_noProductFoundRelatedOpp;
            }
            // Duplicate row in CSV file
            if(DuplicateYearproductNameFamilyOppIdlist.contains(Year+productname+productfamily+OpportunityId))
            {
                csvfilerow += Label.Sector_BulkUpdate_DuplicateRow_Forecasting;
            }
            // Duplicate Product is present on Opportunity
            if(DuplicateOpportunityProductdetails.containskey(productname+productfamily+OpportunityId))
            {
                csvfilerow += Label.Sector_BulkUpdate_DuplicateProduct.replace('{!ProductName}',eachcsvline[ProductNameIndex]);
            }
            
            
            // Year of the Annual forecast already exist
            if(Predictedproductdetails.keyset().contains(Year+productname+productfamily+OpportunityId))
            {
              //  csvfilerow += Label.Sector_BulkUpdate_ProductYear.replace('{!Year}',Year);
                response.validationforecastoverridemessage = Label.Sector_BulkUpdate_forecastoverridemsg;
            } 

            
            if(csvfilerow != null && csvfilerow != '')
            {
                response.foundissuestring = true;
                csvfilevalidation += '"'+csvfilerow+'",';
            }
        }
        
    }
    
    
    /*******************     Validation Step methods end ********************/ 
    
    
    
    
    /*******************     Bulk update methods start ********************/ 
    
    // Logic for Bulk update Opportunity
    public static void UpdateOpportunity(Map<String,String> headerinfo, List<String> headerinfoincsv, List<List<String>> listofcsvvalue, 
                                                   responseWrapper response, Map<String,String> headerinfofieldapi)
    {
        List<Opportunity> listofopptoupdate = new List<Opportunity>();
        for(List<String> eachcsvline : listofcsvvalue)
        {
            Opportunity eachopp = new Opportunity();
            for(Integer i = 0; i < headerinfoincsv.size() ; i++)
            {
                object objectvalue = datareturn(headerinfo.get(headerinfoincsv[i]), eachcsvline[i]);
                if(objectvalue != null)
                    eachopp.put(headerinfofieldapi.get(headerinfoincsv[i]),objectvalue);
            }
            listofopptoupdate.add(eachopp);
        }
        
        Database.SaveResult[] srList = Database.update(listofopptoupdate, false);
        
        Integer k = 0;
        for(List<String> eachcsvline : listofcsvvalue)
        {
            csvfileresult += '\r\n';
            for(Integer i = 0; i < headerinfoincsv.size() ; i++)
            {
                csvfileresult += '"'+eachcsvline[i]+'",';
            }
            if(srList[k].isSuccess())
            {
                csvfileresult += 'true,';
            }
            else
            {
                response.foundissuestring = true;
                String geterrors = ''+srList[k].getErrors();
                if(geterrors.containsIgnoreCase('INSUFFICIENT_ACCESS_OR_READONLY') || geterrors.containsIgnoreCase('INSUFFICIENT_ACCESS_ON_CROSS_REFERENCE_ENTITY'))
                    geterrors = Label.Sector_No_Access;
                csvfileresult += 'false,"'+geterrors+'"';
            }
            k++;
        }
        response.UpdateOpportunityResult =  csvfileresult;
    }
    
    
    // Logic for Bulk update Opportunity Product
    public static void UpdateOpportunityProduct(Map<String,String> headerinfo, List<String> headerinfoincsv, List<List<String>> listofcsvvalue, 
                                                responseWrapper response, Map<String,String> headerinfofieldapi)
    {
        List<String> productNameFamilylist = new List<String>();
        for(List<String> eachcsvline : listofcsvvalue)
        {
            String productname = '';
            String productfamily = '';
            for(Integer i = 0; i < headerinfoincsv.size() ; i++)
            {
                if(headerinfoincsv[i] == Label.Sector_BulkUpdate_ProductFamilyName)
                    productfamily = eachcsvline[i] != null ? eachcsvline[i].deleteWhitespace().toLowerCase() : '';
                if(headerinfoincsv[i] == Label.Sector_BulkUpdate_ProductName)
                    productname = eachcsvline[i] != null ? eachcsvline[i].deleteWhitespace().toLowerCase() : '';
            }
            productNameFamilylist.add(productname+productfamily);
        }
        
        
        Map<String,String> productdetails = new Map<String,String>();
        for(PricebookEntry pbe : [SELECT Id, Name, Pricebook2.Name, Product2.Name, Product2.Family, Product_Name_Family__c 
                                  FROM PricebookEntry 
                                  where Pricebook2Id = :SectorPricebookID
                                  and Product_Name_Family__c in :productNameFamilylist])
        {
            productdetails.put(pbe.Product_Name_Family__c, pbe.Id);                     
        }
        
        List<OpportunityLineItem> opplineinsert = new List<OpportunityLineItem>();
        for(List<String> eachcsvline : listofcsvvalue)
        {
            String productname = '';
            String productfamily = '';
            OpportunityLineItem eachoppline = new OpportunityLineItem();
            for(Integer i = 0; i < headerinfoincsv.size() ; i++)
            {
                
                if(headerinfoincsv[i] == Label.Sector_BulkUpdate_ProductName)
                    productname = eachcsvline[i] != null ? eachcsvline[i].deleteWhitespace().toLowerCase() : '';
                if(headerinfoincsv[i] == Label.Sector_BulkUpdate_ProductFamilyName )
                    productfamily = eachcsvline[i] != null ? eachcsvline[i].deleteWhitespace().toLowerCase() : '';
                
                if(headerinfoincsv[i] != Label.Sector_BulkUpdate_ProductFamilyName && headerinfoincsv[i] != Label.Sector_BulkUpdate_ProductName)
                {
                    object objectvalue = datareturn(headerinfo.get(headerinfoincsv[i]), eachcsvline[i]);
                    if(objectvalue != null)
                        eachoppline.put(headerinfofieldapi.get(headerinfoincsv[i]),objectvalue);
                }
                
            }
            eachoppline.PricebookEntryId = productdetails.get(productname+productfamily);
            eachoppline.Quantity = 1;
            eachoppline.UnitPrice = eachoppline.Revenue__c != null ? eachoppline.Revenue__c : 0;
            opplineinsert.add(eachoppline);
        }
        
        
        Database.SaveResult[] srList = Database.insert(opplineinsert, false);
        Integer k = 0;
        for(List<String> eachcsvline : listofcsvvalue)
        {
            csvfileresult += '\r\n';
            for(Integer i = 0; i < headerinfoincsv.size() ; i++)
            {
                csvfileresult += '"'+eachcsvline[i]+'",';
            }
            if(srList[k].isSuccess())
            {
                csvfileresult += 'true,';
            }
            else
            {
                response.foundissuestring = true;
                String geterrors = ''+srList[k].getErrors();
                if(geterrors.containsIgnoreCase('INSUFFICIENT_ACCESS_OR_READONLY') || geterrors.containsIgnoreCase('INSUFFICIENT_ACCESS_ON_CROSS_REFERENCE_ENTITY'))
                    geterrors = Label.Sector_No_Access;
                csvfileresult += 'false,"'+geterrors+'"';
            }
            k++;
        }
        response.UpdateOpportunityResult =  csvfileresult;
    }
    
    
    
    // Logic for Bulk update Opportunity Product Forecasting
    public static void UpdateOpportunityProductForecasting(Map<String,String> headerinfo, List<String> headerinfoincsv, List<List<String>> listofcsvvalue, 
                                                           responseWrapper response, Map<String,String> headerinfofieldapi)
    {
        
        
        List<String> productNameFamilyOppIdlist = new List<String>();
        List<String> YearproductNameFamilyOppIdlist = new List<String>();
        for(List<String> eachcsvline : listofcsvvalue)
        {
            String productname = '';
            String productfamily = '';
            String Year = '';
            String OpportunityId = '';
            for(Integer i = 0; i < headerinfoincsv.size() ; i++)
            {
                if(headerinfoincsv[i] == Label.Sector_BulkUpdate_ProductFamilyName)
                    productfamily = eachcsvline[i] != null ? eachcsvline[i].deleteWhitespace().toLowerCase() : '';
                if(headerinfoincsv[i] == Label.Sector_BulkUpdate_ProductName)
                    productname = eachcsvline[i] != null ? eachcsvline[i].deleteWhitespace().toLowerCase() : '';
                if(headerinfoincsv[i] == Label.Sector_BulkUpdate_OpportunityId)
                    OpportunityId = (eachcsvline[i] != null && eachcsvline[i].length() >= 15) ? eachcsvline[i].substring(0, 15) : '';
                if(headerinfoincsv[i] == Label.Sector_BulkUpdate_ForecastingYear)
                    Year = eachcsvline[i] != null ? eachcsvline[i] : '';
            }
            productNameFamilyOppIdlist.add(productname+productfamily+OpportunityId);
            
            if(!YearproductNameFamilyOppIdlist.contains(Year+productname+productfamily+OpportunityId))
                YearproductNameFamilyOppIdlist.add(Year+productname+productfamily+OpportunityId);
            
        }
        
        Map<String,String> Predictedproductdetails = new Map<String,String>();
        for(Predicted_Product_Information__c predictedproduct : [SELECT Id, Name, Sector_System_Field_Bulk_Update_Opp__c 
                                                                 FROM Predicted_Product_Information__c
                                                                 where Sector_System_Field_Bulk_Update_Opp__c in :YearproductNameFamilyOppIdlist])
        {
            Predictedproductdetails.put(predictedproduct.Sector_System_Field_Bulk_Update_Opp__c, predictedproduct.Id);                   
        }
        
        
        Map<String,String> OpportunityProductdetails = new Map<String,String>();
        for(OpportunityLineItem oppline : [SELECT Id, Sector_System_Field_Bulk_Update_Opp__c 
                                           FROM OpportunityLineItem
                                           where Sector_System_Field_Bulk_Update_Opp__c in :productNameFamilyOppIdlist])
        {
            OpportunityProductdetails.put(oppline.Sector_System_Field_Bulk_Update_Opp__c, oppline.Id);    
        }
        
        
        // To store the Opportunity details which is used to generate forecasting update table
        Map<Integer, Sector_OpportunitiesUploadController.forecastingdetailsforprocess> oppforecasting = new Map<Integer, Sector_OpportunitiesUploadController.forecastingdetailsforprocess>();
        
        
        List<Predicted_Product_Information__c> prodictedproductlist = new List<Predicted_Product_Information__c>();
        Integer indexouter = 0;
        for(List<String> eachcsvline : listofcsvvalue)
        {
            String productname = '';
            String productfamily = '';
            String Year = '';
            String OpportunityId = '';
            Predicted_Product_Information__c predictedproduct = new Predicted_Product_Information__c();
            for(Integer i = 0; i < headerinfoincsv.size() ; i++)
            {
                
                if(headerinfoincsv[i] == Label.Sector_BulkUpdate_ProductName)
                    productname = eachcsvline[i] != null ? eachcsvline[i].deleteWhitespace().toLowerCase() : '';
                if(headerinfoincsv[i] == Label.Sector_BulkUpdate_ProductFamilyName )
                    productfamily = eachcsvline[i] != null ? eachcsvline[i].deleteWhitespace().toLowerCase() : '';
                if(headerinfoincsv[i] == Label.Sector_BulkUpdate_OpportunityId)
                    OpportunityId = (eachcsvline[i] != null && eachcsvline[i].length() >= 15) ? eachcsvline[i].substring(0, 15) : '';
                if(headerinfoincsv[i] == Label.Sector_BulkUpdate_ForecastingYear)
                    Year = eachcsvline[i] != null ? eachcsvline[i] : '';
                
                if(headerinfoincsv[i] != Label.Sector_BulkUpdate_ProductFamilyName && headerinfoincsv[i] != Label.Sector_BulkUpdate_ProductName && headerinfoincsv[i] != Label.Sector_BulkUpdate_ForecastingYear)
                {
                    object objectvalue = datareturn(headerinfo.get(headerinfoincsv[i]), eachcsvline[i]);
                    if(objectvalue != null)
                        predictedproduct.put(headerinfofieldapi.get(headerinfoincsv[i]),objectvalue);
                }
                
            }
            predictedproduct.Name = ''+Year;
            predictedproduct.Opportunity_Product__c = OpportunityProductdetails.get(productname+productfamily+OpportunityId);
            predictedproduct.Id = Predictedproductdetails.keyset().contains(Year+productname+productfamily+OpportunityId) ? Predictedproductdetails.get(Year+productname+productfamily+OpportunityId) : null;
            prodictedproductlist.add(predictedproduct);
            
            oppforecasting.put(indexouter, new Sector_OpportunitiesUploadController.forecastingdetailsforprocess(predictedproduct.Opportunity__c,predictedproduct.Opportunity_Product__c));
            indexouter++;
        }
        
        List<Bulk_Forecasting_Update__c> bulkforecastinginsert = new List<Bulk_Forecasting_Update__c>();
        Set<String> oppidproductidlist = new Set<String>();
        
       // Database.SaveResult[] srList = Database.insert(prodictedproductlist, false);
        Database.UpsertResult[] srList = Database.upsert(prodictedproductlist, false);
        Integer k = 0;
        for(List<String> eachcsvline : listofcsvvalue)
        {
            csvfileresult += '\r\n';
            for(Integer i = 0; i < headerinfoincsv.size() ; i++)
            {
                csvfileresult += '"'+eachcsvline[i]+'",';
            }
            if(srList[k].isSuccess())
            {
                csvfileresult += 'true,'+srList[k].isCreated()+',';
                
                String oppidproductid = oppforecasting.get(k).OpportuntiyId +''+oppforecasting.get(k).OpportutniyProductId;
                if(!oppidproductidlist.contains(oppidproductid))
                {
                    bulkforecastinginsert.add( (new Bulk_Forecasting_Update__c(Opportunity__c = oppforecasting.get(k).OpportuntiyId, Opportunity_Product__c = oppforecasting.get(k).OpportutniyProductId)) ); 
                    oppidproductidlist.add(oppidproductid);
                }
                
            }
            else
            {
                response.foundissuestring = true;
                String geterrors = ''+srList[k].getErrors();
                if(geterrors.containsIgnoreCase('INSUFFICIENT_ACCESS_OR_READONLY') || geterrors.containsIgnoreCase('INSUFFICIENT_ACCESS_ON_CROSS_REFERENCE_ENTITY'))
                    geterrors = Label.Sector_No_Access;
                csvfileresult += 'false,,"'+geterrors+'"';
            }
            k++;
        }
        
        // inserting bulk forecasting tracking success records
        insert bulkforecastinginsert;
        
        response.UpdateOpportunityResult =  csvfileresult;
    }
    
    /*******************     Bulk update methods end ********************/ 
    
    
    
    /*******************     Get Opportunities owned by user Start ********************/ 
    @AuraEnabled
    public static responseWrapper SectorGetOwnOpportunities(Boolean showoppwithforecasting)
    {
        responseWrapper response = new responseWrapper();
        try
        {
            if(showoppwithforecasting == true)
                response.opplines = [SELECT Id, OpportunityId, Opportunity.Name, Opportunity.AccountId, Opportunity.Account.Name, Opportunity.StageName, 
                                     Product2.Name, Product_Family__c FROM OpportunityLineItem 
                                     where OpportunityId in 
                                     (SELECT OpportunityId 
                                      FROM OpportunityShare 
                                      where UserOrGroupId =: Userinfo.getUserId() 
                                      and OpportunityAccessLevel in  ('All','Edit') )
                                     and Id in 
                                     (SELECT Opportunity_Product__c 
                                      FROM Predicted_Product_Information__c )
                                     order by Opportunity.CreatedDate desc limit 250];
            else
                response.opplines = [SELECT Id, OpportunityId, Opportunity.Name, Opportunity.AccountId, Opportunity.Account.Name, Opportunity.StageName, 
                                     Product2.Name, Product_Family__c FROM OpportunityLineItem 
                                     where OpportunityId in 
                                     (SELECT OpportunityId 
                                      FROM OpportunityShare 
                                      where UserOrGroupId =: Userinfo.getUserId() 
                                      and OpportunityAccessLevel in  ('All','Edit') )
                                     and Id not in 
                                     (SELECT Opportunity_Product__c 
                                      FROM Predicted_Product_Information__c )
                                     order by Opportunity.CreatedDate desc limit 250];
            
            
            response.bulkforecastinglist = [SELECT Id, Name, Opportunity__r.name, Opportunity__c, Opportunity_Product__c,
                                            Opportunity_Product__r.Product2.Name, Opportunity_Product__r.Product2.Family, 
                                            CreatedById, CreatedBy.Name, CreatedDate
                                            FROM Bulk_Forecasting_Update__c 
                                            order by CreatedDate desc limit 100]; 

            response.responseStatus = 'success';
        }
        catch(Exception e)
        {
            response.responseStatus = 'error'; 
            response.responsemessageinmodal = 'Something went wrong. Error: '+e.getMessage()+'. Line number: '+e.getLineNumber()+'. StackTrace: '+e.getStackTraceString()+'. Please try reinitiate the process or contact your system admin.';
        }
        return response;
    }
    /*******************     Get Opportunities owned by user END ********************/ 
    
    
    public class forecastingdetailsforprocess 
    {
        public String OpportuntiyId;
        public String OpportutniyProductId;
        public forecastingdetailsforprocess(String OpportuntiyId, String OpportutniyProductId)
        {
            this.OpportuntiyId = OpportuntiyId;
            this.OpportutniyProductId = OpportutniyProductId;
        }
    }
    
    public class responseWrapper 
    {
        @AuraEnabled public String responseStatus;
        @AuraEnabled public String responseMessage;
        @AuraEnabled public String responsemessageinmodal;
        @AuraEnabled public Boolean foundissuestring;
        @AuraEnabled public String validationforecastoverridemessage;
        @AuraEnabled public String ValidationResultCSV;  // Stores the validation csv issues
        @AuraEnabled public String UpdateOpportunityResult; // Stores the final result csv issues
        @AuraEnabled public List<OpportunityLineItem> opplines;
        @AuraEnabled public List<Bulk_Forecasting_Update__c> bulkforecastinglist;
    }
}