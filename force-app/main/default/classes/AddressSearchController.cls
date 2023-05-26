/******************************************************************************************
Class Name:  AddressSearchController
Description: This class is used t0 call google location API for auto complete functionality
******************************************************************************************/
public class AddressSearchController {
    
    //Method to get address details in the initial load
    @AuraEnabled
    public static site__c getAddressDetailsbyId(String id){
        site__c ad = new site__c();
        ad = [select Id, Sector_City__c, State__c, Sector_Country__c, Zip_Postal_Code__c, Street__C  from site__c where Id=: id];
        return ad;
    }
    
    //Method to save address details on click on Save button
    @AuraEnabled
    public static String saveAddressDetailsbyId(String id, Site__c addDetails){
        system.debug('saveAddressDetailsbyId method');
        site__c obj = [select Id from site__c where Id=: id];
        obj.Sector_City__c = addDetails.Sector_City__c;
        obj.State__c = addDetails.State__c;
        obj.Sector_Country__c = addDetails.Sector_Country__c;
        obj.Zip_Postal_Code__c = addDetails.Zip_Postal_Code__c;
        obj.Street__c = addDetails.Street__c;
        update obj;
        return 'Success';
    }
    
    //Method to call google API and fetch the address recommendations 
    @AuraEnabled
    public static String getAddressSet(String SearchText){
        String APIKey = 'AIzaSyAR_L9rAbRKi9-Kzffd7e60aQsf2T9AgHk';
        String result = null;
        system.debug('SearchText is ' + SearchText);
        try{
            if(SearchText != null){
                String APIUrl = 'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=' + SearchText.replace(' ', '%20') + '&key=' + APIKey; 
                system.debug('APIUrl is ' + APIUrl);
                HttpRequest req = new HttpRequest();
                req.setMethod('GET');
                req.setEndpoint(APIURL);
                Http http = new Http();
                HttpResponse res = http.send(req);
                Integer statusCode = res.getStatusCode();
                system.debug('statusCode is ' + statusCode);
                if(statusCode == 200){
                    system.debug('API invoked successfully');
                    result = res.getBody();
                }
            }
        }
        catch(exception e){
            //Handling exception
            system.debug(e.getMessage());
        }
        return result;
    }
    
    //Method to call google API and fetch the address details by addressID 
    @AuraEnabled
    public static String getAddressDetailsByPlaceId(String PlaceID){
        String APIKey = 'AIzaSyAR_L9rAbRKi9-Kzffd7e60aQsf2T9AgHk';
        String result = null;
        system.debug('SearchText is ' + PlaceID);
        try{
            if(PlaceID != null){
                String APIUrl = 'https://maps.googleapis.com/maps/api/place/details/json?placeid=' + PlaceId.replace(' ', '%20') + '&key=' + APIKey; 
                system.debug('APIUrl is ' + APIUrl);
                HttpRequest req = new HttpRequest();
                req.setMethod('GET');
                req.setEndpoint(APIURL);
                Http http = new Http();
                HttpResponse res = http.send(req);
                Integer statusCode = res.getStatusCode();
                system.debug('statusCode is ' + statusCode);
                if(statusCode == 200){
                    system.debug('API invoked successfully');
                    result = res.getBody();
                }
            }
        }
        catch(exception e){
            //Handling exception
            system.debug(e.getMessage());
        }
        return result;
    }
}