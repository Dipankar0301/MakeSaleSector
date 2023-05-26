@isTest
private class SV2020FileHandler_TestClass {
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
    opportunity_Obj.Account__c  = account_Obj.id;
    Insert opportunity_Obj; 
    test.stopTest();
  }
  static testMethod void test_recordSharing(){
    //List<Account> account_Obj  =  [SELECT id,Name,Watchlist__c,Portfolio_Company__c from Account];
    List<Account> account_Obj  =  [SELECT id,Name,Watchlist__c from Account];
    System.assertEquals(true,account_Obj.size()>0);
    List<Opportunity__c> opportunity_Obj  =  [SELECT id,Account__c,BOM__c,Finance_Lead__c,SF_Business_Lead__c,SF_Business_Support__c,SF_Technical_Lead__c,SF_Legal__c,Commercial_Support__c,Finance_Support__c,Business_Lead__c,Business_Support__c,Legal__c,Technical_Lead__c,Follow_On_Investment__c,Stage__c,Opportunity_Closed__c from Opportunity__c];
    System.assertEquals(true,opportunity_Obj.size()>0);

    Blob beforeblob=Blob.valueOf('Unit Test Attachment Body');

        ContentVersion cv = new ContentVersion();
        cv.title = 'test content trigger';      
        cv.PathOnClient ='test';           
        cv.VersionData =beforeblob;          
        insert cv;         

        ContentVersion testContent = [SELECT id, ContentDocumentId FROM ContentVersion where Id = :cv.Id];

        ContentDocumentLink contentlink=new ContentDocumentLink();
        contentlink.LinkedEntityId=opportunity_Obj[0].id;
        contentlink.ShareType= 'V';
        contentlink.ContentDocumentId=testcontent.ContentDocumentId;

        insert contentlink;
        
        ContentDocumentLink accountcontentlink=new ContentDocumentLink();
        accountcontentlink.LinkedEntityId=account_Obj[0].id;
        accountcontentlink.ShareType= 'V';
        accountcontentlink.ContentDocumentId=testcontent.ContentDocumentId;

        insert accountcontentlink;
    
  }
}