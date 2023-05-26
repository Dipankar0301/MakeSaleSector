global class CopyApexJobDataBatch1 implements Database.Batchable<sObject> {
    
    global List<ApexJobReplica__c> listajr;
    
  global Database.QueryLocator start(Database.BatchableContext bc) {
        
        String query='Select JobId__c from ApexJobReplica__c';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<ApexJobReplica__c> records){
       
        if(records != null && !records.isEmpty())
        {
           listajr = records;  
        }
    }    
    global void finish(Database.BatchableContext bc)
    { 
        if(listajr != null && !listajr.isEmpty())
        {
        Database.executeBatch(new CopyApexJobData(listajr),2000);
        }
        else
        {
          Database.executeBatch(new CopyApexJobData(),2000);
        }
        Datetime sysTime = System.now();
        sysTime = sysTime.addHours(12);
        String chron_exp = '' + sysTime.second() + ' ' + sysTime.minute() + ' ' + sysTime.hour() + ' ' + sysTime.day() + ' ' + sysTime.month() + ' ? ' + sysTime.year();
        System.schedule('Apex Batch Job Replica',chron_exp, new CopyApexJobData1Schedulable());
    } 
}