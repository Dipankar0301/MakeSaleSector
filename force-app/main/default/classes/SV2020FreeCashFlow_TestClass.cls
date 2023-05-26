@isTest
private class SV2020FreeCashFlow_TestClass {
    @isTest static void testFreeCashFlowController() {
        Opportunity__c opp = new Opportunity__c();
        opp.Name = 'Test Opportunity implementation';
        opp.RecordTypeId = Schema.SObjectType.Opportunity__c.getRecordTypeInfosByDeveloperName().get('Implementation').getRecordTypeId();
        
        insert opp;
        
        Test.startTest();
        String url = '/cmp/SV2020DeploymentSection?recordId=' + opp.Id;
        PageReference page = new PageReference(url);
        
        Test.setCurrentPage(page);
        
        System.assertEquals(opp.Id,SV2020FreeCashFlow.fetchRecordId());
        
        List<Free_Cash_Flow__c> fcfs = new List<Free_Cash_Flow__c>();
        if(opp.Id != null){
            fcfs = [SELECT Id, Year__c, FCF__c, CO2e_Avoided_kg__c, HSSE_Exposed_Hours__c, Risked_FCF_after_Tax_Shell_Share__c FROM Free_Cash_Flow__c where Opportunity__c =: opp.id ORDER BY Year__c ASC];
        }
        
        List<Free_Cash_Flow__c> nfcfs= SV2020FreeCashFlow.listOfFreeCashFlows(opp.Id);
        boolean isSame = true;
        
        if(fcfs.size() != nfcfs.size()){
            isSame = false;
        }
        else{
            for(Integer i=0;i<nfcfs.size();++i){
                if(nfcfs[i].FCF__c != fcfs[i].FCF__c || nfcfs[i].Year__c != fcfs[i].Year__c || nfcfs[i].CO2e_Avoided_kg__c != fcfs[i].CO2e_Avoided_kg__c || nfcfs[i].HSSE_Exposed_Hours__c != fcfs[i].HSSE_Exposed_Hours__c || nfcfs[i].Risked_FCF_after_Tax_Shell_Share__c != fcfs[i].Risked_FCF_after_Tax_Shell_Share__c){
                    isSame = false;
                    break;
                }
            }
        }
        boolean check1 = false;
        boolean check2 = false;
        
        for(Integer i=0;i<nfcfs.size();i++) {
            nfcfs[i].FCF__c = 1.32;
        }
        if(nfcfs.size()>0){
            check1 = SV2020FreeCashFlow.saveFCFs(nfcfs);  
        }
        for(Integer i=0;i<nfcfs.size();i++) {
            nfcfs[i].Year__c = '2019';
        }
        if(nfcfs.size()>0){
            check2 = SV2020FreeCashFlow.saveFCFs(nfcfs);
        }
        SV2020FreeCashFlow.booster();
        Test.stopTest();
        System.assertEquals(true, isSame);
        //System.assertEquals(true, check1);
        System.assertEquals(false, check2);
    }
}