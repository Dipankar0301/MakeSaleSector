/*
* Author: Aman Jaiswal
* Description: A test class created to validate the KPITracker_EntityTriggerHandler Class
* Tests executed:
* 1 - CountChildEntitiesTest()
* Count child Entitis record when record is inserted

* 2 - CountChildEntitiesWithDeleteRecTest()
* Count child Entitis record when record is deleted

*/
@isTest
private class KPITracker_EntityTriggerHandlertest {
    
    @testSetup
    static void dataCreation() {
        KPITracker_TestDataFactory.createEntity(5,true); 
    }
    @isTest
    private static  void CountChildEntitiesTest(){
		list<Entity__c> lstEntity= KPITracker_TestDataFactory.createEntityData(1);
        List<Entity__c> lstParenetEntity = KPITracker_TestDataFactory.createParentEntity(1, lstEntity);
        LIST<Entity__c> lstParentParentEntity = KPITracker_TestDataFactory.createParentOFParentEntity(1, lstParenetEntity);
        KPITracker_EntityTriggerHandler objEntityHandler = new KPITracker_EntityTriggerHandler();
		Entity__c objEnti = [Select Id,Name,Parent_Entity__c,Count_of_Child_Entities__c from Entity__c where id=:lstEntity[0].Id limit 1];
        objEntityHandler.CountChildEntities(lstParentParentEntity);
        System.assertEquals(1, objEnti.Count_of_Child_Entities__c);
    }
    @isTest
    private static void CountChildEntitiesWithDeleteRecTest(){
        list<Entity__c> lstEntity= KPITracker_TestDataFactory.createEntityData(1);
        List<Entity__c> lstParenetEntity = KPITracker_TestDataFactory.createParentEntity(1, lstEntity);
        LIST<Entity__c> lstParentParentEntity = KPITracker_TestDataFactory.createParentOFParentEntity(1, lstParenetEntity);
        KPITracker_EntityTriggerHandler objEntityHandler = new KPITracker_EntityTriggerHandler();
        
		Entity__c objEnti = [Select Id,Name,Parent_Entity__c,Count_of_Child_Entities__c from Entity__c where id=:lstParenetEntity[0].Id limit 1];
        System.debug('objEnti:: '+objEnti);
        System.assertEquals(1, objEnti.Count_of_Child_Entities__c);
            
        objEntityHandler.CountChildEntities(lstParentParentEntity);
        
        delete lstParentParentEntity;
        
        objEnti = [Select Id,Name,Parent_Entity__c,Count_of_Child_Entities__c from Entity__c where id=:lstParenetEntity[0].Id limit 1];
       
        System.debug('objEnti:: '+objEnti);
        System.assertEquals(null, objEnti.Count_of_Child_Entities__c);
    }
}