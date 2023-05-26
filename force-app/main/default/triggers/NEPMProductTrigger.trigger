trigger NEPMProductTrigger on Product__c (after insert,after update,before delete) {
    DPM_rigger_Switch__c stoptrigger = DPM_rigger_Switch__c.getOrgDefaults();
    System.debug('****testing****'+stoptrigger.Stop_Trigger_Fire__c);
    Set<id> productSet = new Set<id>();
    if(trigger.isInsert && trigger.isAfter && !stoptrigger.Stop_Trigger_Fire__c){
        
        for(Product__c pro : trigger.new){ 
            System.debug('*****parentid***productinsert**'+pro.Project__c);
            productSet.add(pro.Project__c);
        }
    }
    if(trigger.isUpdate && trigger.isAfter && !stoptrigger.Stop_Trigger_Fire__c){
        
        for(Product__c pro : trigger.new)
        {
            System.debug('*****parentid***Prductupdate**'+pro.Project__c);
            productSet.add(pro.Project__c);
        }    
    }
    if(trigger.isDelete && trigger.isBefore && !stoptrigger.Stop_Trigger_Fire__c){
        
        for(Product__c pro : trigger.old)
        {
            System.debug('*****parentid***ProducktDelete**'+pro.Project__c);
            productSet.add(pro.Project__c);
        }    
    }
    if(productSet.size()>0){
        
        System.debug('******Enter into the List******');
        NEPM_ProjectLastModifiedDateTrigger.updateProjectsLastModifiedDate(productSet);
    }

}