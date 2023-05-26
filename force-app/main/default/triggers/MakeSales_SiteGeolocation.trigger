trigger MakeSales_SiteGeolocation on Site__c (before insert,before update) {
/*
    Id recordtypeidorgaccount= Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId();
    List<Account> accList = new List<Account>();
    List<Site__c> siteTriggerList=new List<Site__c>();
    if(Trigger.new.size()==1){
    for(Site__c site: Trigger.new){
        siteTriggerList.add(site);
        
    }
    List<Site__c> siteList=new List<Site__c>();
    for(Site__c site: siteTriggerList){
            Account acc =new Account(Id=System.Label.MakeSales_SiteGeolocation_ExistingAccount, Name = site.Name, Region__c='Europe', 
                                     Sector__c='Technology',Account_Ownership__c='Sectors', BillingCity=site.City__c, BillingState=site.State__c, 
                                     BillingStreet=site.Street__c,BillingCountry=site.Country__c, BillingPostalCode=site.Zip_Postal_Code__c);
        accList.add(acc);
    }
    
        update accList;
    List<Account> accListGeo =[select id, Name,BillingAddress,BillingCity,BillingState,BillingStreet,BillingCountry,BillingPostalCode,BillingLatitude,BillingLongitude from Account where id in: accList ];
   System.debug('Line 21' +accList);
        System.debug('Line 22'+AccListGeo);
        //Map<String,Account> accMapGeo = new Map<String,Account>();
    
    //for(Account acc : accListGeo){
      //  accMapGeo.put(acc.Name,acc);
    //}
    System.debug('1');
    for(Site__c site: siteTriggerList){
        System.debug('2');
        for(Account acc:accListGeo){
            System.debug('3');
            if(site.Name==acc.name){
                System.debug('4');
                System.debug(accListGeo);
                System.debug(acc.BillingLatitude);
                System.debug(String.valueOf(acc.BillingLongitude));
                //site.Location_latitude__c=String.valueOf(acc.BillingLatitude);
                site.Geo__Longitude__s=acc.BillingLongitude;
                site.Geo__Latitude__s=acc.BillingLatitude;
                //site.Location_Longtiude__c=String.valueOf(acc.BillingLongitude);
                siteList.add(site);
            }
        }
    }
    //insert siteList;
    //delete accList;
    }
  */   
}