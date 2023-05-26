@isTest
public class Test_ProductSelector_AnnualizedRevenue 
{
    @testSetup static void IntialSetup() 
    {
        String orgId = UserInfo.getOrganizationId();  
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');  
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));  
        String uniqueName = orgId + dateString + randomInt; 
        Profile p = [SELECT Id FROM Profile WHERE Name='MakeSaledSector']; 
        User u = new User(Alias = 'standt', Email = 'sectortestclassuser@sector.shell.com', LastName = 'Testing', 
                          EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', 
                          LocaleSidKey = 'en_US', ProfileId = p.Id, 
                          TimeZoneSidKey = 'Europe/Amsterdam', UserName = uniqueName + '@test' + orgId + '.org');
        insert u;
        
        Product2 pro = new Product2(Name = 'Other', Family = 'Fuel',isActive = True);
        Insert pro;
        
        Product2 pro1 = new Product2(Name = 'Other', Family = 'EV Solutions',isActive = True);
        Insert pro1;
        
        Product2 pro2 = new Product2(Name = 'Software', Family = 'EV Solutions',isActive = True);
        Insert pro2;
        
        Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        Update standardPricebook;
        
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = standardPricebook.Id,
            Product2Id = pro.Id,
            UnitPrice = 1020,
            IsActive = true
        );
        Insert pbe;
        
        
        PricebookEntry pbe1 = new PricebookEntry(
            Pricebook2Id = standardPricebook.Id,
            Product2Id = pro1.Id,
            UnitPrice = 1020,
            IsActive = true
        );
        Insert pbe1;
        
        PricebookEntry pbe2 = new PricebookEntry(
            Pricebook2Id = standardPricebook.Id,
            Product2Id = pro2.Id,
            UnitPrice = 1020,
            IsActive = true
        );
        Insert pbe2;
    }
    static testmethod void getOpportunityProductdataTest()
    {
        User us = [Select Id from User where email = 'sectortestclassuser@sector.shell.com'];
        System.runAs(us)
        {
            List<Opportunity> opplist = Sector_TestDataFactory.createOpportunity(1,null, Date.today(), 
                                                                                 'Suspect/Lead', 
                                                                                 'Sector');
            
            insert opplist;
            opplist[0].Pricebook2Id = Test.getStandardPricebookId();
            update opplist;
            
            Sector_AddProduct.responseWrapper response = Sector_AddProduct.getOpportunityProductdata(opplist[0].Id, null, null);
            System.assertEquals('success', response.responseStatus);
        }
    }
    static testmethod void errorgetOpportunityProductdataTest()
    {
        User us = [Select Id from User where email = 'sectortestclassuser@sector.shell.com'];
        System.runAs(us)
        {
            Sector_AddProduct.responseWrapper response = Sector_AddProduct.getOpportunityProductdata(null, null, null);
            System.assertEquals('error', response.responseStatus);
        }
    }
    static testmethod void SaveEditProductdataTest()
    {
        User us = [Select Id from User where email = 'sectortestclassuser@sector.shell.com'];
        System.runAs(us)
        {
            List<Opportunity> opplist = Sector_TestDataFactory.createOpportunity(1,null, Date.today(), 
                                                                                 'Suspect/Lead', 
                                                                                 'Sector');
            insert opplist;
            opplist[0].Pricebook2Id = Test.getStandardPricebookId();
            update opplist;
            Sector_AddProduct.responseWrapper response = Sector_AddProduct.getOpportunityProductdata(opplist[0].Id, null, null);
            System.assertEquals('success', response.responseStatus);
            
            List<Sector_AddProduct.Products> listofselectedproduct = new List<Sector_AddProduct.Products>();
            listofselectedproduct.addall(response.ProductsList);
            
            for(Sector_AddProduct.Products eachproduct : listofselectedproduct)
            {
                eachproduct.Volume = 100;
                eachproduct.Revenue = 100;
                eachproduct.ProductProfit = 100;
            }
            Sector_AddProduct.responseWrapper responsesave = Sector_AddProduct.SaveEditProductdata(opplist[0].Id, Json.serialize(listofselectedproduct), new List<String>{});
            System.assertEquals('success', responsesave.responseStatus);
            
            
            
            
            
            
        }
    }
    
    static testmethod void errorSaveEditProductdataTest()
    {
        User us = [Select Id from User where email = 'sectortestclassuser@sector.shell.com'];
        System.runAs(us)
        {
            List<Opportunity> opplist = Sector_TestDataFactory.createOpportunity(1,null, Date.today(), 
                                                                                 'Suspect/Lead', 
                                                                                 'Sector');
            insert opplist;
            Sector_AddProduct.responseWrapper responsesave = Sector_AddProduct.SaveEditProductdata(opplist[0].Id, null, new List<String>{});
            System.assertEquals('error', responsesave.responseStatus);
            
        }
    }
    
    static testmethod void getEditProductdataTest()
    {
        User us = [Select Id from User where email = 'sectortestclassuser@sector.shell.com'];
        System.runAs(us)
        {
            List<Opportunity> opplist = Sector_TestDataFactory.createOpportunity(1,null, Date.today(), 
                                                                                 'Suspect/Lead', 
                                                                                 'Sector');
            insert opplist;
            opplist[0].Pricebook2Id = Test.getStandardPricebookId();
            update opplist;
            Sector_AddProduct.responseWrapper response = Sector_AddProduct.getOpportunityProductdata(opplist[0].Id, null, null);
            System.assertEquals('success', response.responseStatus);
            
            List<Sector_AddProduct.Products> listofselectedproduct = new List<Sector_AddProduct.Products>();
            listofselectedproduct.addall(response.ProductsList);
            
            for(Sector_AddProduct.Products eachproduct : listofselectedproduct)
            {
                eachproduct.Volume = 100;
                eachproduct.Revenue = 100;
                eachproduct.ProductProfit = 100;
            }
            system.debug('155');
            system.debug(listofselectedproduct);
            Sector_AddProduct.responseWrapper responsesave = Sector_AddProduct.SaveEditProductdata(opplist[0].Id, Json.serialize(listofselectedproduct), new List<String>{});
            System.assertEquals('success', responsesave.responseStatus);
            
            Sector_AddProduct.responseWrapper responseeditproduct = Sector_AddProduct.getEditProductdata(opplist[0].Id);
            System.assertEquals('success', responseeditproduct.responseStatus);
            
            List<Sector_AddProduct.Products> listofselectedproduct1 = responseeditproduct.ProductsList;
            List<String> deleteproduct = new List<String>();
            deleteproduct.add(listofselectedproduct1[0].OpportunityLineId);
            listofselectedproduct1.remove(0);
            responsesave = Sector_AddProduct.SaveEditProductdata(opplist[0].Id, Json.serialize(listofselectedproduct1), deleteproduct);
            System.assertEquals('success', responsesave.responseStatus);
            
            
        }
    }
    static testmethod void noaccess_SaveEditProductdataTest()
    {
        User us = [Select Id from User where email = 'sectortestclassuser@sector.shell.com'];
        List<Opportunity> opplist = Sector_TestDataFactory.createOpportunity(1,null, Date.today(), 
                                                                             'Suspect/Lead', 
                                                                             'Sector');
        insert opplist;
        opplist[0].Pricebook2Id = Test.getStandardPricebookId();
        update opplist;
        Sector_AddProduct.responseWrapper response = Sector_AddProduct.getOpportunityProductdata(opplist[0].Id, null, null);
        System.assertEquals('success', response.responseStatus);
        
        List<Sector_AddProduct.Products> listofselectedproduct = new List<Sector_AddProduct.Products>();
        listofselectedproduct.addall(response.ProductsList);
        
        for(Sector_AddProduct.Products eachproduct : listofselectedproduct)
        {
            eachproduct.Volume = 100;
            eachproduct.Revenue = 100;
            eachproduct.ProductProfit = 100;
        }
        System.runAs(us)
        {
            Sector_AddProduct.responseWrapper responsesave = Sector_AddProduct.SaveEditProductdata(opplist[0].Id, Json.serialize(listofselectedproduct), new List<String>{});
            System.assertEquals('error', responsesave.responseStatus);
            
            //
            
            
        }
        
        
    }
    
    static testmethod void get_Save_OpportunityProductdataannualrevnueTest()
    {
        User us = [Select Id from User where email = 'sectortestclassuser@sector.shell.com'];
        System.runAs(us)
        {
            List<Opportunity> opplist = Sector_TestDataFactory.createOpportunity(1,null, Date.today(), 
                                                                                 'Suspect/Lead', 
                                                                                 'Sector');
            insert opplist;
            opplist[0].Pricebook2Id = Test.getStandardPricebookId();
            update opplist;
            Sector_AddProduct.responseWrapper response = Sector_AddProduct.getOpportunityProductdata(opplist[0].Id, null, null);
            System.assertEquals('success', response.responseStatus);
            
            List<Sector_AddProduct.Products> listofselectedproduct = new List<Sector_AddProduct.Products>();
            listofselectedproduct.add(response.ProductsList[0]);
            listofselectedproduct.add(response.ProductsList[1]);
            
            for(Sector_AddProduct.Products eachproduct : listofselectedproduct)
            {
                eachproduct.Volume = 100;
                eachproduct.Revenue = 100;
                eachproduct.ProductProfit = 100;
            }
            
            Sector_AddProduct.responseWrapper responsesave = Sector_AddProduct.SaveEditProductdata(opplist[0].Id, Json.serialize(listofselectedproduct), new List<String>{});
            System.assertEquals('success', responsesave.responseStatus);
            
            
            OpportunityProductList.responseWrapper responseannualize = OpportunityProductList.getOpportunityProductdata(opplist[0].Id);
            System.assertEquals('success', responseannualize.responseStatus);
            
            for(OpportunityProductList.Products eachproducta : responseannualize.ProductsList)
            {
                eachproducta.ProductDetails = new List<OpportunityProductList.ProductDetail>();
                Decimal startyear = 2020;
                for(Integer k = 0; k < 10; k++)
                {
                    OpportunityProductList.ProductDetail eachpro = new OpportunityProductList.ProductDetail();
                    eachpro.YearOfProduct = startyear + k;
                    eachpro.SalesVolume = 100;
                    eachpro.SalesRevenue = 100;
                    eachpro.SalesProfit = 100;
                    eachproducta.ProductDetails.add(eachpro);
                }
            }
            
            OpportunityProductList.responseWrapper saveresponseannualize = OpportunityProductList.SaveOpportunityProductdata(Json.serialize(responseannualize.ProductsList), opplist[0].Id);
            System.assertEquals('success', saveresponseannualize.responseStatus);
            
            OpportunityProductList.responseWrapper responseannualizenew = OpportunityProductList.getOpportunityProductdata(opplist[0].Id);
            System.assertEquals('success', responseannualizenew.responseStatus);
            
            listofselectedproduct.add(response.ProductsList[0]);
            
            for(Sector_AddProduct.Products eachproduct : listofselectedproduct)
            {
                eachproduct.Volume = 100;
                eachproduct.Revenue = 100;
                eachproduct.ProductProfit = 100;
                eachproduct.ProductProfit = 100;
                eachproduct.co2Emission = 100;
                eachproduct.carbonEmission = 100;
                eachproduct.startyear = ''+2022;
                eachproduct.endyear = ''+2024;
                
            }
            
            responsesave = Sector_AddProduct.SaveEditProductdata(opplist[0].Id, Json.serialize(listofselectedproduct), new List<String>{});
            System.debug('line 269');
            System.debug(responsesave.responseStatus);
            System.debug(responsesave.responseMessage);
            System.assertEquals('success', responsesave.responseStatus);
            
            responseannualizenew = OpportunityProductList.getOpportunityProductdata(opplist[0].Id);
            System.assertEquals('success', responseannualizenew.responseStatus);
            
            
            
            OpportunityLineItem oppline = [Select Id from OpportunityLineItem where OpportunityId =: opplist[0].Id limit 1];
            
            Predicted_Product_Information__c temp_ppi = new Predicted_Product_Information__c();
            temp_ppi.Sales_volume__c = 3423;
            temp_ppi.Revenue__c = 324;
            temp_ppi.Annual_Profit__c = 234;
            temp_ppi.Name = ''+Date.today().addYears(50).year();
            temp_ppi.Opportunity_Product__c = oppline.Id;  
            temp_ppi.Opportunity__c = opplist[0].Id;
            insert temp_ppi;
            
            responseannualizenew = OpportunityProductList.getOpportunityProductdata(opplist[0].Id);
            System.assertEquals('success', responseannualizenew.responseStatus);
            
            
        }
    }
    
    static testmethod void error_get_Save_OpportunityProductdataannualrevnueTest()
    {
        User us = [Select Id from User where email = 'sectortestclassuser@sector.shell.com'];
        
        List<Opportunity> opplist = Sector_TestDataFactory.createOpportunity(1,null, Date.today(), 
                                                                             'Suspect/Lead', 
                                                                             'Sector');
        insert opplist;
        opplist[0].Pricebook2Id = Test.getStandardPricebookId();
        update opplist;
        Sector_AddProduct.responseWrapper response = Sector_AddProduct.getOpportunityProductdata(opplist[0].Id, null, null);
        System.assertEquals('success', response.responseStatus);
        
        List<Sector_AddProduct.Products> listofselectedproduct = new List<Sector_AddProduct.Products>();
        listofselectedproduct.add(response.ProductsList[0]);
        
        for(Sector_AddProduct.Products eachproduct : listofselectedproduct)
        {
            eachproduct.Volume = 100;
            eachproduct.Revenue = 100;
            eachproduct.ProductProfit = 100;
        }
        Sector_AddProduct.responseWrapper responsesave = Sector_AddProduct.SaveEditProductdata(opplist[0].Id, Json.serialize(listofselectedproduct), new List<String>{});
        System.assertEquals('success', responsesave.responseStatus);
        
        
        OpportunityProductList.responseWrapper responseannualize = OpportunityProductList.getOpportunityProductdata(opplist[0].Id);
        System.assertEquals('success', responseannualize.responseStatus);
        
        for(OpportunityProductList.Products eachproducta : responseannualize.ProductsList)
        {
            eachproducta.ProductDetails = new List<OpportunityProductList.ProductDetail>();
            Decimal startyear = 2020;
            for(Integer k = 0; k < 10; k++)
            {
                OpportunityProductList.ProductDetail eachpro = new OpportunityProductList.ProductDetail();
                eachpro.YearOfProduct = startyear + k;
                eachpro.SalesVolume = 100;
                eachpro.SalesRevenue = 100;
                eachpro.SalesProfit = 100;
                eachproducta.ProductDetails.add(eachpro);
            }
        }
        System.runAs(us)
        { 
            OpportunityProductList.responseWrapper saveresponseannualize = OpportunityProductList.SaveOpportunityProductdata(Json.serialize(responseannualize.ProductsList), opplist[0].Id);
            System.assertEquals('error', saveresponseannualize.responseStatus);
        }
    }
    
}