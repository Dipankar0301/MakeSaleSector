@isTest(seeAllData = true)
    public class NEPM_Deliverable_ControllerTest {    
        static testMethod void NEPM_Deliverable_ControllerTest () {
        
         String recTypeId = Schema.SObjectType.NEPM_Project__c.getRecordTypeInfosByDeveloperName().get('Corporate').getRecordTypeId();
            
            NEPM_Project__c p = new NEPM_Project__c();
            p.Name = 'Corporate 333';
            p.RecordTypeId = recTypeId;
            p.NEPM_Stage__c ='Identify';
            p.NEPM_Status__c ='Active';
             p.NEPM_BOM__c=UserInfo.getUserId() ;
            p.NEPM_Decision_Executive__c=UserInfo.getUserId() ;
            insert p;
            
             NEPM_Project__c p1 = new NEPM_Project__c();
            p1.Name = 'City Solutions 333';
            p1.RecordTypeId = recTypeId;
            p1.NEPM_Stage__c ='Operate';
            p1.NEPM_Status__c ='Active';
             p1.NEPM_BOM__c=UserInfo.getUserId() ;
            p1.NEPM_Decision_Executive__c=UserInfo.getUserId() ;
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
            
           
            
             try{
                Test.StartTest();
                 NEPM_Deliverable__c  nepmDel = [SELECT id from NEPM_Deliverable__c  WHERE Project__c =:p.id and NEPM_Deliverable_Type__c ='PCI' LIMIT 1];
                      
                    ApexPages.currentPage().getParameters().put('id', nepmDel.Id);
                    ApexPages.StandardController sc = new ApexPages.standardController(nepmDel);

                     NEPM_Deliverable_Controller nepmObj = new NEPM_Deliverable_Controller (sc);
                     
                     p.NEPM_Stage__c ='Assess (post PCI)';
                      nepmObj.checkProjectDetails();
                    nepmObj.SaveProject();
                    nepmObj.submitRecordForApproval();
                   
                    
                Test.StopTest();
            }catch(Exception eObject){
                system.debug('eObject'+eObject);
            } 

        }
        
         static testMethod void NEPM_Deliverable_ControllerTest2 () {
        
         String recTypeId = Schema.SObjectType.NEPM_Project__c.getRecordTypeInfosByDeveloperName().get('Corporate').getRecordTypeId();
            
            NEPM_Project__c p = new NEPM_Project__c();
            p.Name = 'Corporate 3333';
            p.RecordTypeId = recTypeId;
            p.NEPM_Stage__c ='Identify';
            p.NEPM_Status__c ='Active';
            p.NEPM_Region__c='Global';
            p.NEPM_Project_Description__c ='test';
            p.NEPM_Headline_Size_M_USD__c=1000;
            p.NEPM_BOM__c=UserInfo.getUserId() ;
            p.NEPM_Decision_Executive__c=UserInfo.getUserId() ;
            p.NEPM_Shell_Equity_Share__c=10;
            p.Mandate_Strategy__c='M&A';
            p.NEPM_Technology__c='Other';
            insert p;
            
            NEPM_Project__c p1 = new NEPM_Project__c();
            p1.Name = 'City Solutions 3333';
            p1.RecordTypeId = recTypeId;
            p1.NEPM_Stage__c ='Operate';
            p1.NEPM_Status__c ='Active';
            p1.NEPM_BOM__c=UserInfo.getUserId() ;
            p1.NEPM_Decision_Executive__c=UserInfo.getUserId() ;
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
            
           
            
             try{
                Test.StartTest();
                 NEPM_Deliverable__c  nepmDel = [SELECT id from NEPM_Deliverable__c  WHERE Project__c =:p.id and NEPM_Deliverable_Type__c ='PCN' LIMIT 1];
                      
                    ApexPages.currentPage().getParameters().put('id', nepmDel.Id);
                    ApexPages.StandardController sc = new ApexPages.standardController(nepmDel);

                     NEPM_Deliverable_Controller nepmObj = new NEPM_Deliverable_Controller (sc);
                     
                     p.NEPM_Stage__c ='Assess (post PCI)';
                      nepmObj.checkProjectDetails();
                    nepmObj.SaveProject();
                    nepmObj.submitRecordForApproval();
                    
                    
                    NEPM_Deliverable__c  nepmDel2 = [SELECT id from NEPM_Deliverable__c  WHERE Project__c =:p.id and NEPM_Deliverable_Type__c ='PCI' LIMIT 1];
                      nepmDel2.NEPM_Approved__c = TRUE;
                      update nepmDel2;
                      
                    ApexPages.currentPage().getParameters().put('id', nepmDel2.Id);
                    ApexPages.StandardController sc2 = new ApexPages.standardController(nepmDel2);

                     NEPM_Deliverable_Controller nepmObj2 = new NEPM_Deliverable_Controller (sc2);
                     
                     p.NEPM_Stage__c ='Assess (post PCI)';
                     nepmobj2.checkProjectDetails();
                    nepmObj2.SaveProject();
                    nepmObj2.submitRecordForApproval();
                    
                    
                Test.StopTest();
            }catch(Exception eObject){
                system.debug('eObject'+eObject);
            } 

        }
        
         static testMethod void NEPM_Deliverable_ControllerTest3 () {
        
         String recTypeId = Schema.SObjectType.NEPM_Project__c.getRecordTypeInfosByDeveloperName().get('Global_Customer_Solutions').getRecordTypeId();
            
            GAL__c g = new GAL__c();
            g.Name = 'testuser';
            g.Email__c = 'testuser@shell.com';
            insert g;
            NEPM_Project__c p = new NEPM_Project__c();
            p.Name = 'Corporate 4444';
            p.RecordTypeId = recTypeId;
            p.NEPM_Stage__c ='Identify';
            p.NEPM_Region__c='Global';
            p.NEPM_Status__c ='Active';
            p.NEPM_Project_Description__c ='test';
            p.NEPM_Headline_Size_M_USD__c=1000;
            p.NEPM_BOM__c=UserInfo.getUserId();
            p.NEPM_BOM_GAL__c = g.id;
            p.NEPM_Decision_Executive__c=UserInfo.getUserId() ;
            p.NEPM_Shell_Equity_Share__c=10;
            p.NEPM_Technology__c='Other';
            p.Mandate_Strategy__c='M&A';
            insert p;
            
             NEPM_Project__c p1 = new NEPM_Project__c();
            p1.Name = 'City Solutions 4444';
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
            
            NEPM_Deliverable__c  nepmDel3 = [SELECT id from NEPM_Deliverable__c  WHERE Project__c =:p.id AND NEPM_Deliverable_Type__c ='PCI' LIMIT 1];
            nepmDel3.NEPM_Approved__c = true;
            update nepmDel3;
          
            
            List<Financial__c> financeList = new List<Financial__c>();
            financeList.add(f);
            
           
            
             try{
                Test.StartTest();                
                
                    ApexPages.currentPage().getParameters().put('id', nepmDel3.Id);
                    ApexPages.StandardController sc3 = new ApexPages.standardController(nepmDel3);
                   
                     NEPM_Deliverable_Controller nepmObj2 = new NEPM_Deliverable_Controller (sc3);
                     
                    p.NEPM_Stage__c ='Assess (post PCI)';
                    nepmobj2.checkProjectDetails();
                    nepmObj2.SaveProject();
                    nepmObj2.submitRecordForApproval();
                  
                    
                Test.StopTest();
            }catch(Exception eObject){
                system.debug('eObject'+eObject);
            }

        }

    }