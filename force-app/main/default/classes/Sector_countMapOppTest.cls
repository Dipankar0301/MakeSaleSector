@isTest
public class Sector_countMapOppTest {

    @isTest
    public static void countTest(){
        Id oppUpdateId = null;
        Id recordtypeidorg1= Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId();
        Id recordtypeidorgaccount= Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId();
        Id recordtypeidorgcontact= Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId();
        Account acc =new Account(Name='altify Account', RecordTypeId= recordtypeidorgaccount, Region__c='Europe', Sector__c='Technology');
        insert acc;
        Opportunity obj1 =new Opportunity(recordTypeId= recordtypeidorg1, Name = 'test2', AccountId =acc.id, 
                                          StageName= 'Align', CloseDate = system.today(), Opportunity_Country__c='Afghanistan', 
                                          Opportunity_Region__c='Europe',Value_Amount__c = 10);
        
        insert obj1;
        Contact cnt = new Contact(LastName ='australia new south wales',FirstName = 'DipKarmakar',AccountId =acc.id, recordtypeid =recordtypeidorgcontact,Department__c='Sales');
        insert cnt;
        ALTF__Contact_Map_Details__c acm = new ALTF__Contact_Map_Details__c(name = 'test',ALTF__Contact__c =cnt.id,ALTF__Account__c=acc.id,ALTF__Opportunity__c=obj1.id);
        insert acm;
        
        List<ALTF__Contact_Map_Details__c> acmList = [select id, ALTF__Contact__c,ALTF__Account__c,ALTF__Opportunity__c
                                                      from ALTF__Contact_Map_Details__c where ALTF__Opportunity__c =:obj1.id];
        List<Opportunity> opplist = [select id, Map_count__c from Opportunity where id =: obj1.id];
        System.assertEquals(opplist[0].Map_count__c, 1);
        Id oppDeleteId = obj1.id;
        
        acm.ALTF__Opportunity__c = oppUpdateId;
        update acm;
        List<Opportunity> opplist1 = [select id, Map_count__c from Opportunity where id =: oppDeleteId];
        System.assertEquals(opplist1[0].Map_count__c, 0);
        
        delete acm;
        List<Opportunity> opplist2 = [select id, Map_count__c from Opportunity where id =: oppDeleteId];
        System.assertEquals(opplist2[0].Map_count__c, 0);
    }
}