@isTest
public class Test_Sector_Opportunity_AddMap 
{
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
    static testmethod void getOpportunitydetails()
    {
        User us = [Select Id from User where email = 'sectortestclassuser@sector.shell.com'];
        System.runAs(us)
        {
            
            List<Opportunity> opplist = Sector_TestDataFactory.createOpportunity(1,null, Date.today(), 
                                                                                 'Suspect/Lead', 
                                                                                 'Sector');
            opplist[0].Billing_Street__c = 'TestStreet1';
            opplist[0].Billing_City__c = 'TestCity1';
            opplist[0].Billing_State_Province__c = 'TestState1';
            opplist[0].Billing_Zip_Postal_Code__c = 'TestPostal1';
            opplist[0].Billing_Country__c = 'TestCountry1';
            insert opplist;
            
            Sector_Opportunity_AddMap.responseWrapper response = Sector_Opportunity_AddMap.getAccountDetails(opplist[0].Id);
            System.assertEquals('success', response.responseStatus);
        }
    }
    static testmethod void TestError()
    {
        User us = [Select Id from User where email = 'sectortestclassuser@sector.shell.com'];
        System.runAs(us)
        {
            Sector_Opportunity_AddMap.responseWrapper response = Sector_Opportunity_AddMap.getAccountDetails(null);
            System.assertEquals('error', response.responseStatus);
        }
    }
}