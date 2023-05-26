trigger Event_CallPlan_Status on Call_Plan__c (after update) {
    if(trigger.isAfter && trigger.isUpdate){
        if(Event_CallPlan_TriggerContext.isFirstRun()){
            Map<id,String> cp =new Map<id,String>();
            for(Call_Plan__c cp1: Trigger.new){
                if(cp1.Event_Record_Type__c != null )
                {
                    System.debug('inside call plan trigger');
                    if(cp1.Event_Record_Type__c == Label.Sector_Call_Plan_Type_POPSA)
                    {
                        if(cp1.Purpose_Objective__c != null && cp1.Premise_Stakeholder__c != null && cp1.Anticipate__c != null && cp1.Strategy_Approach__c != null)
                        {
                            if(cp1.Minutes_and_Action__c != null)
                            {
                                cp.put(cp1.EventId__c, 'Minutes Recorded');
                            }
                            else{
                                cp.put(cp1.EventId__c, 'Planned');
                            }
                        }
                        else{
                            cp.put(cp1.EventId__c, 'Scheduled');
                        }
                    }
                }
                else
                {
                    if(cp1.Purpose__c != null && cp1.Objective__c != null && cp1.Premise__c != null && cp1.Strategy__c != null && cp1.Anticipate__c != null)
                    {
                        if(cp1.Agenda__c != null && cp1.Minutes_and_Action__c != null)
                        {
                            cp.put(cp1.EventId__c, 'Minutes Recorded');
                        }
                        else{
                            cp.put(cp1.EventId__c, 'Planned');
                        }
                    }
                    else{
                        cp.put(cp1.EventId__c, 'Scheduled');
                    }
                }
            }
            
            
            Map<Id, Event> eve =new Map<Id, Event>([Select Id, Status_Event__c from Event where id=: cp.keySet()]);
            List<Event> li=new List<Event>();
            for(Event ev : eve.values()){
                ev.Status_Event__c = cp.get(ev.id);
                System.debug('line 49'+ev.Status_Event__c);
                li.add(ev);
            }
            if(li.size()>0){
                
                update li;
            }
        }
    }
    
    
}