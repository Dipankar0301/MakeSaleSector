@isTest
public class Test_Sector_OpportunityStageChecker 
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
        
        insert new TriggerHandler__c(Name = 'OpportunityTrigger', Active__c = true);
    }
    static testmethod void insertcheck_bulk_error()
    {
        User us = [Select Id from User where email = 'sectortestclassuser@sector.shell.com'];
        System.runAs(us)
        {
            
            List<Opportunity> opplist = Sector_TestDataFactory.createOpportunity(100,null, Date.today(), 
                                                                                 Label.Sector_Opportunity_Won_Stages.split(',')[0], 
                                                                                 Label.Sector_Opportunity_DevRecordTypeName);
            // Perform test
            Test.startTest();
            List<Database.SaveResult> resultlist = Database.insert(opplist, false);
            Test.stopTest();
            for(Database.SaveResult result : resultlist)
            {
                System.assert(!result.isSuccess());
                System.assert(result.getErrors().size() > 0);
                system.debug('line 36'+result.getErrors()[0].getMessage());
                System.assertEquals(true, result.getErrors()[0].getMessage().contains(Label.Sector_stage_validation_error_message));
            }
        }
    }
    static testmethod void insertcheck_bulk_success()
    {
        User us = [Select Id from User where email = 'sectortestclassuser@sector.shell.com'];
        System.runAs(us)
        {
            
            List<Opportunity> opplist = Sector_TestDataFactory.createOpportunity(100,null, Date.today(), 
                                                                                 Label.Sector_Opportunity_Won_Stages.split(',')[0], 
                                                                                 Label.Sector_Opportunity_DevRecordTypeName);
            for(Opportunity opp : opplist)
            {
                opp.Opportunity_Country__c = 'USA';
                opp.Opportunity_Region__c = 'Asiapac';
                opp.Value_Amount__c = 100;
                opp.Status_Reason__c = 'Other';
            }
            // Perform test
            Test.startTest();
            List<Database.SaveResult> resultlist = Database.insert(opplist, false);
            Test.stopTest();
            for(Database.SaveResult result : resultlist)
            {
                System.assert(result.isSuccess());
            }
        }
    }
    static testmethod void updatecheck_bulk_error()
    {
        User us = [Select Id from User where email = 'sectortestclassuser@sector.shell.com'];
        System.runAs(us)
        {
            
            List<Opportunity> opplist = Sector_TestDataFactory.createOpportunity(100,null, Date.today(),  
                                                                                 'Suspect/Lead', 
                                                                                 Label.Sector_Opportunity_DevRecordTypeName);
            insert opplist;
            for(Opportunity opp : opplist)
            {
                opp.StageName = Label.Sector_Opportunity_Won_Stages.split(',')[0];
            }
            
            // Perform test
            Test.startTest();
            List<Database.SaveResult> resultlist = Database.update(opplist, false);
            Test.stopTest();
            for(Database.SaveResult result : resultlist)
            {
                System.assert(!result.isSuccess());
                System.assert(result.getErrors().size() > 0);
                System.assertEquals(true, result.getErrors()[0].getMessage().contains(Label.Sector_stage_validation_error_message));
            }
        }
    }
    static testmethod void updatecheck_bulk_success()
    {
        User us = [Select Id from User where email = 'sectortestclassuser@sector.shell.com'];
        System.runAs(us)
        {
            
            List<Opportunity> opplist = Sector_TestDataFactory.createOpportunity(100,null, Date.today(),  
                                                                                 'Suspect/Lead', 
                                                                                 Label.Sector_Opportunity_DevRecordTypeName);
            insert opplist;
            for(Opportunity opp : opplist)
            {
                opp.StageName = Label.Sector_Opportunity_Won_Stages.split(',')[0];
                opp.Opportunity_Country__c = 'USA';
                opp.Opportunity_Region__c = 'Asiapac';
                opp.Value_Amount__c = 100;
                opp.Status_Reason__c = 'Other';
            }
            
            // Perform test
            Test.startTest();
            List<Database.SaveResult> resultlist = Database.update(opplist, false);
            Test.stopTest();
            for(Database.SaveResult result : resultlist)
            {
                System.assert(result.isSuccess());
            }
        }
    }
    static testmethod void triggerturnoff()
    {
        TriggerHandler__c triggerins = TriggerHandler__c.getInstance('OpportunityTrigger');
        triggerins.Active__c = false;
        update triggerins;
        
        User us = [Select Id from User where email = 'sectortestclassuser@sector.shell.com'];
        System.runAs(us)
        {
            
            List<Opportunity> opplist = Sector_TestDataFactory.createOpportunity(100,null, Date.today(), 
                                                                                 Label.Opportunity_Stage_Name_Negotiate, 
                                                                                 Label.Sector_Opportunity_DevRecordTypeName);
            // Perform test
            Test.startTest();
            List<Database.SaveResult> resultlist = Database.insert(opplist, false);
            Test.stopTest();
            for(Database.SaveResult result : resultlist)
            {
                System.assert(result.isSuccess());
            }
        }
    }
}