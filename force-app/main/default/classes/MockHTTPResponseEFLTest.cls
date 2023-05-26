@isTest
global class MockHTTPResponseEFLTest implements HttpCalloutMock {
    global HTTPResponse respond(HTTPRequest req) {
        
        HttpResponse res = new HttpResponse();
        //res.setHeader('Content-Type', 'application/json');
        res.setBody('{error={code=500, message=product not found: Bitumen}}');
        res.setStatusCode(200);
        return res;
    }
}