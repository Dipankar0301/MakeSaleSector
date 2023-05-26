trigger LeadTrigger on Lead (before insert, before update,after update) 
{
    LeadTriggerHelper.updateleaddetails(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap, Trigger.operationType);
    if(Trigger.isAfter && Trigger.isUpdate)
    LeadTriggerHelper.updateLeadConvert(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap, Trigger.operationType);
}