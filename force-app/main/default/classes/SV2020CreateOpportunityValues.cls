public class SV2020CreateOpportunityValues {
    @InvocableMethod
    public static void createOVs(List<Id> OpportunityId) {
        insertOVs(OpportunityId);
    }
    @future(callout=true) public static void insertOVs(List<Id> OpportunityId){
		List<Free_Cash_Flow__c> fcfs = new List<Free_Cash_Flow__c>();
        for(Id mId : OpportunityId){
            for(Integer i = 2014; i<= 2040; i++){
                Free_Cash_Flow__c fcf = new Free_Cash_Flow__c();
                fcf.Opportunity__c = mId;
                fcf.Year__c = String.valueOf(i);
                fcf.FCF__c = 0.00;
                fcfs.add(fcf);
            }
        }
        try{
            if(fcfs.size()>0){
                List<database.SaveResult> srList = database.insert(fcfs);
            }
        }
        catch (Exception e){
            System.debug(e);
        }        
    }
}