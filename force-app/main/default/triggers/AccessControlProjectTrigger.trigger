trigger AccessControlProjectTrigger on DSAD_Access_Control__c (before insert,before update,after insert,after update,after delete) {
    if(trigger.isBefore && (trigger.isInsert || trigger.isUpdate))
    {
        AccessControlProjectTriggerHandler acceshandler = new AccessControlProjectTriggerHandler();
        acceshandler.CheckDuplicates(Trigger.new,Trigger.oldMap);
    }
    if(Trigger.isInsert && Trigger.isAfter){
    
        AccessControlProjectTriggerHandler acceshandler = new AccessControlProjectTriggerHandler();
        acceshandler.AssignAccessOnInsert(Trigger.new);    
    }
    if(Trigger.isUpdate && Trigger.isAfter){
       
       AccessControlProjectTriggerHandler acceshandler = new AccessControlProjectTriggerHandler();
       acceshandler.RemoveAndAssignAccessOnUpdate(Trigger.new,Trigger.oldMap);
           
    }
    if(Trigger.isAfter && Trigger.isDelete){
        
          AccessControlProjectTriggerHandler acceshandler = new AccessControlProjectTriggerHandler();
          acceshandler.RemoveAccessOnDelete(Trigger.old);  
    }
}