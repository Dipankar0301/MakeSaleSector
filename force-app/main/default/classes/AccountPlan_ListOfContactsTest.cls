@isTest
public class AccountPlan_ListOfContactsTest {
	
    @isTest
    static void showMessage(){
        Id recordtypeidorgaccount= Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId();
        Id recordtypeidorgcontact= Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId();
        Account acc =new Account(Name='DK0301', RecordTypeId= recordtypeidorgaccount, Region__c='Europe', Sector__c='Technology');
        insert acc;
        Account_Plan__c accplan = new Account_Plan__c(Name='Test',Customer_Name__c=acc.id,Key_Markets__c='Global',Customer_s_Potential_Power_Demand__c=11);
        insert accplan;
        
        Contact con=new Contact(LastName= 'KarmakarTest',AccountId=acc.id,FirstName='Dipankar');
        insert con;
        
        List<Contact> returnConList = AccountPlan_ListOfContacts.getRelatedList(accplan.id);
        
        
        
        System.assertEquals(con.id, returnConList[0].id);
        List<Id> returnidList1 = AccountPlan_ListOfContacts.getAccountId(accplan.id);
        System.assertEquals(acc.id, returnidList1[0]);
        
        
    }
}