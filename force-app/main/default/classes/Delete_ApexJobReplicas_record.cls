global class Delete_ApexJobReplicas_record implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext bc) {
        
        String query='Select Id from ApexJobReplica__c';
        return Database.getQueryLocator(query);
    }
    global void execute(Database.BatchableContext bc, List<ApexJobReplica__c> records){
       
       delete records;      
    }    
    global void finish(Database.BatchableContext bc)
    { 
      
    }    
}