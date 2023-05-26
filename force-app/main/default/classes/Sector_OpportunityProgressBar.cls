public with sharing class Sector_OpportunityProgressBar {
    @AuraEnabled
    public static Integer getCompletionPercentage(String recordId) {
        List<Opportunity> opplist = [select id, Name, Actual_Close_Date__c,StageName,Status_Reason__c,Status_Comment__c
        from Opportunity where id =: recordId];

        Integer numVal = 0;
        if (opplist[0].Name != null && opplist[0].Name != '') {
            numVal = numVal + 1;
        }
        if (opplist[0].Actual_Close_Date__c != null ) {
            numVal = numVal + 1;
        }
        if (opplist[0].Status_Reason__c != null && opplist[0].Status_Reason__c != '') {
            numVal = numVal + 1;
        }
        if (opplist[0].StageName != null && opplist[0].StageName != '') {
            numVal = numVal + 1;
        }
        if (opplist[0].Status_Comment__c != null && opplist[0].Status_Comment__c != '') {
            numVal = numVal + 1;
        }
        Integer progressPercentage = (numVal*100)/5;
        return progressPercentage;
    }
}