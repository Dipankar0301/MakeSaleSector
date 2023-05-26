public class ChangeOwnerClass {
 @AuraEnabled
    public static Case changeOwnerMethod(Id caseId) {
        if(caseId != null) {
            Case c = [SELECT OwnerId FROM Case WHERE Id = :caseId];
         c.OwnerId = UserInfo.getUserId();
//update case Ownerid with loggedin userid.
            update c;
            return c;
        }
        return null;
    }
}