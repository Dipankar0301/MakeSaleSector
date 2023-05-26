/***
Class Name: TestClassSV2020BrightIdeaCentral  
Created Date: 'Nov 05, 2020'
Description: TestClassSV2020BrightIdeaCentral is the test class created for code coverage of the following classes
1) SV2020BrightIdeaCentralScheduler 
2) SV2020BICAccountAndOppBatchClass 
3) SV2020BrightIdeaCentralHttpRequest 
4) SV2020BrightIdeaCentralDuplicate 
5) SV2020BrightIdeaCentralWrapper 
***/
@isTest
private class TestClassSV2020BrightIdeaCentral  {

    static testMethod void executeBatchJob1() {
        
        
        //Test.setMock(HttpCalloutMock.class, new SV2020BICMockHttpAccessResponseGenerator ());  
         Test.setMock(HttpCalloutMock.class, new SV2020BICMockHttpResponseGenerator());      
        Test.startTest();
        
        Account acc = new Account();
            acc.Name = 'Shell Ventures';
            acc.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('SV2020 - Account Creation Layout').getRecordTypeId();
            acc.Website = 'https://testwebsite.com';
            acc.Company_Status__c = 'Active';
            acc.CreatedById = SV2020BrightIdeaCentralWrapper.UserId;
            insert acc;

        Opportunity__c opp = new Opportunity__c();
            opp.Name = 'test name in Seed';
            opp.Round__c = 'Seed';
            opp.RecordTypeId =  Schema.SObjectType.Opportunity__c.getRecordTypeInfosByName().get('Invest').getRecordTypeId();
            opp.Type_of_Investment__c = 'Warrants';
            opp.Stage__c = 'Unreviewed';
            opp.IC__c = 'SVX';
            opp.Fund__c = 'Business Funded';
            opp.Description__c = 'test description';
            opp.Business_Grouping_1__c = 'Cross Business (all lines of business)';
            opp.Business_Grouping_2__c = 'PTX';
            opp.BOM__c = SV2020BrightIdeaCentralWrapper.UserId; // change to Aimee Lafur
            opp.Account__c = acc.Id;
            opp.CreatedById = SV2020BrightIdeaCentralWrapper.UserId;
        insert opp;   
        Test.StopTest();
        Test.setMock(HttpCalloutMock.class, new SV2020BICMockHttpResponseGenerator());
        //String CRON_EXP = '13 18 * * * ? 2022'; //System.schedule('Schedule Job Name 2',  '13 18 * * * ?', new SV2020BrightIdeaCentralScheduler()); 
        //String jobId = System.schedule('SV2020BrightIdeaCentralScheduler',
        //CRON_EXP,
        //new SV2020BrightIdeaCentralScheduler ());
        //String Yesterday= ;
        String date_created = '10/29/2020';        
        //Test.setMock(HttpCalloutMock.class, new SV2020BICMockHttpAccessResponseGenerator ());
        Test.setMock(HttpCalloutMock.class, new SV2020BICMockHttpResponseGenerator());
      Database.executeBatch(new SV2020BICAccountAndOppBatchClass(date_created), 100); 

    }
    static testMethod void executeBatchJob2() {
        
        
        //Test.setMock(HttpCalloutMock.class, new SV2020BICMockHttpAccessResponseGenerator ());  
         Test.setMock(HttpCalloutMock.class, new SV2020BICMockHttpResponseGenerator());      
        Test.startTest();
        
        Account acc = new Account();
            acc.Name = 'Mosaic Materials';
            acc.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('SV2020 - Account Creation Layout').getRecordTypeId();
            acc.Website = 'https://testwebsite.com';
            acc.Company_Status__c = 'Active';
            acc.CreatedById = SV2020BrightIdeaCentralWrapper.UserId;
            insert acc;
        Test.StopTest();
        Test.setMock(HttpCalloutMock.class, new SV2020BICMockHttpResponseGenerator());
        //String CRON_EXP = '13 18 * * * ? 2022'; //System.schedule('Schedule Job Name 2',  '13 18 * * * ?', new SV2020BrightIdeaCentralScheduler()); 
        //String jobId = System.schedule('SV2020BrightIdeaCentralScheduler',
        //CRON_EXP,
        //new SV2020BrightIdeaCentralScheduler ());
        //String Yesterday= ;
        String date_created = '10/29/2020';        
        //Test.setMock(HttpCalloutMock.class, new SV2020BICMockHttpAccessResponseGenerator ());
        Test.setMock(HttpCalloutMock.class, new SV2020BICMockHttpResponseGenerator());
      Database.executeBatch(new SV2020BICAccountAndOppBatchClass(date_created), 100); 

    }
    static testMethod void executeBatchJob3() {
        
        Test.setMock(HttpCalloutMock.class, new SV2020BICMockHttpResponseGenerator());
        Test.setMock(HttpCalloutMock.class, new SV2020BICMockHttpAccessResponseGenerator ());
        Test.startTest();
        
        Account acc = new Account();
            acc.Name = 'BrightIdeaTestAccountPercentageMatchPurpose';
            acc.RecordTypeId =  Schema.SObjectType.Account.getRecordTypeInfosByName().get('SV2020 - Account Creation Layout').getRecordTypeId();
            //acc.Website = 'https://testwebsite.com';
            acc.IC__c = 'SVX';
            acc.Company_Status__c = 'Active';
            acc.CreatedById = SV2020BrightIdeaCentralWrapper.UserId;
            insert acc;

        Opportunity__c opp = new Opportunity__c();
            opp.Name = 'test name in Seed';
            opp.Round__c = 'Seed';
            opp.RecordTypeId =  Schema.SObjectType.Opportunity__c.getRecordTypeInfosByName().get('Invest').getRecordTypeId();
            opp.Type_of_Investment__c = 'Warrants';
            opp.Stage__c = 'Unreviewed';
            opp.IC__c = 'SVX';
            opp.Fund__c = 'Business Funded';
            opp.Description__c = 'test description';
            opp.Business_Grouping_1__c = 'Cross Business (all lines of business)';
            opp.Business_Grouping_2__c = 'PTX';
            opp.BOM__c = SV2020BrightIdeaCentralWrapper.UserId; // change to Aimee Lafur
            opp.Account__c = acc.Id;
            opp.CreatedById = SV2020BrightIdeaCentralWrapper.UserId;
        insert opp;   
        Test.StopTest();
        
        String CRON_EXP = '13 18 * * * ? 2022'; //System.schedule('Schedule Job Name 2',  '13 18 * * * ?', new SV2020BrightIdeaCentralScheduler()); 
        String jobId = System.schedule('SV2020BrightIdeaCentralSchedulerTest',
        CRON_EXP,
        new SV2020BrightIdeaCentralScheduler ());
        Datetime Yesterday= Date.today().addDays(-1);
        String date_created = Yesterday.format('MM/dd/YYYY'); 
        Test.setMock(HttpCalloutMock.class, new SV2020BICMockHttpResponseGenerator());
        Test.setMock(HttpCalloutMock.class, new SV2020BICMockHttpAccessResponseGenerator ());
        //Database.executeBatch(new SV2020BICAccountAndOppBatchClass(date_created), 1); 

    }    
}