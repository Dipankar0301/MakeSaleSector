public class MakeSales_WarningForUsers {
    @AuraEnabled
    //TO CHECK IF THE USER IS OWNER OR PART OF OPPORTUNITY TEAM
    //IF YES THEN DO NOT SHOW  ANY MESSAGE OTHERWISE SHOW WARNING MESSAGE
    Public static Boolean checkUserRecord(id recId, String userID1){
        //Id userID1 = UserInfo.getUserId();
        //system.debug(userID1);
        Opportunity oppown =[select id,OwnerId from Opportunity where id=:recid];
        if(oppown.OwnerId == userID1)
        {
            return false;
        }
        List<OpportunityTeamMember> otp = [select id,UserId,OpportunityId from OpportunityTeamMember where OpportunityId = :recId];
        System.debug('line 8'+ otp.size());
        for(OpportunityTeamMember op: otp){
            if(op.UserId == userID1){
                
                return false;                        
            } 
        }
        return true;
        
    }
    //TO CHECK IF THE USER IS OWNER OR PART OF ACCOUNT TEAM
    //IF YES THEN DO NOT SHOW  ANY MESSAGE OTHERWISE SHOW WARNING MESSAGE
    @AuraEnabled 
    Public static Boolean checkUserRecordAccount(id recId, String userID1){
        
        system.debug(userID1);
        Account accown =[select id,OwnerId from Account where id=:recid];
        if(accown.OwnerId == userID1)
        {
            return false;
        }
        system.debug(userID1);
        List<AccountTeamMember> atp = [select id,UserId,AccountId from AccountTeamMember where AccountId = :recId];
        for(AccountTeamMember ap: atp){
            if(ap.UserId == userID1){
                
                return false;                        
            } 
        }
       /* List<Opportunity> opp=[select id from Opportunity where AccountId=: recId];
        List<OpportunityTeamMember> otp = [select id,UserId,OpportunityId,OpportunityAccessLevel from OpportunityTeamMember where OpportunityId in: opp];
        System.debug(otp);
        for(OpportunityTeamMember op: otp){
            if(op.UserId == userID1){
                
                return false;                        
            } 
        } 
		*/
        return true;
        
    }
}