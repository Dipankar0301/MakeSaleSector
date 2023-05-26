trigger SV2020CheckUniqueYear on Free_Cash_Flow__c (before insert) {
    
    for(Free_Cash_Flow__c f : Trigger.new){
        Id OppId = f.Opportunity__c;
        String year = f.Year__c;
        
        List<Free_Cash_Flow__c> fcfs = [SELECT Year__c FROM Free_Cash_Flow__c WHERE Opportunity__c =: OppId];
        if(Trigger.isBefore && Trigger.isInsert){     
            for(Free_Cash_Flow__c fcf : fcfs){
                if(year.equals(fcf.Year__c)){
                    f.adderror('The Year Value already exists');
                }
            }  
        }
    }
}