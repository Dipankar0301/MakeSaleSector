global class SMT_UserLicenseBatchClass implements Database.Batchable<sObject> {
    global Database.QueryLocator start(Database.BatchableContext BC) {        
        String query = 'SELECT Id,MasterLabel,Name,Status,TotalLicenses,UsedLicenses,UsedLicensesLastUpdated FROM UserLicense';
        return Database.getQueryLocator(query);
    }    
    global void execute(Database.BatchableContext BC, List<UserLicense> UsrList) {
        list<User_Licenses__c> userlist = [select id,Name__c,Total_Licenses__c,Used_Licenses__c from User_Licenses__c];
        list<User_Licenses__c> userlistInsert = new list<User_Licenses__c>();
        User_Licenses__c userLicense = new User_Licenses__c();       
        if(userlist.size() > 0){
            for(UserLicense acc : UsrList){
                userLicense.Name__c = acc.Name;
                userLicense.Status__c = acc.Status;
                userLicense.Total_Licenses__c = acc.TotalLicenses;
                userLicense.Used_Licenses__c = acc.UsedLicenses;
                userlist.add(userLicense);
            }
        }
        else{             
             for(UserLicense acc1 : UsrList){
                User_Licenses__c userLicenseinsert = new User_Licenses__c();
                userLicenseinsert.Name__c = acc1.Name;
                userLicenseinsert.Status__c = acc1.Status;
                userLicenseinsert.Total_Licenses__c = acc1.TotalLicenses;
                userLicenseinsert.Used_Licenses__c = acc1.UsedLicenses;
                userlistInsert.add(userLicenseinsert);  
             }
                insert userlistInsert;  
               
        }
        try {
            if(userlist.size()>0){
               update userlist; 
            }
            if(userlistInsert.size()>0){
               insert userlistInsert; 
            }          
            
        } catch(Exception e) {
            System.debug(e);
        }        
    }   
    
    global void finish(Database.BatchableContext BC) {
    }
}