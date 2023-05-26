public class MakeSaled_chilldOpportunityInParent {
    @AuraEnabled
    public static List<Opportunity> getRelatedList(Id recordId)
    {
        System.debug(recordId);
        //List<Account> accountlist =[select id, Parent_Record_Id__c from account where id in (select Customer_Name__c from Account_Plan__c where id =: recordId)];
        List<Account> accountlist =[select id, Parent_record_id_18_digits__c from account where id=: recordId];
        System.debug(accountlist);
        String ParentRecordId = accountlist[0].Parent_record_id_18_digits__c;
        //String ParentRecordId15digit = String.valueof(ParentRecordId).substring(0,15);
        System.debug('line 11' + ParentRecordId);
        List<Opportunity> allOpportunity = [select id,Name,AccountId,Owner_Name__c,Parent_Account_Name__c, Account.Name,StageName, Value_Amount__c,Opportunity_Lifetime_Profit__c
                                                from Opportunity where AccountId in
                                                (select id from Account where Parent_record_id_18_digits__c =: ParentRecordId)];        
        
        System.debug('size'+ allOpportunity.size());
        
      
        
        
        
        return allOpportunity;
    }
}