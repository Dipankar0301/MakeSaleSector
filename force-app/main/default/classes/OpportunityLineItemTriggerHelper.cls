public class OpportunityLineItemTriggerHelper 
{
    public static void deletepredictedrecords(List<OpportunityLineItem> oldList, List<OpportunityLineItem> newList, 
                                              Map<Id, OpportunityLineItem> oldMap, Map<Id, OpportunityLineItem> newMap)
    {
        delete [SELECT Id, Opportunity_Product__c FROM Predicted_Product_Information__c
                where Opportunity_Product__c in :oldMap.keyset() and Opportunity__r.recordtype.name = 'Sector']; 
        delete [SELECT Id, Opportunity__c, Opportunity_Product__c FROM Bulk_Forecasting_Update__c 
                where Opportunity_Product__c in :oldMap.keyset() and Opportunity__r.recordtype.name = 'Sector']; 
    }
}