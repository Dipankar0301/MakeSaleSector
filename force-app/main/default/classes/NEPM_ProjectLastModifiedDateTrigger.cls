public with sharing class NEPM_ProjectLastModifiedDateTrigger{

 public static void updateProjectsLastModifiedDate(set<id> projectSet){
     try{
         List<NEPM_Project__c > updateProList = new List<NEPM_Project__c >();
         for(NEPM_Project__c pro : [Select id,name,NEPM_VP_Ship__c,Last_Updated_Child_Records_Date__c From NEPM_Project__c WHERE NEPM_VP_Ship__c != 'DSAD' AND ID IN:projectSet]){
                
                 NEPM_Project__c p = new NEPM_Project__c();
                 p.id = pro.id;
                 p.Last_Updated_Child_Records_Date__c = System.now();
                 updateProList.add(p);
            } 
            if(updateProList.size()>0){
                
                update updateProList;
            }
        }
         catch(Exception e){
            system.debug('Error while updating LastModifiedDateOnProject'+ e);            
        }
   }
}