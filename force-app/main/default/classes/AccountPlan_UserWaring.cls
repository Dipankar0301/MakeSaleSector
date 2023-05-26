public class AccountPlan_UserWaring {
    @AuraEnabled
    Public static Boolean checkUserRecord(id recId, String userID1){
        System.debug('recId' + recId);
        List<Account_Plan__c> accid=[select Customer_Name__c from Account_Plan__c where id=: recId];
        System.debug('accid' + accid);
        Id masterAccid=accid[0].Customer_Name__c;
        System.debug('masterAccid' + masterAccid);
        Account accown =[select id,OwnerId from Account where id=:masterAccid];
        System.debug('accown' + accown);
        if(accown.OwnerId == userID1)
        {
            return false;
        }
        List<AccountTeamMember> atp = [select id,UserId,AccountId from AccountTeamMember where AccountId = :accown.id];
        for(AccountTeamMember ap: atp){
            if(ap.UserId == userID1){
                
                return false;                        
            } 
        }
        return true;
        
    }
}