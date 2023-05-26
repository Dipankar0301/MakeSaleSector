public class Sector_Print_CallPlanController 
{
    public Id eventId{get;set;}
	Public Event eventrecord{get;set;} 
    Public List<EventRelation> eventrealtionrecords{get;set;} 
    Public Call_Plan__c callplanrecord{get;set;}
    Public List<Contact> contactsinevent{get;set;} 
    Public List<Lead> leadsinevent{get;set;} 
    Public List<User> UsersinLead{get;set;} 
    
    public Sector_Print_CallPlanController() 
    {
        List<ID> relationIds = new List<ID>();
        eventId = ApexPages.currentPage().getParameters().get('id');
        eventrecord = [SELECT Id, Subject, Location, Type, Who.Name, What.Name, Owner.Name, Call_Plan_Record_Type__c, Reason_for_Call__c, ShowAs, 
                       IsAllDayEvent, StartDateTime, EndDateTime, Description, IsRecurrence2, IsPrivate, Parent_Event_Id__c, IsChild,
                       ActivityDate, EndDate, RecordType.DeveloperName,
                       Legal_Name__c, Account.Name
                       FROM Event where Id = :eventId];
        
        String eventidnew  = (eventrecord.Parent_Event_Id__c != null && eventrecord.IsChild) ? eventrecord.Parent_Event_Id__c : eventrecord.Id;
        
        eventrecord = [SELECT Id, Subject, Location, Type, Who.Name, What.Name, Owner.Name, Call_Plan_Record_Type__c, Reason_for_Call__c, ShowAs, 
                       IsAllDayEvent, StartDateTime, EndDateTime, Description, IsRecurrence2, IsPrivate, Parent_Event_Id__c, IsChild,
                       ActivityDate, EndDate, RecordType.DeveloperName,
                       Legal_Name__c, Account.Name
                       FROM Event where Id = :eventidnew];
        
        
        eventrealtionrecords = [SELECT Id, RelationId, Relation.Name, EventId, IsWhat, IsParent, IsInvitee 
                               FROM EventRelation 
                               where EventId = :eventidnew and IsWhat = false];
        
        List<Call_Plan__c> callplanlist = [SELECT Id, Purpose_Objective__c, Premise_Stakeholder__c, Anticipate__c, Strategy_Approach__c, 
                                           Event_Record_Type__c, Agenda__c, Minutes_and_Action__c, EventId__c 
                                           FROM Call_Plan__c
                                           where EventId__c = :eventidnew limit 1];
        
        
        for(EventRelation everelation : eventrealtionrecords)
        {
            relationIds.add(everelation.RelationId);
        }
        
        contactsinevent = [Select Id, Name, Account.Name from Contact where Id in :relationIds];
        leadsinevent = [Select Id, Name, Company from Lead where Id in :relationIds];
        UsersinLead = [Select Id, Name from User where Id in :relationIds];
        
        
        callplanrecord = callplanlist != null && callplanlist.size() > 0 ? callplanlist[0] : new Call_Plan__c();
    }
}