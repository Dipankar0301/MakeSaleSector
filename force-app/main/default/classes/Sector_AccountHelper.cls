public class Sector_AccountHelper {
    public static Boolean hasAccountRunFirstTime = true;
    public static void UpdateTopLevelOwnerName(List<Account> oldList, List<Account> newList,Map<Id, Account> oldMap, Map<Id, Account> newMap){
        String SectorRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sector').getRecordTypeId();
        System.debug('line 4');
        Map<String,String> topAccountIds = new Map<String,String>();
        Set<String> triggerRecordId = new Set<String>();
        for(Account acc:newList){
            if(Trigger.isUpdate && acc.RecordTypeId == SectorRecordTypeId){
                System.debug('line 10');
            	//Account tempOld = oldMap?.get(acc.id);
                //System.debug(tempOld);
                //System.debug(acc.Parent_Record_Id__c);
                //System.debug(tempOld.Parent_Record_Id__c);
                //if(acc.Parent_Record_Id__c != tempOld.Parent_Record_Id__c){
                topAccountIds.put(acc.id,acc.Parent_Record_Id__c);
                triggerRecordId.add(acc.id);
                    System.debug('line 14');
                    System.debug(triggerRecordId);
                //}
            }
            if(Trigger.isInsert && acc.RecordTypeId == SectorRecordTypeId){
                topAccountIds.put(acc.id,acc.Parent_Record_Id__c);
                triggerRecordId.add(acc.id);
            }
            
        }
        if(triggerRecordId != null && !triggerRecordId.isEmpty()){
        Map<id, account> topAccounts = new Map<id, account>([select id, Owner_Name__c from account where id in: topAccountIds.values()]);
        System.debug(topAccountIds.values());
        List<Account> AccountRecords =[select id, Owner_Name__c,Name,Parent_Record_Id__c,Top_Level_Account_Owner_Name__c from account where Parent_Record_Id__c in:topAccountIds.values() ];
        System.debug('line 15');
        System.debug(AccountRecords);
        
        System.debug(topAccounts);
        for(Account acc:AccountRecords){
            id parentRecordId = acc.Parent_Record_Id__c;
            System.debug(parentRecordId);
            String s = topAccounts.get(parentRecordId)?.Owner_Name__c;
            acc.Top_Level_Account_Owner_Name__c = s;
        } 
        hasAccountRunFirstTime = false;
        System.debug(AccountRecords);
        update AccountRecords;
    }
    }
}