/*****************************************************************************************************
 * Author: @Krishna V1.0
 * Description: To cover code with test data for SMT_ChartController
 * ****************************************************************************************************/
@isTest
public class SMT_ChartController_Test {
    @testSetup static void setup() {
       // Generating Test data from SMT_TestDataFactory
       SMT_System_Overview__c soList=SMT_TestDataFactory.createSystemOverview();
    }
    //To cover all the methods from getMyData method 
    public static testMethod void getMyDataTest(){
        SMT_System_Overview__c so=[select id, Total_Object_Usage__c,Apex_Code_coverage__c,Data_Storage_Usage__c from SMT_System_Overview__c limit 1];
        system.debug('==='+so);
        
        SMT_ChartController str=new SMT_ChartController();
        str.getMyData();
        str.getDataStorage();
        str.getBusinessrules();
        str.getCustomApps();
        str.getActiveSites();
        str.getPieData();
        str.getMyData();
        str.getCustomTabs();
        str.getCodeUsage();
        str.getBusinessrules();
        str.getActiveFlows();
        str.getVFPages();
    }
   
}