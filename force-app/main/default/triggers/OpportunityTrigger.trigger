trigger OpportunityTrigger on Opportunity (before insert, after insert, after update) 
{
    //To check if the new opportunity is created from Lead
    If(Trigger.isInsert && Trigger.isAfter)
     LeadTriggerHelper.hasInsertRunOpportunity = true;
    if(TriggerHandler__c.getInstance('OpportunityTrigger') != null && TriggerHandler__c.getInstance('OpportunityTrigger').Active__c == false)
        return;
    
    //To check if the new opportunity is created from Lead
    OpportunityTriggerHelper.updateOpportunityDetails(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap, Trigger.operationType);
    Sector_OpportunityStageChecker.checkSectorOpportunityStageValidation(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap, Trigger.operationType);
}