/***************************************************************************************
 * Author and Version:@ Krishna V1.0
 * Application: System Monitoring tool
 * Description: To return a system overview object test data
 * **************************************************************************************/
public class SMT_TestDataFactory {
     public static SMT_System_Overview__c createSystemOverview(){
            Integer i2 = Integer.valueOf('45');
            SMT_System_Overview__c so=new SMT_System_Overview__c(); 
            so.name='System Overview';
            so.Total_Object_Usage__c=i2;
            so.Apex_Code_coverage__c=70;
            so.Data_Storage_Limit__c=decimal.valueOf(200);
            so.Max_Total_Objects__c=50;
            so.Data_Storage_Usage__c=512.00;
            so.Maximum_Storage__c=200;
            so.Business_Rules__c=5;
            so.Maximum_Business_Rules__c=200;
            so.Trigger_Usage__c=20;
            so.Apex_usage__c=10;
            so.Apex_Code_Used_Chars__c=200;
            so.Custom_Apps__c=10;
            so.Maximum_Custom_Apps__c=21;
            so.Active_Salesforce_SItes__c=2;
            so.Maximum_Salesforce_Sites__c=10;
            so.Active_Flows__c=2;
            so.Maximum_Flows__c=20;
            so.Custom_Tabs__c=2;
            so.Maximum_Custom_Tabs__c=10;
            so.Visualforce_Pages__c=10;
            so.Apex_Classes__c=1;
            so.Apex_Code_Used_max_chars__c=100;
            insert so;
        	return so;
    }
}