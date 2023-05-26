/*
* Author: Aman Jaiswal
* Description: A test class created to validate the KPITracker_KPITriggerHandler Class
*/
@isTest
public class KPITracker_KPITriggerHandlertest {
    
    @testSetup
    static void dataCreation() {
        list<Entity__c> lstEntity= KPITracker_TestDataFactory.createEntityData(1);
        List<Entity__c> lstParenetEntity = KPITracker_TestDataFactory.createParentEntity(1, lstEntity);
        LIST<Entity__c> lstParentParentEntity = KPITracker_TestDataFactory.createParentOFParentEntity(1, lstParenetEntity);
        try{
             KPITracker_TestDataFactory.createKPIRec(2,'IT',lstParentParentEntity[0].Id,'Yearly');
        }
        catch(Exception ex){
            Boolean expectedExceptionThrown =  (ex.getMessage().contains('KPI Duration is overlapping with')) ? true : false; 
            System.AssertEquals(true, expectedExceptionThrown, ex.getMessage()); 
        }
       
        
        // KPITracker_TestDataFactory.createKPIRec(1,'Power',lstParenetEntity[0].Id,'Bi-Monthly'); 
        //KPITracker_TestDataFactory.createKPIRec(1,'Customer Centricity',lstParenetEntity[0].Id,'Mid-Year'); 
        //KPITracker_TestDataFactory.createKPIRec(1,'Hydrogen',lstParenetEntity[0].Id,'Quarterly'); 
    }
    @isTest
    private static  void assignDueDateValueTest(){
        Id entityId = [Select Id,name from Entity__c where Hierarchy_Level__c='L2' limit 1].Id;
        KPITracker_TestDataFactory.createKPIRec(1,'Hydrogen',entityId,'Mid-Year');
        List<KPI__c> lstKpi=[Select Id,Name,KPI_Frequency__c,RecordTypeId,Entity__c,KPI_Date__c from KPI__c];
        KPITracker_KPITriggerHandler obj = new KPITracker_KPITriggerHandler();
        obj.assignDueDateValue(lstKpi, new Map<Id, KPI__c>(lstKpi));
    }
    
    @isTest
    private static void updateEthicalLeadershipKPITest(){
        list<Entity__c> lstEntity= KPITracker_TestDataFactory.createEntityData(1);
        List<Entity__c> lstParenetEntity = KPITracker_TestDataFactory.createParentEntity(1, lstEntity);
        List<KPI__c>lstKpi= KPITracker_TestDataFactory.createEthicalLeadershipKPIRec(1,'Ethical Leadership',lstParenetEntity[0].Id,'Monthly'); 
        
        KPITracker_KPITriggerHandler obj = new KPITracker_KPITriggerHandler();
        obj.updateEthicalLeadershipKPI(lstKpi, new Map<Id, KPI__c>(lstKpi));
		
    }
    
    @isTest
    private static void deleteEthicalLeadershipValuesInEntitiesTest(){
        list<Entity__c> lstEntity= KPITracker_TestDataFactory.createEntityData(1);
        List<Entity__c> lstParenetEntity = KPITracker_TestDataFactory.createParentEntity(1, lstEntity);
        List<KPI__c>lstKpi= KPITracker_TestDataFactory.createKPIRec(1,'Ethical Leadership',lstParenetEntity[0].Id,'Quarterly');
        KPITracker_KPITriggerHandler obj = new KPITracker_KPITriggerHandler();
        obj.deleteEthicalLeadershipValuesInEntities(lstKpi);
    }
    
    @isTest
    private static void deleteKPITest(){
        list<Entity__c> lstEntity= KPITracker_TestDataFactory.createEntityData(1);
        List<Entity__c> lstParenetEntity = KPITracker_TestDataFactory.createParentEntity(1, lstEntity);
        List<KPI__c>lstKpi= KPITracker_TestDataFactory.createKPIRec(1,'Ethical Leadership',lstParenetEntity[0].Id,'Bi-Monthly');
        lstKpi=[Select Id,name from KPI__c Where Id=:lstKpi[0].Id];
        lstKpi[0].Uptime_Service_Desk_Ticket_Per_User__c =0;
        update lstKpi;
        delete lstKpi;
        
    }
    @isTest
    private static void calculateCustomerGrowthTest(){
        Test.startTest();
        list<Entity__c> lstEntity= KPITracker_TestDataFactory.createEntityData(1);
        List<Entity__c> lstParenetEntity = KPITracker_TestDataFactory.createParentEntity(1, lstEntity);
        LIST<Entity__c> lstParentParentEntity = KPITracker_TestDataFactory.createParentOFParentEntity(1, lstParenetEntity);
        LIST<Entity__c> lstParentParentParentEntity = KPITracker_TestDataFactory.createParentOFParentOFParentEntity(1, lstParentParentEntity);
        List<KPI__c> lstKpi = KPITracker_TestDataFactory.createCustomerCentricityKPIRec(1,'Customer Centricity',lstParentParentParentEntity[0].Id,'Monthly');
        lstKpi[0].Net_customer_with_trend_B2C__c=10;
        update lstKpi;
        system.debug('@@@'+lstKpi);
        KPITracker_KPITriggerHandler obj = new KPITracker_KPITriggerHandler();
        //obj.calculateCustomerGrowth(lstKpi, new Map<Id, KPI__c>(lstKpi));
        Test.stopTest();
    }
}