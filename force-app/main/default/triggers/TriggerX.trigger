trigger TriggerX on Case (after update) {
    
    Id reactive = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Reactive_Work_Order').getRecordTypeId();
    Id planned = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Planned_Work_Order').getRecordTypeId();
    Id ccnareactive = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('CCNA_Reactive_Work_Order').getRecordTypeId();
    Id ccnaplanned = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('CCNA_Planned_Work_Order').getRecordTypeId();
    Id user_profileid=UserInfo.getProfileId();
    
}