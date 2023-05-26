trigger ProjectNotesAttachmentTrigger on ContentVersion (after insert,after update) {
    
    DPM_rigger_Switch__c stoptrigger = DPM_rigger_Switch__c.getOrgDefaults();
    System.debug('****testing****'+stoptrigger.Stop_Trigger_Fire__c);
    set<id> ContentIdSet = new set<id>();
    set<id> projectSet   = new Set<id>();
    
    if(trigger.isInsert && trigger.isAfter && !stoptrigger.Stop_Trigger_Fire__c){
    
        for(ContentVersion con :trigger.new){
            
            System.debug('***ContentDocumentId**'+con.ContentDocumentId);
            System.debug('****Title*****'+con.Title);
            ContentIdSet.add(con.ContentDocumentId);
        }
    }
    if(trigger.isUpdate && trigger.isAfter && !stoptrigger.Stop_Trigger_Fire__c){
    
        for(ContentVersion con :Trigger.new){
            
             System.debug('***ContentDocumentId**'+con.ContentDocumentId);
             System.debug('****Title*****'+con.Title);
             ContentIdSet.add(con.ContentDocumentId);
        }
    }
    if(ContentIdSet.size()>0){
        
        for(ContentDocumentLink conlink : [SELECT ContentDocumentId,Id,LinkedEntityId FROM ContentDocumentLink where ContentDocumentId IN: ContentIdSet]){
            
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