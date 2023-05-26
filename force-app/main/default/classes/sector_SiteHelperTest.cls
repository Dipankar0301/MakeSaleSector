@isTest(SeeAllData=true)
public class sector_SiteHelperTest {

    /*@testSetup static void IntialSetup() 
    {
        String orgId = UserInfo.getOrganizationId();  
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');  
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));  
        String uniqueName = orgId + dateString + randomInt; 
        Profile p = [SELECT Id FROM Profile WHERE Name='MakeSaledSector']; 
        User u = new User(Alias = 'standt', Email = 'sectortestclassuser@sector.shell.com', LastName = 'Testing', 
                          EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', 
                          LocaleSidKey = 'en_US', ProfileId = p.Id, 
                          TimeZoneSidKey = 'Europe/Amsterdam', UserName = uniqueName + '@test' + orgId + '.org');
        insert u;
    }*/
    static testmethod void createUpdateOnSiteTest()
    {
		/*User us = [Select Id from User where email = 'sectortestclassuser@sector.shell.com'];
        System.runAs(us)
        {*/
            Id recordtypeidorgaccount= Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId();
            Id recordtypeidorgsite= Schema.SObjectType.Site__c.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId();
        	Account acc =new Account(Name='Top level Account 1123', RecordTypeId= recordtypeidorgaccount, Region__c='Europe', Sector__c='Technology',Account_Type__c=
                                    'Enterprise Account',Sub_sectors__c = 'other');
        	insert acc;
            Site__c site1= new Site__c(Name ='Site test class 1',Zip_Postal_Code__c='733101', Sector_Country__c='Afghanistan',Street__c = 'Congress Para',State__c = 'Bihar',
                                       Sector_City__c ='Bangalore',recordtypeid = recordtypeidorgsite,Inserted_Or_Address_Updated__c = false);
            insert site1;
            system.debug('line 29'+ site1);
            Site__c site2= [select id,Name,Sector_Country__c,Inserted_Or_Address_Updated__c,Zip_Postal_Code__c,Street__c,Sector_City__c,State__c from Site__c where id =: site1.id];
            system.debug('line 31'+ site2);
        	System.assertEquals(true,site2.Inserted_Or_Address_Updated__c );
            site2.Sector_Country__c = 'India';
            site2.Inserted_Or_Address_Updated__c = false;
            site2.Zip_Postal_Code__c='742101';
            Site2.Street__c = 'mangalpur';
            Site2.Sector_City__c = 'Bangalore';
            Site2.State__c = 'West Bengal';
            update site2;
            Site__c site3= [select id,Name,Sector_Country__c,Inserted_Or_Address_Updated__c,Street__c,Sector_City__c,State__c from Site__c where id =: site1.id];
            System.assertEquals(true,site3.Inserted_Or_Address_Updated__c );
        //}
    }
     
    static testMethod void testMethod1() 
    {
        Id recordtypeidorgsite= Schema.SObjectType.Site__c.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId();
        List<Site__c> lstsite= new List<Site__c>();
        for(Integer i=0 ;i <1;i++)
        {
            Site__c site1= new Site__c(Name ='Site test class ' +i,Zip_Postal_Code__c='733101', Sector_Country__c='India',Street__c = 'Congress Para',State__c = 'West bengal',
                                       Sector_City__c ='Berlin',recordtypeid = recordtypeidorgsite,Inserted_Or_Address_Updated__c = false);
            lstsite.add(site1);
        }
        
        insert lstsite;
        //MockHttpResponseGenerator mockcall = new MockHttpResponseGenerator();
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
        Test.startTest();

            SiteScheduleUpdate obj1 = new SiteScheduleUpdate();
        	String sch1 = '0 0 1 * * ?'; 
			system.schedule('Test Territory Check1', sch1, obj1); 
            //DataBase.execute(obj); 
            
        Test.stopTest();
        
    }
    static testMethod void testMethod2() 
    {
        Id recordtypeidorgsite= Schema.SObjectType.Site__c.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId();
        List<Site__c> lstsite= new List<Site__c>();
        for(Integer i=0 ;i <1;i++)
        {
            Site__c site1= new Site__c(Name ='Site test class ' +i,Zip_Postal_Code__c='733101', Sector_Country__c='India',Street__c = 'Congress Para',State__c = 'West bengal',
                                       Sector_City__c ='Berlin',recordtypeid = recordtypeidorgsite,Inserted_Or_Address_Updated__c = false);
            lstsite.add(site1);
        }
        
        insert lstsite;
        Test.setMock(HttpCalloutMock.class, new MockHttpResponseGeneratorSector());
        Test.startTest();

            SiteScheduleUpdate obj2 = new SiteScheduleUpdate();
        	String sch2 = '0 0 1 * * ?'; 
			system.schedule('Test Territory Check2', sch2, obj2); 
            //DataBase.execute(obj); 
            
        Test.stopTest();
    }

}