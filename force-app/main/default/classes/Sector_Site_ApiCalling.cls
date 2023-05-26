public class Sector_Site_ApiCalling {
/*    public static Integer countCallout1=0;
    public static Boolean hasInsertRunSite = true;
    public static void GetAddressInsert(List<Site__c> newList, Map<Id, Site__c> newMap)
    {
        String SectorRecordTypeId = Schema.SObjectType.Site__c.getRecordTypeInfosByName().get('Sector').getRecordTypeId();
        //Map<id,Site__c> SiteRecords = New List<id,Site__c>();
        for(Site__c site:newList){
            if(site.RecordTypeId == SectorRecordTypeId){
                String address ='';
                if (site.Street__c != null) {
                    String sText = site.Street__c;
                    sText= sText.replaceAll( '\\s+', '');
                    address += sText  ;
                }
                if (site.City__c != null) {
                    String sText = site.City__c;
                    sText= sText.replaceAll( '\\s+', '');
                    address += sText;
                }
                //if (site.State__c != null) {
                //address += site.State__c;
                //}
                if (site.Zip_Postal_Code__c != null) {
                    address += site.Zip_Postal_Code__c;
                }
                if (site.Sector_Country__c != null) {
                    String sText = site.Sector_Country__c;
                    sText= sText.replaceAll( '\\s+', '');
                    address += sText;
                }
                //SiteRecords.put(site.id,address);
                callingApi(site.id, address);
            }
        }
        //callingApi(SiteRecords);
    }
    public static void GetAddressUpdate(List<Site__c> oldList, List<Site__c> newList, 
                                        Map<Id, Site__c> oldMap, Map<Id, Site__c> newMap)
    {
        if(hasInsertRunSite){
        String SectorRecordTypeId = Schema.SObjectType.Site__c.getRecordTypeInfosByName().get('Sector').getRecordTypeId();
        String addressNew;
        String addressOld;
         System.debug('line 43');
                System.debug(newList);
        System.debug(oldList);
            for(Site__c site:newList){
                if(site.RecordTypeId == SectorRecordTypeId){
                    addressNew ='';
                    if (site.Street__c != null) {
                        String sText = site.Street__c;
                        sText= sText.replaceAll( '\\s+', '');
                        addressNew += sText  ;
                    }
                    if (site.City__c != null) {
                        String sText = site.City__c;
                        sText= sText.replaceAll( '\\s+', '');
                        addressNew += sText;
                    }
                    if (site.Zip_Postal_Code__c != null) {
                        addressNew += site.Zip_Postal_Code__c;
                    }
                    if (site.Sector_Country__c != null) {
                        String sText = site.Sector_Country__c;
                        sText= sText.replaceAll( '\\s+', '');
                        addressNew += sText;
                    }
                }
                Site__c siteold= oldMap.get(site.id);
                System.debug('line 67');
                System.debug(siteold);
                //for(Site__c siteold:oldList){
                        addressOld ='';
                        if (siteold.Street__c != null) {
                            String sText = siteold.Street__c;
                            sText= sText.replaceAll( '\\s+', '');
                            addressOld += sText  ;
                        }
                        if (siteold.City__c != null) {
                            String sText = siteold.City__c;
                            sText= sText.replaceAll( '\\s+', '');
                            addressOld += sText;
                        }
                        if (siteold.Zip_Postal_Code__c != null) {
                            addressOld += siteold.Zip_Postal_Code__c;
                        }
                        if (siteold.Sector_Country__c != null) {
                            String sText = siteold.Sector_Country__c;
                            sText= sText.replaceAll( '\\s+', '');
                            addressOld += sText;
                        }
                        System.debug(addressOld +'---'+ addressNew);
                        if(addressOld != addressNew)
                            callingApi(siteOld.id,addressNew);
                 
            //}
        }
        }
    }
    @future(callout=true)
    public static void callingApi(Id recordIdSite, String address)
    {  
        //if(SiteTriggerHelper.countCallout > 5000){
        //   System.debug('Your API callout limit for the month is exhausted.');
        //}
        //else{
        hasInsertRunSite =false;
        System.debug('line 34' + address);
        String key= System.Label.Googl*eGeoCodingAPI;
        Http httpProtocol = new Http();
        //Create HTTP request to send
        HttpRequest request = new HttpRequest();
        String endpoint = 'https://maps.googleapis.com/maps/api/geocode/json?address='+address+'&key='+key;
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        request.setTimeout(120000);
        HttpResponse response = httpProtocol.send(request);
        
        //System.debug('####Body'+ response.getBody());
        //
        double lat = null;
        double lon = null;
        if (response.getStatusCode() == 200) {
            JSONParser parser = JSON.createParser(response.getBody());
            system.debug('response::' + response.getBody());
            while (parser.nextToken() != null) {
                if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && (parser.getText() == 'location')) {
                    parser.nextToken();
                    while (parser.nextToken() != JSONToken.END_OBJECT) {
                        String txt = parser.getText();
                        parser.nextToken();
                        if (txt == 'lat') {
                            lat = parser.getDoubleValue();
                        } else if (txt == 'lng') {
                            lon = parser.getDoubleValue();
                        }
                    }
                }
            }
            Site__c updateGeo = new Site__c();
            updateGeo.id = recordIdSite;
            updateGeo.Geo__Latitude__s = lat;
            updateGeo.Geo__Longitude__s = lon;
            update updateGeo;
            countCallout1++;
        }
        if(response.getStatusCode() != 200 || test.isRunningTest()){
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            //String userID = UserInfo.getUserEmail();
            String[] toAddresses = new String[]{'karan.gupta@shell.com','dipankar.karmakar@shell.com','sherice.sutcliffe@shell.com','nagarjuna.mutte@shell.com'};
            //String[] toAddresses = new String[]{'dipankar.karmakar@shell.com'};
                
                String subject = 'Site Geolocation API call';
            String sourceUrl=URL.getSalesforceBaseUrl().toExternalForm();
            String mailBody = 'Dear User,<p> your geolocation update for Site Object record has been failed in the RES CRM: <p> <a href='+sourceUrl+'/lightning/r/Site__c/'+recordIdSite+'/view>Click here to view.</a>';
            email.setToAddresses(toAddresses);
            email.setSubject(subject);
            email.setHtmlBody(mailBody);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
        }
    }
*/
}