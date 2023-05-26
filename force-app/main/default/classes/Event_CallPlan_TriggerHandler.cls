public class Event_CallPlan_TriggerHandler {
    
    public static void POPSA_Update_Status(List<Event> eventlist)
    {
        for(Event ev : eventlist){
            if(ev.recordTypeId == Schema.SObjectType.Event.getRecordTypeInfosByDeveloperName().get('Sector_Call_Plan').getRecordTypeId() &&
               ev.Call_Plan_Record_Type__c == Label.Sector_Call_Plan_Type_POPSA)
            {
                //this condition applied because cloned event should copy previous stage, should not automatically assigned to schedule
                if(!(eventlist.size()==1 && eventlist[0].ISClonedd__c == true))
                    ev.Status_Event__c = 'Scheduled';
                //this condition is applied beacuse cloned event should not passed 'PLANNED' stage.
                if((eventlist.size()==1 && eventlist[0].ISClonedd__c == true && eventlist[0].Status_Event__c=='Minutes Recorded'))
                    ev.Status_Event__c = 'Planned';
            }
        }
    }
    
    public static void CallPlanCreationFromEvents(List<Event> eventlist){
        Id recTypeId = Schema.SObjectType.Event.getRecordTypeInfosByName().get('Hydrogen').getRecordTypeId();
        List<Id> recordtypeidslist = new List<Id>{recTypeId, Schema.SObjectType.Event.getRecordTypeInfosByDeveloperName().get('Sector_Call_Plan').getRecordTypeId()};
            
            List<Call_Plan__c> li =new List<Call_Plan__c>();
        
        
        
        System.debug('After Creation'+eventlist[0].Status_Event__c);
        //check if cloned
        if(eventlist.size()==1 && eventlist[0].ISClonedd__c == true)
        {
            for(Event ev : eventlist)
            {
                if(recordtypeidslist.contains(ev.recordTypeId))
                {
                    Call_Plan__c cp = new Call_Plan__c();
                    String s=ev.Subject;
                    cp.Name= ('Call Plan of '+ s).mid(0, 79) ;
                    cp.EventId__c = ev.id;
                    cp.Event_Subject__c = ev.Subject;
                    Call_Plan__c cpo =[select id,Anticipate__c, Purpose_Objective__c, Premise_Stakeholder__c, Strategy_Approach__c,status__c from Call_Plan__c where id =: ev.Cloned_Call_Plan_Id__c];
                    
                    cp.Anticipate__c=cpo.Anticipate__c;
                    cp.Purpose_Objective__c=cpo.Purpose_Objective__c;
                    cp.Premise_Stakeholder__c=cpo.Premise_Stakeholder__c;
                    cp.Strategy_Approach__c=cpo.Strategy_Approach__c;
                    system.debug('call plan status'+cp.Status__c+'event status'+ev.Status_Event__c);
                    if(ev.recordTypeId == Schema.SObjectType.Event.getRecordTypeInfosByDeveloperName().get('Sector_Call_Plan').getRecordTypeId())
                        cp.Event_Record_Type__c = ev.Call_Plan_Record_Type__c;
                    if(ev.Call_Plan_Record_Type__c == Label.Sector_Call_Plan_Type_POPSA)
                        cp.Status__c = ev.Status_Event__c;
                    system.debug('call plan status'+cp.Status__c);
                    li.add(cp);
                }
            }
        }
        else
        {
            for(Event ev : eventlist)
            {
                if(recordtypeidslist.contains(ev.recordTypeId))
                {
                    Call_Plan__c cp = new Call_Plan__c();
                    String s=ev.Subject;
                    cp.Name= ('Call Plan of '+ s).mid(0, 79) ;
                    cp.EventId__c = ev.id;
                    cp.Event_Subject__c = ev.Subject;
                    if(ev.recordTypeId == Schema.SObjectType.Event.getRecordTypeInfosByDeveloperName().get('Sector_Call_Plan').getRecordTypeId())
                        cp.Event_Record_Type__c = ev.Call_Plan_Record_Type__c;
                    if(ev.Call_Plan_Record_Type__c == Label.Sector_Call_Plan_Type_POPSA)
                        cp.Status__c = 'Scheduled';
                    li.add(cp);
                }
            }
        }
        insert li;
        System.debug('li=='+li);
        
        /*** New Line added as part of Call Plan List view ***/
        
        List<Event> eventstoupdate_withCallPlanId = new List<Event>();
        Integer indexc = 0;
        for(Event ev : eventlist)
        {
            if(recordtypeidslist.contains(ev.recordTypeId))
            {
                Event eventcl = new Event();
                eventcl.Id = ev.Id;
                eventcl.Call_Plan__c = li[indexc].Id;
                eventstoupdate_withCallPlanId.add(eventcl);
            }
        }
        Event_CallPlan_TriggerContext.isFirstRun();
        update eventstoupdate_withCallPlanId;
        
        /*** New Line added as part of Call Plan List view ***/

    }
    public static void CallPlanUpdationFromEvents(List<Event> eventlist){
        System.debug('After Updation');
        Id recTypeId = Schema.SObjectType.Event.getRecordTypeInfosByName().get('Hydrogen').getRecordTypeId();
        List<Id> recordtypeidslist = new List<Id>{recTypeId, Schema.SObjectType.Event.getRecordTypeInfosByDeveloperName().get('Sector_Call_Plan').getRecordTypeId()};
            
            Map<id,Event> ma=new Map<id,Event>();
        Call_Plan__c cp = new Call_Plan__c();
        for(Event ev:eventlist){
            if(recordtypeidslist.contains(ev.recordTypeId))
                ma.put(ev.id, ev);
        }
        List<Call_Plan__c> li=[select id,Name,EventId__c,Event_Subject__c,Status__c from Call_Plan__c where EventId__c =: ma.keyset()];
        List<Call_Plan__c> li2 =new List<Call_Plan__c>();
        for(Call_Plan__c cpc: li){
            String s=ma.get(cpc.EventId__c).Subject;
            cpc.Name= ('Call Plan '+ s).mid(0, 79);
            
            cpc.Event_Subject__c = ma.get(cpc.EventId__c).Subject;
            li2.add(cpc);
        }
        update li2;
    }
    public static void Makesales_CallPlanLastDateUpdateToAccount(List<Event> eventlist) {
        
        Set<Id> eventAccount =new Set<Id>();
        List<Event> listEvent =new List<Event>();
        for(Event eve: eventlist){
            eventAccount.add(eve.AccountId);
            listEvent.add(eve);
        }
        List<Account> listAllAccount = new List<Account>();
        
        
        //DateTime dateNow = 
        for(Account acc: [Select Id, Name, Last_Contacted_Date__c,(Select Id,EndDate from Events where Status_Event__c != 'Cancelled' and isDeleted =: false and EndDate <=: Date.today() order by EndDate desc limit 1) 
                          from Account where id in :eventAccount and recordTypeId = :Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId()])
        {
            if(acc.Events.Size()>0)
                for(Event ev :acc.Events)
            {   
                System.debug(acc.Last_Contacted_Date__c + '----' +ev.EndDate);
                acc.Last_Contacted_Date__c = ev.EndDate;
                listAllAccount.add(acc);
            }
            else
            {
                acc.Last_Contacted_Date__c = null;
                listAllAccount.add(acc);
                System.debug(acc.Last_Contacted_Date__c);
            }
        }
        update listAllAccount;
    }
}