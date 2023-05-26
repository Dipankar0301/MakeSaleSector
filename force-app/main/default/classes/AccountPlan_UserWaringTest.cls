@isTest
public class AccountPlan_UserWaringTest {
    @isTest
    static void showMessage(){
        Id recordtypeidorg1= Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId();
        //Id recordtypeidorg2= Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Hydrogen').getRecordTypeId();
        Id recordtypeidorgaccount= Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId();
        Account acc =new Account(Name='DK0301', RecordTypeId= recordtypeidorgaccount, Region__c='Europe', Sector__c='Technology');
        insert acc;
        Account_Plan__c accplan = new Account_Plan__c(Name='Test',Customer_Name__c=acc.id,Key_Markets__c='Global',Customer_s_Potential_Power_Demand__c=11);
        insert accplan;
        Id userID1 = UserInfo.getUserId();
        Boolean bool=AccountPlan_UserWaring.checkUserRecord(accplan.id,userID1);
        System.assertEquals(false, bool);
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User userID2 = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                                EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                                LocaleSidKey='en_US', ProfileId = p.Id, 
                                TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com.makesales.Team');
        insert userID2;
        Boolean bool2=AccountPlan_UserWaring.checkUserRecord(accplan.id,userID2.id);
        System.assertEquals(true, bool2);
    }
}