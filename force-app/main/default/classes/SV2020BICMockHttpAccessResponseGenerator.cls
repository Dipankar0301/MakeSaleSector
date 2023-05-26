@isTest
global class SV2020BICMockHttpAccessResponseGenerator implements HttpCalloutMock {
// Implement this interface method
global HTTPResponse respond(HTTPRequest req) {

// Create a fake response
        HttpResponse res2 = new HttpResponse();
        res2.setHeader('Content-Type', 'application/json');
        res2.setStatusCode(200);
       // res2.setBody('{"access_token": "4eb1504f513fcde8abeeefd074bde077195487f1", "expires_in": 86400,  "token_type": "bearer",    "scope": null,    "refresh_token": "60fef185a8548fbae70234cf203fbee2a4a98f63",    "systems": [        {            "client_name": "Brightidea IdeaSpace",            "host_name": "bi.brightidea.com",            "system_id": "7BEE0F85-FA84-4CA2-B458-43B4117BB927"        },        {            "client_name": "Brightidea developer portal",            "host_name": "developer.brightidea.com",            "system_id": "797B1E97-88E2-4874-80FF-9432F420E561"        },        {            "client_name": "Shell",            "host_name": "shell.brightidea.com",            "system_id": "34AB254E-B15E-11E8-AA5A-0A720A822D3C"        }    ],    "user_id": "4AFB8D9C-70E4-11E9-A306-0A720A822D3C"}');
       res2.setBody(getAccessTokenJSONBody());
        system.debug(res2.getBody());
        return res2;
 
}
global string getAccessTokenJSONBody(){
String json2 = '{"access_token": "4eb1504f513fcde8abeeefd074bde077195487f1"}';
return json2;
}

}