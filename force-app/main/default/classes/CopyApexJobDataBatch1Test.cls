@isTest
public class CopyApexJobDataBatch1Test
{
    static testMethod void testMethod1() 
    {
      ApexJobReplica__c lstAj = new ApexJobReplica__c();
        lstAj.JobId__c='7070m00000raV0kAAE';
        
        insert lstAj;
        
        Test.startTest();
            
            CopyApexJobDataBatch1 obj = new CopyApexJobDataBatch1();
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
    }
}