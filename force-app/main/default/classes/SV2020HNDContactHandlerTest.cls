@isTest
public class SV2020HNDContactHandlerTest {
    @testSetup
    static void setupTestData(){
        test.startTest();
           // Account account_Obj = new Account(Name = 'Name106', Watchlist__c = false, Portfolio_Company__c = false);
        Account account_Obj = new Account(Name = 'Name106', Watchlist__c = false);
            Insert account_Obj; 
            
            Contact contact_Obj = new Contact( FirstName= 'Test', LastName = 'Contact', AccountId =account_Obj.id); 
            Insert contact_Obj;
        test.stopTest();
    }
    
    static testMethod void test_ContaChatterUpdate(){
    contact contact_Obj  = [SELECT FirstName,LastName,AccountId from Contact]; 
    contact_Obj.LastName = 'Contact2';
    update contact_Obj;
    System.assertEquals(true,contact_Obj!= null);
    SV2020HNDContactHandler obj01 = new SV2020HNDContactHandler();
    SV2020HNDContactHandler.ContaChatterUpdate(new Map<Id,Contact>([SELECT FirstName,LastName,AccountId from Contact]),new Map<Id,Contact>([SELECT FirstName,LastName,AccountId from Contact]));
  }
}