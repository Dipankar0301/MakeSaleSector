@isTest
public class Sector_AddASiteZInOpportunityTest {

    @testSetup static void IntialSetup() 
    {
        String orgId = UserInfo.getOrganizationId();  
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');  
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));  
        String uniqueName = orgId + dateString + randomInt; 
        Profile p = [SELECT Id FROM Profile WHERE Name='MakeSaledSector']; 
        User u = new User(Alias = 'standt', Email = 'sectortestclassuser1@sector.shell.com', LastName = 'Testing', 
                          EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', 
                          LocaleSidKey = 'en_US', ProfileId = p.Id, 
                          TimeZoneSidKey = 'Europe/Amsterdam', UserName = uniqueName + '@test' + orgId + '.org');
        insert u;
        
        
    }
    static testmethod void saveRecordsTest()
    {
        User us = [Select Id from User where email = 'sectortestclassuser1@sector.shell.com'];
        System.runAs(us)
        {
            Id recordtypeidorg1= Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId();
            Id recordtypeidorgaccount= Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId();
            Id recordtypeidorgsite= Schema.SObjectType.Site__c.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId();
            Account acc =new Account(Name='DK0301site', RecordTypeId= recordtypeidorgaccount, Region__c='Americas;Asiapac;Australia', Sector__c='Technology');
            insert acc;
            Opportunity obj1 =new Opportunity(recordTypeId= recordtypeidorg1, Name = 'SearchField', AccountId =acc.id, StageName= 'Align', 
                                              CloseDate = system.today(),Fulfilled_by__c='TBC;Bitumen', Opportunity_Region__c='Americas;Asiapac;Australia',
                                              Opportunity_Country__c='Argentina;Barbados',Opportunity_City__c='Bangalore;Kolkata');
            
            insert obj1;
            Site__c site = new Site__c(Name = 'ABC', Account__c =acc.id, recordtypeid =recordtypeidorgsite);
            insert site;
            Site_Link__c sl = new Site_Link__c();
            //sl.Name = site.Name;
            sl.Opportunity__c = obj1.id;
            sl.Site__c = site.id;
            insert sl;
            List<String> selectedValueSite= new List<String>();
            selectedValueSite.add(site.id);
            List<String> result=Sector_AddASiteZInOpportunity.saveRecords(obj1.id,selectedValueSite);
            System.assertEquals('true', result[0]);
            
            //getSiteRecords
            List<Site__c> result2=Sector_AddASiteZInOpportunity.getSiteRecords(obj1.id);
            System.assertEquals(site.id, result2[0].id);
            //getSelectedSiteRecords
            List<Site__c> result3=Sector_AddASiteZInOpportunity.getSelectedSiteRecords(obj1.id);
            System.assertEquals(site.id, result3[0].id);
            String result4=Sector_AddASiteZInOpportunity.getParentAccountRecordId(obj1.id);
            System.assertEquals(acc.id, result4);
        }
    }
    static testmethod void saveRecordsTest1()
    {
        User us = [Select Id from User where email = 'sectortestclassuser1@sector.shell.com'];
        System.runAs(us)
        {
            Id recordtypeidorg1= Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId();
            Id recordtypeidorgaccount= Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId();
            Id recordtypeidorgsite= Schema.SObjectType.Site__c.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId();
            Account acc =new Account(Name='DK0301site1', RecordTypeId= recordtypeidorgaccount, Region__c='Americas;Asiapac;Australia', Sector__c='Technology');
            insert acc;
            Opportunity obj1 =new Opportunity(recordTypeId= recordtypeidorg1, Name = 'SearchField', AccountId =acc.id, StageName= 'Align', 
                                              CloseDate = system.today(),Fulfilled_by__c='TBC;Bitumen', Opportunity_Region__c='Americas;Asiapac;Australia',
                                              Opportunity_Country__c='Argentina;Barbados',Opportunity_City__c='Bangalore;Kolkata');
            
            insert obj1;
            
            //to generate exception
            Site__c site1 = new Site__c( Account__c =acc.id, recordtypeid =recordtypeidorgsite);
            insert site1;
            Site_Link__c sl1 = new Site_Link__c();
            //sl.Name = site.Name;
            sl1.Opportunity__c = obj1.id;
            sl1.Site__c = site1.id;
            insert sl1;
            List<String> selectedValueSite= new List<String>();
            selectedValueSite.add(site1.id);
            
            Test.startTest();
            try{
               List<String> result1=Sector_AddASiteZInOpportunity.saveRecords(obj1.id,selectedValueSite);
            }catch(Exception ahe){
                System.debug('####### ahe = ' + ahe);
            }
            //System.assertEquals('true', result[0]);
            Test.stopTest();
            
        }
    }
}