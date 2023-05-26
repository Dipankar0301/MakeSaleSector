@isTest//(SeeAllData=true)
public class Sector_EFLTest {
    public static boolean isSandbox= [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
    static testmethod void createUpdateOnSiteTest()
    {
         
        
        Id recordtypeidorg1= Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId();
        Id recordtypeidorgaccount= Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId();
        Account acc =new Account(Name='DK0301API', RecordTypeId= recordtypeidorgaccount, Region__c='Americas;Asiapac;Australia', Sector__c='Technology');
        insert acc;
        Opportunity obj1 =new Opportunity(recordTypeId= recordtypeidorg1, Name = 'SearchField', AccountId =acc.id, StageName= 'Align', 
                                          CloseDate = system.today(),Fulfilled_by__c='TBC;Bitumen', Opportunity_Region__c='Americas;Asiapac;Australia',
                                          Opportunity_Country__c='Argentina;Barbados',Opportunity_City__c='Bangalore;Kolkata');
        
        insert obj1;
        Product2 pro = new Product2(Name = 'Other', Family = 'Fuel',isActive = True);
        Insert pro;
        
        Product2 pro1 = new Product2(Name = 'Other', Family = 'EV Solutions',isActive = True);
        Insert pro1;
        
        Product2 pro2 = new Product2(Name = 'Software', Family = 'EV Solutions',isActive = True);
        Insert pro2;
        
        Pricebook2 standardPricebook = new Pricebook2(
            Id = Test.getStandardPricebookId(),
            IsActive = true
        );
        Update standardPricebook;
        
        PricebookEntry pbe = new PricebookEntry(
            Pricebook2Id = standardPricebook.Id,
            Product2Id = pro.Id,
            UnitPrice = 1020,
            IsActive = true
        );
        Insert pbe;
        
        
        PricebookEntry pbe1 = new PricebookEntry(
            Pricebook2Id = standardPricebook.Id,
            Product2Id = pro1.Id,
            UnitPrice = 1020,
            IsActive = true
        );
        Insert pbe1;
        
        PricebookEntry pbe2 = new PricebookEntry(
            Pricebook2Id = standardPricebook.Id,
            Product2Id = pro2.Id,
            UnitPrice = 1020,
            IsActive = true
        );
        Insert pbe2;
        
        obj1.Pricebook2Id = Test.getStandardPricebookId();
            update obj1;
        Sector_AddProduct.responseWrapper response = Sector_AddProduct.getOpportunityProductdata(obj1.Id, null, null);
        System.assertEquals('success', response.responseStatus);
        System.debug(response);
        List<Sector_AddProduct.Products> listofselectedproduct = new List<Sector_AddProduct.Products>();
        listofselectedproduct.addall(response.ProductsList);
        System.debug(listofselectedproduct);
        for(Sector_AddProduct.Products eachproduct : listofselectedproduct)
        {
            eachproduct.Volume = 100;
            eachproduct.Revenue = 100;
            eachproduct.ProductProfit = 100;
        }
        
        Cache.OrgPartition orgPart = Cache.Org.getPartition('local.StoreOnAirAccessToken');
        orgPart.put('token','q2fqa7h3q89atzxapy8yq2em');
        orgPart.put('expiry',system.now().addSeconds(3600));//please edit the time according to the access token time
        
        Profile objProfile = [Select Id, Name from Profile where Name =: 'System Administrator' limit 1];

		User objeUser = [Select Id, ProfileId from User where ProfileId=: objProfile.Id  and isActive =: True limit 1];
        System.runAs(objeUser){
            
             Sector_EFL__c myCustomSetting = new Sector_EFL__c();
            myCustomSetting.Name = 'Sandbox';
				myCustomSetting.Client_Id__c = 'ok0ha2563jvshbkci2tnvf38o';
				myCustomSetting.Client_secret__c = '13t99t281kgthmuca60u6lq09nu7n43g5vtg7mc1d982jrvb5f5';
            	myCustomSetting.Token_URL__c = 'https://carbonmanagementtest.auth.us-east-1.amazoncognito.com/oauth2/token';
             	myCustomSetting.Endpoint__c = 'https://api.carboncalc.test-cc.shell.com/api/v1/calculate/client/SF/fuel-emission';
				insert myCustomSetting;
            System.debug(listofselectedproduct);
        	Test.setMock(HttpCalloutMock.class, new MockHTTPResponseEFL());
        	Test.startTest();
        
        	Map<String, String> responseApi = Sector_AddProduct.callApi(Json.serialize(listofselectedproduct),obj1.Id);
        	Test.stopTest();
        }
    }
    
}