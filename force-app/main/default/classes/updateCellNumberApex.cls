public with sharing class updateCellNumberApex {
    @AuraEnabled()
    public static void CellNumberUpdate(String CellNumber){
        List<User> users=[Select MobilePhone from user where Id=:UserInfo.getUserId()];
        
        if(users.size()>0){
            users[0].MobilePhone = cellNumber;
            update users;
        }
        
    }
}