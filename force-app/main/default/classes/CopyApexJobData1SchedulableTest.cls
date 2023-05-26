@isTest
public class CopyApexJobData1SchedulableTest{
    public static String CRON_EXP = '0 0 0 28 2 ? 2022';
    static testmethod void testScheduledJob(){
        Test.startTest();
            String jobId = System.schedule('CopyApexJobDataSchedulable', CRON_EXP, new CopyApexJobData1Schedulable());    
        Test.stopTest();
    }
}