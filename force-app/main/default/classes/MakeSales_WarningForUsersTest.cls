@isTest
public class MakeSales_WarningForUsersTest {
	@isTest
    static void showMessage(){
        Id recordtypeidorg1= Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId();
        //Id recordtypeidorg2= Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Hydrogen').getRecordTypeId();
        Id recordtypeidorgaccount= Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId();
        Account acc =new Account(Name='DK0301', RecordTypeId= recordtypeidorgaccount, Region__c='Europe', Sector__c='Technology');
        insert acc;
        Opportunity obj1 =new Opportunity(recordTypeId= recordtypeidorg1, Name = 'test2', AccountId =acc.id, 
                                        StageName= 'Align', CloseDate = system.today(), Product_Category_1__c= 'Power', 
                                        Product_Sub_Category_1__c='Renewable',Power_Demand_MWh__c=11,
                                          Revenue_End_Date__c=system.today(),Revenue_Start_Date__c=system.today() );
        
        insert obj1;
        Id userID1 = UserInfo.getUserId();
        Boolean bool=MakeSales_WarningForUsers.checkUserRecord(obj1.id,userID1);
        System.assertEquals(false, bool);
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User userID2 = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com.makesales.Team');
        insert userID2;
        Boolean bool2=MakeSales_WarningForUsers.checkUserRecord(obj1.id,userID2.id);
        System.assertEquals(true, bool2);
        OpportunityTeamMember otm =new OpportunityTeamMember(OpportunityId=obj1.id, TeamMemberRole='Other', Team__c='Cities',UserId=userID2.id);
        insert otm;
        Boolean bool3=MakeSales_WarningForUsers.checkUserRecord(obj1.id,userID2.id);
        System.assertEquals(false, bool3);
        
    }
    @isTest
    static void showMessage1(){
        Id recordtypeidorg1= Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId();
        //Id recordtypeidorg2= Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Hydrogen').getRecordTypeId();
        Id recordtypeidorgaccount= Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId();
        Account acc =new Account(Name='DK0301', RecordTypeId= recordtypeidorgaccount, Region__c='Europe', Sector__c='Technology');
        insert acc;
        Opportunity obj1 =new Opportunity(recordTypeId= recordtypeidorg1, Name = 'test2', AccountId =acc.id, 
                                        StageName= 'Align', CloseDate = system.today(), Product_Category_1__c= 'Power', 
                                        Product_Sub_Category_1__c='Renewable',Power_Demand_MWh__c=11,
                                          Revenue_End_Date__c=system.today(),Revenue_Start_Date__c=system.today() );
        
        insert obj1;
        Id userID1 = UserInfo.getUserId();
        Boolean bool1=MakeSales_WarningForUsers.checkUserRecordAccount(acc.id,userID1);
        System.assertEquals(false, bool1);
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User userID2 = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com.makesales.Team');
        insert userID2;
        Boolean bool2=MakeSales_WarningForUsers.checkUserRecordAccount(acc.id,userID2.id);
        System.assertEquals(true, bool2);
    }
}