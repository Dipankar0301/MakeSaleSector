trigger NEPMFinanceProjectTrigger on Financial__c (after insert,after update,before delete) {
    DPM_rigger_Switch__c stoptrigger = DPM_rigger_Switch__c.getOrgDefaults();
    System.debug('****testing****'+stoptrigger.Stop_Trigger_Fire__c);
    Set<id> financeSet = new Set<id>();
    if(trigger.isInsert && trigger.isAfter && !stoptrigger.Stop_Trigger_Fire__c){
        
        for(Financial__c f : trigger.new){ 
            System.debug('*****parentid***Finance**'+f.Project__c);
            financeSet.add(f.project__C);
        }
    }
    if(trigger.isUpdate && trigger.isAfter && !stoptrigger.Stop_Trigger_Fire__c){
        
        for(Financial__c f : trigger.new)
        {
            System.debug('*****parentid***Finance**'+f.Project__c);
            financeSet.add(f.project__C);
        }    
    }
    if(trigger.isDelete && trigger.isBefore && !stoptrigger.Stop_Trigger_Fire__c){
        
        for(Financial__c f : trigger.old)
        {
            System.debug('*****parentid***Finance**'+f.Project__c);
            financeSet.add(f.project__C);
        }    
    }
    if(financeSet.size()>0){
        
        System.debug('******Enter into the List******');
        NEPM_ProjectLastModifiedDateTrigger.updateProjectsLastModifiedDate(financeSet); 
    }
}