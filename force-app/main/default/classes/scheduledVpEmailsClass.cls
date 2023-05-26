global class scheduledVpEmailsClass implements Schedulable {
   global void execute(SchedulableContext sc) {
      ScheduleEmailsToVPs vp = new ScheduleEmailsToVPs();
          database.executebatch(vp);
   }
}