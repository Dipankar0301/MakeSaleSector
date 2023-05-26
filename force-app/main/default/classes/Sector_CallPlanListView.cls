public class Sector_CallPlanListView {
    
    public static final String POPSA_CONST = 'Call Plan POPSA';
    public static final String LITE_CONST = 'Call Plan Lite';
    public static final String STRING_CONST = '--- None ---';
    // Get Logged in user's list views
    @AuraEnabled
    public static String getListViewDetails(){
        //List<Call_Plan_List_View__c> defaultList=new list<Call_Plan_List_View__c>();
        Boolean pinList=false;
        Boolean defView=false;
        Boolean teamView=false;
        /*try{
List<Call_Plan_List_View__c> clPlns =[SELECT Id, OwnerId, IsDeleted, Name, CreatedDate, Is_Shared__c,
Start_Date__c, End_Date__c, Select_Columns__c, Is_Pinned__c,Pinned__c, Related_To_Account__c, Related_to_Account_Plan__c,
Related_to_Opportunity__c,Call_plan_Type__c,Status__c FROM Call_Plan_List_View__c where ownerid=:UserInfo.getUserId() OR Is_Shared__c=true];
if(!clPlns.isEmpty()) {
defaultList.addAll(clPlns);
for(Call_Plan_List_View__c c:clPlns){/
defView=true;
}

}
if(clPlns.isEmpty()){
Call_Plan_List_View__c c=new Call_Plan_List_View__c();
c.Name='Default View';
c.Is_Pinned__c=true;
c.Select_Columns__c='Subject;Related To;Call Plan Type;Start Date Time;End Date Time;Status;Type;Agenda;Minutes;';
insert c;
defaultList.add(c);
}*/
        //return (!defaultList.isEmpty() ? defaultList:null);
        return 'Subject,Related To,Call Plan Type,Start Date Time,End Date Time,Status;Type;Agenda,Minutes';
        /*}catch(Exception e){
System.debug('e get number'+e.getLineNumber());
throw new AuraHandledException(e.getMessage());
}*/
    }
    // Fetch all Events related to logged in user
    @AuraEnabled
    public static evtWrapper fetchAllEvents(){
        string userId=UserInfo.getUserId();
        try{
            System.debug('e get number 69');
            Id evtRecTypeId = Schema.SObjectType.Event.getRecordTypeInfosByDeveloperName().get('Sector_Call_Plan').getRecordTypeId();
            
            Integer i;
            //i=[select Id from Event where RecordTypeId=:evtRecTypeId AND Ownerid=:userId].size(); // by default all event should be in the list view
            i=[select Id from Event where RecordTypeId=:evtRecTypeId].size();
            evtWrapper eW=new evtWrapper();
            eW.recordType=evtRecTypeId;
            eW.totalEvents=i;
            System.debug('line 75');
            System.debug(eW);
            return eW;
        }catch(Exception ex){
            throw new AuraHandledException(ex.getMessage());
            
        }
    }
    
    // Search events based on user input
    @AuraEnabled
    public static List<evtClPlnWrapper> searchEvents(String currentlistview,String acc,string opp, string accplan, string startdate, string enddate,string callplantype, string status, string subject,integer offset,integer rowsToLoad, String teamUser,String ownerName) {
        System.debug('Method Name--');
        System.debug(ownerName);
        System.debug(currentlistview);
        System.debug(opp);
        try{
            Id evtRecTypeId = Schema.SObjectType.Event.getRecordTypeInfosByDeveloperName().get('Sector_Call_Plan').getRecordTypeId();
            
            String accVal;
            String oppval;
            String accplnVal;
            String subjectVal;
            date startDateTime;
            String ownerNameVal;
            System.debug('e get number 99');
            if(!string.isBlank(startdate)){
                startDateTime=date.valueOf(startdate);
            }
            date endDateTime;
            if(!string.isBlank(enddate)){
                endDateTime=date.valueOf(enddate);
            }
            Event ent=new Event();
            List<string> reasonforCallOpts=getselectOptions(ent,'Reason_for_Call__c');
            List<string> typeOpts=getselectOptions(ent,'Type');
            //fetch Call Plan related picklists
            Call_Plan__c clpln=new Call_Plan__c();
            List<string> statusOpts=getselectOptions(clpln,'Status__c');
            //Map<String,List<String>> conDepFieldMap=Sector_CallPlanListView.getDependentPicklistValues('Event','Call_category__c','Stage__c');
            User userdetailsinfo = Sector_CallPlanListView.getUserDetails();
            
            
            List<evtClPlnWrapper> lstEvnClPlnWrapper =new list<evtClPlnWrapper>();
            List<Event> lstEvnt =new list<Event>();
            Map<Id,Event> evntClPlnMap=new Map<Id,Event>();
            Map<Id,Event> evntMap=new Map<Id,Event>();
            List<id> clPlnEvnts=new List<id>();
            List<id> accEvnts=new List<id>();
            List<id> oppEvnts=new List<id>();
            List<id> accPlnEvnts=new List<id>();
            Map<Id,Account> evntAccMap=new Map<Id,Account>();
            Map<Id,Opportunity> evntOppMap=new Map<Id,Opportunity>();
            Map<Id,Account_Plan__c> evntAccPlnMap=new Map<Id,Account_Plan__c>();
            //Map<Id,Account_Plan__c> clPlnMap=new Map<Id,Account_Plan__c>();
            Map<Id,Call_Plan__c> clPlnMap=new Map<Id,Call_Plan__c>();
            String objectName = 'Event'; 
            String userId = !String.isBlank(teamUser)?teamUser:UserInfo.getUserID();
            String query = 'SELECT';
            set<string> userSet=new set<String>();
            List<string> terrList =new List<string>();
            List<String> TerrIdList=new List<String>();
            
            Map<String, Schema.SObjectField> objectFields = Schema.getGlobalDescribe().get(objectName).getDescribe().fields.getMap();
            
            for(String s : objectFields.keySet()) {
                query += ' ' + s + ', ';
            }
            query += 'what.type,Call_Plan__r.Minutes_and_Action__c,';
            query +='Owner.Name,Call_Plan__r.Premise__c,Call_Plan__r.Purpose__c,Call_Plan__r.Objective__c,';
            query +='Call_Plan__r.Anticipate__c,';
            query+='Call_Plan__r.Strategy__c,Call_Plan__r.Status__c ,';
            //query+='Call_Plan__r.Strategy__c,Status_Event__c,';
            query+='Call_Plan__r.Agenda__c,Call_Plan__r.Name,'; 
            query+='( ';
            query+='SELECT Id,RelationId,Relation.Name,Relation.Type,EventId ';
            query+='FROM EventRelations WHERE isInvitee=true';
            query+=') ';
            
            //query += ' FROM ' + objectName + ' WHERE RecordTypeId=:evtRecTypeId AND Ownerid=:userId '; // by default all event should be in the list view
            query += ' FROM ' + objectName + ' WHERE RecordTypeId=:evtRecTypeId ';
            System.debug('e get number 186');
            /*if(currentlistview !=null){
if(currentlistview.Call_Plan_Type__c !=null){
String cp=currentlistview.Call_Plan_Type__c;
query += ' AND Call_Plan_Record_Type__c !=null ';
query += ' AND Call_Plan_Record_Type__c=:cp ';
}
if(currentlistview.Status__c !=null){
String sta=currentlistview.Status__c;
query += ' AND Call_Plan__r.Status__c !=null ';
query += ' AND Call_Plan__r.Status__c=:sta ';
}
if(currentlistview.Related_To_Account__c !=null){
String s=currentlistview.Related_To_Account__c;
query += ' AND Call_Plan__r.Account__c !=null ';
query += ' AND Call_Plan__r.Account__c=:s ';
}
if(currentlistview.Related_to_Opportunity__c !=null){
String r=currentlistview.Related_to_Opportunity__c;
query += ' AND Call_Plan__r.Call_Plan_Opportunity__c !=null ';
query += ' AND Call_Plan__r.Call_Plan_Opportunity__c =:r ';
}
if(currentlistview.Related_to_Account_Plan__c !=null){
String p=currentlistview.Related_to_Account_Plan__c;
//query += ' AND Call_Plan__r.Call_Plan_Account_Plan__c !=null ';
//query += ' AND Call_Plan__r.Call_Plan_Account_Plan__c =:p ';
}
*/
            /*if(currentlistview.Start_Date__c !=null){
Date d = currentlistview.Start_Date__c;
if(currentlistview.End_Date__c !=null){
query += ' AND DAY_ONLY(Startdatetime) >= : d';
}else
query += ' AND DAY_ONLY(Startdatetime) = : d';   
}
if(currentlistview.End_Date__c !=null){
Date ed = currentlistview.End_Date__c;
if(currentlistview.Start_Date__c !=null){
query += ' AND DAY_ONLY(Enddatetime) <= : ed ';
}else{
query += ' AND DAY_ONLY(Enddatetime) = : ed ';
}
}
}*/
            String accName= 'Account';
            String oppName = 'Opportunity';
            String accPlanName = 'Account_Plan__c';
            System.debug('line 176');
            System.debug(acc);
            System.debug(opp);
            System.debug(accplan);
            query += ' AND What.Name !=null ';
            if(!String.isBlank(acc)){
                accVal='\'%' + String.escapeSingleQuotes(acc.trim()) + '%\'';
                //query += ' AND What.Name !=null ';
                query += ' AND What.Name LIKE '+ accVal;
                query += ' AND What.Type =: accName'; 
            }
            
            if(!String.isBlank(opp)){
                oppVal= '\'%' + String.escapeSingleQuotes(opp.trim()) + '%\'';
                query += ' AND What.Name LIKE '+oppVal;
                query += ' AND What.Type =: oppName';
            }
            if(!String.isBlank(accplan)){
                accplnVal='\'%' + String.escapeSingleQuotes(accplan.trim()) + '%\'';
                query += ' AND What.Name LIKE'+ accplnVal;
                query += ' AND What.Type =: accPlanName';
            }
            if(!String.isBlank(callplantype)){
                query += ' AND Call_Plan_Record_Type__c =: callplantype';
            }
            if(!String.isBlank(status)){
                //query += ' AND Call_Plan__r.Status__c =: status';
                query += ' AND Status_Event__c =: status';
            }
            if(!String.isBlank(subject)){
                subjectVal='\'%' + String.escapeSingleQuotes(subject.trim()) + '%\'';
                query += ' AND Subject LIKE ' +subjectVal;
            }
            // owner search
            if(!String.isBlank(ownerName)){
                ownerNameVal='\'%' + String.escapeSingleQuotes(ownerName.trim()) + '%\'';
                query += ' AND Owner.Name LIKE ' +ownerNameVal;
            }
            //
            if(startDateTime !=null){
                if(endDateTime !=null)
                    query += ' AND DAY_ONLY(Startdatetime) >= : startDateTime ';
                else
                    query += ' AND DAY_ONLY(Startdatetime) = : startDateTime ';   
            }
            if(endDateTime !=null){
                if(startDateTime !=null)
                    query += ' AND DAY_ONLY(Enddatetime) <= : endDateTime ';
                else
                    query += ' AND DAY_ONLY(Enddatetime) = : endDateTime ';  
            }
            query += ' ORDER BY '+objectFields.get('StartDateTime')+''+' DESC ';
            query += ' LIMIT '+rowsToLoad;
            query += ' OFFSET '+offset;
            
            System.debug('query---'+query); //KRT
            List<Event> events=Database.query(query);
            System.debug(events);
            List<event> eList=[select id,Subject,StartDateTime,EndDateTime,Call_Plan__c,RecordTypeId,Ownerid,What.Name,Call_Plan_Record_Type__c,
                           Call_Plan__r.Status__c,Status_Event__c  from Event];
            System.debug(eList);
            if(events !=null){
                for(Event e:events){
                    evntClPlnMap.put(e.whatid, e);
                    evntMap.put(e.id,e);
                    if(e.what.type=='Call_Plan__c')
                        clPlnEvnts.add(e.whatid);            
                    else if(e.what.type=='Account')
                        accEvnts.add(e.whatid);
                    else if(e.what.type=='Opportunity')
                        oppEvnts.add(e.whatid);
                    else if(e.what.type=='Account_Plan__c')
                        accPlnEvnts.add(e.whatid);
                }
            }
            if(clPlnEvnts !=null){
                for(Call_Plan__c cln:[select id,Name,Premise__c,Premise_Stakeholder__c,Purpose__c,Objective__c,Anticipate__c,Agenda__c,Minutes_and_Action__c,
                                      Strategy__c,Status__c
                                      from Call_Plan__c where id IN: clPlnEvnts  ]){
                                          
                                          
                                          clPlnMap.put(cln.id, cln);
                                      }
            }
            if(accEvnts !=null){
                for(Account a:[select id, name from account where id IN: accEvnts]){
                    System.debug('accounts');
                    System.debug(a);
                    evntAccMap.put(a.id,a);
                }
            }
            if(oppEvnts !=null){
                for(Opportunity o:[select id, name from Opportunity where id IN: oppEvnts]){
                    System.debug('opp');
                    System.debug(o);
                    evntOppMap.put(o.id,o);
                }
            }
            
            if(accPlnEvnts !=null){
                for(Account_Plan__c ap:[select id, name from Account_Plan__c where id IN: accPlnEvnts]){
                    System.debug('acc plan');
                    System.debug(ap);
                    evntAccPlnMap.put(ap.id,ap);
                }
            }
            System.debug('e get number 312');
            if(events !=null){
                for(Event cl:evntMap.values())  {     
                    evtClPlnWrapper e = new evtClPlnWrapper();                                         
                    e.Subject=cl.Subject;
                    e.SubjectURL='/'+cl.Id;
                    e.RelatedURL='/'+cl.WhatId;
                    e.Location=cl.Location;            
                    e.ShowTimeAs=cl.ShowAs;
                    e.RelatedTo=cl.whatid;
                    e.RelatedToType=cl.what.type; 
                    e.RecordtypeId=cl.RecordTypeId;
                    e.StatusOpts=statusOpts;            
                    e.AssignedTo=cl.OwnerId;
                    e.AssignedToName=cl.Owner.Name;
                    e.ReasonforCall=cl.Reason_for_Call__c;
                    e.EventId=cl.Id;
                    e.ReasonforCallOpts=reasonforCallOpts;
                    e.Type=cl.Type;
                    e.TypeOpts=typeOpts;
                    e.objId=cl.whatid;            
                    e.userInformation = userdetailsinfo;
                    e.Location=cl.Location;
                    e.Name=cl.whoId;
                    e.StartDateTime=cl.StartDateTime;
                    e.EndDateTime=cl.EndDateTime;
                    e.AllDayEvent=cl.IsAllDayEvent;
                    e.CallPlanType=cl.Call_Plan_Record_Type__c;
                    //e.OwnerName = 
                    e.Agenda=cl.Call_Plan__r.Agenda__c;
                    e.AgendaText=cl.Call_Plan__r.Agenda__c !=null ?(cl.Call_Plan__r.Agenda__c).replaceAll('\\<.*?\\>', '').replaceAll('\n', ''):'';
                    e.MinutesActions=cl.Call_Plan__r.Minutes_and_Action__c !=null ?(cl.Call_Plan__r.Minutes_and_Action__c).replaceAll('\\<.*?\\>', '').replaceAll('\n', ''):'';
                    e.Minutes=cl.Call_Plan__r.Minutes_and_Action__c;
                    e.Premise=cl.Call_Plan__r.Premise__c;
                    e.PremiseText=cl.Call_Plan__r.Premise__c !=null ?(cl.Call_Plan__r.Premise__c).replaceAll('\\<.*?\\>', '').replaceAll('\n', ''):'';
                    e.Purpose=cl.Call_Plan__r.Purpose__c;
                    e.PurposeText=cl.Call_Plan__r.Purpose__c !=null ?(cl.Call_Plan__r.Purpose__c).replaceAll('\\<.*?\\>', '').replaceAll('\n', ''):'';
                    e.Strategy=cl.Call_Plan__r.Strategy__c;
                    e.StrategyText=cl.Call_Plan__r.Strategy__c !=null ?(cl.Call_Plan__r.Strategy__c).replaceAll('\\<.*?\\>', '').replaceAll('\n', ''):'';
                    //call plan status is not update while cancelling the event from inline edit. So fetching the event status directly. 
                    e.Status=cl.Status_Event__c;
                    e.Objective=cl.Call_Plan__r.Objective__c;
                    e.ObjectiveText=cl.Call_Plan__r.Objective__c !=null ?(cl.Call_Plan__r.Objective__c).replaceAll('\\<.*?\\>', '').replaceAll('\n', ''):'';
                    e.Anticipate=cl.Call_Plan__r.Anticipate__c;
                    e.AnticipateText=cl.Call_Plan__r.Anticipate__c !=null ?(cl.Call_Plan__r.Anticipate__c).replaceAll('\\<.*?\\>', '').replaceAll('\n', ''):'';
                    e.CallPlanId=cl.Call_Plan__c;
                    if(cl.what.type=='Account' && evntAccMap.get(cl.whatid) !=null){
                        e.RelatedToName=evntAccMap.get(cl.whatid).Name;
                    }
                    if(clPlnMap.get(cl.whatid) !=null){
                        e.RelatedToName=clPlnMap.get(cl.whatid).Name;
                    }
                    
                    if(evntOppMap.get(cl.whatid) !=null){
                        e.RelatedToName=evntOppMap.get(cl.whatid).Name;
                        
                    }
                    if(evntAccPlnMap.get(cl.whatid) !=null){
                        e.RelatedToName=evntAccPlnMap.get(cl.whatid).Name;                
                    }
                    
                    e.Attendees=cl.EventRelations;
                    lstEvnClPlnWrapper.add(e);
                }
            }
            if(!lstEvnClPlnWrapper.isEmpty())
                return lstEvnClPlnWrapper;  
            else
                return null;
            
        }
        catch(exception e){
            throw new AuraHandledException(e.getMessage());
        }
        
    }
    
    @AuraEnabled
    public static List < String > getselectOptions(sObject objObject, string fld) {
        try{
             List < String > allOpts = new list < String > ();
                // Get the object type of the SObject.
                Schema.sObjectType objType = objObject.getSObjectType();
                
                // Describe the SObject using its object type.
                Schema.DescribeSObjectResult objDescribe = objType.getDescribe();
                
                // Get a map of fields for the SObject
                map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
                
                // Get the list of picklist values for this field.
                list < Schema.PicklistEntry > values =
                    fieldMap.get(fld).getDescribe().getPickListValues();
                //allOpts.add(STRING_CONST);
                // Add these values to the selectoption list.
            if(fld == 'Reason_for_Call__c'){
                
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
            else{
               
                for (Schema.PicklistEntry a: values) {
                    allOpts.add(a.getValue());
                }
                
                allOpts.sort();
                return allOpts;
            }
        }catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    /*
    //method to get Dependent picklist values
    @AuraEnabled
    public static Map<String,List<String>> getDependentPicklistValues(String strObjectName, String controlingField, String dependentField){
        Map<String,List<String>> dependentPicklistValues = new Map<String,List<String>>();
        List<String> noneList = new List<String>{STRING_CONST};
            Schema.sObjectType objType = Schema.getGlobalDescribe().get(strObjectName).newSObject().getSObjectType();
        System.debug('objType-->'+objType);
        Map<String, Schema.SObjectField> objFieldMap = objType.getDescribe().fields.getMap();
        System.debug('objFieldMap-->'+objFieldMap);
        Schema.DescribeFieldResult dependentFieldResult = objFieldMap.get(dependentField).getDescribe();
        Schema.sObjectField controllerField = dependentFieldResult.getController();
        if(controllerField == null){
            return null;
        }
        Schema.DescribeFieldResult controllerFieldResult = controllerField.getDescribe();
        //Get controlling field picklist values if controlling field is not a checkbox
        List<Schema.PicklistEntry> controllerValues = (controllerFieldResult.getType() == Schema.DisplayType.Boolean ? null : controllerFieldResult.getPicklistValues());
        //It is used to decode the characters of the validFor fields. 
        String base64map = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
        dependentPicklistValues.put(STRING_CONST,noneList);
        for (Schema.PicklistEntry entry : dependentFieldResult.getPicklistValues()){
            if (entry.isActive()){
                //The PicklistEntry is serialized and deserialized using the Apex JSON class and it will check to have a 'validFor' field
                List<String> base64chars = String.valueOf(((Map<String,Object>)JSON.deserializeUntyped(JSON.serialize(entry))).get('validFor')).split('');
                for (Integer i = 0; i < controllerValues.size(); i++){
                    Object controllerValue = (controllerValues == null ? (Object) (i == 1) : (Object) (controllerValues[i].isActive() ? controllerValues[i].getLabel() : null));
                    Integer bitIndex = i / 6;
                    Integer bitShift = 5 - Math.mod(i, 6 );
                    if(controllerValue == null || (base64map.indexOf(base64chars[bitIndex]) & (1 << bitShift)) == 0){
                        continue;
                    } 
                    if (!dependentPicklistValues.containsKey(String.valueOf(controllerValue))){
                        dependentPicklistValues.put(String.valueOf(controllerValue), new List<String>());
                    }
                    dependentPicklistValues.get(String.valueOf(controllerValue)).add(entry.getLabel());
                }
            }
        }
        System.debug('dependentPicklistValues-->'+dependentPicklistValues);
        return dependentPicklistValues;
    }
    
    */
    @AuraEnabled
    public static User getUserDetails(){
        return [SELECT id,Profile.Name,ProfileID FROM User WHERE Id =:userInfo.getUserId() limit 1];
    }
    
    // Update Events
    /*
@AuraEnabled(cacheable = false)
public static List<String> updateEvents(List<evtClPlnWrapper> editedEventList){
List<String> errorList = new List<String>();
Map<String, String> callPlanMap = new Map<String, String>();
Set<String> callPlanIdSet = new Set<String>();
try{
List<Event> evtLst = new List<Event>();
List<Call_Plan__c> callPlanLst = new List<Call_Plan__c>();

//Implement Save Logic Here
for(evtClPlnWrapper e:editedEventList){
Event evnt= new Event();
evnt.Id=e.EventId;
evnt.Reason_for_Call__c=e.ReasonforCall;
evnt.Call_Plan__c=e.CallPlanId;
evnt.StartDateTime=e.StartDateTime;
evnt.EndDateTime=e.EndDateTime;
//evnt.Type=e.Type;		
//evnt.Stage__c=e.stageAttr;
//evnt.Call_Plan_Record_Type__c=e.CallPlanType;
evtLst.add(evnt);

if(String.isNotBlank(e.CallPlanId)) callPlanMap.put(e.CallPlanId, evnt.Id);

system.debug('e.MinutesActions :::::' + e.MinutesActions);

if(e.CallPlanId != null && !callPlanIdSet.contains(e.CallPlanId))
{
callPlanIdSet.add(e.CallPlanId);
Call_Plan__c tempCallPlan = new Call_Plan__c(Id = e.CallPlanId);

if(e.MinutesActions != null)
tempCallPlan.Minutes_and_Action__c = e.MinutesActions;

if(e.StartDateTime != null && e.EndDateTime != null)
{
//tempCallPlan.Start_Date__c = e.StartDateTime;
//tempCallPlan.End__c = e.EndDateTime;
}

callPlanLst.add(tempCallPlan);
}

if(evnt.StartDateTime !=null && 
evnt.EndDateTime !=null && 
Date.ValueOf(evnt.StartDateTime).daysBetween(Date.Valueof(evnt.EndDateTime)) < 0){

AuraHandledException er = new AuraHandledException('End Date cannot be less than Start date');
er.setMessage('End Date cannot be less than Start date');
throw er; 
}
}

Set<String> failedEvents = new Set<String>();
Map<String, String> failedEventsMap = new Map<String, String>();
if(!callPlanLst.isEmpty())
{    
//update callPlanLst;
Database.SaveResult [] updateResult = Database.update(callPlanLst, false);
for (Database.SaveResult r : updateResult)
{
if (!r.isSuccess())
{
for (Database.Error e : r.getErrors())
{ 
if(callPlanMap.get(r.getId()) != null)
failedEventsMap.put(callPlanMap.get(r.getId()), e.getMessage());
//errorList.add(callPlanMap.get(r.getId()) + '~~~~~' + e.getMessage());
failedEvents.add(callPlanMap.get(r.getId()));
}                    
}
}
}

if(!evtLst.isEmpty())
{
//update evtLst;
List<Event> eventUpdateList = new List<Event>();
for(Event rec : evtLst)
{
if(!failedEvents.contains(rec.Id))
eventUpdateList.add(rec);
}

Database.SaveResult [] updateResult = Database.update(eventUpdateList, false);
for (Database.SaveResult r : updateResult)
{
if (!r.isSuccess())
{
for (Database.Error e : r.getErrors())
{ 
if(r.getId() != null)
failedEventsMap.put(r.getId(), e.getMessage());
}                    
}
}
}

for(String key : failedEventsMap.keyset())
{
errorList.add(key + '~~~~~' + failedEventsMap.get(key));
}

return errorList;
} 
catch(Exception ex)
{
return errorList;
}
}
*/
    // Update records after inline editing  
    @AuraEnabled
    public static evtClPlnWrapper saveRow(String e, string attList,String resList,String delLst) {
        try{
            System.debug('saveRow');
            System.debug(e);
            String userid=Userinfo.getUserId();
            List<EventRelation> erList=new List<EventRelation>();
            User userdetailsinfo = Sector_CallPlanListView.getUserDetails();
            List<String> jpRelatedProfile = new List<String>();
            jpRelatedProfile = (label.Sector_Profile_label).split(',');
            
            System.Type t=System.Type.forName('Sector_CallPlanListView.evtClPlnWrapper');
            evtClPlnWrapper evt=(evtClPlnWrapper)JSON.deserialize(e,t);
            
            /*System.Type p=System.Type.forName('List<Sector_CustomLookupController.RecordsData>');
            List<Sector_CustomLookupController.RecordsData> attendeees =new List<Sector_CustomLookupController.RecordsData>();
            if(!String.isBlank(attList))
                attendeees=(List<Sector_CustomLookupController.RecordsData>)JSON.deserialize(attList,p);
            
            
            System.Type q=System.Type.forName('List<Sector_CustomLookupController.RecordsData>');
            List<Sector_CustomLookupController.RecordsData> resources =new List<Sector_CustomLookupController.RecordsData>();
            if(!String.isBlank(resList))
                resources=(List<Sector_CustomLookupController.RecordsData>)JSON.deserialize(resList,q);
            
            List<Sector_CustomLookupController.RecordsData> delList =new List<Sector_CustomLookupController.RecordsData>();
            if(!String.isBlank(delLst))
                delList=(List<Sector_CustomLookupController.RecordsData>)JSON.deserialize(delLst,q);
            */
            Map<Id,Boolean> eventIdToinlineMap = new Map<Id,Boolean>();
            Map<Id,Event> restrictEventToUpdateMap = new Map<Id,Event>();
            List<Id> evtRelId=new List<Id>();
            List<EventRelation> finalDelLst=new List<EventRelation>();
            Map<Id,EventRelation> evtRel=new Map<Id,EventRelation> ();
            for(EventRelation erel:[select Id,RelationId from EventRelation where eventid=:evt.EventId]){
                evtRelId.add(erel.RelationId);
                evtRel.put(erel.RelationId,erel);
            }
            if(jpRelatedProfile.contains(userdetailsinfo.Profile.name) &&
               (evt.CallPlanType == POPSA_CONST || evt.CallPlanType == LITE_CONST)){
                   for(Call_Plan__c callPlanObj :[SELECT Id FROM Call_Plan__c where id=:evt.CallPlanId]){
                       //eventIdToinlineMap.put(callPlanObj.Id, callPlanObj.SHL_Is_Inline_Edit__c);
                   }
                   for(Event eventObj :[SELECT Id,OwnerId 
                                        FROM Event where id=:evt.EventId]){
                                            restrictEventToUpdateMap.put(eventObj.Id,eventObj);
                                        }
               }
            
            Integer delLstsize;
            /*if(!delList.isEmpty()){
                delLstsize=delList.size();
                if(delLstsize >1){
                    for(integer i=0;i<delLstsize;i++){
                        if(evtRelId.indexOf(delList[i].value) != -1) {
                            finalDelLst.add(evtRel.get(delList[i].value)); 
                        }
                    }
                }else{
                    if(evtRelId.indexOf(delList[0].value) != -1) {
                        finalDelLst.add(evtRel.get(delList[0].value)); 
                    }
                }
            }
            
            if(!finalDelLst.isEmpty()){
                delete finalDelLst;
            }
            */
            
            
            /*if(!attendeees.isEmpty()){
                for(Sector_CustomLookupController.RecordsData r : attendeees){
                    if(r.value != userid){
                        EventRelation er=new EventRelation();
                        er.EventId=evt.EventId;
                        er.RelationId=r.value;
                        erList.add(er);
                    }
                }
            }
            
            if(!resources.isEmpty()){
                for(Sector_CustomLookupController.RecordsData r : resources){
                    EventRelation er=new EventRelation();
                    er.EventId=evt.EventId;
                    er.RelationId=r.value;
                    er.Status='Accepted';
                    erList.add(er);
                }
            }
            */
            Integer Sublen=evt.Subject.length();
            Event evnt= new Event();
            evnt.Id=evt.EventId;
            evnt.Subject=evt.Subject;
            evnt.Reason_for_Call__c=evt.ReasonforCall;
            evnt.Call_Plan_Record_Type__c=evt.CallPlanType;
            evnt.Call_Plan__c=evt.CallPlanId;
            evnt.StartDateTime=evt.StartDateTime;
            evnt.EndDateTime=evt.EndDateTime;
            evnt.Type=evt.Type;
            evnt.WhatId=evt.RelatedTo;
            evnt.WhoId=evt.Name;
            evnt.IsAllDayEvent=evt.AllDayEvent;
            evnt.OwnerId=evt.AssignedTo;
            evnt.Location=evt.Location;
            evnt.ShowAs=evt.ShowTimeAs;
            Call_Plan__c cl=new Call_Plan__c();
            cl.id=evt.CallPlanId;
            cl.Agenda__c=evt.Agenda;
            cl.Minutes_and_Action__c=evt.Minutes;            
            //cl.Objective__c=evt.Objective;
            cl.Purpose_Objective__c=evt.Purpose;
            cl.Strategy_Approach__c=evt.Strategy;
            cl.Premise_Stakeholder__c=evt.Premise;
            cl.Anticipate__c=evt.Anticipate;
            //cl.Start_Date__c=evt.StartDateTime;
            //cl.End__c=evt.EndDateTime;
            //cl.Reason_for_Call__c=evt.ReasonforCall;
            cl.Status__c=evt.Status;
            if(Date.ValueOf(evt.StartDateTime).daysBetween(Date.Valueof(evt.EndDateTime))<0){
                AuraHandledException er = new AuraHandledException('End Date cannot be less than Start date');
                er.setMessage('End Date cannot be less than Start date');
                throw er; 
            }
            else  if(Sublen >80){
                
                AuraHandledException el = new AuraHandledException('Please edit the Call Plan Subject to be less than 80 characters.');
                el.setMessage('Please edit the Call Plan Subject to be less than 80 characters.');
                throw el;
            }
            else if(restrictEventToUpdateMap != null && restrictEventToUpdateMap.get(evt.EventId) != null){
                if(restrictEventToUpdateMap.get(evt.EventId).OwnerId != userInfo.getUserId()){
                    AuraHandledException eh = new AuraHandledException('You dont have access to edit the below fields Call Categeory,Stage,Share as MKT Information,Reply,Call Plan Related');
                    eh.setMessage('You dont have access to edit the below fields Title,Sub-theme,Call Categeory,Stage,Share as MKT Information,Reply,Call Plan Related.');
                    throw eh;
                }
            }
            else{
                if(!erlist.isEmpty())
                    insert erlist;
                if(cl.id !=null){
                    if(jpRelatedProfile.contains(userdetailsinfo.Profile.name) &&
                       (evt.CallPlanType == POPSA_CONST  || evt.CallPlanType == LITE_CONST)){
                           
                       }
                    update cl;
                }
                if(evnt.id !=null){
                    if(jpRelatedProfile.contains(userdetailsinfo.Profile.name) &&
                       (evt.CallPlanType == POPSA_CONST  || evt.CallPlanType == LITE_CONST)){
                           if(cl.Minutes_and_Action__c != null){
                               Integer recLength = cl.Minutes_and_Action__c.length(); 
                               if(recLength <= 31996)
                               {
                                   evnt.Description= ((cl.Minutes_and_Action__c).substring(0,recLength));
                               }else if(recLength > 31996){
                                   evnt.Description= ((cl.Minutes_and_Action__c).substring(0,31996))+'...';
                               }
                           }else{
                               evnt.Description= '';
                           }
                       }
                    System.debug(evnt);
                    update evnt;
                }
                
            }
            return evt;
        }
        catch(Exception ex){
            System.debug('ex line-->'+ex.getLineNumber());
            throw new AuraHandledException(ex.getMessage()); 
            
        }
        
    }    
    // method for fetch picklist values dynamic  
    
    
    
    
    public class evtWrapper{ 
        @AuraEnabled public Id recordType{get;set;}
        @AuraEnabled public Integer totalEvents{get;set;}
        @AuraEnabled public String errorMsg {get;set;}
        @AuraEnabled public Map<Id,String> teamUserSet {get;set;}
    }
    public class evtClPlnWrapper{
        @AuraEnabled public String Subject{get;set;}
        //@AuraEnabled public String AccountName{get;set;}
        //@AuraEnabled public String OpportunityName{get;set;}
        //@AuraEnabled public String AccountPlanName{get;set;}
        @AuraEnabled public String SubjectURL{get;set;}
        @AuraEnabled public String Location{get;set;}
        @AuraEnabled public DateTime StartDateTime{get;set;}
        @AuraEnabled public DateTime EndDateTime{get;set;}
        @AuraEnabled public Boolean AllDayEvent{get;set;}
        @AuraEnabled public String ShowTimeAs{get;set;}
        @AuraEnabled public Id RelatedTo{get;set;}
        @AuraEnabled public Id RecordtypeId{get;set;}        
        @AuraEnabled public String RelatedURL{get;set;}
        @AuraEnabled public String RelatedToName{get;set;}
        @AuraEnabled public String RelatedToType{get;set;}
        @AuraEnabled public String CallPlanType{get;set;}
        @AuraEnabled public String Agenda{get;set;}
        @AuraEnabled public String AgendaText{get;set;}
        @AuraEnabled public String Minutes{get;set;}
        @AuraEnabled public String MinutesActions{get;set;}   
        @AuraEnabled public String Objective{get;set;}
        @AuraEnabled public String Objectivetext{get;set;}
        @AuraEnabled public String Anticipate{get;set;}
        @AuraEnabled public String AnticipateText{get;set;}
        @AuraEnabled public String Premise{get;set;}
        @AuraEnabled public String PremiseText{get;set;}
        @AuraEnabled public String Purpose{get;set;}
        @AuraEnabled public String PurposeText{get;set;}
        @AuraEnabled public String Strategy{get;set;}
        @AuraEnabled public String StrategyText{get;set;}
        @AuraEnabled public Id Name{get;set;}
        @AuraEnabled public Id EventId{get;set;}
        @AuraEnabled public Id objId{get;set;}        
        @AuraEnabled public String ReasonforCall{get;set;}
        @AuraEnabled public String Status{get;set;}
        //@AuraEnabled public String HuntingFarming{get;set;}
        @AuraEnabled public String Type{get;set;}
        @AuraEnabled public Id AssignedTo{get;set;}
        @AuraEnabled public Id CallPlanId{get;set;}
        @AuraEnabled public Id AccountId{get;set;}
        @AuraEnabled public Id OpportunityId{get;set;}
        @AuraEnabled public Id AccountPlanId{get;set;}
        @AuraEnabled public String AssignedToName{get;set;}
        //@AuraEnabled public Boolean DVRBeUsed{get;set;}
        //@AuraEnabled public String LinktoDVR{get;set;}
        //@AuraEnabled public String sNo {get;set;}
        @AuraEnabled public List<String> ReasonforCallOpts {get;set;}
        @AuraEnabled public List<String> StatusOpts {get;set;}
        //@AuraEnabled public List<String> HuntingFarmingOpts {get;set;}
        @AuraEnabled public List<String> TypeOpts {get;set;}
        //@AuraEnabled public List<String> clPlnOpts {get;set;}  
        @AuraEnabled public List<EventRelation> Attendees {get;set;}
        @AuraEnabled public Id OwnerName{get;set;}
        @AuraEnabled public User userInformation{get;set;}
    }
    
}