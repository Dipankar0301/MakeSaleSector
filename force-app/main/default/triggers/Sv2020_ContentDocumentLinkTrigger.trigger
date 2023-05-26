trigger Sv2020_ContentDocumentLinkTrigger on ContentDocumentLink (after insert) {
    
    set<ID> setLinkedEntityId = new set<ID>();
    set<id> setDocumentIds = new set<id>();
    List<ContentDocumentLink> fileLinks = [select id,ContentDocumentId,LinkedEntityId,LinkedEntity.Type from ContentDocumentLink where id =: trigger.newMap.keyset()];
    system.debug('fileLinks::::: ' + fileLinks);
    for(ContentDocumentLink con : fileLinks){
        if(con.LinkedEntity.Type == 'Opportunity__c'){
            string checkIfopp = string.valueof(con.LinkedEntityId);
            //if(checkIfopp.startsWith('a0N1') ){
                setLinkedEntityId.add(con.LinkedEntityId);
                setDocumentIds.add(con.ContentDocumentId);
            //}
        }
        if(con.LinkedEntity.Type == 'Account'){
            string checkIfopp = string.valueof(con.LinkedEntityId);
            if(checkIfopp.startsWith('001') ){
                setLinkedEntityId.add(con.LinkedEntityId);
                setDocumentIds.add(con.ContentDocumentId);
            }
        }
    }    
    if(!setLinkedEntityId.isEmpty()){        
        SV2020FileHandler.selectFilesByParentId(setLinkedEntityId,setDocumentIds);
        SV2020FileHandler.AccselectFilesByParentId(setLinkedEntityId,setDocumentIds);     
        
    }
}