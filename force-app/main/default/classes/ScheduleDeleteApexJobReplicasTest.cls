@isTest
public class ScheduleDeleteApexJobReplicasTest{
    public static String CRON_EXP = '0 0 0 28 2 ? 2022';
    static testmethod void testScheduledJob(){
        Test.startTest();
            String jobId = System.schedule('Schedule_Delete_ApexJobReplicas_record', CRON_EXP, new Schedule_Delete_ApexJobReplicas_record());    
        Test.stopTest();
    }
}