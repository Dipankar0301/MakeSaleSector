trigger NEPMSupportRoleTrigger on NEPM_Support_Role__c (after insert,after update,before delete) {
    DPM_rigger_Switch__c stoptrigger = DPM_rigger_Switch__c.getOrgDefaults();
    System.debug('****testing****'+stoptrigger.Stop_Trigger_Fire__c);
    Set<id> supportRoleSet = new Set<id>();
    if(trigger.isInsert && trigger.isAfter && !stoptrigger.Stop_Trigger_Fire__c){
        
        for(NEPM_Support_Role__c s : trigger.new){ 
            System.debug('*****parentid***Support**'+s.NEPM_Project__c);
            supportRoleSet.add(s.NEPM_Project__c);
        }
    }
    if(trigger.isUpdate && trigger.isAfter && !stoptrigger.Stop_Trigger_Fire__c){
        
        for(NEPM_Support_Role__c s : trigger.new)
        {
            System.debug('*****parentid***Support**'+s.NEPM_Project__c);
            supportRoleSet.add(s.NEPM_Project__c);
        }    
    }
    if(trigger.isDelete && trigger.isBefore && !stoptrigger.Stop_Trigger_Fire__c){
        
        for(NEPM_Support_Role__c s : trigger.old)
        {
            System.debug('*****parentid***Support**'+s.NEPM_Project__c);
            supportRoleSet.add(s.NEPM_Project__c);
        }    
    }
    if(supportRoleSet.size()>0){
        
        System.debug('******Enter into the List******'); 
        NEPM_ProjectLastModifiedDateTrigger.updateProjectsLastModifiedDate(supportRoleSet);
    }

}