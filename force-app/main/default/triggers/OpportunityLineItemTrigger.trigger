trigger OpportunityLineItemTrigger on OpportunityLineItem (before delete) 
{
    if(Trigger.isBefore && Trigger.isdelete)
        OpportunityLineItemTriggerHelper.deletepredictedrecords(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap); 
}