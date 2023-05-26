@isTest
private class SV2020HNDOpportunityHandler_Test{
    @testSetup
    static void setupTestData(){
        test.startTest();
        
        Profile prof = [select id from profile where name='SV2020 Standard Platform User'];
        User usr = new User();
        usr.firstName = 'test1';
        usr.lastName = 'test2';
        usr.profileId = prof.id;
        usr.username = 'test986@test.com';
        usr.email ='test986@test.com';
        usr.Alias= 'test';
        usr.TimeZoneSidKey='America/Los_Angeles';
        usr.LocaleSidKey='en_US';
        usr.EmailEncodingKey='UTF-8';
        usr.LanguageLocaleKey= 'en_US';
        insert usr;
        system.debug('usr::::'+usr);
        
        User usr1 = new User();
        usr1.firstName = 'test';
        usr1.lastName = '4';
        usr1.profileId = prof.id;
        usr1.username = 'test9867@test.com';
        usr1.email ='test9867@test.com';
        usr1.Alias= 'test';
        usr1.TimeZoneSidKey='America/Los_Angeles';
        usr1.LocaleSidKey='en_US';
        usr1.EmailEncodingKey='UTF-8';
        usr1.LanguageLocaleKey= 'en_US';
        insert usr1;
        system.debug('usr1::::'+usr1);
        
        //Account account_Obj = new Account(Name = 'Name106', Watchlist__c = false, Portfolio_Company__c = false);
    Account account_Obj = new Account(Name = 'Name106', Watchlist__c = false);
        Insert account_Obj; 
        GAL__c Gal_obj  = new GAL__c (Name = 'TestGal',Position__c ='test', Email__c ='test@test.com');
        Insert Gal_obj ;
        String recTypeId = Schema.SObjectType.Opportunity__c.getRecordTypeInfosByName().get('Build').getRecordTypeId();
        Opportunity__c opportunity_Obj = new Opportunity__c(Follow_On_Investment__c = false, Stage__c = 'Operate',Reason_for_Closure__c='Sector Relevance'  ,Opportunity_Closed__c = true, BOM__c =usr.Id, Finance_Lead__c =usr.Id,Commercial_Support__c =usr.Id,Finance_Support__c =usr.Id,Business_Lead__c = Gal_obj.id,Business_Support__c= Gal_obj.id,Legal__c= Gal_obj.id,Technical_Lead__c= Gal_obj.id,SF_Business_Lead__c=usr.Id,SF_Business_Support__c=usr.Id,SF_Technical_Lead__c=usr.Id,SF_Legal__c=usr.Id);
        opportunity_Obj.RecordTypeId = recTypeId;
        
        Insert opportunity_Obj; 
        test.stopTest();
    }
    static testMethod void test_ImplementationStage(){
        String recTypeIdImp = Schema.SObjectType.Opportunity__c.getRecordTypeInfosByName().get('Implementation').getRecordTypeId();
        Opportunity__c imp = new Opportunity__c(Name = 'Test stage change', RecordTypeId = recTypeIdImp);
        Insert imp;
        Opportunity__c test = [SELECT Id,Name, Status__c,CP_Stage__c FROM Opportunity__c WHERE Id =: imp.Id][0];
        test.Status__c = 'Opportunity';
        test.CP_Stage__c = 'First invoice payed';
        update test;
        test.Status__c = 'Delivery';
        test.CP_Stage__c = 'Agreeing to T&C';
        update test;
        test.Status__c = 'Lead';
        update test;
    }
    static testMethod void test_recordSharing(){
       // List<Account> account_Obj  =  [SELECT Name,Watchlist__c,Portfolio_Company__c from Account];
        List<Account> account_Obj  =  [SELECT Name,Watchlist__c from Account];
        System.assertEquals(true,account_Obj.size()>0);
        List<Opportunity__c> opportunity_Obj  =  [SELECT Implementation_Lead__c,BOM__c,Finance_Lead__c,SF_Business_Lead__c,SF_Business_Support__c,SF_Technical_Lead__c,SF_Legal__c,Commercial_Support__c,Finance_Support__c,Business_Lead__c,Business_Support__c,Legal__c,Technical_Lead__c,Follow_On_Investment__c,Stage__c,Opportunity_Closed__c from Opportunity__c];
        System.assertEquals(true,opportunity_Obj.size()>0);
        SV2020HNDOpportunityHandler obj01 = new SV2020HNDOpportunityHandler();
        SV2020HNDOpportunityHandler.accountChatterUpdate(account_Obj,account_Obj);
        SV2020HNDOpportunityHandler.recordSharing(opportunity_Obj,new Map<ID,Opportunity__c>());
    }
    static testMethod void test_recordSharingUpdate(){
        //List<Account> account_Obj  =  [SELECT Name,Watchlist__c,Portfolio_Company__c from Account];
        List<Account> account_Obj  =  [SELECT Name,Watchlist__c from Account];
        System.assertEquals(true,account_Obj.size()>0);
        List<Opportunity__c> opportunity_Obj  =  [SELECT BOM__c,Finance_Lead__c,Commercial_Support__c,Finance_Support__c,Business_Lead__c,Business_Support__c,Legal__c,Technical_Lead__c,Follow_On_Investment__c,Stage__c,Opportunity_Closed__c from Opportunity__c];
        System.assertEquals(true,opportunity_Obj.size()>0);
        SV2020HNDOpportunityHandler obj01 = new SV2020HNDOpportunityHandler();
        SV2020HNDOpportunityHandler.recordSharingUpdate(opportunity_Obj,new Map<ID,Opportunity__c>());
    }
    static testMethod void test_OpporChatterUpdate(){
        //List<Account> account_Obj  =  [SELECT Name,Watchlist__c,Portfolio_Company__c from Account];
        List<Account> account_Obj  =  [SELECT Name,Watchlist__c from Account];
        System.assertEquals(true,account_Obj.size()>0);
        List<Opportunity__c> hellOpp  =  [SELECT BOM__c,Finance_Lead__c,Commercial_Support__c,Finance_Support__c,Business_Lead__c,Business_Support__c,Legal__c,Technical_Lead__c,Follow_On_Investment__c,Stage__c,Opportunity_Closed__c from Opportunity__c];
        system.debug('hellOpp:::::'+hellOpp);  
        System.assertEquals(true,hellOpp.size()>0);
        SV2020HNDOpportunityHandler obj01 = new SV2020HNDOpportunityHandler();
        SV2020HNDOpportunityHandler.OpporChatterUpdate(new Map<Id,Opportunity__c>([SELECT BOM__c,Finance_Lead__c,Commercial_Support__c,Finance_Support__c,Business_Lead__c,Business_Support__c,Legal__c,Technical_Lead__c,Follow_On_Investment__c,Stage__c,Opportunity_Closed__c from Opportunity__c]),new Map<Id,Opportunity__c>([SELECT BOM__c,Finance_Lead__c,Commercial_Support__c,Finance_Support__c,Business_Lead__c,Business_Support__c,Legal__c,Technical_Lead__c,Follow_On_Investment__c,Stage__c,Opportunity_Closed__c from Opportunity__c]));
    }
    static testMethod void test_recordSharingUpdateRecord(){
        User us = [Select id,email from User Where email='test9867@test.com'];
        Opportunity__c Opp1  =  [SELECT BOM__c,Finance_Lead__c,Commercial_Support__c,Finance_Support__c,Business_Lead__c,Business_Support__c,Legal__c,Technical_Lead__c,Follow_On_Investment__c,Stage__c,Opportunity_Closed__c from Opportunity__c][0];
        Opp1.BOM__c = us.id;
        update opp1; 
        SV2020HNDOpportunityHandler obj01 = new SV2020HNDOpportunityHandler();
        SV2020HNDOpportunityHandler.OpporChatterUpdate(new Map<Id,Opportunity__c>([SELECT BOM__c,Finance_Lead__c,Commercial_Support__c,Finance_Support__c,Business_Lead__c,Business_Support__c,Legal__c,Technical_Lead__c,Follow_On_Investment__c,Stage__c,Opportunity_Closed__c from Opportunity__c]),new Map<Id,Opportunity__c>([SELECT BOM__c,Finance_Lead__c,Commercial_Support__c,Finance_Support__c,Business_Lead__c,Business_Support__c,Legal__c,Technical_Lead__c,Follow_On_Investment__c,Stage__c,Opportunity_Closed__c from Opportunity__c]));
        
    }
}