public class SV2020FileHandler {    
    public static void selectFilesByParentId(Set<ID> idSet,set<id> setDocumentIds){        
        map<Id, List<ContentVersion>> mapParentIdFiles = new map<Id, List<ContentVersion>>();        
        List<FeedItem> posts = new List<FeedItem>();
        system.debug('*** setDocumentIds ***'+setDocumentIds);
        //List<Opportunity__c> oppList = ;        
        //Get document ids from ContentDocumentLink
        //set<Id> setDocumentIds = new set<Id>();
        //if(idSet !=null){
           // for(ContentDocumentLink fileLink: [select Id, LinkedEntityId, ContentDocumentId from ContentDocumentLink where LinkedEntityId in: idSet]){
                //setDocumentIds.add(fileLink.ContentDocumentId);
            //}    
        //}       
        //Get ContentVersions from documents
        map<Id, ContentVersion> mapContentVersion = new map<Id, ContentVersion>();       
        if(setDocumentIds !=null){
            for(ContentVersion cv: [select Id, title, ContentDocumentId from ContentVersion where ContentDocumentId in: setDocumentIds]){
                mapContentVersion.put(cv.ContentDocumentId, cv);
            }       
        }       
        //Map to relate a record with his files
        system.debug('*** mapContentVersion ***'+mapContentVersion);
        if(idSet !=null){
            for(ContentDocumentLink fileLink: [select Id, LinkedEntityId, ContentDocumentId from ContentDocumentLink where LinkedEntityId in: idSet]){
                if(mapContentVersion.containsKey(fileLink.ContentDocumentId)){
                    if(mapParentIdFiles.containsKey(fileLink.LinkedEntityId)){
                        mapParentIdFiles.get(fileLink.LinkedEntityId).add(mapContentVersion.get(fileLink.ContentDocumentId));
                    }else{
                        mapParentIdFiles.put(fileLink.LinkedEntityId, new List<ContentVersion>{mapContentVersion.get(fileLink.ContentDocumentId)});
                    }
                }
            }
        }
            
        for(ContentVersion cont: mapContentVersion.values()){
            for(Opportunity__c opp: [select id, name,Account__c from Opportunity__c where id IN: idSet]){
                if(opp.Account__c !=null){
                    FeedItem post = new FeedItem(                    
                        ParentId = opp.Account__c,
                        Title = cont.Title,
                        Body = 'New file has been added in the '+Opp.Name +' Opportunity'+'\r\n'+' File Name: ' +cont.Title
                    );
                    posts.add(post);
                    system.debug('post :::::'+post);
                }
            }
        }
        for(ContentVersion cont: mapContentVersion.values()){
            for(Opportunity__c opp: [select id, name,Account__c from Opportunity__c where id IN: idSet]){
                FeedItem post = new FeedItem(
                    ParentId = opp.id,
                    Title = cont.Title,
                    Body = 'New file has been added in the '+Opp.Name +' Opportunity'+'\r\n'+' File Name: ' +cont.Title
                );
                posts.add(post);
                system.debug('post :::::'+post);
            }
        }
        if(posts.size()>0){
            insert posts; 
            system.debug('posts :::::'+ posts);
        }
    }
    
    public static void AccselectFilesByParentId(Set<ID> idSet,set<id> setDocumentIds){        
        map<Id, List<ContentVersion>> mapParentIdFiles = new map<Id, List<ContentVersion>>();        
        List<FeedItem> accposts = new List<FeedItem>();          
        //Get document ids from ContentDocumentLink
        //set<Id> setDocumentIds = new set<Id>();
        
        //if(idSet !=null){
           // for(ContentDocumentLink fileLink: [select Id, LinkedEntityId, ContentDocumentId from ContentDocumentLink where LinkedEntityId in: idSet]){
                //setDocumentIds.add(fileLink.ContentDocumentId);
           // }   
        //}       
        //Get ContentVersions from documents
        map<Id, ContentVersion> mapContentVersion = new map<Id, ContentVersion>();
        if(setDocumentIds !=null){
            for(ContentVersion cv: [select Id, title, ContentDocumentId from ContentVersion where ContentDocumentId in: setDocumentIds]){
                mapContentVersion.put(cv.ContentDocumentId, cv);
            }
        }           
        //Map to relate a record with his files
        if(idSet !=null){
            for(ContentDocumentLink fileLink: [select Id, LinkedEntityId, ContentDocumentId from ContentDocumentLink where LinkedEntityId in: idSet]){
                if(mapContentVersion.containsKey(fileLink.ContentDocumentId)){
                    if(mapParentIdFiles.containsKey(fileLink.LinkedEntityId)){
                        mapParentIdFiles.get(fileLink.LinkedEntityId).add(mapContentVersion.get(fileLink.ContentDocumentId));
                    }else{
                        mapParentIdFiles.put(fileLink.LinkedEntityId, new List<ContentVersion>{mapContentVersion.get(fileLink.ContentDocumentId)});
                    }
                }
            }
        }
        
        for(ContentVersion cont: mapContentVersion.values()){
            for(Account acc: [select id, name,RecordType.name from Account where id IN: idSet]){
                if (acc.RecordType.name == label.SV2020_Account_Creation_Layout || acc.RecordType.name == label.SV2020_Account_Record_Type){
                    FeedItem acpost = new FeedItem(
                        ParentId = acc.id,
                        Title = cont.Title,
                        Body = 'New file has been added in the '+acc.Name +' Account'+'\r\n'+' File Name: ' +cont.Title
                    );
                    accposts.add(acpost);  
                }           
            }
        }
        if(accposts.size()>0){
            insert accposts; 
            //system.debug('accposts :::::'+ accposts);
        }
    }
}