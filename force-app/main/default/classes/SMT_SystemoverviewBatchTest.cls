/***********************************************************************************************************
 * Author: @Krishna V1.0
 * Description: This class helps to code coverage for SMT_SystemoverviewBatch, SMT_AutomatedTestJobQueuer
 *  			and SMT_SystemOverviewSchedule classes
 * *********************************************************************************************************/
@isTest
public class SMT_SystemoverviewBatchTest {

    static testMethod void test() 
    {
        List<SMT_System_Overview__c> soList = new List<SMT_System_Overview__c>();
        for(Integer i = 0 ; i < 200; i++)
        {
            SMT_System_Overview__c so = new SMT_System_Overview__c();
            so.Name='System Overview';
            so.Active__c = true;
            soList.add(so);
        }
        Insert soList;
        String CRON_EXP = '0 5 * * * ?';
		Test.startTest();
        	//To test SMT_SystemOverviewBatch class
            SMT_SystemOverviewBatch obj = new SMT_SystemOverviewBatch();
            DataBase.executeBatch(obj); 
            //To test SMT_SystemOverviewSchedule class
            String jobId = System.schedule('Update System overview records', CRON_EXP, new SMT_SystemOverviewSchedule());
            //To test SMT_AutomatedTestJobQueuer class
            String job = System.schedule('Update System overview', CRON_EXP, new SMT_AutomatedTestJobQueuer());
		Test.stopTest();
        
		//Verify records updated
		List<SMT_System_Overview__c> accUpdatedList = [SELECT Id, Name FROM SMT_System_Overview__c];
		System.assert(accUpdatedList[0].Name.Contains('System Overview'));
    }
}