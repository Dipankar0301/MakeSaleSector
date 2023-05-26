/**************************************************************************************************
 * Author: @Krishna V1.0
 * Description: To cover code with test data for SMT_OverviewCls
****************************************************************************************************/
@isTest
public class SMT_OverviewCls_Test {
	@testSetup static void setup() {
       // Generating Test data from SMT_TestDataFactory
       SMT_System_Overview__c soList=SMT_TestDataFactory.createSystemOverview();
    }
    //To cover positive case of getSMTOverview method
    public static testMethod void SMT_OverviewClsPositivecase(){
        SMT_System_Overview__c so=[select id, Total_Object_Usage__c,Apex_Code_coverage__c,Data_Storage_Usage__c,Business_Rules__c from SMT_System_Overview__c limit 1];
        system.debug('==='+so.Total_Object_Usage__c);
        
        test.startTest();
        	SMT_OverviewCls str=new SMT_OverviewCls();
            //str.st.Total_Object_Usage__c=integer.valueOf(so.Total_Object_Usage__c);
            str.getSMTOverview();
        test.stopTest();
    }
    
     //To cover positive case of getSMTOverview method
     public static testMethod void SMT_OverviewCls_elseTest(){
        SMT_System_Overview__c so=[select id, Total_Object_Usage__c,Apex_Code_coverage__c,Data_Storage_Usage__c,Business_Rules__c from SMT_System_Overview__c limit 1];
        system.debug('==='+so);
        so.name='sys overview';
        update so;
        test.startTest();
        
        SMT_OverviewCls str=new SMT_OverviewCls();
        pagereference pg = page.SMT_SystemOverviewPage;
        //pg.getparameters().put(so.Total_Object_Usage__c,2.00);
        //pg.getparameters().put('uid',string.valueOf(b.id));
        test.setcurrentpage(pg);
        	str.getSMTOverview();
        test.stopTest();
    }
}