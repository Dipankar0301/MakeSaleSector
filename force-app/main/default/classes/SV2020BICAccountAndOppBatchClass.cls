/***
Class Name: SV2020BICAccountAndOppBatchClass 
Created Date: 'Nov 05, 2020'
Description: SV2020BICAccountAndOppBatchClass is the batch class daily executed daily and process the BIC ideas. 
if idea name matches with SV2020 account name(matche 70% -fuzzy logic), then it will update matched account's chatter feed. Otherwise it will create new 
account and opportunity in Salesforce(SV2020 app).
***/
global class SV2020BICAccountAndOppBatchClass implements Database.Batchable<Object>, Database.AllowsCallouts, Database.Stateful{
    Map<String, Object> processResult;
    public class ideawrapper{       
        public String ideaname{get;set;}
        public String status{get;set;}
        public String trackingURL{get;set;}    }    
    list<ideawrapper> ideastatisticslist = new list<ideawrapper>();
    Map<string,string> getResult = new Map<string,string>();
    Map<string,map<string,string>> ideaStatisticsResult = new Map<string,map<string,string>>();
    List<Account> accountList;    
    List<Object> ideaList;
    Integer totalIdeas;
    String ideaCreatedDate;   
    String createdDate;
    //public static string VIEW_URL = system.URL.getSalesforceBaseUrl().toExternalForm();
    
    global SV2020BICAccountAndOppBatchClass(String date_created ){       
        this.ideaCreatedDate = date_created ; 
             
    }    
    global Iterable<Object> start(Database.BatchableContext BC){
    //Date dT=date.valueOf(ideaCreatedDate);
        // system.debug('***dT**333'+dT);
        //createdDate= String.valueof(dT.Month())+'/'+String.valueof(dT.day())+'/'+String.valueof(dT.year());
        //Get the BIC Token.
        string token = null;        
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(system.label.SV2020BICauthenticationUrl);
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
        request.setTimeout(2*60*1000);
        // Set the body as a JSON object
        request.setbody('grant_type=password&client_id='+system.label.SV2020ClientID+'&client_secret='+system.label.SV2020ClientSecret+'&username='+system.label.SV2020BICusername+'&password='+system.label.SV2020BICpassword+'');
        
        HttpResponse response = http.send(request);
        // Parse the JSON response
        if (response.getStatusCode() == 200) {
            Map<String, Object> tokenResult = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            token = String.valueOf(tokenResult.get('access_token')); 
        }   
        String campaign_id = system.label.SV2020SVXCampaignID;
        //system.debug('***ideaCreatedDate333***'+ideaCreatedDate);
        Map<String, Object> result = SV2020BrightIdeaCentralHttpRequest.fetchIdeas(token, ideaCreatedDate,campaign_id);
        if(!result.isEmpty() && result.keyset() !=null){
            this.ideaList= (List<Object>)result.get('ideas');
            this.totalIdeas=integer.valueof(result.get('TotalIdeas'));  
        }
        return this.ideaList;
    }
    
    global void execute(Database.BatchableContext BC, List<Object> scope){
       for(Object i: scope){            
            Map<String, Object> idea = (Map<String, Object>)i;
            String ideaname = String.valueOf(idea.get('title'));
            String website = String.valueOf(idea.get('url'));
            String ideadescription = String.valueOf(idea.get('description'));
            String description  = ideadescription.replaceAll('\\<.*?\\>', '');            
            ideaname  = ideaname.replaceAll('\\<.*?\\>', ''); 
            getResult = SV2020BrightIdeaCentralDuplicate.CreateAccount(ideaname, website, description); 
            //if(getResult !=null){
                //ideaStatisticsResult.put(ideaname,getResult); // Store all idea results.           
            //}            
            if(getResult !=null && getResult.get('status')=='Updated Successfully'){
                ideawrapper ideawrp = new ideawrapper();
                ideawrp.ideaname = ideaname;
                ideawrp.status= system.label.SV2020BICIdeaUpdatedStatus;
                ideawrp.trackingURL=getResult.get('trackinglink');                        
                ideastatisticslist.add(ideawrp);  
            }
            else if(getResult !=null && getResult.get('status')=='Inserted Successfully'){
                ideawrapper ideawrp2 = new ideawrapper();                
                ideawrp2.ideaname = ideaname;
                ideawrp2.status= system.label.SV2020BICIdeaInsertedStatus;
                ideawrp2.trackingURL=getResult.get('trackinglink');                        
                ideastatisticslist.add(ideawrp2);  
            }
            else if(getResult !=null && getResult.get('status')=='failed'){
                ideawrapper ideawrp3 = new ideawrapper();               
                ideawrp3.ideaname = ideaname;
                ideawrp3.status= getResult.get('error');
                ideawrp3.trackingURL=getResult.get('trackinglink');                        
                ideastatisticslist.add(ideawrp3);  
            }
            
        }
    }
    
    global void finish(Database.BatchableContext BC){
        //system.debug('***createdDate***'+createdDate);
        //System.debug('*** REACHED HERE getResult***333'+getResult);
        //System.debug('*** REACHED HERE ideaStatisticsResult***333'+ideaStatisticsResult);
        
            List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();        
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();        
            List<String> sendTo = new List<String>();
            List<String> sendCC = new List<String>();
            for(SV2020_Integration_with_BIC__mdt sv2020Add : [SELECT id,To_Address__c FROM SV2020_Integration_with_BIC__mdt WHERE To_Address__c !=null]){
                sendCC.add(sv2020Add.To_Address__c);
            }
            sendTo.add(system.label.SV2020BICMailToAddress);
            email.setToAddresses(sendTo);
            email.setCCAddresses(sendCC);
            email.setReplyTo('no-reply@salesforce.com');
            email.setSenderDisplayName(system.label.SV2020SenderDisplayName);

            email.setSubject(system.label.SV2020BICMailsubjectpart1+' '+ideaCreatedDate +' '+system.label.SV2020BICMailsubjectpart2);
            //background-color: grey
            String EmailBody = '';
            EmailBody += system.label.SV2020BICEmailBodyPart1; 
            EmailBody += '<br>'; 
            EmailBody += 'Total number of ideas Created = '+ totalIdeas+'<br>'; 
            EmailBody += 'Number of ideas Processed = '+ ideaList.size() +'<br>'; 
            //Include HTML template only if are there ideas.
            if(ideaList.size() >0){
                EmailBody += '<html> <head> <style> thead table { width:100%;} table, th, td { border: 1px solid black; border-collapse: collapse;} th, td {padding: 12px;text-align: left;} #t01 tr:nth-child(even) {background-color: #eee;}#t01 tr:nth-child(odd) {background-color: #fff;}#t01 th {background-color: black;color: white;}</style></head><b>Please see the Processed Idea Details below</b> <table> <thead style="color:black;background-color: lightgrey"> <tr><th>Idea Name</th><th>Status</th> <th>Tracking link</th></tr> </thead><tbody> ';
                for(ideawrapper idea: ideastatisticslist){          
                    EmailBody += '<tr> <td>'+idea.ideaname+'</td> <td>'+idea.status+'</td> <td>'+idea.trackingURL +'</td> </tr>'  ;         
                }
                    EmailBody += ' </tbody></table> </html>';
            }
            //EmailBody += 'Company Name: '+companyname+', '+ 'Website: '+Website+', '+'Description: '+Description +'<br>';
            //EmailBody += '<br> <b>Matched Account Details: </b><br>';
            //EmailBody += 'Matched account: '+ String.valueOf(bestAccountMatched)+'<br>'+ '<b>Tracking link: </b>'+trackinglink+'<br>';
            EmailBody += '<br>Thanks,<br>SV2020 Salesforce Team';
            email.setHtmlBody(EmailBody);        
            mails.add(email);
            Messaging.sendEmail(mails);
            //system.debug('***mails*** 333'+mails);
        
        system.debug('***Reached to Finish Methis***');
    }
}