public class MakeSaled_RelatedOppsInCampaign {
	 @AuraEnabled
    public static List<Opportunity> getRelatedList(Id recordId)
    {
        System.debug(recordId);
        //List<Account> accountlist =[select id, Parent_Record_Id__c from account where id in (select Customer_Name__c from Account_Plan__c where id =: recordId)];
        List<Campaign> campaignList =[select id, Top_Campaign_Id__c from Campaign where id=: recordId];
        System.debug(campaignList);
        String ParentRecordId = campaignList[0].Top_Campaign_Id__c;
        System.debug('line 11' + ParentRecordId);
        List<Opportunity> allOpportunity = [select id,Name,Value_Amount__c,Campaign.name,Campaign.Owner_Name__c,Owner_Name__c,StageName,
                                                Account.Name,Account_Owner_Name__c,Parent_Account_Name__c,CampaignId
                                                from Opportunity where CampaignId in
                                                (select id from Campaign where Top_Campaign_Id__c =: ParentRecordId)];        
        
        System.debug('size'+ allOpportunity.size());
        
      
        
        
        
        return allOpportunity;
    }
}