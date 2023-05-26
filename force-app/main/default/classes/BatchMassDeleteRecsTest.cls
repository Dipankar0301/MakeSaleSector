@isTest
private class BatchMassDeleteRecsTest{

    static testMethod void BatchMassDeleteRecsTest() {
     Contact c = new Contact();
     c.LastName='test';
     insert c; 
        String query = 'select Id from Contact';
        BatchMassDeleteRecs b = new BatchMassDeleteRecs(query);
        Test.startTest();
        b.start(null);
        b.finish(null);
        Database.executeBatch(b,200);

        Test.stopTest();
    }

}