global class SMT_UserLicenseScheduleClass implements Schedulable{
    global void execute(SchedulableContext SC){
        SMT_UserLicenseBatchClass batch = new SMT_UserLicenseBatchClass();
        database.executebatch(batch);
    }
}