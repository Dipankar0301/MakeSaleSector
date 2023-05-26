trigger SiteTrigger on Site__c (before insert,before update) {
/*    
    if(Trigger.isInsert){
        if(TriggerHandler__c.getInstance('SiteTrigger') != null && TriggerHandler__c.getInstance('SiteTrigger').Active__c == false)
        return;
        Sector_Site_ApiCalling.GetAddressInsert(Trigger.new,Trigger.newMap);
    }
    if(Trigger.isUpdate){
        if(TriggerHandler__c.getInstance('SiteTrigger') != null && TriggerHandler__c.getInstance('SiteTrigger').Active__c == false)
        return;
        Sector_Site_ApiCalling.GetAddressUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
    }
    
*/
    if(TriggerHandler__c.getInstance('SiteTrigger') != null && TriggerHandler__c.getInstance('SiteTrigger').Active__c == false)
        return;
     if(Trigger.isInsert && sector_SiteHelper.isBatchCode == false){
         sector_SiteHelper.UpdateFieldForInsert(Trigger.new,Trigger.newMap);
     }
    if(Trigger.isUpdate && sector_SiteHelper.isBatchCode == false){
        sector_SiteHelper.UpdateFieldForUpdate(Trigger.old, Trigger.new, Trigger.oldMap, Trigger.newMap);
    }
}