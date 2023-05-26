@isTest
public class CopyApexJobDataTest
{
    static testMethod void testMethod1() 
    {
      ApexJobReplica__c lstAj1 = new ApexJobReplica__c();
        lstAj1.JobId__c='7070m00000raV0kAAE';
        
        insert lstAj1;
        
        List<ApexJobReplica__c> listaj = new List<ApexJobReplica__c>();
        listaj.add(lstAj1);
        
        Test.startTest();
            
            CopyApexJobData obj = new CopyApexJobData();
            CopyApexJobData obj1 = new CopyApexJobData(listaj);
            DataBase.executeBatch(obj); 
             DataBase.executeBatch(obj1); 
        Test.stopTest();
    }
}