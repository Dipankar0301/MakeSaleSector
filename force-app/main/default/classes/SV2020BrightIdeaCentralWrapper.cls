/***
Class Name: SV2020BrightIdeaCentralWrapper 
Created Date: 'Nov 05, 2020'
Last Modified: 'Nov 05, 2020'
Description: SV2020BrightIdeaCentralWrapper is created to return the response in message format, while process the ideas(Sync the ideas with SV2020 Accounts). 
If idea name matches with SV2020 account name(matche 70% -fuzzy logic), then it will update matched account's chatter feed. Otherwise it will create new 
account and opportunity in Salesforce(SV2020 app).
***/
public class SV2020BrightIdeaCentralWrapper {
    public static String ERROR_MESSAGE_VALID_COMPANY_NAME = 'Enter a Valid Company Name';
    public static String ERROR_MESSAGE_VALID_WEBSITE = 'Enter a Valid Website';
    public static String ERROR_MESSAGE_VALID_COMPANY_ID = 'Enter a Valid Company Id';
    public static String ERROR_MESSAGE_VALID_OPPORTUNITY_ID = 'Enter a Valid Opportunity Id';
    public static String ERROR_MESSAGE_INCORRECT_ACCOUNT_ID = 'Problem fetching Company. Please ensure that you have sent correct Company Id';
    public static String ERROR_MESSAGE_INCORRECT_OPPORTUNITY_ID = 'Problem fetching Opportunity. Please ensure that you have sent correct Company Id';
    public static String ERROR_MESSAGE_INCORRECT_ACCOUNT_AND_OPPORTUNITY_ID = 'Problem fetching Comapany and Opportunity. Please ensure that you have sent correct Company and Opportunity Ids';
    
    public static String RECORD_TYPE = 'SV2020 Account Record Type';
    public static Integer RECORD_LIMIT = 49000;
    
    //public static String VIEW_URL = system.label.SV2020AccountURL;
    public static string VIEW_URL = system.URL.getSalesforceBaseUrl().toExternalForm();
    //'https://newenergies--h2opsdev2.lightning.force.com/lightning/r/Account/';
    //public static String VIEW_URL = URL.getSalesforceBaseUrl().toExternalForm();
    //https://newenergies--h2opsdev2.my.salesforce.com0013L00000669HZQAY/view
    
    public static String EMAIL_BODY_1 = 'Please see the Idea details below and take Action, whether to Create New Account and Opportunity or to update the matched Account Chatter feed by using the below Tracking link';
    //'To be discussed with Akshat';
    
    public static String UserId = System.Label.SV2020BICIntegerationUserId; // Change to Aimee Lafur
    
    public static String ACTION = 'Email Sent to Aimee to take Action';
    
    public static String getMessage(String companyname, Account bestMatch, Double ratio){
        Map<String, String> message = new Map<String,String>();     
        message.put('matched account', String.valueOf(bestMatch));
        message.put('company name', companyname);
        message.put('action','No Action Required, Updated the best matched Opportunity Chatter Feed');
        if(ratio >=50.0 && ratio <= 70.0){
            message.put('action', ACTION);
        }
        return String.valueOf(message);
    }
    
    public static boolean isValidUrl(String url){
        try{
            URL mUrl = new URL(url);
            return true;
        }
        catch(Exception e){
            return false;
        }
    }
    
    public static Map<String, String> getResult(String status, String error, String message, String companyId,String opportunityId, Decimal ratio){
        Map<String, String> result = new Map<String, String>();
        
        String trackinglink = null;
        
        if(companyId != null){
            trackinglink = VIEW_URL+'/lightning/r/Account/'+companyId+'/view';
        }
        result.put('timestamp', String.valueOf(DateTime.now()));
        result.put('status', status);
        result.put('error', error);        
        result.put('trackinglink', trackinglink);
        result.put('companyId', companyId);
        result.put('opportunityId', opportunityId);
        result.put('match', String.valueOf(ratio));
        result.put('message', message);
        
        return result;
    }
    
    /***public static Double LevenshteinDistance(String A, String B){
        Double ratio = 0.0;
        Integer rows = A.length() + 1;
        Integer columns = B.length() + 1;
        Integer cost,row,col;
        List<List<Integer>> distance = new List<List<Integer>>();
        
        for(Integer i=0; i<rows; ++i){
            List<Integer> dis = new List<Integer>();
            for(Integer j=0; j<columns; ++j){
                dis.add(0);
            }
            distance.add(dis);
        }
        
        for(Integer i=1; i<rows; i++){
            for(Integer j=1; j<columns; ++j){
                distance[i][0] = i;
                distance[0][j] = j;
            }
        }
        
        for(col=1; col<columns; ++col){
            for(row=1; row<rows; ++row){
                if(A.charAt(row-1) == B.charAt(col-1)){
                    cost = 0;
                }
                else{
                    cost = 2;
                }
                distance[row][col] = Math.min(Math.min(distance[row-1][col] + 1, distance[row][col-1] + 1),distance[row-1][col-1] + cost);
            }
        }
        //Levenshtein Distance
        ratio = Double.valueOf(((A.length() + B.length()) - distance[rows-1][columns-1]))/Double.valueOf((A.length() + B.length())) * 100.0;
        Integer roundOff = Integer.valueOf(ratio * 100.0);
        return Double.valueOf(roundOff)/100.00;
    } ***/
    
    /*** public static void sendEmail(Double Ratio,String companyname, String body,String Website, String Description,Account bestAccountMatched,ID companyId){
        String trackinglink = null;
        
        if(companyId != null){
            trackinglink = VIEW_URL+companyId+'/view';
        }
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        
        List<String> sendTo = new List<String>();
        for(SVX_Integration_with_SV2020__mdt sv2020Add : [SELECT id,To_Addresses__c   FROM SVX_Integration_with_SV2020__mdt WHERE To_Addresses__c !=null]){
            sendTo.add(sv2020Add.To_Addresses__c);
        }
        sendTo.add('sahil.khosla@shell.com');
        email.setToAddresses(sendTo);
        
        email.setReplyTo('no-reply@salesforce.com');
        
        email.setSenderDisplayName('SV2020 Salesforce - Bright Idea Central');
        
        email.setSubject('Take Action for Idea - ' + companyname);
        
        String EmailBody = '';
        EmailBody += 'Dear Aimee, <br>';
        EmailBody += '<br>'+body+'<br>';
        EmailBody += '<b>Idea Details: </b> <br>';
        EmailBody += 'Company Name: '+companyname+', '+ 'Website: '+Website+', '+'Description: '+Description +'<br>';
        EmailBody += '<br> <b>Matched Account Details: </b><br>';
        EmailBody += 'Matched account: '+ String.valueOf(bestAccountMatched)+'<br>'+ '<b>Tracking link: </b>'+trackinglink+'<br>';
        EmailBody += '<br>Thanks,<br>SV2020 Salesforce Team';
        email.setHtmlBody(EmailBody);
        
        mails.add(email);
        Messaging.sendEmail(mails);
        
        return;
    }
    ***/
    
    public static void postOnFeed(Account acc, String companyname,String website,String description){
    
        //Check whether Account has opportunity or not, if it is present update opportunity chatter feed, else create new opp and update that opportunity chatter feed.
        List<FeedItem> feedList = new List<FeedItem>();
        Id oppRecordTypeid = Schema.SObjectType.Opportunity__c.getRecordTypeInfosByName().get('Invest').getRecordTypeId();
        list<opportunity__c> opplist = [SELECT id,name,Account__c FROM opportunity__c WHERE Account__c =: acc.Id and RecordTypeId =: oppRecordTypeid  order by createddate desc LIMIT 1];
        try{
            //Update Account Chatter Feed.
            FeedItem postacc = new FeedItem(CreatedById= UserId,ParentId = acc.Id,Title = acc.Name, Body = system.label.SV2020BICChatterUpdateText+' '+website);
            feedList.add(postacc);
            if(opplist !=null && opplist.size() > 0){
                //Update Account's latest Invest Opportunity Chatter Feed.
                FeedItem postOpp = new FeedItem(CreatedById= UserId,ParentId = opplist[0].Id,Title = opplist[0].Name, Body = system.label.SV2020BICChatterUpdateText+' '+website);
                feedList.add(postOpp);
            }else{
                Opportunity__c opp = new Opportunity__c();
                if(companyname.length()>80){
                    companyname = companyname.substring(0,70);
                }
                opp.Name = companyname + ' - '+ system.label.SV2020BICOppNameRound;
                opp.Account__c = acc.id;
                opp.Round__c = system.label.SV2020BICOppNameRound;
                opp.RecordTypeId =  Schema.SObjectType.Opportunity__c.getRecordTypeInfosByName().get('Invest').getRecordTypeId();
                opp.Type_of_Investment__c = 'Warrants';
                opp.Stage__c = 'Unreviewed';
                opp.IC__c = 'SVX';
                opp.Fund__c = 'Business Funded';
                opp.Description__c = description;
                opp.Business_Grouping_1__c = 'Cross Business (all lines of business)';
                opp.Business_Grouping_2__c = 'PTX';
                opp.BOM__c = SV2020BrightIdeaCentralWrapper.userId;
                opp.CreatedById = SV2020BrightIdeaCentralWrapper.UserId;
                opp.OwnerID= SV2020BrightIdeaCentralWrapper.UserId;
                insert opp;
                //Update Account's newly created Invest Opportunity Chatter Feed.
                FeedItem postNewOpp = new FeedItem(CreatedById= UserId,ParentId = opp.Id,Title = opp.Name, Body = system.label.SV2020BICChatterUpdateText+' '+website);
                feedList.add(postNewOpp);
            }
            if(feedList.size()>0){
                insert feedList;
            }
        }catch(Exception exp){
            system.debug('Error occured in SV2020BrightIdeaCentralWrapper class'+ exp);                
        }

        
    }
}