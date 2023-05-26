public class DataFirstInterviewViewQuestionsCtr {
    @AuraEnabled
    public static String fetchRecordId(){
        return apexpages.currentpage().getparameters().get('recordId');
    }
    @AuraEnabled
    public static List<Interview_Response__c> listOfQuestions(Id InterviewId){
        List<Interview_Response__c> questions = new List<Interview_Response__c>();
        if(InterviewId != null){
        	questions = [SELECT Id, Theme__c,Theme__r.Name, Question__c, Interview_Question_Number__c, Maturity_Level__c, Urgency_for_Improvements__c, Comments__c FROM Interview_Response__c where Interview__c =: InterviewId];
        }
        return questions;
    }
    
    @AuraEnabled
    public static List<Theme__c> listOfSections(Id InterviewId){
        List<Theme__c> themes = new List<Theme__c>();
        if(InterviewId != null) {
           themes = [SELECT Id, Name, Key_Areas_of_Improvement__c, Key_Strengths__c, Additional_Comments__c FROM Theme__c where Interview__c =:InterviewId];   
        }
        return themes;
    }
    
    @AuraEnabled
    public static boolean saveQuestions(List<Interview_Response__c> responses){
        try {
            if(responses.size()>0){
            	List<database.SaveResult> srList = database.update(responses);    
            }
        }
        catch(Exception e) {
            return false;
        }
		return true;       
    }
    
    @AuraEnabled
    public static boolean saveSections(List<Theme__c> responses){
        try {
            if(responses.size()>0){
            	List<database.SaveResult> srList = database.update(responses);    
            }
        }
        catch(Exception e) {
            return false;
        }
		return true; 
    }
}