@istest
class SMT_UserLicenseBatchTestClass{
    public static testMethod void testschedule() {
        Test.StartTest();
        SMT_UserLicenseBatchClass testbatch = new SMT_UserLicenseBatchClass();
        Database.executeBatch(testbatch);
        Test.stopTest();
    }
}