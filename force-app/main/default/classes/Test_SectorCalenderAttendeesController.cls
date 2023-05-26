@isTest
public class Test_SectorCalenderAttendeesController 
{
    
    @testSetup static void IntialSetup() 
    {
        String orgId = UserInfo.getOrganizationId();  
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');  
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));  
        String uniqueName = orgId + dateString + randomInt; 
        Profile p = [SELECT Id FROM Profile WHERE Name='MakeSaledSector']; 
        User u = new User(Alias = 'standt', Email = 'sectortestclassuser1@sector.shell.com', LastName = 'Testing last', 
                          EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', 
                          LocaleSidKey = 'en_US', ProfileId = p.Id, 
                          TimeZoneSidKey = 'Europe/Amsterdam', UserName = uniqueName + '@test' + orgId + '.org');
        insert u;
        
        
    }
    
    static testmethod void getfetchLookupDataTest()
    {
        User us = [Select Id from User where email = 'sectortestclassuser1@sector.shell.com'];
        System.runAs(us)
        {
            
            List<Account> acclist = Sector_TestDataFactory.createAccount(1, 'Sector');
            insert acclist;
            
            List<Contact> contactlist = Sector_TestDataFactory.createContact(1,acclist[0].Id, 'Sector');
            insert contactlist;
            
            SectorCalenderAttendeesController.responseWrapper result =  SectorCalenderAttendeesController.fetchLookupData('last' , 'user',  '', new List<Id> {}, true);
            System.assertEquals('success', result.responseStatus);
            System.assertEquals(true, result.returnsearchresult.size() > 0);
        }
    }

    static testmethod void getallAttendeesContactTest()
    {
        User us = [Select Id from User where email = 'sectortestclassuser1@sector.shell.com'];
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
            
            
            
            List<Account> acclist = Sector_TestDataFactory.createAccount(1, 'Sector');
            insert acclist;
            
            List<Contact> contactlist = Sector_TestDataFactory.createContact(1,acclist[0].Id, 'Sector');
            contactlist[0].email = 'test@example.com';
            insert contactlist;
            
            SectorCalenderAttendeesController.responseWrapper result = SectorCalenderAttendeesController.saveAttendees(eventrecord.Id, contactlist[0].Id);
            System.assertEquals('success', result.responseStatus);
            
            
            contactlist = Sector_TestDataFactory.createContact(1,acclist[0].Id, 'Sector');
            contactlist[0].email = 'test2543@exampl234e.com';
            insert contactlist;
            
            result = SectorCalenderAttendeesController.saveAttendees_contact(eventrecord.Id, contactlist[0].Id);
            System.assertEquals('success', result.responseStatus);

            result = SectorCalenderAttendeesController.getAttendees(eventrecord.Id);
            System.assertEquals('success', result.responseStatus);
            
            result = SectorCalenderAttendeesController.getContacts_Attendee(eventrecord.Id);
            System.assertEquals('success', result.responseStatus);
            
            result = SectorCalenderAttendeesController.getallAttendees(eventrecord.Id);
            System.assertEquals('success', result.responseStatus);
            
            result = SectorCalenderAttendeesController.SendemailtoAttendee(eventrecord.Id, 'Customerview', JSON.serialize(result.Attendees), 'test', 'test');
            System.assertEquals('success', result.responseStatus);
            
            result = SectorCalenderAttendeesController.deleteAttendees_contact(eventrecord.Id, contactlist[0].Id);
            System.assertEquals('success', result.responseStatus);
            
        }
    }
    
    
    
    static testmethod void getallAttendeesLeadTest()
    {
        User us = [Select Id from User where email = 'sectortestclassuser1@sector.shell.com'];
        String adminuserID = Userinfo.getUserId();
        System.runAs(us)
        {
            Event eventrecord = new Event();
            eventrecord.Subject = 'Test Event';
            eventrecord.IsAllDayEvent = TRUE;
            eventrecord.ActivityDate = Date.today();
            eventrecord.OwnerId = Userinfo.getUserId();
            insert eventrecord;
            
            
            
            List<Lead> leadlist = Sector_TestDataFactory.createLead(1, 'Standard_Lead');
            leadlist[0].email = 'test@example.com';
            insert leadlist;
            
            SectorCalenderAttendeesController.responseWrapper result = SectorCalenderAttendeesController.saveAttendees(eventrecord.Id, leadlist[0].Id);
            System.assertEquals('success', result.responseStatus);
            
            result = SectorCalenderAttendeesController.getAttendees(eventrecord.Id);
            System.assertEquals('success', result.responseStatus);
            
            result = SectorCalenderAttendeesController.getContacts_Attendee(eventrecord.Id);
            System.assertEquals('success', result.responseStatus);
            
            result = SectorCalenderAttendeesController.getallAttendees(eventrecord.Id);
            System.assertEquals('success', result.responseStatus);
            
            result = SectorCalenderAttendeesController.SendemailtoAttendee(eventrecord.Id, 'InternalView', JSON.serialize(result.Attendees), 'test', 'test');
            System.assertEquals('success', result.responseStatus);
            
            result = SectorCalenderAttendeesController.deleteAttendees(eventrecord.Id, leadlist[0].Id);
            System.assertEquals('success', result.responseStatus);

        }
    }
    
    
    static testmethod void getallAttendeeserrorTest()
    {
        User us = [Select Id from User where email = 'sectortestclassuser1@sector.shell.com'];
        String adminuserID = Userinfo.getUserId();
        System.runAs(us)
        {
            SectorCalenderAttendeesController.responseWrapper result = SectorCalenderAttendeesController.getallAttendees(null);
            System.assertEquals('error', result.responseStatus);
            
            result = SectorCalenderAttendeesController.getAttendees(null);
            System.assertEquals('error', result.responseStatus);
            
            result = SectorCalenderAttendeesController.getContacts_Attendee(null);
            System.assertEquals('error', result.responseStatus);
            
            result = SectorCalenderAttendeesController.saveAttendees(null,null);
            System.assertEquals('error', result.responseStatus);
            
            result = SectorCalenderAttendeesController.saveAttendees_contact(null,null);
            System.assertEquals('error', result.responseStatus);
            
            result = SectorCalenderAttendeesController.SendemailtoAttendee(null, 'InternalView', null, 'test', 'test');
            System.assertEquals('error', result.responseStatus);

        }
    }
    
    
}