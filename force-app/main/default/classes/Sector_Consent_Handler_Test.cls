@isTest
public class Sector_Consent_Handler_Test {

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
    
    static testmethod void ConsentContactTest()
    {
        User us = [Select Id from User where email = 'sectortestclassuser@sector.shell.com'];
        SV2020RecursiveTriggerHandler.isFirstTime = false;
        System.runAs(us)
        {
            List<Account> accList = new List<Account>();
            List<Contact> conList = new List<Contact>();
            accList = Sector_TestDataFactory.createAccount(20, 'Sector');
            insert acclist;
            
            for(Account acc : acclist)
            {
                conlist.addall(Sector_TestDataFactory.createContact(10,acc.Id, 'Sector'));
            }
            insert conlist; 
            
            List<Id> Contactids = new List<Id>();
            for(Contact conn : conlist)
            {
				Contactids.add(conn.Id);                
            }
            
            Sector_Consent_Handler.updateSFMCPreferenceCenterKey_Contact(Contactids);
            
            for(Contact conn : [Select Id, SFMC_Preference_Center_Key__c from Contact 
                               where Id in :conlist ])
            {
                System.assertEquals(true, conn.SFMC_Preference_Center_Key__c != null);
            }
        }
    }
    
    
    static testmethod void ConsentLeadTest()
    {
        User us = [Select Id from User where email = 'sectortestclassuser@sector.shell.com'];
        System.runAs(us)
        {
            List<Lead> Leadlist = new List<Lead>();
            Leadlist = Sector_TestDataFactory.createLead(200, 'Standard_Lead') ;
            insert Leadlist;
            
            List<Id> leadids = new List<Id>();
            for(Lead leadrecord : Leadlist)
            {
                leadids.add(leadrecord.Id);                
            }
            
            Sector_Consent_LeadUpdateSFMC.updateSFMCPreferenceCenterKey_Lead(leadids);
            
            for(Lead leadrecord : [Select Id, SFMC_Preference_Center_Key__c from Lead 
                                where Id in :leadids ])
            {
                System.assertEquals(true, leadrecord.SFMC_Preference_Center_Key__c != null);
            }
        }
    }
}