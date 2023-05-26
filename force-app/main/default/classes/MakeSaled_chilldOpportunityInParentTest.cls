@isTest
public class MakeSaled_chilldOpportunityInParentTest {
	@isTest
    static void showMessage(){
        Id recordtypeidorg1= Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId();
        Id recordtypeidorgaccount= Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId();
        Account acc1 =new Account(Name='top level', RecordTypeId= recordtypeidorgaccount, Region__c='Europe', Sector__c='Technology');
        insert acc1;
        Account acc2 =new Account(Name='1st level', RecordTypeId= recordtypeidorgaccount, Region__c='Europe', Sector__c='Technology', ParentId =acc1.id);
        insert acc2;
        Opportunity opp1 = new Opportunity(name= 'top level opp', RecordTypeId=recordtypeidorg1, closedate=date.today(),stagename='Suspect/Lead',accountid=acc1.id);
        insert opp1;
        Opportunity opp2 = new Opportunity(name= '1st level opp', RecordTypeId=recordtypeidorg1, closedate=date.today(),stagename='Suspect/Lead',accountid=acc2.id);
        insert opp2;
        List<Opportunity> opplist = new List<Opportunity>();
        opplist.add(opp1);
        opplist.add(opp2);
        List<Opportunity> bool=MakeSaled_chilldOpportunityInParent.getRelatedList(acc2.id);
        System.assertEquals(opplist.size(), bool.size());
        // I am checking the id's of the account plan from both the lists.
        // If it gives any error then we can remove these two lines as error can come because of the returned list does not have plan in sequence
        System.assertEquals(opplist[0].id, bool[0].id); 
        System.assertEquals(opplist[0].name, bool[0].name);
        System.assertEquals(opplist[0].Name, bool[0].Name);
        System.assertEquals(opplist[1].id, bool[1].id);
        System.assertEquals(opplist[1].name, bool[1].name);
        System.assertEquals(opplist[1].Name, bool[1].Name);
    }
}