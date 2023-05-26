public with sharing class OpportunityProductList 
{
    @AuraEnabled
    public static responseWrapper getOpportunityProductdata(String OppId)
    {
        responseWrapper response = new responseWrapper();
        try
        { 
            List<Products> ProductsList = new List<Products>();
            Set<String> ListofYears = new Set<String>();
            for(OpportunityLineItem eachoppline : [SELECT Id, OpportunityId, Product2.Name, Product2.Family, ProductCode,Product2.QuantityUnitOfMeasure,
                                                   (Select id,Name,Sales_volume__c,Revenue__c,Opportunity_Product__c, Annual_Profit__c ,Annual_CO2_Emissions_Reduction_Tonnes__c 
                                                    From Predicted_Product_Informations__r  order by Name)
                                                   FROM OpportunityLineItem where OpportunityId = :OppId  order by CreatedDate])
            {
                if(eachoppline.Predicted_Product_Informations__r.size() > 0)
                {
                   for(Predicted_Product_Information__c predicprod : eachoppline.Predicted_Product_Informations__r)
                   {
                       ListofYears.add(predicprod.Name.trim());
                   }
                }
            }
            
            for(OpportunityLineItem eachoppline : [SELECT Id, OpportunityId, Product2.Name, Product2.Family, ProductCode,Product2.QuantityUnitOfMeasure,
                                                   Volume__c, Revenue__c, Total_Profit__c, Total_CO2_Emissions_Reduction_Tonnes__c, Total_Carbon_Emissions_Tonnes__c,
                                                   (Select id,Name,Sales_volume__c,Revenue__c,Opportunity_Product__c, Annual_Profit__c ,Annual_CO2_Emissions_Reduction_Tonnes__c, 
                                                    Annual_CO2_Emissions_Tonnes__c 
                                                    From Predicted_Product_Informations__r order by Name)
                                                   FROM OpportunityLineItem where OpportunityId = :OppId  order by CreatedDate])
            {
                Products productlt = new Products();
                productlt.ProductName = eachoppline.Product2.Name;
                productlt.ProductFamily = eachoppline.Product2.Family;
                productlt.ProductId = eachoppline.Id;
                productlt.QuantityUnitOfMeasure = eachoppline.Product2.QuantityUnitOfMeasure;
                
                productlt.TotalVolume = eachoppline.Volume__c;
                productlt.TotalRevenue = eachoppline.Revenue__c;
                productlt.TotalGrossMargin = eachoppline.Total_Profit__c;
                productlt.TotalCO2Emissions = eachoppline.Total_CO2_Emissions_Reduction_Tonnes__c;
                productlt.TotalCO2EmissionsTonnes = eachoppline.Total_Carbon_Emissions_Tonnes__c;
                
                productlt.ProductDetails = new List<ProductDetail>();
                if(eachoppline.Predicted_Product_Informations__r.size() > 0)
                {
                    Set<String> listofyearalreadyadded = new Set<String>();
                    for(Predicted_Product_Information__c ppi : eachoppline.Predicted_Product_Informations__r)
                    {
                        ProductDetail productyear = new ProductDetail();
                        productyear.YearOfProduct = Integer.valueof(ppi.Name.trim());
                        productyear.SalesVolume = ppi.Sales_volume__c == null ? 0 : ppi.Sales_volume__c;
                        productyear.SalesRevenue = ppi.Revenue__c == null ? 0 : ppi.Revenue__c;
                        productyear.SalesProfit = ppi.Annual_Profit__c == null ? 0 : ppi.Annual_Profit__c;
                        productyear.pCo2Emission = ppi.Annual_CO2_Emissions_Reduction_Tonnes__c == null ? 0 : ppi.Annual_CO2_Emissions_Reduction_Tonnes__c;//added
                        productyear.AnnualCo2Emission = ppi.Annual_CO2_Emissions_Tonnes__c == null ? 0 : ppi.Annual_CO2_Emissions_Tonnes__c;//added
                        productyear.RowSaved = true;
                        productlt.ProductDetails.add(productyear);
                        
                        listofyearalreadyadded.add(ppi.Name.trim());
                    }
                    
                    // If any misssing year is present on related Product
                    for(String eachyear : ListofYears)
                    {
                        if(!listofyearalreadyadded.contains(eachyear.trim()))
                        {
                            ProductDetail productyear = new ProductDetail();
                            productyear.YearOfProduct = Integer.valueof(eachyear.trim());
                            productyear.SalesVolume = 0;
                            productyear.SalesRevenue = 0;
                            productyear.SalesProfit = 0;
                            productyear.pCo2Emission = 0;//added
                            productyear.AnnualCo2Emission = 0;
                            productyear.RowSaved = false;
                            productlt.ProductDetails.add(productyear);
                        }
                    }
                }
                else
                {
                    // If new product is added to Opportunity
                    for(String eachyear : ListofYears)
                    {
                        ProductDetail productyear = new ProductDetail();
                        productyear.YearOfProduct = Integer.valueof(eachyear.trim());
                        productyear.SalesVolume = 0;
                        productyear.SalesRevenue = 0;
                        productyear.SalesProfit = 0;
                        productyear.RowSaved = false;
                        productyear.pCo2Emission = 0;//added
                        productyear.AnnualCo2Emission = 0;
                        productlt.ProductDetails.add(productyear);
                    }
                }
                ProductsList.add(productlt);
            }
            response.ProductsList = ProductsList;
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
    public static responseWrapper SaveOpportunityProductdata(String ProductDetails,String OppId)
    {
        responseWrapper response = new responseWrapper();
        Savepoint sp = Database.setSavepoint();
        try
        {
            System.debug(ProductDetails);
            List<Products> ProductsList = (List<Products>)JSON.deserialize(ProductDetails, List<Products>.class);
            system.debug(ProductsList);
            delete [Select Id from Predicted_Product_Information__c where Opportunity_Product__r.OpportunityId = :OppId];
          
            List<Predicted_Product_Information__c> tobeinserted = new List<Predicted_Product_Information__c>();
            
            for(Products pro: ProductsList)
            {
                for(ProductDetail prod: pro.ProductDetails)
                {
                    Predicted_Product_Information__c temp_ppi = new Predicted_Product_Information__c();
                    temp_ppi.Sales_volume__c = prod.SalesVolume;
                    temp_ppi.Revenue__c = prod.SalesRevenue;
                    temp_ppi.Annual_Profit__c = prod.SalesProfit;
                    temp_ppi.Annual_CO2_Emissions_Reduction_Tonnes__c = prod.pCo2Emission;//added
                    temp_ppi.Annual_CO2_Emissions_Tonnes__c = prod.AnnualCo2Emission;
                    temp_ppi.Name = String.ValueOf(prod.YearOfProduct);
                    temp_ppi.Opportunity_Product__c = pro.productid;  
                    temp_ppi.Opportunity__c = OppId;
                    tobeinserted.add(temp_ppi);
                }
            }
			insert tobeinserted;            
            
            response.responseStatus = 'success';
            response.responseMessage =  Label.Sector_Annual_Revenue_Volume_Save;
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
    
    public class responseWrapper 
    {
        @AuraEnabled public String responseStatus;
        @AuraEnabled public String responseMessage;
        @AuraEnabled public List<Products> ProductsList;
    }
    public class Products 
    {
        @AuraEnabled public String ProductName;
        @AuraEnabled public String ProductFamily;
        @AuraEnabled public String ProductId;
        @AuraEnabled public String QuantityUnitOfMeasure;
        @AuraEnabled public Decimal TotalVolume;
        @AuraEnabled public Decimal TotalRevenue;
        @AuraEnabled public Decimal TotalGrossMargin;
        @AuraEnabled public Decimal TotalCO2EmissionsTonnes;
        @AuraEnabled public Decimal TotalCO2Emissions;
        @AuraEnabled public List<ProductDetail> ProductDetails;
    }
    public class ProductDetail 
    {
        @AuraEnabled public Decimal YearOfProduct;
        @AuraEnabled public Decimal SalesVolume;
        @AuraEnabled public Decimal SalesRevenue;
        @AuraEnabled public Decimal SalesProfit;
        @AuraEnabled public Decimal pCo2Emission; //added
        @AuraEnabled public Decimal AnnualCo2Emission; 
        @AuraEnabled public Boolean RowSaved;
        
    }
    
}