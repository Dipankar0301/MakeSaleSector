public class SiteGeocodeAddress {
    public static boolean isSandbox= [SELECT IsSandbox FROM Organization LIMIT 1].IsSandbox;
    public static Sector_GeoCodeResponse getGeoCodeAddress(String Address) {
        
        System.debug('line 34' + address);
        
        Http httpProtocol = new Http();
        //Create HTTP request to send
        HttpRequest request = new HttpRequest();
        address = EncodingUtil.urlEncode(address, 'UTF-8');
        GeoCodingAPI__c settings = isSandbox == true ? GeoCodingAPI__c.getInstance('Sandbox'): GeoCodingAPI__c.getInstance('Production');
        System.debug('line 11'+isSandbox);
        System.debug('line 12 in geocodeAddress'+settings);
        String apiKey = settings.API_Key__c;
        System.debug('line 14 in geocodeAddress'+apiKey);
        //Address = EncodingUtil.urlEncode(Address, 'UTF-8');
        String endpoint = 'https://maps.googleapis.com/maps/api/geocode/json?address='+Address+'&key='+apiKey;
        System.debug('Line 11 in http'+ endpoint);
        request.setEndpoint(endpoint);
        request.setMethod('GET');
        request.setTimeout(120000);
        HttpResponse response = httpProtocol.send(request);
        System.debug('In SiteGeocodeAddress line 18');
        System.debug(response.getBody());
        
        return Sector_GeoCodeResponse.parse(response.getBody());
        
    }
    
}