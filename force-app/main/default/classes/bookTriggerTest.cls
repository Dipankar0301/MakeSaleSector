@isTest

private class bookTriggerTest {
    
 static testMethod void validateHelloWorld() {

 Book__c b = new Book__c(Name='Behind', Price__c=100);

 System.debug('Price before inserting new book: ' + b.Price__c);

 

 insert b;

 

 b = [SELECT Price__c FROM Book__c WHERE Id =:b.Id];

 System.debug('Price after trigger fired: ' + b.Price__c);

 

 System.assertEquals(80, b.Price__c);

 }

}