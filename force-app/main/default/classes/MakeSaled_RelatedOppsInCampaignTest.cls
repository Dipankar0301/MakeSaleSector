@isTest
public class MakeSaled_RelatedOppsInCampaignTest {
		@isTest
    static void showMessage(){
        Id recordtypeidorg1= Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId();
        Id recordtypeidorgaccount= Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId();
        Id recordtypeidorgCampaign= Schema.SObjectType.Campaign.getRecordTypeInfosByDeveloperName().get('Project_City_Solutions').getRecordTypeId();
        String userid= UserInfo.getUserId();
        Account acc1 =new Account(Name='top level X', RecordTypeId= recordtypeidorgaccount, Region__c='Europe', Sector__c='Technology');
        insert acc1;
        Account acc2 =new Account(Name='1st level Y', RecordTypeId= recordtypeidorgaccount, Region__c='Europe', Sector__c='Technology', ParentId =acc1.id);
        insert acc2;
        Campaign cmp1 = new Campaign(Name ='camp 1',RecordTypeId=recordtypeidorgCampaign, Project_Owner__c =userid,Status ='Align');
        insert cmp1;
        Campaign cmp2 = new Campaign(Name ='camp 2',RecordTypeId=recordtypeidorgCampaign, Project_Owner__c =userid,Status ='Align',ParentId=cmp1.id);
        insert cmp2;
        
        Opportunity opp1 = new Opportunity(name= 'top level opp', RecordTypeId=recordtypeidorg1, closedate=date.today(),stagename='Suspect/Lead',accountid=acc1.id,campaignId =cmp1.id);
        insert opp1;
        Opportunity opp2 = new Opportunity(name= '1st level opp', RecordTypeId=recordtypeidorg1, closedate=date.today(),stagename='Suspect/Lead',accountid=acc2.id,campaignId =cmp2.id);
        insert opp2;
        List<Opportunity> opplist = new List<Opportunity>();
        opplist.add(opp1);
        opplist.add(opp2);
        List<Opportunity> bool=MakeSaled_RelatedOppsInCampaign.getRelatedList(cmp2.id);
        System.assertEquals(opplist.size(), bool.size());
        // I am checking the id's of the account plan from both the lists.
        // If it gives any error then we can remove these two lines as error can come because of the returned list does not have plan in sequence
        System.assertEquals(opplist[0].id, bool[0].id); 
        System.assertEquals(opplist[0].name, bool[0].name);
        System.assertEquals(opplist[0].CampaignId, bool[0].CampaignId);
        System.assertEquals(opplist[1].id, bool[1].id);
        System.assertEquals(opplist[1].name, bool[1].name);
        System.assertEquals(opplist[1].CampaignId, bool[1].CampaignId);
    }
}