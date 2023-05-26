public class OpportunityTriggerHelper 
{
    public static void updateOpportunityDetails(List<Opportunity> oldList, List<Opportunity> newList, Map<Id, Opportunity> oldMap, 
                                         Map<Id, Opportunity> newMap, System.TriggerOperation operationType)
    {  
        if(operationType == System.TriggerOperation.BEFORE_INSERT)
        {
            /************************* Update Opportunity Owner ***************************************/
            Clone_UpdateOpportunityOwner(newList);
            /************************* Update Opportunity Owner ***************************************/
        }
    }
    public static void Clone_UpdateOpportunityOwner(List<Opportunity> newList)
    {
        List<Id> oppids = new List<Id>();
        for(Opportunity opprecord : newList)
        {
            if(opprecord.RecordTypeId != null && opprecord.isClone() &&
               (Schema.SObjectType.Opportunity.getRecordTypeInfosById().get(opprecord.RecordTypeId).getDeveloperName() == Label.SEUK_B2B_Opportunity_Dev_Name ||
                Schema.SObjectType.Opportunity.getRecordTypeInfosById().get(opprecord.RecordTypeId).getDeveloperName() == Label.SEUK_B2B_Solutions_Opportunity_Dev_Name)
              )
            {
                oppids.add(opprecord.getclonesourceId());
            }
        }
        if(oppids.size() > 0)
        {
            Map<ID, Opportunity> oppmap = new Map<ID, Opportunity>([Select Id, OwnerId from Opportunity
                                                                    where Id in : oppids]);
            for(Opportunity opprecord : newList)
            {
                if(opprecord.isClone())
                {
                    opprecord.OwnerId = oppmap.get(opprecord.getclonesourceId()).OwnerId;
                }      
            }
        }
    }
}