@isTest
public class AccOppTeamMailTest {
    @isTest
    static void methodA(){
        id userID = UserInfo.getUserId();
        Id recordtypeidorg1= Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId();
        //Id recordtypeidorg2= Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Hydrogen').getRecordTypeId();
        Id recordtypeidorgaccount= Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId();
        Account acc =new Account(Name='DK0301', RecordTypeId= recordtypeidorgaccount, Region__c='Europe', Sector__c='Technology');
        insert acc;
        AccountTeamMember atm = new AccountTeamMember(AccountId=acc.id,TeamMemberRole='Lead Qualifier',UserId=userID);
        insert atm;
        Opportunity obj1 =new Opportunity(recordTypeId= recordtypeidorg1, Name = 'test3', AccountId =acc.id, 
                                        StageName= 'Align', CloseDate = system.today(), Product_Category_1__c= 'Power', 
                                        Product_Sub_Category_1__c='Renewable',Power_Demand_MWh__c=11,
                                          Revenue_End_Date__c=system.today(),Revenue_Start_Date__c=system.today() );
        
        insert obj1;
        OpportunityTeamMember otm = new OpportunityTeamMember(OpportunityId=obj1.id,TeamMemberRole='Lead Qualifier',UserId=userID);
        insert otm;
        delete atm;
        //delete [Select Id from AccountTeamMember where AccountId =: acc.id];
        
        
        Test.startTest();
        AccOppTeamMail.donotsendemail = false;
        System.debug('AccOppTeamMail.donotsendemai test class='+AccOppTeamMail.donotsendemail);
        AccountTeamMember atm1 = new AccountTeamMember(AccountId=acc.id,TeamMemberRole='Account Manager',UserId=userID);
        insert atm1;
        Test.stopTest();
        
    }
    @isTest
    static void methodB(){
        System.debug('Successful 1');
        //id userID = UserInfo.getUserId();
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator']; 
        User userID1 = new User(Alias = 'standt', Email='standarduser@testorg.com', 
            EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
            LocaleSidKey='en_US', ProfileId = p.Id, 
            TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg.com.makesales.Team');
        insert userID1;
        
        //User userID1=[select id from User where isActive=true limit 1];
        
        Id recordtypeidorg1= Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId();
        //Id recordtypeidorg2= Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Hydrogen').getRecordTypeId();
        Id recordtypeidorgaccount= Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId();
        Account acc =new Account(Name='DK03011995', RecordTypeId= recordtypeidorgaccount, Region__c='Europe', Sector__c='Technology');
        insert acc;
        System.debug('Successful 2');
        Opportunity obj1 =new Opportunity(recordTypeId= recordtypeidorg1, Name = 'test3', AccountId =acc.id, 
                                        StageName= 'Align', CloseDate = system.today(), Product_Category_1__c= 'Power', 
                                        Product_Sub_Category_1__c='Renewable',Power_Demand_MWh__c=11,
                                          Revenue_End_Date__c=system.today(),Revenue_Start_Date__c=system.today() );
        
        insert obj1;
        System.debug(obj1.id);
        
        delete [Select Id from OpportunityTeamMember where OpportunityId =: obj1.id];
        
        
        Test.startTest();
        AccOppTeamMail.donotsendemail = false;
        OpportunityTeamMember otm = new OpportunityTeamMember(OpportunityId=obj1.id,TeamMemberRole='Lead Qualifier',UserId=userID1.id);
        insert otm;
        Test.stopTest();

        //delete otm;
    }

}