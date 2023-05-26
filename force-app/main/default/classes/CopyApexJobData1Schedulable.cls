global class CopyApexJobData1Schedulable implements schedulable
{
    global void execute(SchedulableContext sc)
    {
      CopyApexJobDataBatch1 b = new CopyApexJobDataBatch1(); 
      database.executebatch(b,2000);
      System.abortJob(sc.getTriggerId());
    }
}