global class SMT_SystemOverviewBatch implements Database.Batchable<sObject>,Database.AllowsCallouts {
    global Database.QueryLocator start(Database.BatchableContext BC) {
        // collect the batches of records or objects to be passed to execute
        String query = 'SELECT Id, Name,Active__c from SMT_System_Overview__c';
        return Database.getQueryLocator(query);
    }
     
    global void execute(Database.BatchableContext BC, List<SMT_System_Overview__c> soList) {
        system.debug('----'+soList);
        
        /*SMT_TestUtilCls cst=new SMT_TestUtilCls();
        cst.testclasses();*/
        
        if(soList.size()>0){
            // process each batch of records default size is 200
            for(SMT_System_Overview__c so : soList) {
                system.debug('==='+so.name);
                if(so.name=='System Overview'){
                    so.Active__c =true;
                }
                
            } 
            update soList;
            //Database.SaveResult[] updateResults = Database.update(soList, false);
            system.debug('@@@@'+soList);
        }       
        
    }   
     
    global void finish(Database.BatchableContext BC) {
        // Use the
      AsyncApexJob a = [Select a.TotalJobItems, a.Status, a.NumberOfErrors,
      a.JobType, a.JobItemsProcessed, a.ExtendedStatus, a.CreatedById,
      a.CompletedDate From AsyncApexJob a WHERE id = :BC.getJobId()];
      system.debug('==='+a.Status);
        if(a.status=='Completed'){
             SMT_OverviewCls assT=new SMT_OverviewCls();
             assT.getSMTOverview();
        }
    }
}