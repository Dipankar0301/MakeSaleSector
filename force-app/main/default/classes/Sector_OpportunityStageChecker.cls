public class Sector_OpportunityStageChecker
{
    
    public static void checkSectorOpportunityStageValidation(List<Opportunity> oldList, List<Opportunity> newList, 
                                                             Map<Id, Opportunity> oldMap, Map<Id, Opportunity> newMap, System.TriggerOperation operationType)
    {  
        if((operationType == System.TriggerOperation.AFTER_INSERT || operationType == System.TriggerOperation.AFTER_UPDATE) )
        {
            List<String> OpportunityWonStages = Label.Sector_Opportunity_Won_Stages.split(',');
            for(Opportunity opprecord : newList)
            {
                if(opprecord.RecordTypeId != null && 
                   Schema.SObjectType.Opportunity.getRecordTypeInfosById().get(opprecord.RecordTypeId).getDeveloperName() == Label.Sector_Opportunity_DevRecordTypeName && 
                   (operationType == System.TriggerOperation.AFTER_INSERT || (newMap != null && oldMap != null && newMap.get(opprecord.Id).StageName != oldMap.get(opprecord.Id).StageName ) )
                  )
                {
                    String errormessage = '';
                    if(opprecord.StageName == Label.Opportunity_Stage_Name_Negotiate || OpportunityWonStages.contains(opprecord.StageName))
                    {
                        if(opprecord.Opportunity_Country__c  == null)
                            errormessage += (errormessage != '' ? ' & ' : '')+Schema.getGlobalDescribe().get('Opportunity').getDescribe().fields.getMap().get('Opportunity_Country__c').getDescribe().getLabel();
                        if(opprecord.Opportunity_Region__c  == null)
                            errormessage += (errormessage != '' ? ' & ' : '')+Schema.getGlobalDescribe().get('Opportunity').getDescribe().fields.getMap().get('Opportunity_Region__c').getDescribe().getLabel();
                        if(opprecord.Value_Amount__c  == null || opprecord.Value_Amount__c <= 0 )
                            errormessage += (errormessage != '' ? ' & ' : '')+Schema.getGlobalDescribe().get('Opportunity').getDescribe().fields.getMap().get('Value_Amount__c').getDescribe().getLabel() + '[This field must be non-zero on Stage '+opprecord.StageName+']';
                        if(OpportunityWonStages.contains(opprecord.StageName) && opprecord.Status_Reason__c == null)
                            errormessage += (errormessage != '' ? ' & ' : '')+Schema.getGlobalDescribe().get('Opportunity').getDescribe().fields.getMap().get('Status_Reason__c').getDescribe().getLabel();
                    }
                    if(errormessage != '')
                        opprecord.addError(Label.Sector_stage_validation_error_message + ' ' + errormessage);
                }
            }
        }
    }
}