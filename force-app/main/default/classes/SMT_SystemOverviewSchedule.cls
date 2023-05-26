global class SMT_SystemOverviewSchedule implements Schedulable {
    global void execute(SchedulableContext sc) {
        SMT_SystemOverviewBatch b = new SMT_SystemOverviewBatch(); 
        database.executebatch(b);
    }
}