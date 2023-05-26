/*
* Author: Aman Jaiswal
* Description: A test class created to validate the KPITracker_Batch_Historic_KPI_Snapshot Batch Class

* Tests executed:

* 1 - batchTestWithDefalutConstructor()
* Run the batch class without passing the Entity ID

* 2 - batchTestWithParamConstructor()
* Run the batch class with passing the Entity ID

*/

@isTest
Private class KPITracker_Batch_Histo_KPI_SnapshotTest {
    @isTest
    private static void batchTestWithDefalutConstructor(){
        
        KPITracker_General_Setting__c setting = new KPITracker_General_Setting__c();
        setting.Name = 'Test Setting';
        setting.To_Address__c = 'aman.jaiswal@shell.com';
		setting.Subject__c = 'Historical KPI Data';
        insert setting;
        
        list<Entity__c> lstEntity= KPITracker_TestDataFactory.createEntityData(1);
        List<Entity__c> lstParenetEntity = KPITracker_TestDataFactory.createParentEntity(1, lstEntity);
        LIST<Entity__c> lstParentParentEntity = KPITracker_TestDataFactory.createParentOFParentEntity(1, lstParenetEntity);
        KPITracker_Batch_Historic_KPI_Snapshot obj = new KPITracker_Batch_Historic_KPI_Snapshot();
        Database.executeBatch(obj, 200);
        List<KPITracker_Historic_KPI__c> lstHisKpi =[SELECT ID,name from KPITracker_Historic_KPI__c];
        System.debug('lstHisKpi Size:: '+lstHisKpi.size());
    }
    @isTest
    private static void batchTestWithParamConstructor(){
        KPITracker_General_Setting__c setting = new KPITracker_General_Setting__c();
        setting.Name = 'Test Setting';
        setting.To_Address__c = 'aman.jaiswal@shell.com';
        setting.Subject__c = 'Historical KPI Data';
        insert setting;
        set<Id> setEntityId = new set<Id>();
        list<Entity__c> lstEntity= KPITracker_TestDataFactory.createEntityData(1);
        setEntityId.add(lstEntity[0].Id);
        KPITracker_Batch_Historic_KPI_Snapshot obj = new KPITracker_Batch_Historic_KPI_Snapshot(setEntityId);
        Database.executeBatch(obj, 200);
        List<KPITracker_Historic_KPI__c> lstHisKpi =[SELECT ID,name from KPITracker_Historic_KPI__c];
        System.debug('lstHisKpi Size:: '+lstHisKpi.size());
    }
    
    @isTest
    private static void KPITrackerSnapshotBatchScheduler(){
        Test.startTest();
        String jobId = System.schedule('ScheduleApexClassTest',  '0 0 0 15 3 ? *', new KPITrackerSnapshotBatchScheduler());
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
        System.assertEquals('0 0 0 15 3 ? *', ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        Test.stopTest();
    }
}