trigger ContentDocumentProjectTrigger on ContentDocument (Before delete) {
    set<id> ContentIdSet = new set<id>();
    Set<id> ContentDocumentids = new Set<id>();
    set<id> projectSet   = new Set<id>();
    
    if(trigger.isBefore && trigger.isDelete){
        for (ContentDocument cdl : Trigger.old) {
            ContentIdSet.add(cdl.LatestPublishedVersionId);
            System.debug('******ContentDocumentId*******'+cdl.LatestPublishedVersionId);
            System.debug('*******parent id*****'+cdl.ParentId); 
            System.debug('******id*******'+cdl.id);
            ContentDocumentids.add(cdl.id);
        }
    }
    if(ContentIdSet.size()>0){
        
        for(ContentDocumentLink conlink : [SELECT ContentDocumentId,Id,LinkedEntityId FROM ContentDocumentLink where ContentDocumentId IN: ContentDocumentids]){
            
            if(conlink.LinkedEntityId.getSobjectType() == NEPM_Project__c.SobjectType){
            
                  projectSet.add(conlink.LinkedEntityId);
            }
            System.debug('******SobjectType******'+conlink.LinkedEntityId.getSobjectType());
        }
    }
    if(projectSet.size()>0){
       
        NEPM_ProjectLastModifiedDateTrigger.updateProjectsLastModifiedDate(projectSet);
        
    }
    
}