public class SV2020HNDContactHandler {
    Public static void ContaChatterUpdate(Map<Id, Contact> newMap, Map<Id, Contact> oldMap) {
        List<FeedItem> posts = new List<FeedItem>();
        Contact NewCon = newMap.values(); 
        Contact OldCon = oldMap.values(); 
        Contact ConObject = new Contact(); 
        List<Contact> updateCon = [SELECT AccountId,Email,FirstName,LastName,Name,No_Longer_With_Company__c,Phone,Salutation FROM Contact where ID IN : newMap.keyset()];
        
        system.debug('updateCon value ::: ' + updateCon);
        
        Schema.SObjectType objType = ConObject.getSObjectType(); 
        Map<String, Schema.SObjectField> M = Schema.SObjectType.Contact.fields.getMap(); 
        for (String str : M.keyset()) {
            try {
                
                if(NewCon.get(str) != OldCon.get(str)){
                    system.debug('******The value has changed!!!! '); 
                                for (Contact con : updateCon) {
                                   String status ='Value of Contact Name:'+Con.Name +'\r\n'  +' The Value of '+M.get(str).getDescribe().getLabel() +' Changed Field name'+'\r\n'  + 'New value: ' + NewCon.get(str) +'\r\n' + 'Old value: '+OldCon.get(str);
                                   FeedItem post = new FeedItem(
                                            ParentId = con.AccountId,
                                            Title = con.Name,
                                            Body = status
                                        );
                                        posts.add(post);
                                    system.debug('posts  :: ' + posts);
                                    }
                                    upsert posts;
             system.debug('posts::::'+posts);
                }
                
            }
            catch (Exception e) { 
                System.debug('Error: ' + e); 
            } 
        } 
    }


}