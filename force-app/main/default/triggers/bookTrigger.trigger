trigger bookTrigger on Book__c (before insert) {

list<Book__c> li = trigger.new;
       
        for(Book__c str : li){
            str.Price__c = str.Price__c * 0.8;
        }
       
}