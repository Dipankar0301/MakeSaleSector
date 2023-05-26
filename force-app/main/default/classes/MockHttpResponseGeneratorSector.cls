@isTest
global class MockHttpResponseGeneratorSector implements HttpCalloutMock {

    
    // Implement this interface method
    global HTTPResponse respond(HTTPRequest req) {
        // Optionally, only send a mock response for a specific endpoint
        // and method.
        //System.assertEquals('https://example.com/example/test', req.getEndpoint());
        //System.assertEquals('GET', req.getMethod());
        
        // Create a fake response
        HttpResponse res = new HttpResponse();
        //res.setHeader('Content-Type', 'application/json');
        //res.setBody('{"results":[{"address_components":[{"long_name":"Balurghat","short_name":"Balurghat","types":["locality","political"]},{"long_name":"DakshinDinajpur","short_name":"DakshinDinajpur","types":["administrative_area_level_2","political"]},{"long_name":"WestBengal","short_name":"WB","types":["administrative_area_level_1","political"]},{"long_name":"India","short_name":"IN","types":["country","political"]}],"formatted_address":"Balurghat,WestBengal,India","geometry":{"bounds":{"northeast":{"lat":25.266121,"lng":88.8085413},"southwest":{"lat":25.2110178,"lng":88.7531161}},"location":{"lat":25.2372834,"lng":88.78306120000001},"location_type":"APPROXIMATE","viewport":{"northeast":{"lat":25.266121,"lng":88.8085413},"southwest":{"lat":25.2110178,"lng":88.7531161}}},"partial_match":true,"place_id":"ChIJzckkt85h-zkRs5G_GU07SLY","types":["locality","political"]}],"status":"OK"}');
        //res.setStatusCode(400);
        res.setStatus('ZERO_RESULTS');
        return res;
    } 
}