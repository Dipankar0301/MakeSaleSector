@isTest
public class Test_Sector_Print_CallPlanController 
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
        
        insert new TriggerHandler__c(Name = 'OpportunityTrigger', Active__c = true);
    }
	@isTest
    static void Print_Event()
    {
        User us = [Select Id from User where email = 'sectortestclassuser@sector.shell.com'];
        String adminuserID = Userinfo.getUserId();
        System.runAs(us)
        {
            Event eventrecord = new Event();
            eventrecord.Subject = 'Test Event';
            eventrecord.IsAllDayEvent = TRUE;
            eventrecord.ActivityDate = Date.today();
            eventrecord.OwnerId = Userinfo.getUserId();
            insert eventrecord;
            
            EventRelation er = new EventRelation(EventId = eventrecord.Id, RelationId = adminuserID);
            insert er;
            
            PageReference printevent = Page.Sector_Print_CallPlan;
            Test.setCurrentPage(printevent);
            ApexPages.currentPage().getParameters().put('id',eventrecord.Id);
            Sector_Print_CallPlanController ac = new Sector_Print_CallPlanController();
            
            System.assertEquals(eventrecord.Id, ac.eventId);
            
            System.assertEquals(true, ac.callplanrecord != null);
            
            System.assertEquals(true, ac.eventrealtionrecords.size() > 0);
        }

    }
}