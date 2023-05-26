@isTest
public class SV2020dynamicRowsController_Test {
    @isTest static void testController() {
                Opportunity__c opp = new Opportunity__c();
        opp.Name = 'Test Opportunity implementation';
        opp.RecordTypeId = Schema.SObjectType.Opportunity__c.getRecordTypeInfosByDeveloperName().get('Implementation').getRecordTypeId();
        
        insert opp;
        
        Test.startTest();
        
        List<Date> dates = new List<Date>();
        List<String> comments = new List<String>();
        
        dates.add(Date.today());
        comments.add('test comment');
        
		SV2020dynamicRowsController.saveaccs(dates, comments, opp.Id);
        
        Test.stopTest();
    }
}