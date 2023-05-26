trigger Event_CallPlan on Event (before insert,after insert, after update, after delete,after undelete) {
    
    
    if(TriggerHandler__c.getInstance('Event_CallPlan') != null && TriggerHandler__c.getInstance('Event_CallPlan').Active__c == false)
        return;
    
    
    if(Trigger.IsInsert && Trigger.isAfter){
        Event_CallPlan_TriggerHandler.CallPlanCreationFromEvents(Trigger.new);
    }
    else if(Trigger.IsUpdate  && Trigger.isAfter && Event_CallPlan_TriggerContext.isFirstRun()){
        
        Event_CallPlan_TriggerHandler.CallPlanUpdationFromEvents(Trigger.new);
    }
    else if(Trigger.IsInsert && Trigger.isbefore) 
    {
        Event_CallPlan_TriggerHandler.POPSA_Update_Status(Trigger.new);
    }
    if((Trigger.isAfter)&&(Trigger.IsInsert || Trigger.IsUpdate || Trigger.IsDelete || Trigger.IsUnDelete) ){
        if(Trigger.isAfter && (Trigger.IsInsert ||Trigger.IsUpdate ||Trigger.IsUnDelete)){
            Event_CallPlan_TriggerHandler.Makesales_CallPlanLastDateUpdateToAccount(Trigger.new);
        }
        else if((Trigger.IsDelete  && Trigger.isAfter)){
            Event_CallPlan_TriggerHandler.Makesales_CallPlanLastDateUpdateToAccount(Trigger.old);
        }
    }
}