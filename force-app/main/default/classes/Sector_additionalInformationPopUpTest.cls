@isTest
public class Sector_additionalInformationPopUpTest {

    @testSetup static void IntialSetup() 
    {
        String orgId = UserInfo.getOrganizationId();  
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');  
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));  
        String uniqueName = orgId + dateString + randomInt; 
        Profile p = [SELECT Id FROM Profile WHERE Name='MakeSaledSector'];
        Profile p1 = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        User u = new User(Alias = 'standt', Email = 'sectortestclassuser@sector.shell.com', LastName = 'Testing', 
                          EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', 
                          LocaleSidKey = 'en_US', ProfileId = p.Id, 
                          TimeZoneSidKey = 'Europe/Amsterdam', UserName = uniqueName + '@test' + orgId + '.org');
        insert u;
        User u1 = new User(Alias = 'standt1', Email = 'sector1testclassuser@sector.shell.com', LastName = 'Testing1', 
                          EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', 
                          LocaleSidKey = 'en_US', ProfileId = p1.Id, 
                          TimeZoneSidKey = 'Europe/Amsterdam', UserName = uniqueName + '@test' + orgId + '.org1');
        insert u1;
    }
    static testmethod void testcheckOpportunityRecord()
    {
        User us = [Select Id from User where email = 'sectortestclassuser@sector.shell.com'];
        User us1 = [Select Id from User where email = 'sector1testclassuser@sector.shell.com'];
        System.runAs(us)
        {
            String loggedUserId = UserInfo.getUserId();
            Id recordtypeidorg1= Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId();
            Id recordtypeidorgaccount= Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId();
            Account acc =new Account(Name='Dipankar030195', RecordTypeId= recordtypeidorgaccount, Region__c='Americas;Asiapac;Australia', Sector__c='Technology');
            insert acc;
            Opportunity obj1 =new Opportunity(recordTypeId= recordtypeidorg1, Name = 'additionalInformation', AccountId =acc.id, StageName= 'Align', 
                                              CloseDate = system.today(),Fulfilled_by__c='TBC;Bitumen', Opportunity_Region__c='Americas;Asiapac;Australia',
                                              Opportunity_Country__c='Argentina;Barbados',Opportunity_City__c='Bangalore;Kolkata');
            
            insert obj1;
            Boolean bool=Sector_additionalInformationPopUp.checkOpportunityRecord(obj1.id);
            System.assertEquals(bool,false);
            obj1.OwnerId =loggedUserId;
            //update obj1;
            //Boolean bool1=Sector_additionalInformationPopUp.checkOpportunityRecord(obj1.id);
            //System.assertEquals(bool1,true);
        }
    }
    
}