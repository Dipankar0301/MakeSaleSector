public class AccountPlan_ListOfContacts {
    @AuraEnabled
    public static list<Contact> getRelatedList(Id recordId)
    {
        List<Account_Plan__c> accid =[select id,Customer_Name__c from Account_Plan__c where id =: recordId limit 1];
        Id accplanid=accid[0].Customer_Name__c;
        List<Contact> Conlist = [Select id,Name,Shell_Counterpart__c,Management_Style__c,Department__c,Buyer_Profile__c,Vendor_Preference__c,Buying_group__c,Title,Individual_Relationship_Insights__c from Contact where AccountId =: accplanid ];
        System.debug(conlist);
        return Conlist;
    }
    
    @AuraEnabled
    public static list<Id> getAccountId(Id recordId)
    {
        List<Account_Plan__c> accid =[select id,Customer_Name__c from Account_Plan__c where id =: recordId limit 1];
        Id accountid=accid[0].Customer_Name__c;
        //Id recordtypeidorg1= Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId();
        List<ID> li = new List<Id>(); 
        li.add(accountid);
        //System.debug(accountid + ''+ recordtypeidorg1);
        return li;
    }
}