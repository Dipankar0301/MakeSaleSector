public with sharing class SectorCalenderAttendeesController 
{
    
    /** start lookup **/
    
    // Method to fetch lookup search result   
    @AuraEnabled(cacheable=true)
    public static responseWrapper fetchLookupData(string searchKey , string sObjectApiName, 
                                                string objectfilters, List<Id> exludelistids, 
                                                Boolean searchshellcontact)
    {    
        responseWrapper response = new responseWrapper();
        try
        {
            List < sObject > returnList = new List < sObject > ();
            if(searchKey != null && searchKey != '')
            {
                string sWildCardText = '%' + searchKey + '%';
                string sQuery = 'Select Id,Name From ' + sObjectApiName + ' Where Name Like : sWildCardText '+objectfilters+' order by Name ASC LIMIT 5';
                for (sObject obj: database.query(sQuery)) 
                {
                    returnList.add(obj);
                } 
                
                if(searchshellcontact == true)
                {
                    for (sObject obj: [Select Id,Name From Contact 
                                       Where Name Like : sWildCardText and 
                                       AccountId= :Label.Sector_ShellAccountId and Id not in :exludelistids 
                                       order by Name ASC LIMIT 5]) 
                    {
                        returnList.add(obj);
                    } 
                }
                
            }
            response.returnsearchresult = returnList;
            response.responseStatus = 'success';
        }
        catch(Exception e)
        {
            response.responseStatus = 'error';
            response.responseMessage = 'Something went wrong. Error: '+e.getMessage()+'. Line number: '+e.getLineNumber()+'. StackTrace: '+e.getStackTraceString()+'. Please try reinitiate the process or contact your system admin.';
        }
        return response;
    }
    
    
    /** end lookup **/
    
    
    
    @AuraEnabled  
    public static responseWrapper getallAttendees(Id recordId)
    {
        responseWrapper response = new responseWrapper();
        try
        {
            String newrecordid = recordId;
            Event eventre = [SELECT Id, OwnerId, Owner.Name, Owner.Email, IsChild, Parent_Event_Id__c FROM Event where Id =:recordId limit 1];
            if(eventre.Parent_Event_Id__c != null && eventre.Id != eventre.Parent_Event_Id__c && eventre.IsChild == true)
            {
                newrecordid =  eventre.Parent_Event_Id__c;
            }
            
            response.neweventrecordId = eventre.Parent_Event_Id__c;
            
            response.isownerofevent = (Userinfo.getUserId() == eventre.OwnerId && eventre.IsChild == false) ? true : false ;
            
            response.Attendees = new List<Attendee>();
            response.AttendeesIds = new List<Id>();
            for(User userre : [Select Id, Name, Email from User 
                               where Id in (SELECT RelationId FROM EventRelation  
                                            where EventId = :newrecordid) and Email != null]) 
            {
                Attendee att = new Attendee();
                att.AttendeeName = userre.Name;
                att.AttendeeEmail = userre.Email;
                att.AttendeeId = userre.Id;
                response.Attendees.add(att);
            }
            
            for(Contact conn : [Select Id, Name, Email from Contact 
                                where Id in (SELECT RelationId FROM EventRelation  
                                             where EventId = :newrecordid ) and Email != null]) 
            {
                Attendee att = new Attendee();
                att.AttendeeName = conn.Name;
                att.AttendeeEmail = conn.Email;
                att.AttendeeId = conn.Id;
                response.Attendees.add(att);
            }
            
            for(Lead leadeach : [Select Id, Name, Email from Lead 
                                 where Id in (SELECT RelationId FROM EventRelation  
                                              where EventId = :newrecordid ) and Email != null]) 
            {
                Attendee att = new Attendee();
                att.AttendeeName = leadeach.Name;
                att.AttendeeEmail = leadeach.Email;
                att.AttendeeId = leadeach.Id;
                response.Attendees.add(att);
            }
            
            Attendee att = new Attendee();
            att.AttendeeName = eventre.Owner.Name;
            att.AttendeeEmail = eventre.Owner.Email;
            att.AttendeeId = eventre.OwnerId;
            response.Attendees.add(att); 
            
            response.AttendeesIds.add(eventre.OwnerId);
            response.responseStatus = 'success';
        }
        catch(Exception e)
        {
            response.responseStatus = 'error';
            response.responseMessage = 'Something went wrong. Error: '+e.getMessage()+'. Line number: '+e.getLineNumber()+'. StackTrace: '+e.getStackTraceString()+'. Please try reinitiate the process or contact your system admin.';
        }
        return response;
    }
    
    
    
    
    
    
    
    @AuraEnabled (cacheable=true)  // Fetch attendee related to event
    public static responseWrapper getAttendees(Id recordId)
    {
        responseWrapper response = new responseWrapper();
        try
        {
            String newrecordid = recordId;
            Event eventre = [SELECT Id, OwnerId, Owner.Name, Owner.Email, IsChild, Parent_Event_Id__c FROM Event where Id =:recordId limit 1];
            if(eventre.Parent_Event_Id__c != null && eventre.Id != eventre.Parent_Event_Id__c && eventre.IsChild == true)
            {
                newrecordid =  eventre.Parent_Event_Id__c;
            }
            
            response.isownerofevent = (Userinfo.getUserId() == eventre.OwnerId && eventre.IsChild == false) ? true : false ;
            
            response.Attendees = new List<Attendee>();
            response.AttendeesIds = new List<Id>();
            for(User userre : [Select Id, Name, Email from User 
                               where Id in (SELECT RelationId FROM EventRelation  
                                            where EventId = :newrecordid)]) 
            {
                Attendee att = new Attendee();
                att.AttendeeName = userre.Name;
                att.AttendeeEmail = userre.Email;
                att.AttendeeId = userre.Id;
                response.Attendees.add(att);
            }
            
            for(Contact conn : [Select Id, Name, Email from Contact 
                                where Id in (SELECT RelationId FROM EventRelation  
                                             where EventId = :newrecordid and IsInvitee = true)]) 
            {
                Attendee att = new Attendee();
                att.AttendeeName = conn.Name;
                att.AttendeeEmail = conn.Email;
                att.AttendeeId = conn.Id;
                response.Attendees.add(att);
            }
            
            for(EventRelation evere : [SELECT RelationId FROM EventRelation  
                                            where EventId = :newrecordid])
            {
                response.AttendeesIds.add(evere.RelationId);
            }
            
            response.AttendeesIds.add(eventre.OwnerId);
            response.responseStatus = 'success';
        }
        catch(Exception e)
        {
            response.responseStatus = 'error';
            response.responseMessage = 'Something went wrong. Error: '+e.getMessage()+'. Line number: '+e.getLineNumber()+'. StackTrace: '+e.getStackTraceString()+'. Please try reinitiate the process or contact your system admin.';
        }
        return response;
    }
    
    
    @AuraEnabled (cacheable=true)  // Fetch attendee related to event
    public static responseWrapper getContacts_Attendee(Id recordId)
    {
        responseWrapper response = new responseWrapper();
        try
        {
            String newrecordid = recordId;
            Event eventre = [SELECT Id, OwnerId, IsChild, Parent_Event_Id__c 
                             FROM Event where Id =:recordId limit 1];
            if(eventre.Parent_Event_Id__c != null && eventre.Id != eventre.Parent_Event_Id__c
               && eventre.IsChild == true)
            {
                newrecordid =  eventre.Parent_Event_Id__c;
            }
            
            response.isownerofevent = (Userinfo.getUserId() == eventre.OwnerId && eventre.IsChild == false) ? true : false ;
            
            response.Attendees = new List<Attendee>();
            response.AttendeesIds = new List<Id>();
            for(Contact conn : [Select Id, Name, Email from Contact 
                                where Id in (SELECT RelationId FROM EventRelation  
                                             where EventId = :newrecordid and IsParent = true)]) 
            {
                Attendee att = new Attendee();
                att.AttendeeName = conn.Name;
                att.AttendeeEmail = conn.Email;
                att.AttendeeId = conn.Id;
                response.Attendees.add(att);
            }
            
            Boolean hasleadinAttendee = false;
            for(Lead ld : [Select Id, Name, Email from Lead 
                           where Id in (SELECT RelationId FROM EventRelation  
                                        where EventId = :newrecordid)]) 
            {
                hasleadinAttendee = true;
                Attendee att = new Attendee();
                att.AttendeeName = ld.Name;
                att.AttendeeEmail = ld.Email;
                att.AttendeeId = ld.Id;
                response.Attendees.add(att);
            }
            
            for(EventRelation evere : [SELECT RelationId FROM EventRelation  
                                       where EventId = :newrecordid])
            {
                response.AttendeesIds.add(evere.RelationId);
            }
            
            response.isownerofevent = (hasleadinAttendee == true) ? false : response.isownerofevent;
            
            response.AttendeesIds.add(eventre.OwnerId);
            response.responseStatus = 'success';
        }
        catch(Exception e)
        {
            response.responseStatus = 'error';
            response.responseMessage = 'Something went wrong. Error: '+e.getMessage()+'. Line number: '+e.getLineNumber()+'. StackTrace: '+e.getStackTraceString()+'. Please try reinitiate the process or contact your system admin.';
        }
        return response;
    }
        
    @AuraEnabled  // save attendee related to event
    public static responseWrapper saveAttendees(Id eventId, Id attendeeId)
    {   
        responseWrapper response = new responseWrapper();
        Savepoint sp = Database.setSavepoint();
        try
        {
            EventRelation er = new EventRelation(EventId = eventId, RelationId = attendeeId, isInvitee = true);
            insert er;
            response.responseMessage = Label.SectorSharewithUser_Attendeeadded;
            response.responseStatus = 'success';
        }
        catch(Exception e)
        {
            Database.rollback(sp);
            response.responseStatus = 'error';
            response.responseMessage = 'Something went wrong. Error: '+e.getMessage()+'. Line number: '+e.getLineNumber()+'. StackTrace: '+e.getStackTraceString()+'. Please try reinitiate the process or contact your system admin.';
        }
        return response;
    }
    
    
    @AuraEnabled  // save attendee related to event
    public static responseWrapper saveAttendees_contact(Id eventId, Id attendeeId)
    {   
        responseWrapper response = new responseWrapper();
        Savepoint sp = Database.setSavepoint();
        try
        {
            EventRelation er = new EventRelation(EventId = eventId, RelationId = attendeeId, 
                                                 isInvitee = false, IsParent = true, IsWhat = false);
            insert er;
            response.responseMessage = Label.SectorSharewithUser_Attendeeadded;
            response.responseStatus = 'success';
        }
        catch(Exception e)
        {
            Database.rollback(sp);
            response.responseStatus = 'error';
            response.responseMessage = 'Something went wrong. Error: '+e.getMessage()+'. Line number: '+e.getLineNumber()+'. StackTrace: '+e.getStackTraceString()+'. Please try reinitiate the process or contact your system admin.';
        }
        return response;
    }
    
    
    @AuraEnabled  // save attendee related to event
    public static responseWrapper SendemailtoAttendee(String recordId, String viewvalue, String Attendeelist, 
                                                      String subjectemail, String bodyemail)
    {   
        System.debug('line 296 of share with user');
        System.debug(bodyemail);
        responseWrapper response = new responseWrapper();
        Savepoint sp = Database.setSavepoint();
        try
        {
            
            Event eve = [Select Id, WhatId from Event where Id  = :recordId];
            List<Attendee> attendeelistc = (List<Attendee>)JSON.deserialize(Attendeelist, List<Attendee>.class); 
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
            List<String> toaddress = new List<String>();
            for(Attendee att : attendeelistc)
            {
                toaddress.add(att.AttendeeId);
            }
            
            if(eve.WhatId != null)
                message.setWhatId(eve.WhatId);
            
            message.setToAddresses(toaddress);
            message.setSubject(subjectemail);
            message.setHTMLBody(bodyemail);
            
            PageReference ref;
            if(viewvalue == 'Customerview')
                ref = page.Sector_Print_Customer_CallPlan;
            else
                ref = page.Sector_Print_CallPlan;
            
            ref.getParameters().put('Id', recordId);
            
            Blob reportPdf;
            if(Test.isRunningTest()) 
            { 
                reportPdf = blob.valueOf('Unit.Test');
            }
            else
            {
                reportPdf = ref.getContentAsPDF();
            }
            
            
            ContentVersion objCV = new ContentVersion(
                Title = 'Meeting Summary',
                PathOnClient = 'CallPlan.pdf',
                VersionData = reportPdf,
                IsMajorVersion = true,
                ContentLocation = 'S'
            );
            insert objCV;
            objCV = [
                SELECT ContentDocumentId
                FROM ContentVersion
                WHERE Id =: objCV.Id
            ];
            ContentDocumentLink objCDL = new ContentDocumentLink(
                ContentDocumentId = objCV.ContentDocumentId,
                LinkedEntityId = recordId,
                Visibility = 'AllUsers'
            );
            insert objCDL;

            message.setEntityAttachments(new String[]{ objCV.ID });
            Messaging.SingleEmailMessage[] messages =  new List<Messaging.SingleEmailMessage> {message};
                Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            if (results[0].success) 
            {
                response.responseMessage = Label.SectorSharewithUser_EventShared;
                response.responseStatus = 'success';
            } 
            else 
            {
                response.responseMessage = 'Event is not shared. '+results[0].errors[0].message+'. Please try again or contact system admin.';
                response.responseStatus = 'error';
            }
        }
        catch(Exception e)
        {
            Database.rollback(sp);
            response.responseStatus = 'error';
            response.responseMessage = 'Something went wrong. Error: '+e.getMessage()+'. Line number: '+e.getLineNumber()+'. StackTrace: '+e.getStackTraceString()+'. Please try reinitiate the process or contact your system admin.';
        }
        return response;
    }
    
    
    
    @AuraEnabled  // delete attendee related to event
    public static responseWrapper deleteAttendees(Id eventId, Id attendeeId)
    {   
        responseWrapper response = new responseWrapper();
        Savepoint sp = Database.setSavepoint();
        try
        {
            
            delete [SELECT Id, RelationId, EventId, IsWhat, IsParent, IsInvitee, AccountId 
                    FROM EventRelation
                    where RelationId =: attendeeId and EventId =: eventId limit 1];
            response.responseMessage = Label.SectorSharewithUser_Attendeedeleted;
            response.responseStatus = 'success';
        }
        catch(Exception e)
        {
            Database.rollback(sp);
            response.responseStatus = 'error';
            response.responseMessage = 'Something went wrong. Error: '+e.getMessage()+'. Line number: '+e.getLineNumber()+'. StackTrace: '+e.getStackTraceString()+'. Please try reinitiate the process or contact your system admin.';
        }
        return response;
    }
    
    
    @AuraEnabled  // delete attendee related to event
    public static responseWrapper deleteAttendees_contact(Id eventId, Id attendeeId)
    {   
        responseWrapper response = new responseWrapper();
        Savepoint sp = Database.setSavepoint();
        try
        {
            
            delete [SELECT Id, RelationId, EventId, IsWhat, IsParent, IsInvitee, AccountId 
                    FROM EventRelation
                    where RelationId =: attendeeId and EventId =: eventId limit 1];
            response.responseMessage = Label.SectorSharewithUser_Attendeedeleted;
            response.responseStatus = 'success';
        }
        catch(Exception e)
        {
            Database.rollback(sp);
            response.responseStatus = 'error';
            response.responseMessage = 'Something went wrong. Error: '+e.getMessage()+'. Line number: '+e.getLineNumber()+'. StackTrace: '+e.getStackTraceString()+'. Please try reinitiate the process or contact your system admin.';
        }
        return response;
    }
    
    
    
    
    
    public class responseWrapper 
    {
        @AuraEnabled public String responseStatus;
        @AuraEnabled public String responseMessage;
        @AuraEnabled public String neweventrecordId;
        @AuraEnabled public List<Attendee> Attendees;
        @AuraEnabled public List<Id> AttendeesIds;
        @AuraEnabled public boolean isownerofevent;
        @AuraEnabled public List <sObject> returnsearchresult;
        
    }
    public class Attendee
    {
        @AuraEnabled public String AttendeeName;
        @AuraEnabled public String AttendeeEmail;
        @AuraEnabled public Id AttendeeId;
    }
}