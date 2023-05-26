/*
* Author: Aman Jaiswal
* Description: This Class is used for create a test records
*/


@isTest
public class KPITracker_TestDataFactory {
    
    public static List<Entity__c> createEntity(Integer numEntity,Boolean isParentEntity) {
        
        List<Entity__c> lstEntity= new List<Entity__c>();
        List<Entity__c> lstParentEntity = new List<Entity__c>();
        
        for(Integer i=0;i<numEntity;i++) {
            Entity__c enti = new Entity__c(Name='Entity' + i,Hierarchy_Level__c='L0',Customer_Centric_Visibility_Flag__c='YES',Ethical_Leadership_Visibility_Flag__c='YES',Hydrogen_Visibility_Flag__c = 'YES',IT_Visibility_Flag__c= 'YES',Limited_Financial_Visibility_Flag__c = 'YES',People_Visibility_Flag__c ='YES',Power_Visibility_Flag__c='YES');
            lstEntity.add(enti);
        }
        insert lstEntity;
        
        if(isParentEntity){
            for(Integer i=0;i<numEntity;i++) {
                Entity__c parEntity = new Entity__c(Name='Entity' + i, Parent_Entity__c= lstEntity[i].Id,Hierarchy_Level__c='L1',Customer_Centric_Visibility_Flag__c='YES',Ethical_Leadership_Visibility_Flag__c='YES',Hydrogen_Visibility_Flag__c = 'YES',IT_Visibility_Flag__c= 'YES',Limited_Financial_Visibility_Flag__c = 'YES',People_Visibility_Flag__c ='YES',Power_Visibility_Flag__c='YES');
                lstParentEntity.add(parEntity);
            }
            insert lstParentEntity; 
            return lstParentEntity;
        }
        return lstEntity;
    }
    
    public static List<Entity__c> createEntityData(Integer numEntity) {
        
        List<Entity__c> lstEntity = new List<Entity__c>();
        
        for(Integer i=0;i<numEntity;i++) {
            Entity__c enti = new Entity__c(Name='Entity' + i,Hierarchy_Level__c='L0',Customer_Centric_Visibility_Flag__c='YES',Ethical_Leadership_Visibility_Flag__c='YES',Hydrogen_Visibility_Flag__c = 'YES',IT_Visibility_Flag__c= 'YES',Limited_Financial_Visibility_Flag__c = 'YES',People_Visibility_Flag__c ='YES',Power_Visibility_Flag__c='YES');
            lstEntity.add(enti);
        }
        insert lstEntity;
        return lstEntity;
    }
    
    public static List<Entity__c> createParentEntity(Integer numEntity,List<Entity__c> entity){
        
        List<Entity__c> lstParentEntity = new List<Entity__c>();
        for(Integer i=0;i<numEntity;i++) {
            Entity__c parEntity = new Entity__c(Name='Parent Entity' + i, Parent_Entity__c= entity[i].Id,Hierarchy_Level__c='L1',Customer_Centric_Visibility_Flag__c='YES',Ethical_Leadership_Visibility_Flag__c='YES',Hydrogen_Visibility_Flag__c = 'YES',IT_Visibility_Flag__c= 'YES',Limited_Financial_Visibility_Flag__c = 'YES',People_Visibility_Flag__c ='YES',Power_Visibility_Flag__c='YES');
            lstParentEntity.add(parEntity);
        }
        insert lstParentEntity; 
        return lstParentEntity;
        
    }
    
    public static List<Entity__c> createParentOFParentEntity(Integer numEntity,List<Entity__c> parentEntity){
        
        List<Entity__c> lstParentToParentEntity = new List<Entity__c>();
        for(Integer i=0;i<numEntity;i++) {
            Entity__c parEntity = new Entity__c(Name='Parent Of Parent Entity' + i, Parent_Entity__c= parentEntity[i].Id,Hierarchy_Level__c='L2',Customer_Centric_Visibility_Flag__c='YES',Ethical_Leadership_Visibility_Flag__c='YES',Hydrogen_Visibility_Flag__c = 'YES',IT_Visibility_Flag__c= 'YES',Limited_Financial_Visibility_Flag__c = 'YES',People_Visibility_Flag__c ='YES',Power_Visibility_Flag__c='YES');
            lstParentToParentEntity.add(parEntity);
        }
        insert lstParentToParentEntity;
        return lstParentToParentEntity;
    }
    
    public static List<Entity__c> createParentOFParentOFParentEntity(Integer numEntity,List<Entity__c> parentEntity){
        
        List<Entity__c> lstParentToParentEntity = new List<Entity__c>();
        for(Integer i=0;i<numEntity;i++) {
            Entity__c parEntity = new Entity__c(Name='Parent Of Parent of Parent Entity' + i, Parent_Entity__c= parentEntity[i].Id,Hierarchy_Level__c='L3',Customer_Centric_Visibility_Flag__c='YES',Ethical_Leadership_Visibility_Flag__c='YES',Hydrogen_Visibility_Flag__c = 'YES',IT_Visibility_Flag__c= 'YES',Limited_Financial_Visibility_Flag__c = 'YES',People_Visibility_Flag__c ='YES',Power_Visibility_Flag__c='YES');
            lstParentToParentEntity.add(parEntity);
        }
        insert lstParentToParentEntity;
        return lstParentToParentEntity;
    }
    
    public static List<KPI__c>createKPIRec(Integer numEntity, String RecTypeName,Id entityId,String frequencyType){
        List<KPI__c> lstKpi = new LIST<KPI__c>();
        for(Integer i=0;i<numEntity;i++) {
            KPI__c objKpi = new KPI__c();
            objKpi.RecordTypeId = Schema.SObjectType.KPI__C.getRecordTypeInfosByName().get(RecTypeName).getRecordTypeId();
            objKpi.IT_Vulnerability__c=10;
            objKpi.Uptime_Service_Desk_Ticket_Per_User__c=10;
            objKpi.KPI_Date__c = date.today();
            objKpi.Total_nominations__c=5;
            objKpi.Due_Date__c = date.today();
            objKpi.Number_of_overdues__c =2;
            objKpi.Entity__c =entityId;
            objKpi.KPI_Frequency__c = frequencyType;
            lstKpi.add(objKpi);
        }
        insert lstKpi;
        return lstkpi;
        
    }
    
    public static List<KPI__c>createCustomerCentricityKPIRec(Integer numEntity, String RecTypeName,Id entityId,String frequencyType){
        List<KPI__c> lstKpi = new LIST<KPI__c>();
       	Entity__c objen = [Select Id,Name from Entity__c where id=:entityId];
        for(Integer i=0;i<numEntity;i++) {
            KPI__c objKpi = new KPI__c();
            objKpi.RecordTypeId = Schema.SObjectType.KPI__C.getRecordTypeInfosByName().get(RecTypeName).getRecordTypeId();
            objKpi.KPI_Date__c = date.today();
            objKpi.Net_customer_with_trend_B2B__c =10;
            objKpi.Net_customer_with_trend_B2C__c = 20;
            objKpi.Entity__c =entityId;
            objKpi.KPI_Frequency__c = frequencyType;
            lstKpi.add(objKpi);
        }
        insert lstKpi;
        return lstkpi;
        
    }
    
    public static List<KPI__c>createEthicalLeadershipKPIRec(Integer numEntity, String RecTypeName,Id entityId,String frequencyType){
        List<KPI__c> lstKpi = new LIST<KPI__c>();
        List<Entity__c> ls = [SELECT id,name,Customer_Centric_Visibility_Flag__c,Ethical_Leadership_Visibility_Flag__c,Hydrogen_Visibility_Flag__c,IT_Visibility_Flag__c,Limited_Financial_Visibility_Flag__c,People_Visibility_Flag__c,Power_Visibility_Flag__c from Entity__c where id=:entityId ];
        System.debug('ls:: '+ls);
        for(Integer i=0;i<numEntity;i++) {
            KPI__c objKpi = new KPI__c();
            objKpi.RecordTypeId = Schema.SObjectType.KPI__C.getRecordTypeInfosByName().get(RecTypeName).getRecordTypeId();
            objKpi.KPI_Date__c = date.today();
            objKpi.Total_nominations__c=5;
            objKpi.Due_Date__c = date.today();
            objKpi.Entity__c =entityId;
            objKpi.KPI_Frequency__c = frequencyType;
            lstKpi.add(objKpi);
        }
        insert lstKpi;
        return lstkpi;
        
    }
}