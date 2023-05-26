trigger KPITracker_KPITrigger on KPI__c (before insert,before update,after insert,before delete,after update,after delete) {
    if(trigger.isBefore)
    {
        if(trigger.isInsert){
            KPITracker_KPITriggerHandler KPIHandler = New KPITracker_KPITriggerHandler();
            KPIHandler.assignDueDateValue(Trigger.new,null); 
            KPIHandler.updateNominiesEthical(Trigger.new,null); 
            //KPIHandler.checkOverlapping(Trigger.new,null);           
        }
        else if(trigger.isUpdate){
            KPITracker_KPITriggerHandler KPIHandler = New KPITracker_KPITriggerHandler();
            KPIHandler.assignDueDateValue(Trigger.new,Trigger.oldMap); 
             KPIHandler.updateNominiesEthical(Trigger.new,Trigger.oldMap); 
            //KPIHandler.checkOverlapping(Trigger.new,Trigger.oldMap);   
 
        }
         if(Trigger.IsDelete){
            system.debug('Trigger.IsDelete 000');
            KPITracker_KPITriggerHandler KPIHandler = New KPITracker_KPITriggerHandler();           
            KPIHandler.deleteEthicalLeadershipValuesInEntities(Trigger.old); 
            //KPIHandler.checkOverlapping(Trigger.new,Trigger.oldMap);   
            
        }

    }
    
   if(trigger.isAfter)
    {
        
       
        if(trigger.isInsert){
            KPITracker_KPITriggerHandler KPIHandler = New KPITracker_KPITriggerHandler();
            KPIHandler.calculateCustomerGrowth(Trigger.new,null); 
            //.updateCustomerGrowthEntities(Trigger.new,null);
        } if(trigger.isUpdate){
            KPITracker_KPITriggerHandler KPIHandler = New KPITracker_KPITriggerHandler();
            KPIHandler.calculateCustomerGrowth(Trigger.new,Trigger.oldMap); 
            //KPIHandler.updateCustomerGrowthEntities(Trigger.new,Trigger.oldMap);
        } 
         if(Trigger.IsDelete){
            
            KPITracker_KPITriggerHandler KPIHandler = New KPITracker_KPITriggerHandler();           
            //KPIHandler.updateCustomerGrowthEntities(Trigger.old,null); 
         }
    }
    
    
     

}