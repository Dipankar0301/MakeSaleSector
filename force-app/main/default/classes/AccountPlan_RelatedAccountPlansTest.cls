@isTest
public class AccountPlan_RelatedAccountPlansTest {
    @isTest
    static void showMessage(){
        Id recordtypeidorg1= Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId();
        Id recordtypeidorgaccount= Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId();
        Account acc1 =new Account(Name='DK03011995', RecordTypeId= recordtypeidorgaccount, Region__c='Europe', Sector__c='Technology');
        insert acc1;
        Account acc2 =new Account(Name='DPK0301', RecordTypeId= recordtypeidorgaccount, Region__c='Europe', Sector__c='Technology', ParentId =acc1.id);
        insert acc2;
        Account_Plan__c accplan1 = new Account_Plan__c(Name='Test1',Customer_Name__c=acc1.id,Key_Markets__c='Global',Customer_s_Potential_Power_Demand__c=11);
        insert accplan1;
        Account_Plan__c accplan2 = new Account_Plan__c(Name='Test2',Customer_Name__c=acc2.id,Key_Markets__c='Global',Customer_s_Potential_Power_Demand__c=11);
        insert accplan2;
        List<Account_Plan__c> accplanlist = new List<Account_Plan__c>();
        accplanlist.add(accplan1);
        accplanlist.add(accplan2);
        List<Account_Plan__c> bool=AccountPlan_RelatedAccountPlans.getRelatedList(accplan2.id);
        System.assertEquals(accplanlist.size(), bool.size());
        // I am checking the id's of the account plan from both the lists.
        // If it gives any error then we can remove these two lines as error can come because of the returned list does not have plan in sequence
        System.assertEquals(accplanlist[0].id, bool[0].id);
        System.assertEquals(accplanlist[0].Customer_Name__c, bool[0].Customer_Name__c);
        System.assertEquals(accplanlist[0].Name, bool[0].Name);
        System.assertEquals(accplanlist[1].id, bool[1].id);
        System.assertEquals(accplanlist[1].Customer_Name__c, bool[1].Customer_Name__c);
        System.assertEquals(accplanlist[1].Name, bool[1].Name);
    }
}