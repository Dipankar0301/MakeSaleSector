trigger CaseTrigger on Case (before insert, before update) 
{
	CaseTriggerHelper.updatecasedetails(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap, Trigger.operationType);
}