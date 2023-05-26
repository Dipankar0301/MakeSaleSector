/***
Class Name: SV2020BrightIdeaCentralHttpRequest 
Created Date: 'Nov 05, 2020'
Description: SV2020BrightIdeaCentralHttpRequest is created to fetch ideas(using Access Bearer Token) from BIC by making htp callouts and 
return the fetched ideas to SV2020BICAccountAndOppBatchClass.
***/
public class SV2020BrightIdeaCentralHttpRequest {
  private static string authenticationUrl = 'https://auth.brightidea.com/_oauth2/token';
    private static string ideasUrl = system.label.SV2020BICideasUrl; 
    public static Map<String, Object> fetchIdeas(String token, String date_created ,String campaign_id){
        List<Account> accounts = new List<Account>();
        List<Object> ideas = new List<Object>();
       // string date_created2='10/14/2020';
        Integer page = 1;
        Integer currentPage = 0;
        Integer pageCount = 0;
        Integer totalIdeas = 0;
        
        do{
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            //https://shell.brightidea.com/api3/idea?date_created=10/16/2020&campaign_id=CD5D113B-0BD7-11EA-B69C-0A420302F982&page_size=50&page=1
            //System.debug('***EndPoint URL***'+ideasUrl+'?date_created='+date_created+'&campaign_id='+campaign_id+'&page_size='+system.label.SV2020BICpagesize+'&page='+String.valueOf(page));
            if(date_created != null){
                request.setEndpoint(ideasUrl+'?date_created='+date_created+'&campaign_id='+campaign_id+'&page_size='+system.label.SV2020BICpagesize+'&page='+String.valueOf(page));
            }else{
                //System.debug('***Else   EndPoint URL***'+ideasUrl+'?campaign_id='+campaign_id+'&page_size='+system.label.SV2020BICpagesize+'&page='+String.valueOf(page));
                request.setEndpoint(ideasUrl+'?campaign_id='+campaign_id+'&page_size='+system.label.SV2020BICpagesize+'&page='+String.valueOf(page));
            }
            request.setMethod('GET');
            request.setHeader('Content-Type', 'application/x-www-form-urlencoded');
            request.setHeader('Authorization', 'Bearer '+token);
            request.setTimeout(2*60*1000);
        
            HttpResponse response = http.send(request);
            
            if(response.getStatusCode() == 200){
                //update page
                Map<String, Object> results = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                if(!results.isEmpty() && results.get('idea_list') !=null){
                    List<Object> ideasFetched = (List<Object>)results.get('idea_list');
                    if(ideasFetched !=null){
                        ideas.addAll(ideasFetched);
                    }
                 }
                 if(!results.isEmpty() && results.get('stats') !=null){
                    Map<String, Object> stats = (Map<String, Object>)results.get('stats');
                    if(!stats.isEmpty() && stats.keyset() !=null){
                        currentPage = (Integer)stats.get('current_page');
                        pageCount = (Integer)stats.get('page_count');                        
                        totalIdeas = (Integer)stats.get('total');
                    }
                }
            }
            page++;
        }
        while(page <= pageCount);

        if(ideas.size() < totalIdeas){
            // Error Fetching Ideas
        }
        
        
        Map<String, Object> result = new Map<String, Object>();
        result.put('ideas',ideas);
        //result.put('IdeaFetchErrors');
        //result.put('DuplicateIdeas');
        //add best matched accounts tracking links
        result.put('IdeasToBeProcessed', ideas.size());
        result.put('TotalIdeas', totalIdeas);
        //System.debug('***************************MAPPPP**********************');
        //System.debug(result);         
      return result;   
    }
}