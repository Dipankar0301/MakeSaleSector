trigger NEPMExternalContactsJuncTrigger on External_Contacts_Junction__c (after insert,after update,before delete) {
    
    DPM_rigger_Switch__c stoptrigger = DPM_rigger_Switch__c.getOrgDefaults();
    System.debug('****testing****'+stoptrigger.Stop_Trigger_Fire__c);
    Set<id> externalContactSet = new Set<id>();
    if(trigger.isInsert && trigger.isAfter && !stoptrigger.Stop_Trigger_Fire__c){
        
        for(External_Contacts_Junction__c exc : trigger.new){ 
            System.debug('*****parentid***ExternalContac**'+exc.Project__c);
            externalContactSet.add(exc.Project__c);
        }
    }
    if(trigger.isUpdate && trigger.isAfter && !stoptrigger.Stop_Trigger_Fire__c){
        
        for(External_Contacts_Junction__c exc : trigger.new)
        {
            System.debug('*****parentid**ExternalContact**'+exc.Project__c);
            externalContactSet.add(exc.Project__c);
        }    
    }
    if(trigger.isDelete && trigger.isBefore && !stoptrigger.Stop_Trigger_Fire__c){
        
        for(External_Contacts_Junction__c exc : trigger.old)
        {
            System.debug('*****parentid***ExternalContact**'+exc.Project__c);
            externalContactSet.add(exc.Project__c);
        }    
    }
    if(externalContactSet.size()>0){
        
        System.debug('******Enter into the List******');
        NEPM_ProjectLastModifiedDateTrigger.updateProjectsLastModifiedDate(externalContactSet);
    }
}