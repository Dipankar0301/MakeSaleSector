@isTest(seeAllData = false)
public class nepm_SalesPath_PopupTest {    
    static testMethod void NEPM_SalesPath_PopupTest() {
    
     String recTypeId = Schema.SObjectType.NEPM_Project__c.getRecordTypeInfosByDeveloperName().get('Nature_Based_Solutions').getRecordTypeId();
        
        GAL__c g = new GAL__c();
        g.Name = 'testuser';
        g.Email__c = 'test@shell.com';
        insert g;
        
        NEPM_Project__c p = new NEPM_Project__c();
        p.Name = 'Nature Based Solutions';
        p.RecordTypeId = recTypeId;
        p.NEPM_Stage__c ='Assess (post PCI)';
        p.NEPM_Status__c ='Active';
        //p.NEPM_BOM__c = UserInfo.getUserId();
        p.NEPM_BOM_GAL__c = g.id;
        insert p;
        
        NEPM_Project__c p1 = new NEPM_Project__c();
        p1.Name = 'Nature Based Solutions1';
        p1.RecordTypeId = recTypeId;
        p1.NEPM_Stage__c ='Operate';
        p1.NEPM_Status__c ='Active';
        insert p1;
        
        Financial__c f = new Financial__c();
        f.Project__c = p.Id;
        f.NE_CAPEX__c = 20;
        f.FEASEX_M__c = 25;
        f.Non_NE_CAPEX_M__c = 30;
        f.Year__c = 2015;
        insert f;
        
      
        
        List<Financial__c> financeList = new List<Financial__c>();
        financeList.add(f);
        
        NEPM_SalesPath_Popup.validateApporvals(p.Id,p.NEPM_Stage__c);
        NEPM_SalesPath_Popup.validateApporvals(p1.Id,p1.NEPM_Stage__c);
        NEPM_SalesPath_Popup.updateDeliverable(p.Id,p.NEPM_Stage__c,true,true);
        NEPM_SalesPath_Popup.updateDeliverable(p.Id,p.NEPM_Stage__c,false,false);
        NEPM_SalesPath_Popup.updateDeliverable(p1.Id,p1.NEPM_Stage__c,true,true);
        NEPM_SalesPath_Popup.updateDeliverable(p1.Id,p1.NEPM_Stage__c,false,false);


    }
    static testMethod void NEPM_SalesPath_PopupTest2() {
    
     String recTypeId = Schema.SObjectType.NEPM_Project__c.getRecordTypeInfosByDeveloperName().get('Nature_Based_Solutions').getRecordTypeId();
        
        GAL__c g = new GAL__c();
        g.Name = 'testuser';
        g.Email__c = 'test@shell.com';
        insert g;
        
        NEPM_Project__c p = new NEPM_Project__c();
        p.Name = 'Nature Based Solutions';
        p.RecordTypeId = recTypeId;
        p.NEPM_Stage__c ='Execute (post GIP)';
        p.NEPM_Status__c ='Active';
        //p.NEPM_BOM__c = UserInfo.getUserId();
        p.NEPM_BOM_GAL__c = g.id;
        insert p;
        
         NEPM_Project__c p1 = new NEPM_Project__c();
        p1.Name = 'City Solutions';
        p1.RecordTypeId = recTypeId;
        p1.NEPM_Stage__c ='Operate';
        p1.NEPM_Status__c ='Active';
        insert p1;
        
        Financial__c f = new Financial__c();
        f.Project__c = p.Id;
        f.NE_CAPEX__c = 20;
        f.FEASEX_M__c = 25;
        f.Non_NE_CAPEX_M__c = 30;
        f.Year__c = 2015;
        insert f;
        
      
        
        List<Financial__c> financeList = new List<Financial__c>();
        financeList.add(f);
        
        NEPM_SalesPath_Popup.validateApporvals(p.Id,p.NEPM_Stage__c);
        NEPM_SalesPath_Popup.validateApporvals(p1.Id,p1.NEPM_Stage__c);
        NEPM_SalesPath_Popup.updateDeliverable(p.Id,p.NEPM_Stage__c,true,true);
        NEPM_SalesPath_Popup.updateDeliverable(p.Id,p.NEPM_Stage__c,false,false);
        NEPM_SalesPath_Popup.updateDeliverable(p1.Id,p1.NEPM_Stage__c,true,true);
        NEPM_SalesPath_Popup.updateDeliverable(p1.Id,p1.NEPM_Stage__c,false,false);


    }
    static testMethod void NEPM_SalesPath_PopupTest3() {
    
     String recTypeId = Schema.SObjectType.NEPM_Project__c.getRecordTypeInfosByDeveloperName().get('Nature_Based_Solutions').getRecordTypeId();
        
        GAL__c g = new GAL__c();
        g.Name = 'testuser';
        g.Email__c = 'test@shell.com';
        insert g;
        
        NEPM_Project__c p = new NEPM_Project__c();
        p.Name = 'Nature Based Solutions';
        p.RecordTypeId = recTypeId;
        p.NEPM_Stage__c ='Assess (post PCI)';
        p.NEPM_Status__c ='Active';
        //p.NEPM_BOM__c = UserInfo.getUserId();
        p.NEPM_BOM_GAL__c = g.id;
        insert p;
        
         NEPM_Project__c p1 = new NEPM_Project__c();
        p1.Name = 'City Solutions';
        p1.RecordTypeId = recTypeId;
        p1.NEPM_Stage__c ='Operate';
        p1.NEPM_Status__c ='Active';
        insert p1;
        
        Financial__c f = new Financial__c();
        f.Project__c = p.Id;
        f.NE_CAPEX__c = 20;
        f.FEASEX_M__c = 25;
        f.Non_NE_CAPEX_M__c = 30;
        f.Year__c = 2015;
        insert f;
        
      
        
        List<Financial__c> financeList = new List<Financial__c>();
        financeList.add(f);
        
        NEPM_SalesPath_Popup.validateApporvals(p.Id,p.NEPM_Stage__c);
        NEPM_SalesPath_Popup.validateApporvals(p1.Id,p1.NEPM_Stage__c);
        NEPM_SalesPath_Popup.updateDeliverable(p.Id,p.NEPM_Stage__c,true,true);
        NEPM_SalesPath_Popup.updateDeliverable(p.Id,p.NEPM_Stage__c,false,false);
        NEPM_SalesPath_Popup.updateDeliverable(p1.Id,p1.NEPM_Stage__c,true,true);
        NEPM_SalesPath_Popup.updateDeliverable(p1.Id,p1.NEPM_Stage__c,false,false);


    }
     static testMethod void NEPM_SalesPath_PopupTest4() {
    
     String recTypeId = Schema.SObjectType.NEPM_Project__c.getRecordTypeInfosByDeveloperName().get('Nature_Based_Solutions').getRecordTypeId();
        GAL__c g = new GAL__c();
        g.Name = 'testuser';
        g.Email__c = 'test@shell.com';
        insert g;
         
        NEPM_Project__c p = new NEPM_Project__c();
        p.Name = 'Corporate';
        p.RecordTypeId = recTypeId;
        p.NEPM_Stage__c ='Execute (post GIP)';
        p.NEPM_Status__c ='Active';
        p.NEPM_BOM_GAL__c = g.id;
        p.Approval_makes_Project_Read_Only__c = false;
        insert p;
        
        NEPM_Project__c p1 = new NEPM_Project__c();
        p1.Name = 'City Solutions';
        p1.RecordTypeId = recTypeId;
        p1.NEPM_Stage__c ='Operate';
        p1.NEPM_Status__c ='Active';
        p1.Approval_makes_Project_Read_Only__c = false;
        insert p1;
        
        Financial__c f = new Financial__c();
        f.Project__c = p.Id;
        f.NE_CAPEX__c = 20;
        f.FEASEX_M__c = 25;
        f.Non_NE_CAPEX_M__c = 30;
        f.Year__c = 2015;
        insert f;
        
      
        
        List<Financial__c> financeList = new List<Financial__c>();
        financeList.add(f);
        
        NEPM_SalesPath_Popup.checkRecordLock(p.Id);
 
    }
    static testMethod void NEPM_SalesPath_PopupTest5() {
    
     String recTypeId = Schema.SObjectType.NEPM_Project__c.getRecordTypeInfosByDeveloperName().get('Nature_Based_Solutions').getRecordTypeId();
        
        GAL__c g = new GAL__c();
        g.Name = 'testuser';
        g.Email__c = 'test@shell.com';
        insert g;
        
        NEPM_Project__c p = new NEPM_Project__c();
        p.Name = 'Corporate';
        p.RecordTypeId = recTypeId;
        p.NEPM_Stage__c ='Assess (post PCI)';
        p.NEPM_Status__c ='Active';
        p.Approval_makes_Project_Read_Only__c = false;
        p.NEPM_BOM_GAL__c = g.id;
        insert p;
        
         NEPM_Project__c p1 = new NEPM_Project__c();
        p1.Name = 'City Solutions';
        p1.RecordTypeId = recTypeId;
        p1.NEPM_Stage__c ='Operate';
        p1.Approval_makes_Project_Read_Only__c = false;
        p1.NEPM_Status__c ='Active';
        insert p1;
        
        Financial__c f = new Financial__c();
        f.Project__c = p.Id;
        f.NE_CAPEX__c = 20;
        f.FEASEX_M__c = 25;
        f.Non_NE_CAPEX_M__c = 30;
        f.Year__c = 2015;
        insert f;
        
      
        
        List<Financial__c> financeList = new List<Financial__c>();
        financeList.add(f);
        
        NEPM_SalesPath_Popup.checkRecordLock(p.Id);
 
    }

}