@istest
class SMT_UserLicenseScheduleTestClass{
    public static testMethod void testschedule() {
        Test.StartTest();
        SMT_UserLicenseScheduleClass testsche = new SMT_UserLicenseScheduleClass();
        String sch = '0 0 23 * * ?';
        system.schedule('Test status Check', sch, testsche );
        Test.stopTest();
    }
}