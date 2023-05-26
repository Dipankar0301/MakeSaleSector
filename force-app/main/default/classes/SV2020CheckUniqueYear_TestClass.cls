@isTest
private class SV2020CheckUniqueYear_TestClass {
    @isTest static void checkUniqueYear() {
        Opportunity__c opp = new Opportunity__c();
        opp.Name = 'Test Opportunity implementation';
        opp.RecordTypeId = Schema.SObjectType.Opportunity__c.getRecordTypeInfosByDeveloperName().get('Implementation').getRecordTypeId();
        
        insert opp;
        
        Opportunity__c o = [SELECT Id From Opportunity__c WHERE Name = 'Test Opportunity implementation'];
        
        Free_Cash_Flow__c f1 = new Free_Cash_Flow__c();
        Free_Cash_Flow__c f2 = new Free_Cash_Flow__c();
        
        f1.Year__c = '2015';
        f1.FCF__c = 1.23;
        f1.HSSE_Exposed_Hours__c = 23;
        f1.CO2e_Avoided_kg__c = 12.3;
        f1.Opportunity__c = o.id;
        
        insert f1;
        
        f2.Year__c = '2015';
        f2.FCF__c = 2.46;
        f2.HSSE_Exposed_Hours__c = 45;
        f2.CO2e_Avoided_kg__c = 145.3;
        f2.Opportunity__c = o.id;
        
        String error = '';
        Test.startTest();
        try{
        	insert(f2);    
        }
        catch (Exception e){
            error = e.getMessage();
        }
        Test.stopTest();
    		
       	System.assertEquals('Insert failed. First exception on row 0; first error: FIELD_CUSTOM_VALIDATION_EXCEPTION, The Year Value already exists: []', error);
    }
}