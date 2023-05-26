@isTest
public class Delete_ApexJobReplicas_recordTest
{
    static testMethod void testMethod1() 
    {
      ApexJobReplica__c lstAj = new ApexJobReplica__c();
        lstAj.JobId__c='7070m00000raV0kAAE';
        
        insert lstAj;
        
        Test.startTest();
            
            Delete_ApexJobReplicas_record obj = new Delete_ApexJobReplicas_record();
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
    }
}