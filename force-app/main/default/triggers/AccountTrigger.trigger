trigger AccountTrigger on Account (before insert,before update,after Insert, after update) {
    //To check if the new Account is created from Lead
    //public static Boolean hasAccountRunFirstTime = true;
    if(TriggerHandler__c.getInstance('AccountTrigger') != null && TriggerHandler__c.getInstance('AccountTrigger').Active__c == false)
        return;
    If(Trigger.isInsert && Trigger.isAfter)
        LeadTriggerHelper.hasInsertRunAccount = true;
    If(Trigger.isAfter){
        if((Trigger.isInsert || Trigger.isUpdate) && Sector_AccountHelper.hasAccountRunFirstTime == true)
        {
            System.debug('line 9 in trigger');
            Sector_AccountHelper.UpdateTopLevelOwnerName(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
        }
    }
    
}