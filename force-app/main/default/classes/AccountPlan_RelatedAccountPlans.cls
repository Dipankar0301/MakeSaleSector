public class AccountPlan_RelatedAccountPlans {
    @AuraEnabled
    public static List<Account_Plan__c> getRelatedList(Id recordId)
    {
        List<Account> accountlist =[select id, Parent_record_id_18_digits__c from account where id in (select Customer_Name__c from Account_Plan__c where id =: recordId)];
        
        String ParentRecordId = accountlist[0].Parent_record_id_18_digits__c;
        //String ParentRecordId15digit =String.valueof(ParentRecordId).substring(0,15);
        List<Account_Plan__c> allAccountPlan = [select id,Name,Customer_Name__c, Customer_Name__r.Name 
                                                from Account_Plan__c where Customer_Name__c in
                                                (select id from Account where Parent_record_id_18_digits__c=: ParentRecordId)];        
        
        
        
      
        
        
        
        return allAccountPlan;
        //bnnb
    }
}