global class Schedule_Delete_ApexJobReplicas_record implements schedulable
{
    global void execute(SchedulableContext sc)
    {
      Delete_ApexJobReplicas_record b = new Delete_ApexJobReplicas_record(); 
      database.executebatch(b,2000);
      //System.abortJob(sc.getTriggerId());
    }
}