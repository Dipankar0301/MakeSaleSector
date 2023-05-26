@isTest
public class OpportunityTriggerTest
{
    @testSetup static void IntialSetup() 
    {
        String orgId = UserInfo.getOrganizationId();  
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');  
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));  
        String uniqueName = orgId + dateString + randomInt; 
        Profile p = [SELECT Id FROM Profile WHERE Name='SEUK']; 
        User u = new User(Alias = 'standt', Email = 'seuktestclassuser@seuk.shell.com', LastName = 'Testing', 
                          EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', 
                          LocaleSidKey = 'en_US', ProfileId = p.Id, 
                          TimeZoneSidKey = 'Europe/Amsterdam', UserName = uniqueName + '@test' + orgId + '.org');
        insert u;
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'SEUK_Super_User'];
        insert new PermissionSetAssignment(AssigneeId = u.id, PermissionSetId = ps.Id);
    }
    static testmethod void test_single_clone()
    {
        User us = [Select Id from User where email = 'seuktestclassuser@seuk.shell.com'];
        Account acc;
        System.runAs(us)
        {
            acc = SEUK_TestDataFactory.createAccount(1, SEUKStaticValues.Account_SEUK_B2B_Accounts)[0];  
            insert acc;
        }
        Integer numofopp = 1;
        List<Opportunity> opplist = SEUK_TestDataFactory.createOpportunity(numofopp, acc.Id, Date.today(), 
                                                                           SEUKStaticValues.Opportunity_StageName, 
                                                                           SEUKStaticValues.Opportunity_SEUK_B2B_Opportunity); 
        insert opplist;
        List<Opportunity> cloneopplist = new List<Opportunity>();
        System.runAs(us)
        {
			for(Opportunity opp : opplist)
            {
                Opportunity cloneopp = opp.clone(false, false);
                cloneopplist.add(cloneopp);
            }
            insert cloneopplist;
        }
        for(Opportunity opp : [Select Id, OwnerId from Opportunity where Id in :cloneopplist ])
        {
			System.assertEquals(USerinfo.getUserId(), opp.OwnerId);
        }
    }
    static testmethod void test_Bulk_Clone()
    {
        User us = [Select Id from User where email = 'seuktestclassuser@seuk.shell.com'];
        Account acc;
        System.runAs(us)
        {
            acc = SEUK_TestDataFactory.createAccount(1, SEUKStaticValues.Account_SEUK_B2B_Accounts)[0];  
            insert acc;
        }
        Integer numofopp = 300;
        List<Opportunity> opplist = SEUK_TestDataFactory.createOpportunity(numofopp, acc.Id, Date.today(), 
                                                                           SEUKStaticValues.Opportunity_StageName, 
                                                                           SEUKStaticValues.Opportunity_SEUK_B2B_Opportunity); 
        insert opplist;
        List<Opportunity> cloneopplist = new List<Opportunity>();
        System.runAs(us)
        {
            for(Opportunity opp : opplist)
            {
                Opportunity cloneopp = opp.clone(false, false);
                cloneopplist.add(cloneopp);
            }
            insert cloneopplist;
        }
        for(Opportunity opp : [Select Id, OwnerId from Opportunity where Id in :cloneopplist ])
        {
            System.assertEquals(USerinfo.getUserId(), opp.OwnerId);
        }
    }
}