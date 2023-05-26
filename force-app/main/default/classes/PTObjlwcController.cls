public with sharing class PTObjlwcController {
    
    @AuraEnabled
    public static PTObjs__c savePTObj(String name,String phoneNumber) {
        

        PTObjs__c p =new PTObjs__c();
            p.Name= name;
            p.Name__c= name;
            p.Mobile_Number1__c= phoneNumber;
        insert p;
        
        return p;
    }
}