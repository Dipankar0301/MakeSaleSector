trigger SV2020OppShare on Opportunity__c (before insert, before update, after insert, after update) {
    if(trigger.isBefore){
        if(trigger.isInsert){
            SV2020HNDOpportunityHandler.SFFieldsUpdate(trigger.new);
        }
        if(trigger.isUpdate){    
        system.debug('*** SV2020RecursiveTriggerHandler.isFirstTime *** 111'+SV2020RecursiveTriggerHandler.isFirstTime);        
            if(SV2020RecursiveTriggerHandler.isFirstTime){
                SV2020RecursiveTriggerHandler.isFirstTime = false;
                SV2020HNDOpportunityHandler.OpporChatterUpdate(trigger.newMap, trigger.oldMap);
                SV2020HNDOpportunityHandler.SFFieldsUpdate(trigger.new);
            } 
            
        }
        
    }
    if(trigger.isAfter){
        if(trigger.isInsert ){
            SV2020HNDOpportunityHandler.recordSharing(trigger.new, trigger.oldMap);
          //  SV2020HNDOpportunityHandler.AllRecordSharing();
            
        }
        if(trigger.isUpdate){
        system.debug('*** SV2020RecursiveTriggerHandler.isFirstTime *** 222'+SV2020RecursiveTriggerHandler.isFirstTime);        
            //if(SV2020RecursiveTriggerHandler.isFirstTime){
                    //SV2020RecursiveTriggerHandler.isFirstTime = false;
                SV2020HNDOpportunityHandler.ImplementationTimeline(trigger.old , trigger.new);
                SV2020HNDOpportunityHandler.recordSharingUpdate(trigger.new, trigger.oldMap);
              //  SV2020HNDOpportunityHandler.AllRecordSharing();
            //}
        }
		
    }
}