public class Sector_Geocode_Address {
    public static Sector_GeoCodeResponse getGeoCodeAddress(String Address) {
        string url ='https://maps.googleapis.com/maps/api/geocode/json?key=<Your Key Here>&address=' + EncodingUtil.urlEncode(Address, 'UTF-8');
        
        // Instantiate a new http object
        Http h = new Http();
        
        // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('GET');
        
        // Send the request, and return a response
        HttpResponse res = h.send(req);        
        
        return Sector_GeoCodeResponse.parse(res.getBody());         
    }
    
}