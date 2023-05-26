@isTest
public class SV2020OpportunityValues_Test {
    @isTest static void testCreateOVs(){
     	Opportunity__c opp = new Opportunity__c();
        opp.Name = 'Test Opportunity';
        opp.RecordTypeId = Schema.SObjectType.Opportunity__c.getRecordTypeInfosByDeveloperName().get('Implementation').getRecordTypeId();
        
        Test.startTest();
        insert opp;
        List<Id> oppids = new List<Id>();
        oppids.add(opp.id);
        Test.stopTest();
        
        List<Free_Cash_Flow__c> fcfs = [SELECT Id, Year__c, FCF__c, CO2e_Avoided_kg__c, HSSE_Exposed_Hours__c, Risked_FCF_after_Tax_Shell_Share__c FROM Free_Cash_Flow__c where Opportunity__c =: opp.id ORDER BY Year__c ASC];
        System.assertEquals(27, fcfs.size());
    }
}