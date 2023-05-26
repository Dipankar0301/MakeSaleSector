@isTest
public class MakeSales_SiteGeolocationTest {
    
    @isTest	
    static void showMessage(){
        
        Id recordtypeidorgaccount= Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId();
        Id recordtypeidorgsite= Schema.SObjectType.Site__c.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId();
        Site__c site1 =new Site__c(name='Test Site for geo',Street__c='Congress Para',State__c='West Bengal',Zip_Postal_Code__c='733101',City__c='Balurghat',Country__c='India');
        insert site1;
        Account acc =new Account(Id=System.Label.MakeSales_SiteGeolocation_ExistingAccount, name = site1.Name, Region__c='Europe', 
                                 Sector__c='Technology',Account_Ownership__c='Sectors', BillingCity=site1.City__c, BillingState=site1.State__c, 
                                 BillingStreet=site1.Street__c,BillingCountry=site1.Country__c, BillingPostalCode=site1.Zip_Postal_Code__c);
        update acc;
        List<Account> accListGeo =[select id, Name,BillingAddress,BillingCity,BillingState,BillingStreet,BillingCountry,BillingPostalCode,BillingLatitude,BillingLongitude from Account where id =: acc.id ];
        List<Site__c> siteListGeo =[select id, Name,Geo__Longitude__s,Geo__Latitude__s from Site__c where id =: site1.id ];
        
        
        if(site1.Name==acc.name){
            System.debug(accListGeo);
            System.debug(acc.BillingLatitude);
            System.debug(String.valueOf(acc.BillingLongitude));
            System.assertEquals(siteListGeo[0].Geo__Longitude__s, accListGeo[0].BillingLongitude);
            System.assertEquals(siteListGeo[0].Geo__Latitude__s, accListGeo[0].BillingLatitude);
            
            
        }
        
        
        
        
    }
    
}