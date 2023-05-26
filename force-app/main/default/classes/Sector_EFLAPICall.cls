public class Sector_EFLAPICall {
    public static void callApi(){
        Http httpProtocol = new Http();
        //Create HTTP request to send
        HttpRequest request = new HttpRequest();
        
        String apiKey;
        //System.debug('line 14 in geocodeAddress'+apiKey);
        //String endpoint = 'https://carbonmanagementprod.auth.us-east-1.amazoncognito.com/oauth2/token';
        //System.debug('Line 11 in http'+ endpoint);
        request.setEndpoint('https://carbonmanagementprod.auth.us-east-1.amazoncognito.com/oauth2/token');
        request.setMethod('POST');
        request.setHeader('Content-Type','application/json;charset=UTF-8');
        request.setBody('{"input_quantity": 60.4,"input_uom": "MT (Metric Tonnes)","product": "Bitumen","region": "Australia"}');
        request.setTimeout(120000);
        HttpResponse response = httpProtocol.send(request);
        System.debug('Line 17');
		System.debug(response.getStatusCode());
        System.debug(response.getBody());
        
        
        /* "ProductList" : [ {
"input_quantity" : "11",
"input_uom" : "MT (Metric Tonnes)",
"product" : "Bitumen",
"region" : "Australia"
}*/
    }
}