trigger NEPMFeedstockTrigger on Feedstock__c (after insert,after update,before delete) {
    
    DPM_rigger_Switch__c stoptrigger = DPM_rigger_Switch__c.getOrgDefaults();
    System.debug('****testing****'+stoptrigger.Stop_Trigger_Fire__c);
    Set<id> FeedstockSet = new Set<id>();
    if(trigger.isInsert && trigger.isAfter && !stoptrigger.Stop_Trigger_Fire__c){
        
        for(Feedstock__c feed : trigger.new){ 
            System.debug('*****parentid***FeedStockinsert**'+feed.Project__c);
            FeedstockSet.add(feed.Project__c);
        }
    }
    if(trigger.isUpdate && trigger.isAfter && !stoptrigger.Stop_Trigger_Fire__c){
        
        for(Feedstock__c feed : trigger.new)
        {
            System.debug('*****parentid***FeedStockupdate**'+feed.Project__c);
            FeedstockSet.add(feed.Project__c);
        }    
    }
    if(trigger.isDelete && trigger.isBefore && !stoptrigger.Stop_Trigger_Fire__c){
        
        for(Feedstock__c feed : trigger.old)
        {
            System.debug('*****parentid***FeedStockDelete**'+feed.Project__c);
            FeedstockSet.add(feed.Project__c);
        }    
    }
    if(FeedstockSet.size()>0){
        
        System.debug('******Enter into the List******');
        NEPM_ProjectLastModifiedDateTrigger.updateProjectsLastModifiedDate(FeedstockSet);
    }
}