trigger NEPMCustomerOfftakerTrigger on Customer_Offtaker__c (after insert,after update,before delete) {
    
    DPM_rigger_Switch__c stoptrigger = DPM_rigger_Switch__c.getOrgDefaults();
    System.debug('****testing****'+stoptrigger.Stop_Trigger_Fire__c);
    Set<id> customerOfftakerSet = new Set<id>();
    if(trigger.isInsert && trigger.isAfter && !stoptrigger.Stop_Trigger_Fire__c){
        
        for(Customer_Offtaker__c cus : trigger.new){ 
            System.debug('*****parentid***CutosmerOfftaker**'+cus.Project__c);
            customerOfftakerSet.add(cus.Project__c);
        }
    }
    if(trigger.isUpdate && trigger.isAfter && !stoptrigger.Stop_Trigger_Fire__c){
        
        for(Customer_Offtaker__c cus : trigger.new)
        {
            System.debug('*****parentid***CutosmerOfftaker**'+cus.Project__c);
            customerOfftakerSet.add(cus.Project__c);
        }    
    }
    if(trigger.isDelete && trigger.isBefore && !stoptrigger.Stop_Trigger_Fire__c){
        
        for(Customer_Offtaker__c cus : trigger.old)
        {
            System.debug('*****parentid***CutosmerOfftaker**'+cus.Project__c);
            customerOfftakerSet.add(cus.Project__c);
        }    
    }
    if(customerOfftakerSet.size()>0){
        
        System.debug('******Enter into the List******');  
        NEPM_ProjectLastModifiedDateTrigger.updateProjectsLastModifiedDate(customerOfftakerSet);
    }
}