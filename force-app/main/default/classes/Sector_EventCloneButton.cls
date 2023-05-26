public class Sector_EventCloneButton {
    
    //private final static Map<String, PicklistEntries> uiApiCache = new Map<String, PicklistEntries>();
    
    @AuraEnabled
    public static User getUserDetails(){
        return [SELECT id,Profile.Name,ProfileID FROM User WHERE Id =:userInfo.getUserId() limit 1];
    }
    
    
    @AuraEnabled
    public static responseWrapper getEventClone(String eventId,Event eventRecord) {
        responseWrapper response = new responseWrapper();
        try
        {
            //String CALL_PLAN = 'SHL_Call_Plan__c';
            String message='';
            system.debug(eventId);
            String objectName = 'Event';  
            String query = 'SELECT';
            Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
            for(String s : objectFields.keySet()) {
                query += ' ' + s + ', ';
            }
            query += 'Account.Name '; 
            if (query.subString(query.Length()-1,query.Length()) == ','){
                query = query.subString(0,query.Length()-1);
            }
            query += ' FROM ' + objectName;
            query += ' WHERE Id =  \''+ eventId+'\''; 
            system.debug(query);    
            
            Event eve = Database.query(query);
            //test
            system.debug('@@@@eve'+eve);
            User userdetailsinfo = Sector_EventCloneButton.getUserDetails();
            //Boolean isJapanUserRT = false;
            if(eventRecord!=null)
            {  
                //if((eventRecord.Call_Plan_Record_Type__c == 'Call Plan POPSA')){
                //      isJapanUserRT = True;
                //}
                Integer Sublen = eventRecord.Subject.length();
                boolean IsAllDayEvent = eventRecord.IsAllDayEvent; 
                String whatIdObjType = String.valueOf(eve.whatId.getSObjectType());
                Integer daysDifference = Date.ValueOf(eventRecord.StartDateTime).daysBetween(Date.Valueof(eventRecord.EndDateTime));
                Integer isCloneOnSameStartDay = Date.ValueOf(eventRecord.StartDateTime).daysBetween(Date.Valueof(eve.StartDateTime));
                Integer isCloneOnSameEndDay = Date.ValueOf(eve.EndDateTime).daysBetween(Date.Valueof(eventRecord.EndDateTime));
                System.debug(eve.StartDateTime);
                System.debug(eventRecord.StartDateTime);
                System.debug(eve.EndDateTime);
                System.debug(eventRecord.EndDateTime);
                System.debug(eve.StartDateTime == eventRecord.StartDateTime);
                System.debug(eve.EndDateTime == eventRecord.EndDateTime);
                //evedate = 
                System.debug(eve.StartDateTime.isSameDay(eventRecord.StartDateTime));
                System.debug(eve.StartDateTime.isSameDay(eventRecord.StartDateTime) && eve.EndDateTime.isSameDay(eventRecord.EndDateTime));
                //if(eve.StartDateTime.isSameDay(eventRecord.StartDateTime) && eve.EndDateTime.isSameDay(eventRecord.EndDateTime)){
                if(eve.StartDateTime == eventRecord.StartDateTime && eve.EndDateTime == eventRecord.EndDateTime){
                    AuraHandledException e = new AuraHandledException('Please Choose Different Start and End Dates for Call Plan');
                    e.setMessage('Please Choose Different Start and End Dates for Call Plan');
                    throw e;
                } 
                else if(eve.StartDateTime == eventRecord.StartDateTime && eve.EndDateTime != eventRecord.EndDateTime){
                    AuraHandledException e = new AuraHandledException('Please Choose Different Start for Call Plan');
                    e.setMessage('Please Choose Different Start for Call Plan');
                    throw e;
                }
                else if(Sublen >80){
                    AuraHandledException e = new AuraHandledException('Please edit the Call Plan Subject to be less than 80 characters.');
                    e.setMessage('Please edit the Call Plan Subject to be less than 80 characters.');
                    throw e;
                }
                else if(eve.EndDateTime == eventRecord.EndDateTime && eve.StartDateTime != eventRecord.StartDateTime){
                    AuraHandledException e = new AuraHandledException('Please Choose Different End Date for Call Plan');
                    e.setMessage('Please Choose Different End Date for Call Plan');
                    throw e;
                }
                else if(daysDifference >14){
                    AuraHandledException e = new AuraHandledException('Call plan cannot be longer than 14 days');
                    e.setMessage('Call plan cannot be longer than 14 days');
                    throw e;
                }
                else if(eventRecord.StartDateTime < system.Now() && eve.Call_Plan_Record_Type__c!='Call Plan Lite'){
                    AuraHandledException e = new AuraHandledException('Start Date cannot be past');
                    e.setMessage('Start Date can not be past');
                    throw e;
                }
                else if(eventRecord.EndDateTime < eventRecord.StartDateTime){
                    AuraHandledException e = new AuraHandledException('The Start Date for your Call Plan must be before the End Date');
                    e.setMessage('The Start Date for your Call Plan must be before the End Date');
                    throw e;
                }
                else{    
                    Event newEvent = new Event(); 
                    newEvent.Subject = eventRecord.Subject;
                    system.debug('eventRecord.IsAllDayEvent '+ eventRecord.IsAllDayEvent);
                    newEvent.IsAllDayEvent = eventRecord.IsAllDayEvent; 
                    newEvent.StartDateTime = eventRecord.StartDateTime;
                    newEvent.ActivityDateTime = eventRecord.StartDateTime;
                    datetime dT=newEvent.StartDateTime;
                    newEvent.ActivityDate = date.newinstance(dT.year(), dT.month(), dT.day());
                    newEvent.EndDateTime = eventRecord.EndDateTime;
                    newEvent.Type = eventRecord.Type;
                    newEvent.DurationInMinutes = null;
                    newEvent.Location = eventRecord.Location;
                    newEvent.ShowAs = eventRecord.ShowAs;
                    newEvent.Reason_for_Call__c= eventRecord.Reason_for_Call__c;
                    newEvent.Call_Plan_Record_Type__c = eventRecord.Call_Plan_Record_Type__c;
                    newEvent.Description = '';
                    newEvent.Ownerid=UserInfo.getUserId();
                    newEvent.whoId = eventRecord.WhoId;
                    newEvent.WhatId = eventRecord.WhatId;
                    //newEvent.Call_Plan__c = eventRecord__r.EventId__c;
                    System.debug('whatId');
                    
                    String eventidne = eventRecord.id;
                    /*********** new code to handle system generated event **************/
                    if(eve.Parent_Event_Id__c != null && eve.Parent_Event_Id__c != eve.Id)
                    {
                        eventidne = eve.Parent_Event_Id__c;
                    }
                    /*********** new code to handle system generated event **************/

                    List<Call_Plan__c> cp =[select id from Call_Plan__c where EventId__c =: eventidne];
                    
                    if(cp.size() == 0)
                    {
                        response.responseMessage = 'This is not original event, this is system generated event which could not be cloned. Please ask Organizer to get original event which can be used for clone.';
                        response.responseStatus = 'info';
                        return response;
                    }
                    
                    System.debug('cp'+ cp);
                    newEvent.Cloned_Call_Plan_Id__c = cp[0].id;
                    System.debug('call plan id'+cp[0].id);
                    newEvent.recordtypeId = eventRecord.recordtypeId;
                    System.debug(newEvent.recordtypeId);
                    //newEvent.Call_category__c = eventRecord.Call_category__c;
                    system.debug('event status'+eventRecord.Status_Event__c);
                    newEvent.Status_Event__c = eventRecord.Status_Event__c;
                    newEvent.ISClonedd__c = true;
                    
                    insert newEvent;  
                    
                    response.eventre = newEvent;
                    response.responseStatus = 'success';
                    return response;
                }
            }
            else
            { 
                response.eventre = eve;
                response.responseStatus = 'success';
                return response;
            }
        }
        catch (Exception e) {
            if(e.getMessage().contains('insufficient access rights on cross-reference id') || e.getMessage().contains('INSUFFICIENT_ACCESS_ON_CROSS_REFERENCE_ENTITY') )
            {
                AuraHandledException auexc = new AuraHandledException(Label.Create_Permission_From_Account);
                auexc.setMessage(Label.Create_Permission_From_Account);
                //system.debug(e);
                throw auexc;
                
                
                //throw new AuraHandledException(Label.Create_Permission_From_Account);    
            }
            else{
                AuraHandledException auexc1 = new AuraHandledException(e.getMessage());
                auexc1.setMessage(e.getMessage());
                throw auexc1;   
            }
        }  
    }
    @AuraEnabled
    public static List<String> getselectOptions(sObject objObject, string fld) {
        
        List < String > allOpts = new list < String > ();
        Schema.sObjectType objType = objObject.getSObjectType();
        Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
        Map<String,Schema.SObjectField> fieldMap = objDescribe.fields.getMap();
        list <Schema.PicklistEntry> values = fieldMap.get(fld).getDescribe().getPickListValues();
        for(Schema.PicklistEntry a: values) {
            if(a.getValue() =='Event/Meet/Campaign'||a.getValue() =='Market Visits'||a.getValue() =='Others'||a.getValue() =='Prospecting'||
              a.getValue() =='Tender/Contract'||a.getValue() =='Training/Presentations'||a.getValue() =='Follow Up'||a.getValue() =='Account Plan Review'||
              a.getValue() =='Quarterly Business Review'||a.getValue() =='Dispute')
            	allOpts.add(a.getValue());
        }
        allOpts.sort();
        system.debug(allOpts);
        return allOpts;
    }
    
    
    public class responseWrapper 
    {
        @AuraEnabled public String responseStatus;
        @AuraEnabled public String responseMessage;
        @AuraEnabled public Event eventre;
    }
    
    /*@AuraEnabled
    public static PicklistEntries getPicklistValues(String objectName,Id recordTypeId,String fieldName) {
        String requestUrl =
            URL.getSalesforceBaseUrl().toExternalForm() +
            '/services/data/v51.0/ui-api/object-info/' +
            objectName +
            '/picklist-values/' +
            recordTypeId +
            '/' +
            fieldName;
        
        // Try to get entries from cache
        PicklistEntries entries = uiApiCache.get(requestUrl);
        if (entries == null) {
            // Prepare UI API request
            HttpRequest request = new HttpRequest();
            request.setMethod('GET');
            request.setHeader(
                'Authorization',
                'Bearer ' + UserInfo.getSessionId()
            );
            request.setEndpoint(requestUrl);
            // Call UI API
            try {
                HttpResponse httpResponse = new Http().send(request);
                if (httpResponse.getStatusCode() == 200) {
                    // Parse JSON response into PicklistEntries
                    entries = (PicklistEntries) JSON.deserialize(
                        httpResponse.getBody(),
                        PicklistEntries.class
                    );
                    // Cache entries
                    uiApiCache.put(requestUrl, entries);
                } else {
                    throw new CalloutException(
                        'HTTP ' +
                        httpResponse.getStatusCode() +
                        ' while calling UI API, Response: ' +
                        httpResponse.getBody()
                    );
                }
            } catch (System.Exception e) {
                System.debug('ERROR: ' + e);
                throw e;
            }
        }
        return entries;
    }
     public class PicklistEntries {
        public PicklistEntry defaultValue;
        public List<PicklistEntry> values;
    }
    */
    
}