@isTest
Public class NEPM_ProjectTriggerClassTest{

    
    @testSetup static void setup() {
             
     String recTypeId = Schema.SObjectType.NEPM_Project__c.getRecordTypeInfosByDeveloperName().get('Nature_Based_Solutions').getRecordTypeId();
        
        GAL__c g = new GAL__c();
        g.Name = 'testuser';
        g.Email__c = 'test@shell.com';
        insert g;
        
        NEPM_Project__c p = new NEPM_Project__c();
        p.Name = 'Nature Based Solutions';
        p.RecordTypeId = recTypeId;
        p.NEPM_Stage__c ='Assess (post PCI)';
        p.NEPM_Technology_Lead_GAL__c = g.id;
        p.NEPM_BOM_GAL__c = g.id;
        p.NEPM_Status__c ='Active';
        p.Mandate_Strategy__c='M&A';
        insert p;
        
        String recTypeId1 = Schema.SObjectType.NEPM_Project__c.getRecordTypeInfosByDeveloperName().get('Offshore_Wind').getRecordTypeId();
        
        NEPM_Project__c p1 = new NEPM_Project__c();
        p1.Name = 'Offshore Wind';
        p1.RecordTypeId = recTypeId1 ;
        p1.NEPM_Stage__c ='Operate';
        //p1.NEPM_BOM__c = UserInfo.getUserId();
        p1.NEPM_Decision_Executive_GAL__c = g.id;
        p1.NEPM_BOM_GAL__c = g.id;
        p1.NEPM_Status__c ='Active';
        insert p1;
        
        String recTypeId2 = Schema.SObjectType.NEPM_Project__c.getRecordTypeInfosByDeveloperName().get('Onshore_Power').getRecordTypeId();
        
        NEPM_Project__c p2 = new NEPM_Project__c();
        p2.Name = 'Onshore renewable power';
        p2.RecordTypeId = recTypeId2 ;
        p2.NEPM_Stage__c ='Operate';
        p2.NEPM_Commercial_Lead_GAL__c = g.id;
        p2.NEPM_BOM_GAL__c = g.id;
        p2.NEPM_Status__c ='Active';
        insert p2;
        
        
        Financial__c f = new Financial__c();
        f.Project__c = p.Id;
        f.NE_CAPEX__c = 20;
        f.FEASEX_M__c = 25;
        f.Non_NE_CAPEX_M__c = 30;
        f.Year__c = 2015;
        insert f;
        
      
        
        List<Financial__c> financeList = new List<Financial__c>();
        financeList.add(f);
    }
    
    static testMethod void updateNEPM_ProjectTriggerClassTest() {
      
        NEPM_Project__c pro = [SELECT Id,NEPM_Status__c,Enter_Status_change_comments__c FROM NEPM_Project__c WHERE Name='Nature Based Solutions' LIMIT 1];
        
        NEPM_Project__c ne = new NEPM_Project__c();
        ne.NEPM_Status__c = 'Cancelled';
        ne.Enter_Status_change_comments__c='test';
        ne.id = pro.id;
        update ne;   
    }
    static testMethod void updateNEPM_ProjectTriggerClassTest1() {
      
        NEPM_Project__c pro = [SELECT Id,NEPM_Status__c,NEPM_BOM_GAL__c,Enter_Status_change_comments__c FROM NEPM_Project__c WHERE Name='Nature Based Solutions' LIMIT 1];
        
        GAL__c g = new GAL__c();
        g.Name = 'testuser';
        g.Email__c = 'test1@shell0.com';
        insert g;
        
        NEPM_Project__c ne = new NEPM_Project__c();
        ne.NEPM_BOM_GAL__c  = g.id;
        ne.NEPM_Status__c = 'Cancelled';
        ne.Enter_Status_change_comments__c='test';
        ne.id = pro.id;
        update ne;   
    }
    static testMethod void updateNEPM_ProjectTriggerClassTest2() {
      
        NEPM_Project__c pro = [SELECT Id,NEPM_Status__c,NEPM_BOM_GAL__c,NEPM_Decision_Executive_GAL__c,Enter_Status_change_comments__c FROM NEPM_Project__c WHERE Name='Offshore Wind' LIMIT 1];
        
        
        NEPM_Project__c ne = new NEPM_Project__c();
        ne.NEPM_Status__c = 'Cancelled';
        ne.Enter_Status_change_comments__c='test';
        ne.NEPM_Decision_Executive_GAL__c = null;
        ne.id = pro.id;
        update ne;   
    }
    static testMethod void updateNEPM_ProjectTriggerClassTest3() {
      
        NEPM_Project__c pro = [SELECT Id,NEPM_Status__c,NEPM_BOM_GAL__c,NEPM_Decision_Executive_GAL__c,Enter_Status_change_comments__c FROM NEPM_Project__c WHERE Name='Onshore renewable power' LIMIT 1];
        
        
        NEPM_Project__c ne = new NEPM_Project__c();
        ne.NEPM_Status__c = 'Cancelled';
        ne.Enter_Status_change_comments__c='test';
        ne.NEPM_Commercial_Lead_GAL__c = null;
        ne.id = pro.id;
        update ne;
        
         
    }
     static testMethod void updateNEPM_ProjectTriggerClassTest4() {
      
        NEPM_Project__c pro = [SELECT Id,NEPM_Status__c,NEPM_BOM_GAL__c,NEPM_Decision_Executive_GAL__c,Enter_Status_change_comments__c FROM NEPM_Project__c WHERE Name='Nature Based Solutions' LIMIT 1];
        
        
        NEPM_Project__c ne = new NEPM_Project__c();
        ne.NEPM_Status__c = 'Cancelled';
        ne.Enter_Status_change_comments__c='test';
        ne.NEPM_Technology_Lead_GAL__c = null;
        ne.id = pro.id;
        update ne;   
    }
     static testMethod void updateNEPM_ProjectTriggerClassTest5() {
      
        NEPM_Project__c pro = [SELECT Id,NEPM_Status__c,NEPM_BOM_GAL__c,NEPM_Decision_Executive_GAL__c,Enter_Status_change_comments__c FROM NEPM_Project__c WHERE Name='Onshore renewable power' LIMIT 1];
        
        GAL__c g = new GAL__c();
        g.Name = 'testuser';
        g.Email__c = 'test@shell1.com';
        insert g;
        
        NEPM_Project__c ne = new NEPM_Project__c();
        ne.NEPM_Status__c = 'Cancelled';
        ne.Enter_Status_change_comments__c='test';
        ne.NEPM_Commercial_Lead_GAL__c = g.id;
        ne.id = pro.id;
        update ne;   
    }
    
}