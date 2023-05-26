@isTest
public class MakeSales_Sector_MultiSelectParentTest {
    
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
    static testmethod void getRecordTest()
    {
        User us = [Select Id from User where email = 'sectortestclassuser1@sector.shell.com'];
        System.runAs(us)
        {
            Id recordtypeidorg1= Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId();
            Id recordtypeidorgaccount= Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId();
            Account acc =new Account(Name='DK0301', RecordTypeId= recordtypeidorgaccount, Region__c='Americas;Asiapac;Australia', Sector__c='Technology');
            insert acc;
            Opportunity obj1 =new Opportunity(recordTypeId= recordtypeidorg1, Name = 'SearchField', AccountId =acc.id, StageName= 'Align', 
                                              CloseDate = system.today(),Fulfilled_by__c='TBC;Bitumen', Opportunity_Region__c='Americas;Asiapac;Australia',
                                              Opportunity_Country__c='Argentina;Barbados',Opportunity_City__c='Bangalore;Kolkata');
            
            insert obj1;
            Map<String,List<String>> resultMap=MakeSales_Sector_MultiSelectParent.getRecord(obj1.id);
            List<String> values = new List<String>();
            List<String> values1 = new List<String>();
            List<String> values2 = new List<String>();
            List<String> values3 = new List<String>();
            values =resultMap.get('Fulfilled');
            values1 =resultMap.get('Region');
            values2 =resultMap.get('Country');
            values3 =resultMap.get('City');
            List<String> picklistValues;
            List<String> picklistValues1;
            List<String> picklistValues2;
            List<String> picklistValues3;
            if(obj1.Fulfilled_by__c != null)
                picklistValues = obj1.Fulfilled_by__c.split(';');
            if(obj1.Opportunity_Region__c != null)
                picklistValues1 = obj1.Opportunity_Region__c.split(';');
            if(obj1.Opportunity_Country__c != null)
                picklistValues2 = obj1.Opportunity_Country__c.split(';');
            if(obj1.Opportunity_City__c != null)
                picklistValues3 = obj1.Opportunity_City__c.split(';');
            if(obj1.Fulfilled_by__c != null && values != null){
                
                System.assertEquals(values[0], picklistValues[0]);
                System.debug(values1 + '--------'+picklistValues1);
                System.assertEquals(values1[0], picklistValues1[0]); 
                System.assertEquals(values2[0], picklistValues2[0]); 
                System.assertEquals(values3[0], picklistValues3[0]); 
            }       
            
        }
    }
    static testmethod void getPicklistValuesTest()
    {
        User us = [Select Id from User where email = 'sectortestclassuser1@sector.shell.com'];
        System.runAs(us)
        {
            Map<String, List<String>> picklistvaluesMap= New Map<String,List<String>>();
            List<String> pickListValuesList1= new List<String>();
            Schema.DescribeFieldResult fieldResult1 = Opportunity.Fulfilled_by__c.getDescribe();
            List<Schema.PicklistEntry> ple1 = fieldResult1.getPicklistValues();
            for( Schema.PicklistEntry pickListVal : ple1){
                pickListValuesList1.add(pickListVal.getLabel());
            }
            
            List<String> pickListValuesList2= new List<String>();
            Schema.DescribeFieldResult fieldResult2 = Opportunity.Opportunity_Region__c.getDescribe();
            List<Schema.PicklistEntry> ple2 = fieldResult2.getPicklistValues();
            for( Schema.PicklistEntry pickListVal : ple2){
                pickListValuesList2.add(pickListVal.getLabel());
            }
            List<String> pickListValuesList3= new List<String>();
            Schema.DescribeFieldResult fieldResult3 = Opportunity.Opportunity_Country__c.getDescribe();
            List<Schema.PicklistEntry> ple3 = fieldResult3.getPicklistValues();
            for( Schema.PicklistEntry pickListVal : ple3){
                pickListValuesList3.add(pickListVal.getLabel());
            }
            List<String> pickListValuesList4= new List<String>();
            Schema.DescribeFieldResult fieldResult4 = Opportunity.Opportunity_City__c.getDescribe();
            List<Schema.PicklistEntry> ple4 = fieldResult4.getPicklistValues();
            for( Schema.PicklistEntry pickListVal : ple4){
                pickListValuesList4.add(pickListVal.getLabel());
            }
            picklistvaluesMap.put('Fulfilled', pickListValuesList1);
            picklistvaluesMap.put('Region', pickListValuesList2);
            picklistvaluesMap.put('Country', pickListValuesList3);
            picklistvaluesMap.put('City', pickListValuesList4);
            
            Id recordtypeidorg1= Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId();
            Id recordtypeidorgaccount= Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId();
            Account acc =new Account(Name='DK0301', RecordTypeId= recordtypeidorgaccount, Region__c='Americas;Asiapac;Australia', Sector__c='Technology');
            insert acc;
            Opportunity obj1 =new Opportunity(recordTypeId= recordtypeidorg1, Name = 'SearchField', AccountId =acc.id, StageName= 'Align', 
                                              CloseDate = system.today(),Fulfilled_by__c='TBC;Bitumen', Opportunity_Region__c='Americas;Asiapac;Australia',
                                              Opportunity_Country__c='Argentina;Barbados',Opportunity_City__c='Bangalore;Kolkata');
            
            insert obj1;
            
            Map<String,List<String>> resultMap=MakeSales_Sector_MultiSelectParent.getPicklistValues(obj1.id);
            System.assertEquals(picklistvaluesMap.keyset(), resultMap.keyset());
            For(String s: resultMap.keyset()){
                System.assertEquals(picklistvaluesMap.get(s), resultMap.get(s));
            }
        }
    }
    static testmethod void saveRecordsTest()
    {
        User us = [Select Id from User where email = 'sectortestclassuser1@sector.shell.com'];
        System.runAs(us)
        {
            Id recordtypeidorg1= Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId();
            Id recordtypeidorgaccount= Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId();
            Id recordtypeidorgsite= Schema.SObjectType.Site__c.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId();
            Account acc =new Account(Name='DK0301', RecordTypeId= recordtypeidorgaccount, Region__c='Americas;Asiapac;Australia', Sector__c='Technology');
            insert acc;
            Opportunity obj1 =new Opportunity(recordTypeId= recordtypeidorg1, Name = 'SearchField', AccountId =acc.id, StageName= 'Align', 
                                              CloseDate = system.today(),Fulfilled_by__c='TBC;Bitumen', Opportunity_Region__c='Americas;Asiapac;Australia',
                                              Opportunity_Country__c='Argentina;Barbados',Opportunity_City__c='Bangalore;Kolkata');
            
            insert obj1;
            /*Site__c site = new Site__c(Name = 'ABC', Account__c =acc.id, recordtypeid =recordtypeidorgsite);
            insert site;
            
            Site_Link__c sl = new Site_Link__c();
            sl.Name = site.Name;
            sl.Opportunity__c = obj1.id;
            sl.Site__c = site.id;*/
            
            
            List<String> selectedValueFulfill = new List<String>();
            List<String> selectedValueRegion= new List<String>();
            List<String> selectedValueCountry= new List<String>();
            List<String> selectedValueCity= new List<String>();
            //List<String> selectedValueSite= new List<String>();
            String a= 'CCUS';
            selectedValueFulfill.add(a);
            selectedValueFulfill.add('Chemicals');
            
            selectedValueRegion.add('Americas');
            selectedValueRegion.add('Australia');
            
            selectedValueCountry.add('France');
            selectedValueCountry.add('Germany');
            
            selectedValueCity.add('Cape Town');
            selectedValueCity.add('Chennai');
            
            //selectedValueSite.add(site.id);
            
            //List<String> result=MakeSales_Sector_MultiSelectParent.saveRecords(obj1.id,selectedValueFulfill,selectedValueRegion,selectedValueCountry,selectedValueCity,selectedValueSite);
            List<String> result=MakeSales_Sector_MultiSelectParent.saveRecords(obj1.id,selectedValueFulfill,selectedValueRegion,selectedValueCountry,selectedValueCity);
            
            System.assertEquals('true', result[0]);
            //error
            selectedValueRegion.add('Europe');
            //List<String> result1=MakeSales_Sector_MultiSelectParent.saveRecords(obj1.id,selectedValueFulfill,selectedValueRegion,selectedValueCountry,selectedValueCity,selectedValueSite);
            List<String> result1=MakeSales_Sector_MultiSelectParent.saveRecords(obj1.id,selectedValueFulfill,selectedValueRegion,selectedValueCountry,selectedValueCity);
            
            System.assertEquals('One or more of the regions you selected for this opportunity is not associated with the account you selected. Please review your opportunity region selection.', result1[0]);
            //getSiteRecords
            /*List<Site__c> result2=MakeSales_Sector_MultiSelectParent.getSiteRecords(obj1.id);
            System.assertEquals(site.id, result2[0].id);
            //getSelectedSiteRecords
            List<Site__c> result3=MakeSales_Sector_MultiSelectParent.getSelectedSiteRecords(obj1.id);
            System.assertEquals(site.id, result3[0].id);*/
        }
    }
    
}