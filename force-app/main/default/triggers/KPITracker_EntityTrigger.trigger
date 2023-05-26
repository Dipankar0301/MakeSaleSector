trigger KPITracker_EntityTrigger on Entity__c (after insert,after update, after delete) {
    
    if(trigger.isAfter)
    {
        if(trigger.isDelete){
            KPITracker_EntityTriggerHandler ent = New KPITracker_EntityTriggerHandler();
            system.debug(' @@@@@@ ');
            ent.CountChildEntities(Trigger.old);
        }
    }
    if(trigger.isAfter)
    {
        if(trigger.isInsert){

            KPITracker_EntityTriggerHandler ent = New KPITracker_EntityTriggerHandler();
            ent.CountChildEntities(trigger.New);
        }
        /*Sampada*/
       /* if(trigger.isUpdate){
            KPITracker_EntityTriggerHandler ent=New KPITracker_EntityTriggerHandler();//
            ent.updateFields(trigger.New);
        }*/
    }

}