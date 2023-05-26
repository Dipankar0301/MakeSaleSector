@isTest
public class AccountTriggerTest {

    
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
    }
    static testmethod void SingleBackStopDateTest_GasMeter_Zero()
    {
		User us = [Select Id from User where email = 'sectortestclassuser@sector.shell.com'];
        System.runAs(us)
        {
            Id recordtypeidorgaccount= Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId();
        	Account acc =new Account(Name='Top level Account 1123', RecordTypeId= recordtypeidorgaccount, Region__c='Europe', Sector__c='Technology',Account_Type__c=
                                    'Enterprise Account',Sub_sectors__c = 'other');
        	insert acc;
            Account acc1 =new Account(Name='list view Account Test 1225', RecordTypeId= recordtypeidorgaccount, Region__c='Europe', Sector__c='Technology',ParentId = acc.id,
                                     Account_Type__c = 'Enterprise Account',Sub_sectors__c = 'other');
        	insert acc1;
            
            
            //Boolean bool1=MakeSaled_Opportunity_stagePopUp.checkRecordLock(obj1.id);
        	System.assertEquals(acc.Owner_Name__c,acc1.Top_Level_Account_Owner_Name__c);
        }
    }
}