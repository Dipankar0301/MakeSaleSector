public class Sector_additionalInformationPopUp {
	
    @AuraEnabled
    Public static Boolean checkOpportunityRecord(id recId){
        System.debug('recId' + recId);
        Opportunity OppRecord = [Select id, Name,StageName, Opportunity_City__c, Opportunity_Country__c, Opportunity_Region__c, Fulfilled_by__c from Opportunity where id =: recId];
        System.debug(OppRecord);
        Site_Link__c[] siteLink = [Select id, Opportunity__c from Site_Link__c where Opportunity__c =: recId];
        OpportunityShare[] OppShare =[SELECT Id, OpportunityId, UserOrGroupId, OpportunityAccessLevel, RowCause FROM OpportunityShare where OpportunityId =: recId and (OpportunityAccessLevel = 'All' or OpportunityAccessLevel ='Edit')];
        Set<String> userEdit = new Set<String>();
        for(OpportunityShare os: OppShare){
            userEdit.add(os.UserOrGroupId);
        }
        String loggedUserId = UserInfo.getUserId();
        system.debug(siteLink);
        system.debug(OppRecord.StageName);
        system.debug(OppRecord.Opportunity_City__c);
        system.debug(OppRecord.Opportunity_Country__c);
        system.debug(OppRecord.Opportunity_Region__c);
        system.debug(OppRecord.Fulfilled_by__c);
      //  if((userEdit.contains(loggedUserId))&&(siteLink.size() == 0) && (OppRecord.StageName=='Align' || OppRecord.StageName=='Negotiate') && (OppRecord.Opportunity_City__c == null) && (OppRecord.Opportunity_Country__c == null) && (OppRecord.Opportunity_Region__c == null) && (OppRecord.Fulfilled_by__c == null))
        if((userEdit.contains(loggedUserId))
           //&&(siteLink.size() == 0) 
           && 
           (OppRecord.StageName=='Align' || OppRecord.StageName=='Negotiate') && (OppRecord.Fulfilled_by__c == null))
        {
            System.debug('inside if');
            return true;
        }
        //List<AccountTeamMember> atp = [select id,UserId,AccountId from AccountTeamMember where AccountId = :accown.id];
        /*for(AccountTeamMember ap: atp){
            if(ap.UserId == userID1){
                
                return false;                        
            } 
        } */
        
        return false;
        
    }
}