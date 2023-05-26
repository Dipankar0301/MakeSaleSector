@isTest
public class addDeleteControllerTest {    
    static testMethod void addDeleteControllerTest() {
    
     String recTypeId = Schema.SObjectType.NEPM_Project__c.getRecordTypeInfosByDeveloperName().get('Corporate').getRecordTypeId();
        
        GAL__c g = new GAL__c();
        g.Name = 'testuser';
        g.Email__c = 'test@shell.com';
        insert g;
        
        NEPM_Project__c p = new NEPM_Project__c();
        p.Name = 'Corporate';
        p.RecordTypeId = recTypeId;
        p.NEPM_Stage__c ='Assess (post PCI)';
        p.NEPM_Status__c ='Active';
        p.NEPM_BOM_GAL__c = g.id;
        insert p;
        
        
        Financial__c f = new Financial__c();
        f.Project__c = p.Id;
        f.NE_CAPEX__c = 20;
        f.FEASEX_M__c = 25;
        f.Non_NE_CAPEX_M__c = 30;
        f.Year__c = 2015;
        insert f;
        
        List<Financial__c> financeList = new List<Financial__c>();
        financeList.add(f);
        
        addDeleteController.saveContacts(financeList,p.Id);
        addDeleteController.findFinancials(p.Id);
        addDeleteController.deleteFinancials(f.Id);
        addDeleteController.checkforRecordtypeName(p.Id);

    }
    static testMethod void addDeleteControllerTest2() {
    
     String recTypeId = Schema.SObjectType.NEPM_Project__c.getRecordTypeInfosByDeveloperName().get('Global_Customer_Solutions').getRecordTypeId();
        
        GAL__c g = new GAL__c();
        g.Name = 'testuser';
        g.Email__c = 'test@shell.com';
        insert g;
        
        NEPM_Project__c p = new NEPM_Project__c();
        p.Name = 'Corporate';
        p.RecordTypeId = recTypeId;
        p.NEPM_Stage__c ='Assess (post PCI)';
        p.NEPM_Status__c ='Active';
        p.NEPM_BOM_GAL__c = g.id;
        p.Approval_makes_Project_Read_Only__c = false;
        insert p;
        
        
        Financial__c f = new Financial__c();
        f.Project__c = p.Id;
        f.NE_CAPEX__c = 20;
        f.FEASEX_M__c = 25;
        f.Non_NE_CAPEX_M__c = 30;
        f.Year__c = 2015;
        insert f;
        
        List<Financial__c> financeList = new List<Financial__c>();
        financeList.add(f);
        
        addDeleteController.saveContacts(financeList,p.Id);
        addDeleteController.findFinancials(p.Id);
        addDeleteController.deleteFinancials(f.Id);
        addDeleteController.CheckforApproval(p.Id);
        addDeleteController.checkforRecordtypeName(p.Id);

    }

}