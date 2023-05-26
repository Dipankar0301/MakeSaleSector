@isTest
global class SV2020BICMockHttpResponseGenerator implements HttpCalloutMock {
// Implement this interface method

global HTTPResponse respond(HTTPRequest req) {

// Create a fake response
HttpResponse res = new HttpResponse();
res.setHeader('Content-Type', 'application/json');
res.setBody(getJSONBody());
res.setStatusCode(200);
return res;
}


global string getJSONBody()
{

   Datetime Yesterday= Date.today().addDays(-1);
    String date_created = Yesterday.format('MM/dd/YYYY'); 

String json='{"access_token\": \"4eb1504f513fcde8abeeefd074bde077195487f1\","idea_list": [{\"date_created\": \"2020-10-29 18:46:08\",\"date_modified\": \"2020-09-25 13:44:00\",\"title\": \"Mosaic Materials\",\"description\": \"test"},{\"date_created\": \"2020-10-29 18:46:08\",\"date_modified\": \"2020-09-25 13:44:00\",\"title\": \"Shell Ventures\",\"description\": \"test"}],"stats": {"current_page": 1, "page_count": 1, "total": 2}}';
return json; 
}


}