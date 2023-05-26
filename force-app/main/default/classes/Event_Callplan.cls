public class Event_Callplan {
    @AuraEnabled
    public static String getCallPlanRecordId(String recId){
        List<Call_Plan__c> cp=[select id from Call_Plan__c where EventId__c=: recId];
        return cp[0].Id;
    }
    @AuraEnabled
    public static String getEventStatus(String recId){
        List<Event> cp=[select id, Status_Event__c from Event where id=: recId];
        return cp[0].Status_Event__c;
    }
    

    
    @AuraEnabled
    public static responseWrapper getCallPlanDetails(String eventId)
    {
        responseWrapper response = new responseWrapper();
        try
        {
            
            response.EventDetails = [select id, Status_Event__c, IsChild, Call_Plan_Record_Type__c,Parent_Event_Id__c, OwnerId 
                                     from Event where id=: eventId];
            
            response.iseventowner = (response.EventDetails.IsChild == false && response.EventDetails.OwnerId == Userinfo.getUserId()) ? true : false;
            
            List<Call_Plan__c> callplanlist = [select id from Call_Plan__c where EventId__c =: eventId];
            
            if(callplanlist.size() > 0)
            {
                response.CallPlanId = callplanlist[0].Id; 
                response.responseStatus = 'success';
            }
            else if(response.EventDetails.Parent_Event_Id__c != null)
            {
                String peventid = response.EventDetails.Parent_Event_Id__c;
                callplanlist = [select id from Call_Plan__c where EventId__c =: peventid];
                response.CallPlanId = callplanlist[0].Id; 
                response.responseStatus = 'success';
            }
            else
            {
                response.responseMessage = 'This is not original event created by Organizer, this is system generated event, please contact Organizer to get orginal Event record.';
                response.responseStatus = 'info';
            }
        }
        catch(Exception e)
        {
            response.responseStatus = 'error';
            response.responseMessage = 'Something went wrong. Error: '+
                e.getMessage()+'. Line number: '+e.getLineNumber()+'. StackTrace: '+e.getStackTraceString()+'. Please try again or contact system admin.';
        }
        return response;
    }
    
    public class responseWrapper 
    {
        @AuraEnabled public String responseStatus;
        @AuraEnabled public String responseMessage;
        @AuraEnabled public String CallPlanId;
        @AuraEnabled public Event EventDetails;
        @AuraEnabled public Boolean iseventowner;
    }

}