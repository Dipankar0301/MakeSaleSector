@isTest
public class Test_Sector_OpportunitiesUpload 
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
        
        Product2 pro = new Product2(Name = 'Other', Family = 'Fuel');
        Insert pro;
        
        
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
    }
    
    static testmethod void OpportunityupdateTest()
    {
        User us = [Select Id from User where email = 'sectortestclassuser@sector.shell.com'];
        System.runAs(us)
        {
            Account acc = new Account(Name = 'Test Account Name312324');
            insert acc;
            
            List<Opportunity> opplist =  Sector_TestDataFactory.createOpportunity(Integer.valueof(Label.Sector_BulkUpdate_MinOpportunityCount),
                                                                                  acc.Id, Date.today(), 
                                                                                  'Suspect/Lead', 
                                                                                  'Sector');
            
            insert opplist;
            
            String csvgenerate = 'Opportunity Id,Opportunity Name,Close Date,Stage,Opportunity Lifetime Revenue (USD$),Gross Margin (USD$),Opportunity Lifetime CO2 Reduction\r\n';
            
            for(Opportunity opp : opplist)
            {
                csvgenerate += ''+opp.Id+','+opp.Name+','+DateTime.newInstance(opp.CloseDate.year(),opp.CloseDate.month(),opp.CloseDate.day()).format('yyyy-MM-dd')+','+opp.StageName+',100,200,234\r\n';
            }
            
            Sector_OpportunitiesUploadController.responseWrapper response = Sector_OpportunitiesUploadController.SectorOpportunityValidateFile('TestFile.csv',csvgenerate, Label.Sector_BulkUpdate_OpportunityLabel);
            System.assertEquals('success', response.responseStatus);
            
            response = Sector_OpportunitiesUploadController.SectorUpdateOpportunity('TestFile.csv',csvgenerate, Label.Sector_BulkUpdate_OpportunityLabel);
            System.assertEquals('success', response.responseStatus);
            
        }
    }
    
    
    static testmethod void MinRowsOpportunityupdateerrorTest()
    {
        User us = [Select Id from User where email = 'sectortestclassuser@sector.shell.com'];
        System.runAs(us)
        {
            Account acc = new Account(Name = 'Test Account Name312324');
            insert acc;
            
            List<Opportunity> opplist =  Sector_TestDataFactory.createOpportunity(Integer.valueof(Label.Sector_BulkUpdate_MinOpportunityCount) - 1,
                                                                                  acc.Id, Date.today(), 
                                                                                  'Suspect/Lead', 
                                                                                  'Sector');
            
            insert opplist;
            
            String csvgenerate = 'Opportunity Id,Opportunity Name,Close Date,Stage,Opportunity Lifetime Revenue (USD$),Gross Margin (USD$),Opportunity Lifetime CO2 Reduction\r\n';
            
            for(Opportunity opp : opplist)
            {
                csvgenerate += ''+opp.Id+','+opp.Name+','+DateTime.newInstance(opp.CloseDate.year(),opp.CloseDate.month(),opp.CloseDate.day()).format('yyyy-MM-dd')+','+opp.StageName+',100,200,342\r\n';
            }
            
            Sector_OpportunitiesUploadController.responseWrapper response = Sector_OpportunitiesUploadController.SectorOpportunityValidateFile('TestFile.csv',csvgenerate, Label.Sector_BulkUpdate_OpportunityLabel);
            System.assertEquals('info', response.responseStatus);
            
            
        }
    }
    
    static testmethod void OpportunityProductdataTest()
    {
        User us = [Select Id from User where email = 'sectortestclassuser@sector.shell.com'];
        System.runAs(us)
        {
            Account acc = new Account(Name = 'Test Account Name312324');
            insert acc;
            
            List<Opportunity> opplist =  Sector_TestDataFactory.createOpportunity(Integer.valueof(Label.Sector_BulkUpdate_MinOpportunityCount),
                                                                                  acc.Id, Date.today(), 
                                                                                  'Suspect/Lead', 
                                                                                  'Sector');
            insert opplist;
            for(Opportunity opp : opplist)
            {
                opp.Pricebook2Id = Test.getStandardPricebookId();
            }
            update opplist;
            
            String csvgenerate = 'Opportunity Id,Product Family,Product Name,Total Volume,Total Revenue (USD$),Total Gross Margin (USD$),Total CO2 Emissions Reduction (Tonnes)\r\n';
            
            String ProductName = 'Other';
            String Productfamily = 'Fuel';
            
            for(Opportunity opp : opplist)
            {
                csvgenerate += ''+opp.Id+','+Productfamily+','+ProductName+',100,200,300,234'+'\r\n';
            }
            
            Sector_OpportunitiesUploadController.SectorPricebookID = Test.getStandardPricebookId();
            Sector_OpportunitiesUploadController.responseWrapper response = Sector_OpportunitiesUploadController.SectorOpportunityValidateFile('TestFile.csv',csvgenerate, Label.Sector_BulkUpdate_OpportunityProduct);
            System.assertEquals('success', response.responseStatus);
            
            
            response = Sector_OpportunitiesUploadController.SectorUpdateOpportunity('TestFile.csv',csvgenerate, Label.Sector_BulkUpdate_OpportunityProduct);
            System.assertEquals('success', response.responseStatus);
            System.debug('response='+response);
            System.debug('responseUpdateOpportunityResult='+response.UpdateOpportunityResult);
            
        }
    }
    
    
    static testmethod void NoAccessOpportunityupdateTest()
    {
        User us = [Select Id from User where email = 'sectortestclassuser@sector.shell.com'];
        Account acc = new Account(Name = 'Test Account Name312324');
        insert acc;
        
        List<Opportunity> opplist =  Sector_TestDataFactory.createOpportunity(Integer.valueof(Label.Sector_BulkUpdate_MinOpportunityCount),
                                                                              acc.Id, Date.today(), 
                                                                              'Suspect/Lead', 
                                                                              'Sector');
        insert opplist;
        System.runAs(us)
        {
            
            
            String csvgenerate = 'Opportunity Id,Opportunity Name,Close Date,Stage,Opportunity Lifetime Revenue (USD$),Gross Margin (USD$),Opportunity Lifetime CO2 Reduction\r\n';
            
            for(Opportunity opp : opplist)
            {
                csvgenerate += ''+opp.Id+','+opp.Name+','+DateTime.newInstance(opp.CloseDate.year(),opp.CloseDate.month(),opp.CloseDate.day()).format('yyyy-MM-dd')+','+opp.StageName+',100,200,34\r\n';
            }
            
            Sector_OpportunitiesUploadController.responseWrapper response = Sector_OpportunitiesUploadController.SectorOpportunityValidateFile('TestFile.csv',csvgenerate, Label.Sector_BulkUpdate_OpportunityLabel);
            System.assertEquals('success', response.responseStatus);
            
            response = Sector_OpportunitiesUploadController.SectorUpdateOpportunity('TestFile.csv',csvgenerate, Label.Sector_BulkUpdate_OpportunityLabel);
            System.assertEquals('success', response.responseStatus);
            
        }
    }
    
    static testmethod void NoAccessOpportunityProductdataTest()
    {
        User us = [Select Id from User where email = 'sectortestclassuser@sector.shell.com'];
        Account acc = new Account(Name = 'Test Account Name312324');
        insert acc;
        
        List<Opportunity> opplist =  Sector_TestDataFactory.createOpportunity(Integer.valueof(Label.Sector_BulkUpdate_MinOpportunityCount),
                                                                              acc.Id, Date.today(), 
                                                                              'Suspect/Lead', 
                                                                              'Sector');
        for(Opportunity opp : opplist)
        {
            opp.Pricebook2Id = Test.getStandardPricebookId();
        }
        insert opplist;
        
        System.runAs(us)
        {
            
            
            String csvgenerate = 'Opportunity Id,Product Family,Product Name,Total Volume,Total Revenue (USD$),Total Gross Margin (USD$),Total CO2 Emissions Reduction (Tonnes)\r\n';
            
            String ProductName = 'Other';
            String Productfamily = 'Fuel';
            
            for(Opportunity opp : opplist)
            {
                csvgenerate += ''+opp.Id+','+Productfamily+','+ProductName+',100,200,300,764'+'\r\n';
            }
            
            Sector_OpportunitiesUploadController.SectorPricebookID = Test.getStandardPricebookId();
            Sector_OpportunitiesUploadController.responseWrapper response = Sector_OpportunitiesUploadController.SectorOpportunityValidateFile('TestFile.csv',csvgenerate, Label.Sector_BulkUpdate_OpportunityProduct);
            System.assertEquals('success', response.responseStatus);
            
            response = Sector_OpportunitiesUploadController.SectorUpdateOpportunity('TestFile.csv',csvgenerate, Label.Sector_BulkUpdate_OpportunityProduct);
            System.assertEquals('success', response.responseStatus);
            
        }
    }
    
    static testmethod void OpportunityupdateMorerowsTest() 
    {
        User us = [Select Id from User where email = 'sectortestclassuser@sector.shell.com'];
        Account acc = new Account(Name = 'Test Account Name312324');
        insert acc;
        
        List<Opportunity> opplist =  Sector_TestDataFactory.createOpportunity(Sector_OpportunitiesUploadController.MaxLimitofrows+1,acc.Id, Date.today(), 
                                                                              'Suspect/Lead', 
                                                                              'Sector');
        insert opplist;
        System.runAs(us)
        {
            
            
            String csvgenerate = 'Opportunity Id,Opportunity Name,Close Date,Stage,Opportunity Lifetime Revenue (USD$),Gross Margin (USD$),Opportunity Lifetime CO2 Reduction\r\n';
            
            for(Opportunity opp : opplist)
            {
                csvgenerate += ''+opp.Id+','+opp.Name+','+DateTime.newInstance(opp.CloseDate.year(),opp.CloseDate.month(),opp.CloseDate.day()).format('yyyy-MM-dd')+','+opp.StageName+',200,100,324\r\n';
            }
            
            Sector_OpportunitiesUploadController.responseWrapper response = Sector_OpportunitiesUploadController.SectorOpportunityValidateFile('TestFile.csv',csvgenerate, Label.Sector_BulkUpdate_OpportunityLabel);
            System.assertEquals('info', response.responseStatus);
            System.assertEquals(Label.Sector_BulkUpdate_Limitrecords, response.responseMessage);
            
            
        }
    }
    
    
    static testmethod void OpportunityupdateWrongdateformatTest()
    {
        User us = [Select Id from User where email = 'sectortestclassuser@sector.shell.com'];
        Account acc = new Account(Name = 'Test Account Name312324');
        insert acc;
        
        List<Opportunity> opplist =  Sector_TestDataFactory.createOpportunity(Integer.valueof(Label.Sector_BulkUpdate_MinOpportunityCount),
                                                                              acc.Id, Date.today(), 
                                                                              'Suspect/Lead', 
                                                                              'Sector');
        insert opplist;
        System.runAs(us)
        {
            
            
            String csvgenerate = 'Opportunity Id,Opportunity Name,Close Date,Stage,Opportunity Lifetime Revenue (USD$),Gross Margin (USD$),Opportunity Lifetime CO2 Reduction\r\n';
            
            for(Opportunity opp : opplist)
            {
                csvgenerate += ''+opp.Id+','+opp.Name+','+DateTime.newInstance(opp.CloseDate.year(),opp.CloseDate.month(),opp.CloseDate.day()).format('dd-mm-yy')+','+opp.StageName+',200,100,324\r\n';
            }
            
            Sector_OpportunitiesUploadController.responseWrapper response = Sector_OpportunitiesUploadController.SectorOpportunityValidateFile('TestFile.csv',csvgenerate, Label.Sector_BulkUpdate_OpportunityLabel);
            System.assertEquals('success', response.responseStatus);
            
        }
    }
    
    
    static testmethod void OpportunityProductNoProductFound_wrongdatatypedataTest()
    {
        User us = [Select Id from User where email = 'sectortestclassuser@sector.shell.com'];
        Account acc = new Account(Name = 'Test Account Name312324');
        insert acc;
        
        List<Opportunity> opplist =  Sector_TestDataFactory.createOpportunity(10,acc.Id, Date.today(), 
                                                                              'Suspect/Lead', 
                                                                              'Sector');
        for(Opportunity opp : opplist)
        {
            opp.Pricebook2Id = Test.getStandardPricebookId();
        }
        insert opplist;
        
        System.runAs(us)
        {
            
            
            String csvgenerate = 'Opportunity Id,Product Family,Product Name,Total Volume,Total Revenue (USD$),Total Gross Margin (USD$),Total CO2 Emissions Reduction (Tonnes)\r\n';
            
            String ProductName = 'Noproductname';
            String Productfamily = 'Nofamilyname';
            
            for(Opportunity opp : opplist)
            {
                csvgenerate += ''+'abc'+','+Productfamily+','+ProductName+',abc,sa,sad,dsf'+'\r\n';
            }
            
            
            Sector_OpportunitiesUploadController.datareturn('Boolean', 'true');
            Sector_OpportunitiesUploadController.datareturn('reference', 'test');
            
            Sector_OpportunitiesUploadController.SectorPricebookID = Test.getStandardPricebookId();
            Sector_OpportunitiesUploadController.responseWrapper response = Sector_OpportunitiesUploadController.SectorOpportunityValidateFile('TestFile.csv',csvgenerate, Label.Sector_BulkUpdate_OpportunityProduct);
            System.assertEquals('success', response.responseStatus);
            
            response = Sector_OpportunitiesUploadController.SectorOpportunityValidateFile('TestFile.csv',null, Label.Sector_BulkUpdate_OpportunityProduct);
            System.assertEquals('error', response.responseStatus);
            
            response = Sector_OpportunitiesUploadController.SectorUpdateOpportunity('TestFile.csv',csvgenerate, Label.Sector_BulkUpdate_OpportunityProduct);
            System.assertEquals('error', response.responseStatus);
            
        }
    }
    
    
    static testmethod void OpportunityForecastingdataTest()
    {
        User us = [Select Id from User where email = 'sectortestclassuser@sector.shell.com'];
        System.runAs(us)
        {
            Account acc = new Account(Name = 'Test Account Name312324');
            insert acc;
            
            List<Opportunity> opplist =  Sector_TestDataFactory.createOpportunity(10,
                                                                                  acc.Id, Date.today(), 
                                                                                  'Suspect/Lead', 
                                                                                  'Sector');
            insert opplist;
            for(Opportunity opp : opplist)
            {
                opp.Pricebook2Id = Test.getStandardPricebookId();
            }
            update opplist;
            
            
            String csvgenerate = 'Opportunity Id,Product Family,Product Name,Total Volume,Total Revenue (USD$),Total Gross Margin (USD$),Total CO2 Emissions Reduction (Tonnes)\r\n';
            
            String ProductName = 'Other';
            String Productfamily = 'Fuel';
            
            for(Opportunity opp : opplist)
            {
                csvgenerate += ''+opp.Id+','+Productfamily+','+ProductName+',100,200,300,3423'+'\r\n';
            }
            
            Sector_OpportunitiesUploadController.SectorPricebookID = Test.getStandardPricebookId();
            Sector_OpportunitiesUploadController.responseWrapper response = Sector_OpportunitiesUploadController.SectorOpportunityValidateFile('TestFile.csv',csvgenerate, Label.Sector_BulkUpdate_OpportunityProduct);
            System.assertEquals('success', response.responseStatus);
            
            
            response = Sector_OpportunitiesUploadController.SectorUpdateOpportunity('TestFile.csv',csvgenerate, Label.Sector_BulkUpdate_OpportunityProduct);
            System.assertEquals('success', response.responseStatus);
            System.debug('response='+response);
            System.debug('responseUpdateOpportunityResult='+response.UpdateOpportunityResult);
            
            csvgenerate = 'Opportunity Id,Product Family,Product Name,Year,Annual Volume,Annual Revenue (USD$),Annual Gross Margin (USD$),Annual CO2 Emissions Reduction (Tonnes)\r\n';

            
            for(Opportunity opp : opplist)
            {
                csvgenerate += ''+opp.Id+','+Productfamily+','+ProductName+',2030,100,200,300,344'+'\r\n';
            }
            
            Sector_OpportunitiesUploadController.SectorPricebookID = Test.getStandardPricebookId();
            response = Sector_OpportunitiesUploadController.SectorOpportunityValidateFile('TestFile.csv',csvgenerate, Label.Sector_BulkUpdate_ProductForecast);
            System.assertEquals('success', response.responseStatus);
            
            
            response = Sector_OpportunitiesUploadController.SectorUpdateOpportunity('TestFile.csv',csvgenerate, Label.Sector_BulkUpdate_ProductForecast);
            System.assertEquals('success', response.responseStatus);
            
            
            response = Sector_OpportunitiesUploadController.SectorOpportunityValidateFile('TestFile.csv',csvgenerate, Label.Sector_BulkUpdate_ProductForecast);
            System.assertEquals('success', response.responseStatus);
            
            
            response = Sector_OpportunitiesUploadController.SectorUpdateOpportunity('TestFile.csv',csvgenerate, Label.Sector_BulkUpdate_ProductForecast);
            System.assertEquals('success', response.responseStatus);
            
            

            
        }
    }
    
    
    static testmethod void OpportunityForecastingDuplicateProductdataTest()
    {
        User us = [Select Id from User where email = 'sectortestclassuser@sector.shell.com'];
        System.runAs(us)
        {
            Account acc = new Account(Name = 'Test Account Name312324');
            insert acc;
            
            List<Opportunity> opplist =  Sector_TestDataFactory.createOpportunity(10,
                                                                                  acc.Id, Date.today(), 
                                                                                  'Suspect/Lead', 
                                                                                  'Sector');
            insert opplist;
            for(Opportunity opp : opplist)
            {
                opp.Pricebook2Id = Test.getStandardPricebookId();
            }
            update opplist;
            
            
            String csvgenerate = 'Opportunity Id,Product Family,Product Name,Total Volume,Total Revenue (USD$),Total Gross Margin (USD$),Total CO2 Emissions Reduction (Tonnes)\r\n';
            
            String ProductName = 'Other';
            String Productfamily = 'Fuel';
            
            for(Opportunity opp : opplist)
            {
                csvgenerate += ''+opp.Id+','+Productfamily+','+ProductName+',100,200,300,324'+'\r\n';
            }
            
            Sector_OpportunitiesUploadController.SectorPricebookID = Test.getStandardPricebookId();
            Sector_OpportunitiesUploadController.responseWrapper response = Sector_OpportunitiesUploadController.SectorOpportunityValidateFile('TestFile.csv',csvgenerate, Label.Sector_BulkUpdate_OpportunityProduct);
            System.assertEquals('success', response.responseStatus);
            
            
            response = Sector_OpportunitiesUploadController.SectorUpdateOpportunity('TestFile.csv',csvgenerate, Label.Sector_BulkUpdate_OpportunityProduct);
            System.assertEquals('success', response.responseStatus);
            System.debug('response='+response);
            System.debug('responseUpdateOpportunityResult='+response.UpdateOpportunityResult);
            
            Sector_OpportunitiesUploadController.SectorPricebookID = Test.getStandardPricebookId();
            response = Sector_OpportunitiesUploadController.SectorOpportunityValidateFile('TestFile.csv',csvgenerate, Label.Sector_BulkUpdate_OpportunityProduct);
            System.assertEquals('success', response.responseStatus);
            
            
            response = Sector_OpportunitiesUploadController.SectorUpdateOpportunity('TestFile.csv',csvgenerate, Label.Sector_BulkUpdate_OpportunityProduct);
            System.assertEquals('success', response.responseStatus);
            System.debug('response='+response);
            System.debug('responseUpdateOpportunityResult='+response.UpdateOpportunityResult);
            
            
            csvgenerate = 'Opportunity Id,Product Family,Product Name,Year,Annual Volume,Annual Revenue (USD$),Annual Gross Margin (USD$),Annual CO2 Emissions Reduction (Tonnes)\r\n';
            
            
            for(Opportunity opp : opplist)
            {
                csvgenerate += ''+opp.Id+','+Productfamily+','+ProductName+',2030,100,200,300,3423'+'\r\n';
            }
            
            Sector_OpportunitiesUploadController.SectorPricebookID = Test.getStandardPricebookId();
            response = Sector_OpportunitiesUploadController.SectorOpportunityValidateFile('TestFile.csv',csvgenerate, Label.Sector_BulkUpdate_ProductForecast);
            System.assertEquals('success', response.responseStatus);
            
            
            response = Sector_OpportunitiesUploadController.SectorUpdateOpportunity('TestFile.csv',csvgenerate, Label.Sector_BulkUpdate_ProductForecast);
            System.assertEquals('success', response.responseStatus);
            
            
            response = Sector_OpportunitiesUploadController.SectorOpportunityValidateFile('TestFile.csv',csvgenerate, Label.Sector_BulkUpdate_ProductForecast);
            System.assertEquals('success', response.responseStatus);
            
            
            response = Sector_OpportunitiesUploadController.SectorUpdateOpportunity('TestFile.csv',csvgenerate, Label.Sector_BulkUpdate_ProductForecast);
            System.assertEquals('success', response.responseStatus);
            
            
            
            
        }
    }
    
    
    static testmethod void NoAccessOpportunityForecastingdataTest()
    {
        User us = [Select Id from User where email = 'sectortestclassuser@sector.shell.com'];
        Account acc = new Account(Name = 'Test Account Name312324');
        insert acc;
        
        List<Opportunity> opplist =  Sector_TestDataFactory.createOpportunity(Integer.valueof(Label.Sector_BulkUpdate_MinOpportunityCount),
                                                                              acc.Id, Date.today(), 
                                                                              'Suspect/Lead', 
                                                                              'Sector');
        for(Opportunity opp : opplist)
        {
            opp.Pricebook2Id = Test.getStandardPricebookId();
        }
        insert opplist;
        
        System.runAs(us)
        {
            
            Sector_OpportunitiesUploadController.SectorGetOwnOpportunities(true);
            Sector_OpportunitiesUploadController.SectorGetOwnOpportunities(false);
            String csvgenerate = 'Opportunity Id,Product Family,Product Name,Year,Annual Volume,Annual Revenue (USD$),Annual Gross Margin (USD$),Annual CO2 Emissions Reduction (Tonnes)\r\n';
            
            String ProductName = 'Other';
            String Productfamily = 'Fuel';
            
            for(Opportunity opp : opplist)
            {
                csvgenerate += ''+opp.Id+','+Productfamily+','+ProductName+',2030,100,200,300,324'+'\r\n';
                csvgenerate += ''+opp.Id+','+Productfamily+','+ProductName+',2030,100,200,300,234'+'\r\n';
            }
            
            Sector_OpportunitiesUploadController.SectorPricebookID = Test.getStandardPricebookId();
            Sector_OpportunitiesUploadController.responseWrapper response = Sector_OpportunitiesUploadController.SectorOpportunityValidateFile('TestFile.csv',csvgenerate, Label.Sector_BulkUpdate_ProductForecast);
            System.assertEquals('success', response.responseStatus);
            
            response = Sector_OpportunitiesUploadController.SectorUpdateOpportunity('TestFile.csv',csvgenerate, Label.Sector_BulkUpdate_ProductForecast);
            System.assertEquals('success', response.responseStatus);
            
        }
    }
    
    
    static testmethod void OpportunityForecastingNoProductFound_wrongdatatypedataTest()
    {
        User us = [Select Id from User where email = 'sectortestclassuser@sector.shell.com'];
        Account acc = new Account(Name = 'Test Account Name312324');
        insert acc;
        
        List<Opportunity> opplist =  Sector_TestDataFactory.createOpportunity(10,acc.Id, Date.today(), 
                                                                              'Suspect/Lead', 
                                                                              'Sector');
        for(Opportunity opp : opplist)
        {
            opp.Pricebook2Id = Test.getStandardPricebookId();
        }
        insert opplist;
        
        System.runAs(us)
        {
            
            
            String csvgenerate = 'Opportunity Id,Product Family,Product Name,Year,Annual Volume,Annual Revenue (USD$),Annual Gross Margin (USD$),Annual CO2 Emissions Reduction (Tonnes)\r\n';
            
            String ProductName = 'Noproductname';
            String Productfamily = 'Nofamilyname';
            
            for(Opportunity opp : opplist)
            {
                csvgenerate += ''+opp.Id+','+Productfamily+','+ProductName+',9000,dsf,234,sfgfd,ds'+'\r\n';
            }
            
            
            Sector_OpportunitiesUploadController.datareturn('Boolean', 'true');
            Sector_OpportunitiesUploadController.datareturn('reference', 'test');
            
            Sector_OpportunitiesUploadController.SectorPricebookID = Test.getStandardPricebookId();
            Sector_OpportunitiesUploadController.responseWrapper response = Sector_OpportunitiesUploadController.SectorOpportunityValidateFile('TestFile.csv',csvgenerate, Label.Sector_BulkUpdate_ProductForecast);
            System.assertEquals('success', response.responseStatus);
            
            response = Sector_OpportunitiesUploadController.SectorOpportunityValidateFile('TestFile.csv',null, Label.Sector_BulkUpdate_ProductForecast);
            System.assertEquals('error', response.responseStatus);
            
            response = Sector_OpportunitiesUploadController.SectorUpdateOpportunity('TestFile.csv',csvgenerate, Label.Sector_BulkUpdate_ProductForecast);
            System.assertEquals('error', response.responseStatus);
            
        }
    }
    
    
    
    public static testMethod void readIETFRFC4180CSVValueTest() {
        String data = null;  // Placeholder for data to use in testing.
        
        System.debug(data = Parser.CRLF);
        new CSVReader.CSVValue('', false, Parser.CRLF)
            .assertEquals(CSVReader.readIETFRFC4180CSVValue(data));
        
        System.debug(data = '""' + Parser.CRLF);
        new CSVReader.CSVValue('', true, Parser.CRLF)
            .assertEquals(CSVReader.readIETFRFC4180CSVValue(data));
        
        System.debug(data = '"",asdf' + Parser.CRLF);
        new CSVReader.CSVValue('', true, Parser.COMMA)
            .assertEquals(CSVReader.readIETFRFC4180CSVValue(data));
        
        System.debug(data = ',asdf' + Parser.CRLF);
        new CSVReader.CSVValue('', false, Parser.COMMA)
            .assertEquals(CSVReader.readIETFRFC4180CSVValue(data));
        
        System.debug(data = '"' + Parser.CRLF + '",blah' + Parser.CRLF);
        new CSVReader.CSVValue(Parser.CRLF, true, Parser.COMMA)
            .assertEquals(CSVReader.readIETFRFC4180CSVValue(data));
        
        System.debug(data = '"""marty""","""chang"""' + Parser.CRLF);
        new CSVReader.CSVValue('"marty"', true, Parser.COMMA)
            .assertEquals(CSVReader.readIETFRFC4180CSVValue(data));
        
        System.debug(data = '"com""pli""cate' + Parser.CRLF + 'd"'
                     + Parser.CRLF);
        new CSVReader.CSVValue('com"pli"cate' + Parser.CRLF + 'd', true, Parser.CRLF)
            .assertEquals(CSVReader.readIETFRFC4180CSVValue(data));
        
        System.debug(data = 'asdf' + Parser.CRLF);
        new CSVReader.CSVValue('asdf', false, Parser.CRLF)
            .assertEquals(CSVReader.readIETFRFC4180CSVValue(data));
    }
    
    
    
}