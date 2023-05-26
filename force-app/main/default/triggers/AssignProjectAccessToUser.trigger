trigger AssignProjectAccessToUser on User (After insert,After Update) {
    
    if(Trigger.Isinsert && Trigger.isAfter){
        Map<String,String> usermap = new Map<String,String>();
        if(NEPM_AvoidRecursion.isFirstRun()){
            for(user u : Trigger.new){
                if(u.IsActive){

                    usermap.put(u.Email,u.id);
                }
            }
            if(!usermap.isEmpty()){
             
                AssignAccessToUser.userAccess(usermap);
            }  
       }
    }
    if(Trigger.isUpdate && Trigger.isAfter){
        Map<String,String> usermap = new Map<String,String>();
        if(NEPM_AvoidRecursion.isFirstRun()){
            for(user newUser : Trigger.new){
                user olduser = Trigger.oldMap.get(newUser.ID);
                if(newUser.IsActive != olduser.isActive && newUser.IsActive){
                    
                    usermap.put(newUser.Email,newUser.id);
                    
                  }
               }
                if(!usermap.isEmpty()){
                 
                     AssignAccessToUser.userAccess(usermap);
                }
        }
    }
}