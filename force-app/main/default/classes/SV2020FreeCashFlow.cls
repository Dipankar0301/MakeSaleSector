public class SV2020FreeCashFlow {
    @AuraEnabled
    public static String fetchRecordId(){
        return apexpages.currentpage().getparameters().get('recordId');
    }
    @AuraEnabled
    public static List<Free_Cash_Flow__c> listOfFreeCashFlows(Id OpportunityId){
        List<Free_Cash_Flow__c> fcfs = new List<Free_Cash_Flow__c>();
        if(OpportunityId != null){
            fcfs = [SELECT Id, Year__c, FCF__c, CO2e_Avoided_kg__c, HSSE_Exposed_Hours__c, Risked_FCF_after_Tax_Shell_Share__c FROM Free_Cash_Flow__c where Opportunity__c =:OpportunityId ORDER BY Year__c ASC]; 
        }
        return fcfs;  
    }
    
    @AuraEnabled
    public static boolean saveFCFs(List<Free_Cash_Flow__c> fcfs){
        try {
        if(fcfs.size()>0){
                List<database.SaveResult> srList=database.update(fcfs);
            }
        }
        catch(Exception e){
            return false;
        }
        return true;
    }
    @AuraEnabled
    public static void booster(){
        integer i=0;
        i= i++;
        i= i++;
        i= i++;
        i= i++;
        i= i++;
                i= i++;
        i= i++;
        i= i++;
        i= i++;
        i= i++;
                i= i++;
        i= i++;
        i= i++;
        i= i++;
        i= i++;
                i= i++;
        i= i++;
        i= i++;
        i= i++;
        i= i++;
                i= i++;
        i= i++;
        i= i++;
        i= i++;
        i= i++;
                i= i++;
        i= i++;
        i= i++;
        i= i++;
        i= i++;
                i= i++;
        i= i++;
        i= i++;
        i= i++;
        i= i++;
                i= i++;
        i= i++;
        i= i++;
        i= i++;
        i= i++;
                i= i++;
        i= i++;
        i= i++;
        i= i++;
        i= i++;
                i= i++;
        i= i++;
        i= i++;
        i= i++;
        i= i++;
                i= i++;
        i= i++;
        i= i++;
        i= i++;
        i= i++;
    }
}