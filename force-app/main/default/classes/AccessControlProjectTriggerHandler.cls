Public Class AccessControlProjectTriggerHandler{

        Public List<NEPM_Project__Share> ProjectShareList = new List<NEPM_Project__Share>();
        Public  List<NEPM_Project__Share> DeleteProjectShare = new List<NEPM_Project__Share>();
        
        public void CheckDuplicates(List<DSAD_Access_Control__c> newAccessControlList,Map<id,DSAD_Access_Control__c> accessOldMap){
           
          try{
                Map<Id,List<DSAD_Access_Control__c>> accessControlMap = new Map<Id,List<DSAD_Access_Control__c>>();
                set<String> projset = new Set<String>();
                List<DSAD_Access_Control__c> AccessControlList;
                for(DSAD_Access_Control__c access : newAccessControlList){
                    
                    projset.add(access.Project__c);
                }
                for(DSAD_Access_Control__c c: [SELECT Deal_Team_Member_User__c,Id,Name,Project__c,Roles__c FROM DSAD_Access_Control__c WHERE Project__c IN:projset]){
                    if(accessControlMap.containsKey(c.Project__c)){   
                        accessControlMap.get(c.Project__c).add(c);
                    }
                    else{
                        AccessControlList = new List<DSAD_Access_Control__c>();
                        AccessControlList.add(c);
                        accessControlMap.put(c.Project__c,AccessControlList);
                    }       
                }
                
                for (DSAD_Access_Control__c c : newAccessControlList) 
                {
                    if((accessControlMap.containsKey(c.Project__c) && System.Trigger.isInsert )|| (accessControlMap.containsKey(c.Project__c) && c.Deal_Team_Member_User__c != accessOldMap.get(c.Id).Deal_Team_Member_User__c)){
                        for(DSAD_Access_Control__c Access : accessControlMap.get(c.Project__c))
                        {
                            if(c.Deal_Team_Member_User__c == Access.Deal_Team_Member_User__c)
                            {
                                c.Deal_Team_Member_User__c.addError('Deal Member already has the Access');
                            }   
                        }
                    }
                }
           }
            catch(Exception e){
            
                   System.debug('***Error occours in Before inser or update Trigger'+e);
            }
       } 
       public void AssignAccessOnInsert(List<DSAD_Access_Control__c> newAccessControlList){
       
         try{   
                for(DSAD_Access_Control__c access :newAccessControlList){
                    if(access.Deal_Team_Member_User__c != null)
                    {
                        NEPM_Project__Share projecShare = new NEPM_Project__Share();
                        projecShare.ParentId = access.Project__c;
                        projecShare.UserOrGroupId = access.Deal_Team_Member_User__c;
                        projecShare.AccessLevel = 'Edit';
                        projecShare.RowCause = 'DSAD_Deal_Member__c';
                        ProjectShareList.add(projecShare);
                     }
                 }
                 if(ProjectShareList.size() > 0){
                 
                 
                     insert ProjectShareList;
                 }
             }
             catch(Exception e){
                 
                  System.debug('***Error occours in After Insert Trigger'+e);
             }
        }
        public void RemoveAndAssignAccessOnUpdate(List<DSAD_Access_Control__c> newAccessControlList,Map<id,DSAD_Access_Control__c> accessOldMap)
        {
           try{ 
                Map<string,string> mapDealuser = new Map<string,string>();
                Set<string> projectid = new set<string>();
                for(DSAD_Access_Control__c access:newAccessControlList){
                
                    if(access.Deal_Team_Member_User__c != null && accessOldMap.get(access.Id).Deal_Team_Member_User__c != access.Deal_Team_Member_User__c){
                        
                        projectid.add(access.Project__c);
                        mapDealuser.put(accessOldMap.get(access.Id).Deal_Team_Member_User__c,access.Deal_Team_Member_User__c);
                              
                   } 
               }
               for(NEPM_Project__Share share : [SELECT AccessLevel,Id,IsDeleted,ParentId,RowCause,UserOrGroupId FROM NEPM_Project__Share WHERE UserOrGroupId IN:mapDealuser.keyset() AND RowCause = 'DSAD_Deal_Member__c' AND ParentId IN:projectid])
               {
                
                    NEPM_Project__Share projecShare = new NEPM_Project__Share();
                    projecShare.ParentId = share.ParentId;
                    projecShare.UserOrGroupId = mapDealuser.get(share.UserOrGroupId);
                    projecShare.AccessLevel = 'Edit';
                    projecShare.RowCause = 'DSAD_Deal_Member__c';
                    ProjectShareList.add(projecShare); 
                    
                    DeleteProjectShare.add(share);
               }
               if(DeleteProjectShare.size() >0){
                   
                   delete DeleteProjectShare;
               }
               if(ProjectShareList.size() > 0){
                   
                   insert ProjectShareList;
               }
            }
            catch(Exception e){
            
                System.debug('***Error occours in After Update Trigger'+e);
            }
        }
        public void RemoveAccessOnDelete(List<DSAD_Access_Control__c> accessOldList){
          
          try{   
               Set<string> useridset = new Set<string>();
               Set<string> projectset = new Set<string>();
               for(DSAD_Access_Control__c Access : accessOldList){
                    projectset.add(Access.Project__c);
                    useridset.add(Access.Deal_Team_Member_User__c);
               }
               for(NEPM_Project__Share share : [SELECT AccessLevel,Id,IsDeleted,ParentId,RowCause,UserOrGroupId FROM NEPM_Project__Share WHERE UserOrGroupId IN:useridset AND RowCause = 'DSAD_Deal_Member__c' AND ParentId IN:projectset]){
                
                    DeleteProjectShare.add(share);
               }
               if(DeleteProjectShare.size() >0){
               
                    delete DeleteProjectShare;
               }
            }
            catch(Exception e){
            
                 System.debug('***Error occours in After Delete Trigger'+e);
            }
        }
}