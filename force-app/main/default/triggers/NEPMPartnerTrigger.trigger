trigger NEPMPartnerTrigger on Partner__c (after insert,after update,before delete) {
     DPM_rigger_Switch__c stoptrigger = DPM_rigger_Switch__c.getOrgDefaults();
    System.debug('****testing****'+stoptrigger.Stop_Trigger_Fire__c);
    Set<id> partnerSet = new Set<id>();
    if(trigger.isInsert && trigger.isAfter && !stoptrigger.Stop_Trigger_Fire__c){
        
        for(Partner__c p : trigger.new){ 
            System.debug('*****parentid***Partner**'+p.Project__c);
            partnerSet.add(p.Project__c);
        }
    }
    if(trigger.isUpdate && trigger.isAfter && !stoptrigger.Stop_Trigger_Fire__c){
        
        for(Partner__c p : trigger.new)
        {
            System.debug('*****parentid***Partner**'+p.Project__c);
            partnerSet.add(p.Project__c);
        }    
    }
    if(trigger.isDelete && trigger.isBefore && !stoptrigger.Stop_Trigger_Fire__c){
        
        for(Partner__c p : trigger.old)
        {
            System.debug('*****parentid***Partner**'+p.Project__c);
            partnerSet.add(p.Project__c);
        }    
    }
    if(partnerSet.size()>0){
        
        System.debug('******Enter into the List******');
        NEPM_ProjectLastModifiedDateTrigger.updateProjectsLastModifiedDate(partnerSet);
    }
}