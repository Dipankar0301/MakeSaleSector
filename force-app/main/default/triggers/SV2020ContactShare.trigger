trigger SV2020ContactShare on Contact (before insert, before update, after insert, after update) {
    
    if(TriggerHandler__c.getInstance('SV2020ContactShare') != null && TriggerHandler__c.getInstance('SV2020ContactShare').Active__c == false)
        return;
    
    if(trigger.isBefore){
        if(trigger.isUpdate){
            
            if(SV2020RecursiveTriggerHandler.isFirstTime){
                SV2020RecursiveTriggerHandler.isFirstTime = false;
                SV2020HNDContactHandler.ContaChatterUpdate(trigger.newMap, trigger.oldMap);
            } 
            
        }
        
    }
    //To check if the new Contact is created from Lead
    If(Trigger.isInsert){
        if(Trigger.isAfter){
            LeadTriggerHelper.hasInsertRunContact = true;
        }
    } 
}