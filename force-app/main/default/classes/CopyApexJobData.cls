global class CopyApexJobData implements Database.Batchable<sObject> {
    
    global List<ApexJobReplica__c> listaj;
    
    global CopyApexJobData() {
       
    }

    global CopyApexJobData(List<ApexJobReplica__c> lista) {
        // expose property to batch methods
        this.listaj = lista;
    }
    
    global Database.QueryLocator start(Database.BatchableContext bc) {
        List<String> s=new List<String>{'Future','Queueable','BatchApex'};
            //List<String> d=new List<String>{'CopyApexJobData','SampleBatchTest1','SampleBatchTest3','SampleBatchTest4'};
          //  List<ApexJobReplica__c> listaj=[Select JobId__c from ApexJobReplica__c];
        Set<Id> b = new Set<Id>();
        if(listaj != null && !listaj.isEmpty())
        {
            for(ApexJobReplica__c aj :listaj)
            {
                b.add(aj.JobId__c);
            }
        }
        if(!Test.isRunningTest()) 
        {
            if(listaj != null && !listaj.isEmpty())
            {
          String query='SELECT Id, Status,NumberOfErrors,JobType,JobItemsProcessed, TotalJobItems, CreatedBy.Email ,ApexClass.Name FROM AsyncApexJob where ApexClass.Name != \'CopyApexJobData\'and ApexClass.Name != \'CopyApexJobDataBatch1\'and JobType in :s and ID NOT IN :b' ;
            return Database.getQueryLocator(query);
            }
            
            else
            {
               String query='SELECT Id, Status,NumberOfErrors,JobType,JobItemsProcessed, TotalJobItems, CreatedBy.Email ,ApexClass.Name FROM AsyncApexJob where ApexClass.Name != \'CopyApexJobData\'and ApexClass.Name != \'CopyApexJobDataBatch1\'and JobType in :s' ;
            return Database.getQueryLocator(query); 
            }
        }
        
        else
        {
            String query='SELECT Id, Status,NumberOfErrors,JobType,JobItemsProcessed, TotalJobItems, CreatedBy.Email ,ApexClass.Name FROM AsyncApexJob where JobType in :s and ID NOT IN :b' ;
            return Database.getQueryLocator(query); 
        }
    }
    global void execute(Database.BatchableContext bc, List<AsyncApexJob> records){
        System.debug('test1'+records);
        
        List<ApexJobReplica__c> listajnsert = new List<ApexJobReplica__c>();
        for(AsyncApexJob lh : records){
            if(lh.ApexClass.Name !=null)
            {
                ApexJobReplica__c a = new ApexJobReplica__c();
                a.JobId__c=lh.Id;
                a.Status__c=lh.Status;
                a.AJ_Number_of_Errors__c=lh.NumberOfErrors;	
                a.AJ_JobType__c=lh.JobType;
                a.AJ_JobItemProcessed__c=lh.JobItemsProcessed;
                a.AJ_TotalJobItems__c=lh.TotalJobItems;
                a.AJ_CreatedBy__c=lh.CreatedBy.Email;
                a.AJ_ApexClassName__c=lh.ApexClass.Name;
                a.AJ_Date__c=Date.Today();
                listajnsert.add(a);
            }
        }
        insert listajnsert;
    } 
    
    global void finish(Database.BatchableContext bc)
    { 
       
        
    }    
}