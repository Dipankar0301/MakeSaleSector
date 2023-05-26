@isTest
public class Cris_Case_Test {

    static testMethod void crcase(){
        //list<schema.Location> li=new list<schema.Location>();
        schema.Location loc=new schema.Location(Name='abc',LocationType='Site',CRISId__c='absert');
        insert loc;
        Case c=new Case(Location__c=loc.id,Status='New');
        c.OrderType__c='a';c.ReasonCode__c='p';c.Origin= 'Phone';
        insert c;
        c.ReasonCode__c='q';
        update c;
        //c.ReasonCode__c='x';
        //update c;
        c.OrderType__c='c';c.ReasonCode__c='x';
        update c;
        loc.CSSIs__c='inbsert';
        loc.CRISId__c='';
        update loc;
        c.OrderType__c='a';c.ReasonCode__c='r';
        update c;
        c.OrderType__c='c';c.ReasonCode__c='x';
        update c;
        c.OrderType__c='c';c.ReasonCode__c='y';
        update c;
        c.OrderType__c='c';c.ReasonCode__c='z';
        update c;
        Account acc=new Account(Name='abc', CRISId__c='absert');
        insert acc;
        Case c1=new Case(AccountId=acc.id,Status='New');
        c1.OrderType__c='a';c1.ReasonCode__c='p';c1.Origin= 'Phone';
        insert c1;
        c1.OrderType__c='b';
        c1.ReasonCode__c='t';
        update c1;
        c1.OrderType__c='b';
        c1.ReasonCode__c='s';
        update c1;
        acc.CRISId__c='';
        acc.CSSIs__c='asdfghjkl';
        update acc;
        c1.OrderType__c='c';
        c1.ReasonCode__c='x';
        update c1;
        c1.ReasonCode__c='y';
        update c1;
    }
}