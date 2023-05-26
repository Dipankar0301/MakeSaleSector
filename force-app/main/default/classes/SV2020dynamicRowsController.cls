public with sharing class SV2020dynamicRowsController {
    @AuraEnabled
    public static void saveaccs(List<Date> dates,List<String> comments, String recId){        
        List<Implementation_Comment__c> mList = new List<Implementation_Comment__c>();
        if(dates.size()>0){
            for(Integer i=0;i<dates.size();i++){
                Implementation_Comment__c iCom = new Implementation_Comment__c();
                iCom.Date__c = dates[i];
                iCom.Comment__c = String.valueOf(comments[i]);
                iCom.Opportunity__c = recId;
                mList.add(iCom);
            }
            if(mList.size() > 0) 
            	insert mList;
        }
    }
}