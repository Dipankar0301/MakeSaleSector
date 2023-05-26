global with sharing class SMT_AutomatedTestJobQueuer implements schedulable {
    
    global void execute(SchedulableContext SC) {
        doExecute();
    }
    
    @future (callout=true)
    public static void doExecute(){ 
        //enqueueUnitTests();
        List<ApexTestQueueItem> testQueueItems = new List<ApexTestQueueItem>();
    	List<ApexClass> unitTestClasses = [SELECT Id, Name FROM ApexClass WHERE Name like '%Test%'];
         	  
        for(ApexClass unitTestClass : unitTestClasses){
            testQueueItems.add(new ApexTestQueueItem(ApexClassId = unitTestClass.Id));
   		}
        
    	if (!Test.isRunningTest()) {
   			insert testQueueItems;
        }
    }
}