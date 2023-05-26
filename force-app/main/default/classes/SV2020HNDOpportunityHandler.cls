public class SV2020HNDOpportunityHandler { 
public static string LastModifiedDate = 'Last Modified Date'; 
public static string SystemModstamp = 'System Modstamp';
    /* Fields updating for Gal to SF user fields */
    public static void SFFieldsUpdate(list<Opportunity__c> newopps){
        list<id> galid = new List<id>();
        for(Opportunity__c opp : newopps){
            //system.debug('opp.Business_Lead__c:'+opp.Business_Lead__c);
            if(String.isNotBlank(opp.Business_Lead__c)){
                galid.add(opp.Business_Lead__c);
            }
            if(String.isNotBlank(opp.Business_Support__c)){
                galid.add(opp.Business_Support__c);
            }
            if(String.isNotBlank(opp.Legal__c)){
                galid.add(opp.Legal__c);
            }
            if(String.isNotBlank(opp.Technical_Lead__c)){
                galid.add(opp.Technical_Lead__c);
            }
        }
        list<string> EmailLIsts =new list<string>();
        map<id,string> galemail= new map<id,string>();
        for(GAL__c c:[select Email__c from GAL__c where id in :galid]){
            if(c.Email__c!=null && c.Email__c!=''){
                EmailLIsts.add(c.Email__c);
                galemail.put(c.id,c.Email__c);
            }
        }
        //system.debug('EmailLIsts:'+EmailLIsts);
        //system.debug('galemail:'+galemail);
        map<string,user> mapuser= new map<string,user>();
        for(user u:[select email,id from user where email in :EmailLIsts ]){
            mapuser.put(u.email,u);
        }
        //system.debug('mapuser:'+mapuser);
        for(Opportunity__c opp : newopps){
            opp.SF_Business_Lead__c =  ( String.isNotBlank(opp.Business_Lead__c) && galemail.containskey(opp.Business_Lead__c) &&  mapuser.containskey(galemail.get(opp.Business_Lead__c)))? mapuser.get(galemail.get(opp.Business_Lead__c)).Id:null;                    
            opp.SF_Business_Support__c = ( String.isNotBlank(opp.Business_Support__c) && galemail.containskey(opp.Business_Support__c) && mapuser.containskey(galemail.get(opp.Business_Support__c)))?mapuser.get(galemail.get(opp.Business_Support__c)).Id:null;                     
            opp.SF_Legal__c =( String.isNotBlank(opp.Legal__c) && galemail.containskey(opp.Legal__c) &&  mapuser.containskey(galemail.get(opp.Legal__c)))? mapuser.get(galemail.get(opp.Legal__c)).Id:null;
            opp.SF_Technical_Lead__c =  (String.isNotBlank(opp.Technical_Lead__c) && galemail.containskey(opp.Technical_Lead__c)!=null && mapuser.containskey(galemail.get(opp.Technical_Lead__c))) ? mapuser.get(galemail.get(opp.Technical_Lead__c)).Id:null; 
           
        }
    }
    /* Sharing record to users */
    public static void recordSharing(List<Opportunity__c> newOpportunity, Map<ID, Opportunity__c> updatedOpporunity_oldvalue){        
        set<Id> opportunityUserIds_Set = new set<Id>();
        set<ID> opportunityoldIds_Set = new set<ID>();
        list<Opportunity__Share> oppshare =  new list<Opportunity__Share>();
        
        for(Opportunity__c newOpp : newOpportunity){
            if(newOpp.BOM__c != null){
                opportunityUserIds_Set.add(newOpp.BOM__c);
            }    
            if(newOpp.Finance_Lead__c != null){
                opportunityUserIds_Set.add(newOpp.Finance_Lead__c);
            }
            if(newOpp.Commercial_Support__c != null){
                opportunityUserIds_Set.add(newOpp.Commercial_Support__c);
            }
            if(newOpp.Finance_Support__c != null){
                opportunityUserIds_Set.add(newOpp.Finance_Support__c);
            }
            if(newOpp.Implementation_Lead__c != null){
                opportunityUserIds_Set.add(newOpp.Implementation_Lead__c);
            }
            if(newOpp.SF_Business_Lead__c != null){
                opportunityUserIds_Set.add(newOpp.SF_Business_Lead__c);
            }
            if(newOpp.SF_Business_Support__c != null){
                opportunityUserIds_Set.add(newOpp.SF_Business_Support__c);
            }
            if(newOpp.SF_Technical_Lead__c != null){
                opportunityUserIds_Set.add(newOpp.SF_Technical_Lead__c);
            }
            if(newOpp.SF_Legal__c != null){
                opportunityUserIds_Set.add(newOpp.SF_Legal__c);
            }
        } 
        
        if(!newOpportunity.isEmpty()){
            
            for(Opportunity__c newOppList : newOpportunity){
                
                for(ID userId : opportunityUserIds_Set){
                    if(newOppList.BOM__c == UserId || newOppList.Finance_Lead__c == UserId || newOppList.Commercial_Support__c == UserId || newOppList.Finance_Support__c == UserId ||newOppList.Implementation_Lead__c == UserId ||newOppList.SF_Business_Lead__c == UserId ||newOppList.SF_Business_Support__c == UserId ||newOppList.SF_Technical_Lead__c == UserId ||newOppList.SF_Legal__c == UserId){
                        
                        Opportunity__Share oppShareInstance  = new Opportunity__Share();
                        oppShareInstance.ParentId =  newOppList.id;
                        oppShareInstance.UserOrGroupId = userId;
                        oppShareInstance.AccessLevel = 'Edit';                        
                        oppshare.add(oppShareInstance);
                    }
                }
            }
        }
        
        if(!oppshare.isEmpty()){
            Database.SaveResult[] jobOppShareInsertResult = Database.insert(oppshare,false); 
        }
        
    }
    /* Sharing record update if user is removed/ replaced */
    public static void recordSharingUpdate(List<Opportunity__c> newOpportunity, Map<ID, Opportunity__c> updatedOpporunity_oldvalue){
        set<Id> opportunityUserIdsCheck_Set = new set<Id>();
        set<ID> opportunityoldIdsCheck_Set = new set<ID>();       
        list<Opportunity__Share> oppshareupdate =  new list<Opportunity__Share>();
        for(Opportunity__c  ChecknewOppList : newOpportunity){
            for(Opportunity__c oldoppList : updatedOpporunity_oldvalue.values()){
                if(ChecknewOppList.id == oldoppList.id){
                    if(ChecknewOppList.BOM__c != null){
                        opportunityUserIdsCheck_Set.add(ChecknewOppList.BOM__c);                           
                        
                        if(oldoppList.BOM__c != null)
                            opportunityoldIdsCheck_Set.add(oldoppList.BOM__c); 
                    } 
                    if(ChecknewOppList.Finance_Lead__c != null){
                        opportunityUserIdsCheck_Set.add(ChecknewOppList.Finance_Lead__c);                           
                        
                        if(oldoppList.Finance_Lead__c != null)
                            opportunityoldIdsCheck_Set.add(oldoppList.Finance_Lead__c); 
                    }
                    if(ChecknewOppList.Commercial_Support__c != null){
                        opportunityUserIdsCheck_Set.add(ChecknewOppList.Commercial_Support__c);                           
                        
                        if(oldoppList.Commercial_Support__c != null)
                            opportunityoldIdsCheck_Set.add(oldoppList.Commercial_Support__c); 
                    }
                    if(ChecknewOppList.Finance_Support__c != null){
                        opportunityUserIdsCheck_Set.add(ChecknewOppList.Finance_Support__c);                           
                        
                        if(oldoppList.Finance_Support__c != null)
                            opportunityoldIdsCheck_Set.add(oldoppList.Finance_Support__c); 
                    }
                    if(ChecknewOppList.Implementation_Lead__c != null){
                        opportunityUserIdsCheck_Set.add(ChecknewOppList.Implementation_Lead__c);                           
                        
                        if(oldoppList.Implementation_Lead__c != null)
                            opportunityoldIdsCheck_Set.add(oldoppList.Implementation_Lead__c); 
                    }
                    if(ChecknewOppList.SF_Business_Lead__c != null){
                        opportunityUserIdsCheck_Set.add(ChecknewOppList.SF_Business_Lead__c);                           
                        
                        if(oldoppList.SF_Business_Lead__c != null)
                            opportunityoldIdsCheck_Set.add(oldoppList.SF_Business_Lead__c); 
                    }
                    if(ChecknewOppList.SF_Business_Support__c != null){
                        opportunityUserIdsCheck_Set.add(ChecknewOppList.SF_Business_Support__c);                           
                        
                        if(oldoppList.SF_Business_Support__c != null)
                            opportunityoldIdsCheck_Set.add(oldoppList.SF_Business_Support__c); 
                    }
                    if(ChecknewOppList.SF_Technical_Lead__c != null){
                        opportunityUserIdsCheck_Set.add(ChecknewOppList.SF_Technical_Lead__c);                           
                        
                        if(oldoppList.SF_Technical_Lead__c != null)
                            opportunityoldIdsCheck_Set.add(oldoppList.SF_Technical_Lead__c); 
                    }
                    if(ChecknewOppList.SF_Legal__c != null){
                        opportunityUserIdsCheck_Set.add(ChecknewOppList.SF_Legal__c);                           
                        
                        if(oldoppList.SF_Legal__c != null)
                            opportunityoldIdsCheck_Set.add(oldoppList.SF_Legal__c); 
                    }  
                }
            }
        }
        if(!opportunityoldIdsCheck_Set.isEmpty()){
            list<Opportunity__Share> allOldOppShare_List = [select id,ParentId,UserOrGroupId from Opportunity__Share where ParentId IN: newOpportunity and Rowcause = 'Manual'];
            
            if(!allOldOppShare_List.isEmpty()){
                Database.Delete(allOldOppShare_List, false);
                
            }
        }
        
        if(!newOpportunity.isEmpty()){
            for(Opportunity__c newOppList : newOpportunity){
                
                for(ID userId : opportunityUserIdsCheck_Set){
                    if(newOppList.BOM__c == UserId || newOppList.Finance_Lead__c == UserId || newOppList.Commercial_Support__c == UserId || newOppList.Finance_Support__c == UserId ||newOppList.Implementation_Lead__c == UserId ||newOppList.SF_Business_Lead__c == UserId ||newOppList.SF_Business_Support__c == UserId ||newOppList.SF_Technical_Lead__c == UserId ||newOppList.SF_Legal__c == UserId){
                        
                        Opportunity__Share oppShareInstancenew  = new Opportunity__Share();
                        oppShareInstancenew.ParentId =  newOppList.id;
                        oppShareInstancenew.UserOrGroupId = userId;
                        oppShareInstancenew.AccessLevel = 'Edit';                        
                        oppshareupdate.add(oppShareInstancenew);
                    }
                }
            }
        }
        
        if(!oppshareupdate.isEmpty()){
            Database.SaveResult[] jobOppShareInsertResult = Database.insert(oppshareupdate,false); 
        }
    }
   /* Chatter Post if record is changed post in account */
    Public static void OpporChatterUpdate(Map<Id, Opportunity__c> newMap, Map<Id, Opportunity__c> oldMap) {
        List<FeedItem> posts = new List<FeedItem>();
        List<FeedItem> oppposts = new List<FeedItem>();
        list<string> accId = new list<string>();
        list<string> userId = new list<string>();
        list<string> GAL = new list<string>();
        map<id,account> accIdAndNameMap = new map<id,account>(); 
        map<id,user> userIdAndNameMap = new map<id,user>();
        map<id,GAL__c> galIdAndNameMap = new map<id,GAL__c>();
        list<Opportunity__c> NewOpp = newMap.values();
        list<Opportunity__c> OldOpp = oldMap.values(); 
        Opportunity__c OppObject = new Opportunity__c(); 
       /*** List<Opportunity__c> updateOpp = [SELECT Account__c,BOM__c,Business_Lead__c,Business_Support__c,Closed__c,Business_Grouping_1__c,Business_Grouping_2__c,
                                          Commercial_Support__c,CreatedById,CreatedDate,
                                          Deal_Source_Description__c,Deal_Source__c,Description__c,Finance_Lead__c,Finance_Support__c,Implementation_Lead__c,
                                          Follow_On_Investment__c,Fund__c,GIP_Completed__c,IC__c,Id,IsDeleted,LastActivityDate,
                                          LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Legal__c,Link_To_Other_Opportunity__c,
                                          Name,Number_Of_Days_Opened__c,Number_Of_Days_Open__c,Opportunity_Closed__c,
                                          OwnerId,PCI_Completed__c,Reason_for_Closure__c,RecordTypeId,Round__c,
                                          Shell_Initial_Commitment_M_USD__c,Stage__c,Team__c,Technical_Lead__c,
                                          Total_Round_Size_M_USD__c,Type_of_Investment__c,Current_Phase_Cost_M_USD__c,Past_Phases_Cost_M_USD__c,Total_Project_Cost_M_USD__c FROM Opportunity__c where ID IN : newMap.keyset()];***/
            Schema.SObjectType objType = OppObject.getSObjectType(); 
        Map<String, Schema.SObjectField> M = Schema.SObjectType.Opportunity__c.fields.getMap(); 
        for (String str : M.keyset()) {
            try {     
//system.debug('*** M.get(str).getDescribe().getType() ***'+M.get(str).getDescribe().getType());
//&& M.get(str).getDescribe().getType() == 'REFERENCE'          
                if( NewOpp[0].get(str) != OldOpp[0].get(str) && M.get(str).getDescribe().getLabel() != LastModifiedDate &&  M.get(str).getDescribe().getLabel() != SystemModstamp && M.get(str).getDescribe().getLabel() != label.SV2020Number_Of_Days_Opened &&  M.get(str).getDescribe().getLabel() != label.SV2020Number_Of_Days_Open && M.get(str).getDescribe().getType() == Schema.DisplayType.REFERENCE){ 
                    if(NewOpp[0].get(str) !=null)
                    GAL.add(NewOpp[0].get(str).tostring());
                if(OldOpp[0].get(str) !=null)
                    GAL.add(OldOpp[0].get(str).tostring());
                    /***if( NewOpp[0].get(str) !=null){
                        string NewOppString = NewOpp[0].get(str).tostring();
                            if(NewOppString.startsWith('001')) 
                                accId.add(NewOppString);
                    }
                    if( OldOpp[0].get(str) !=null){
                        string oldOppString = OldOpp[0].get(str).tostring();
                            if(oldOppString.startsWith('001')) 
                                accId.add(oldOppString);                    
                    }
                    if( NewOpp[0].get(str) !=null){
                        string NewOppString = NewOpp[0].get(str).tostring();
                        system.debug('*** NewOppString *** 55555'+NewOppString);
                            if(NewOppString.startsWith('005')) 
                                userId.add(NewOppString);
                    }
                    if( OldOpp[0].get(str) !=null){
                        string oldOppString = OldOpp[0].get(str).tostring();
                        system.debug('*** oldOppString *** 6666'+oldOppString);
                            if(oldOppString.startsWith('005')) 
                                userId.add(oldOppString);                   
                    }***/
                }
            }
            catch (Exception e) { 
                System.debug('Error: ' + e); 
            } 
        }
        
        for(account acc: [select id,name from Account where id IN:GAL]){
            accIdAndNameMap.put(acc.id,acc);
        }
        for(User usr: [select id,name from User where id IN:GAL]){
            userIdAndNameMap.put(usr.id,usr);
        }
        for(GAL__c usr: [select id,name from GAL__c where id IN:GAL]){
            galIdAndNameMap.put(usr.id,usr);
        }
        
        //system.debug('*** accIdAndNameMap ***'+accIdAndNameMap);
    
        //system.debug('*** userIdAndNameMap ***'+userIdAndNameMap);
        
        //system.debug('*** galIdAndNameMap ***'+galIdAndNameMap);
        
       for (String str : M.keyset()) {
            try { 
                System.debug('Field name: '+M.get(str).getDescribe().getLabel() +'. New value: ' + NewOpp[0].get(str) +'. Old value: '+OldOpp[0].get(str));
                if(NewOpp[0].get(str) != OldOpp[0].get(str) && M.get(str).getDescribe().getLabel() != LastModifiedDate &&  M.get(str).getDescribe().getLabel() != SystemModstamp && M.get(str).getDescribe().getLabel() != label.SV2020Number_Of_Days_Opened &&  M.get(str).getDescribe().getLabel() != label.SV2020Number_Of_Days_Open){
                                    
                    //for (Opportunity__c opp : updateOpp) {
                                                String status ='The following field associated to '+NewOpp[0].Name +' has been modified : '+M.get(str).getDescribe().getLabel() +'\r\n'+ 'New value: ' + NewOpp[0].get(str) +'\r\n' + 'Old value: '+OldOpp[0].get(str);
                                                
if(NewOpp[0].get(str) !=null && OldOpp[0].get(str) !=null &&  M.get(str).getDescribe().getType() == Schema.DisplayType.REFERENCE && userIdAndNameMap.containskey(NewOpp[0].get(str).tostring()) && userIdAndNameMap.containskey(OldOpp[0].get(str).tostring())){
 status ='The following field associated to '+NewOpp[0].Name +' has been modified : '+M.get(str).getDescribe().getLabel() +'\r\n'+ 'New value: ' + userIdAndNameMap.get(NewOpp[0].get(str).tostring()).name +'\r\n' + 'Old value: '+userIdAndNameMap.get(OldOpp[0].get(str).tostring()).name;
 
  //system.debug('*** status userIdAndNameMap 111***'+status);
                }
                else if(NewOpp[0].get(str) !=null && OldOpp[0].get(str) ==null && M.get(str).getDescribe().getType() == Schema.DisplayType.REFERENCE && userIdAndNameMap.containskey(NewOpp[0].get(str).tostring())){
 status ='The following field associated to '+NewOpp[0].Name +' has been modified : '+M.get(str).getDescribe().getLabel() +'\r\n'+ 'New value: ' + userIdAndNameMap.get(NewOpp[0].get(str).tostring()).name  +'\r\n' + 'Old value: '+OldOpp[0].get(str);
   //system.debug('*** status 222***'+status);
                } else if(NewOpp[0].get(str) ==null && OldOpp[0].get(str) !=null && M.get(str).getDescribe().getType() == Schema.DisplayType.REFERENCE && userIdAndNameMap.containskey(OldOpp[0].get(str).tostring())){
                     status ='The following field associated to '+NewOpp[0].Name +' has been modified : '+M.get(str).getDescribe().getLabel() +'\r\n'+ 'New value: ' +  NewOpp[0].get(str) +'\r\n' + 'Old value: '+userIdAndNameMap.get(OldOpp[0].get(str).tostring()).name;
                        ///system.debug('*** status 333***'+status);
                }
                
                
                    if(NewOpp[0].get(str) !=null && OldOpp[0].get(str) !=null && M.get(str).getDescribe().getType() == Schema.DisplayType.REFERENCE && accIdAndNameMap.containskey(NewOpp[0].get(str).tostring()) && accIdAndNameMap.containskey(OldOpp[0].get(str).tostring())){
 status ='The following field associated to '+NewOpp[0].Name +' has been modified : '+M.get(str).getDescribe().getLabel() +'\r\n'+ 'New value: ' + accIdAndNameMap.get(NewOpp[0].get(str).tostring()).name +'\r\n' + 'Old value: '+accIdAndNameMap.get(OldOpp[0].get(str).tostring()).name;
                }
                else if(NewOpp[0].get(str) !=null && OldOpp[0].get(str) ==null && M.get(str).getDescribe().getType() == Schema.DisplayType.REFERENCE && accIdAndNameMap.containskey(NewOpp[0].get(str).tostring())){
 status ='The following field associated to '+NewOpp[0].Name +' has been modified : '+M.get(str).getDescribe().getLabel() +'\r\n'+ 'New value: ' + accIdAndNameMap.get(NewOpp[0].get(str).tostring()).name  +'\r\n' + 'Old value: '+OldOpp[0].get(str);
                } else if(NewOpp[0].get(str) ==null && OldOpp[0].get(str) !=null && M.get(str).getDescribe().getType() == Schema.DisplayType.REFERENCE && accIdAndNameMap.containskey(OldOpp[0].get(str).tostring())){
                     status ='The following field associated to '+NewOpp[0].Name +' has been modified : '+M.get(str).getDescribe().getLabel() +'\r\n'+ 'New value: ' +  NewOpp[0].get(str) +'\r\n' + 'Old value: '+accIdAndNameMap.get(OldOpp[0].get(str).tostring()).name;
                }   

if(NewOpp[0].get(str) !=null && OldOpp[0].get(str) !=null && M.get(str).getDescribe().getType() == Schema.DisplayType.REFERENCE && galIdAndNameMap.containskey(NewOpp[0].get(str).tostring()) && galIdAndNameMap.containskey(OldOpp[0].get(str).tostring())){
 status ='The following field associated to '+NewOpp[0].Name +' has been modified : '+M.get(str).getDescribe().getLabel() +'\r\n'+ 'New value: ' + galIdAndNameMap.get(NewOpp[0].get(str).tostring()).name +'\r\n' + 'Old value: '+galIdAndNameMap.get(OldOpp[0].get(str).tostring()).name;
 
  //system.debug('*** status galIdAndNameMap 111***'+status);
                }
                else if(NewOpp[0].get(str) !=null && OldOpp[0].get(str) ==null && M.get(str).getDescribe().getType() == Schema.DisplayType.REFERENCE && galIdAndNameMap.containskey(NewOpp[0].get(str).tostring())){
 status ='The following field associated to '+NewOpp[0].Name +' has been modified : '+M.get(str).getDescribe().getLabel() +'\r\n'+ 'New value: ' + galIdAndNameMap.get(NewOpp[0].get(str).tostring()).name  +'\r\n' + 'Old value: '+OldOpp[0].get(str);
   //system.debug('*** status 222***'+status);
                } else if(NewOpp[0].get(str) ==null && OldOpp[0].get(str) !=null && M.get(str).getDescribe().getType() == Schema.DisplayType.REFERENCE && galIdAndNameMap.containskey(OldOpp[0].get(str).tostring())){
                     status ='The following field associated to '+NewOpp[0].Name +' has been modified : '+M.get(str).getDescribe().getLabel() +'\r\n'+ 'New value: ' +  NewOpp[0].get(str) +'\r\n' + 'Old value: '+galIdAndNameMap.get(OldOpp[0].get(str).tostring()).name;
                        //system.debug('*** status 333***'+status);
                }               

                
                            //String status ='The following field associated to '+NewOpp[0].Name +' has been modified : '+M.get(str).getDescribe().getLabel() +'\r\n'+ 'New value: ' + NewValue +'\r\n' + 'Old value: '+OldValue;
                        if(NewOpp[0].Account__c !=null &&  M.get(str).getDescribe().getLabel() != label.SV2020Number_Of_Days_Opened &&  M.get(str).getDescribe().getLabel() != label.SV2020Number_Of_Days_Open ){
                            FeedItem post = new FeedItem(
                                ParentId = NewOpp[0].Account__c,
                                Title = NewOpp[0].Name,
                                Body = status
                            );
                            posts.add(post);
                        }
                    
                    if( M.get(str).getDescribe().getLabel() != label.SV2020Number_Of_Days_Opened &&  M.get(str).getDescribe().getLabel() != label.SV2020Number_Of_Days_Open ){
                            FeedItem post = new FeedItem(
                                ParentId = NewOpp[0].id,
                                Title = NewOpp[0].Name,
                                Body = status
                            );
                            posts.add(post);
                    }
                    //}
                    if(posts.size()>0){
                        upsert posts;
                    }
                }
            }
            catch (Exception e) { 
                System.debug('Error: ' + e); 
            } 
        } 
    }
    Public static void accountChatterUpdate(list<Account> NewAccList, list<Account> OldAccList) {
        List<FeedItem> posts = new List<FeedItem>();
        List<FeedItem> oppposts = new List<FeedItem>();
        list<string> accId = new list<string>();
        list<string> userId = new list<string>();
        list<string> GAL = new list<string>();
        map<id,account> accIdAndNameMap = new map<id,account>(); 
        map<id,user> userIdAndNameMap = new map<id,user>();
        //map<id,GAL__c> galIdAndNameMap = new map<id,GAL__c>();
        list<Account> NewAcc  = NewAccList;
        list<Account> OldAcc = OldAccList; 
        Account accObject = new Account(); 
       /*** List<Opportunity__c> updateOpp = [SELECT Account__c,BOM__c,Business_Lead__c,Business_Support__c,Closed__c,Business_Grouping_1__c,Business_Grouping_2__c,
                                          Commercial_Support__c,CreatedById,CreatedDate,
                                          Deal_Source_Description__c,Deal_Source__c,Description__c,Finance_Lead__c,Finance_Support__c,Implementation_Lead__c,
                                          Follow_On_Investment__c,Fund__c,GIP_Completed__c,IC__c,Id,IsDeleted,LastActivityDate,
                                          LastModifiedById,LastModifiedDate,LastReferencedDate,LastViewedDate,Legal__c,Link_To_Other_Opportunity__c,
                                          Name,Number_Of_Days_Opened__c,Number_Of_Days_Open__c,Opportunity_Closed__c,
                                          OwnerId,PCI_Completed__c,Reason_for_Closure__c,RecordTypeId,Round__c,
                                          Shell_Initial_Commitment_M_USD__c,Stage__c,Team__c,Technical_Lead__c,
                                          Total_Round_Size_M_USD__c,Type_of_Investment__c,Current_Phase_Cost_M_USD__c,Past_Phases_Cost_M_USD__c,Total_Project_Cost_M_USD__c FROM Opportunity__c where ID IN : newMap.keyset()];***/
            Schema.SObjectType objType = accObject.getSObjectType(); 
        Map<String, Schema.SObjectField> M = Schema.SObjectType.Account.fields.getMap(); 
        for (String str : M.keyset()) {
            try {     
//system.debug('*** M.get(str).getDescribe().getType() ***'+M.get(str).getDescribe().getType());
//&& M.get(str).getDescribe().getType() == 'REFERENCE'          
                if( NewAcc[0].get(str) != OldAcc[0].get(str) && M.get(str).getDescribe().getLabel() != LastModifiedDate &&  M.get(str).getDescribe().getLabel() != SystemModstamp && M.get(str).getDescribe().getType() == Schema.DisplayType.REFERENCE){ 
                    if(NewAcc[0].get(str) !=null)
                    GAL.add(NewAcc[0].get(str).tostring());
                if(OldAcc[0].get(str) !=null)
                    GAL.add(OldAcc[0].get(str).tostring());
                }
            }
            catch (Exception e) { 
                System.debug('Error: ' + e); 
            } 
        }
        
        for(account acc: [select id,name from Account where id IN:GAL]){
            accIdAndNameMap.put(acc.id,acc);
        }
        for(User usr: [select id,name from User where id IN:GAL]){
            userIdAndNameMap.put(usr.id,usr);
        }        
        //system.debug('*** accIdAndNameMap ***'+accIdAndNameMap);
    
        //system.debug('*** userIdAndNameMap ***'+userIdAndNameMap);
        
        //system.debug('*** galIdAndNameMap ***'+galIdAndNameMap);
        
       for (String str : M.keyset()) {
            try { 
                System.debug('Field name: '+M.get(str).getDescribe().getLabel() +'. New value: ' + NewAcc[0].get(str) +'. Old value: '+OldAcc[0].get(str));
                if(NewAcc[0].get(str) != OldAcc[0].get(str) &&  M.get(str).getDescribe().getLabel() != LastModifiedDate &&  M.get(str).getDescribe().getLabel() != SystemModstamp){
                                    
                    //for (Opportunity__c opp : updateOpp) {
                                                String status ='The following field associated to '+NewAcc[0].Name +' has been modified : '+M.get(str).getDescribe().getLabel() +'\r\n'+ 'New value: ' + NewAcc[0].get(str) +'\r\n' + 'Old value: '+OldAcc[0].get(str);
                                                
if(NewAcc[0].get(str) !=null && OldAcc[0].get(str) !=null &&  M.get(str).getDescribe().getType() == Schema.DisplayType.REFERENCE && userIdAndNameMap.containskey(NewAcc[0].get(str).tostring()) && userIdAndNameMap.containskey(OldAcc[0].get(str).tostring())){
 status ='The following field associated to '+NewAcc[0].Name +' has been modified : '+M.get(str).getDescribe().getLabel() +'\r\n'+ 'New value: ' + userIdAndNameMap.get(NewAcc[0].get(str).tostring()).name +'\r\n' + 'Old value: '+userIdAndNameMap.get(OldAcc[0].get(str).tostring()).name;
 
  //system.debug('*** status userIdAndNameMap 111***'+status);
                }
                else if(NewAcc[0].get(str) !=null && OldAcc[0].get(str) ==null && M.get(str).getDescribe().getType() == Schema.DisplayType.REFERENCE && userIdAndNameMap.containskey(NewAcc[0].get(str).tostring())){
 status ='The following field associated to '+NewAcc[0].Name +' has been modified : '+M.get(str).getDescribe().getLabel() +'\r\n'+ 'New value: ' + userIdAndNameMap.get(NewAcc[0].get(str).tostring()).name  +'\r\n' + 'Old value: '+OldAcc[0].get(str);
   //system.debug('*** status 222***'+status);
                } else if(NewAcc[0].get(str) ==null && OldAcc[0].get(str) !=null && M.get(str).getDescribe().getType() == Schema.DisplayType.REFERENCE && userIdAndNameMap.containskey(OldAcc[0].get(str).tostring())){
                     status ='The following field associated to '+NewAcc[0].Name +' has been modified : '+M.get(str).getDescribe().getLabel() +'\r\n'+ 'New value: ' +  NewAcc[0].get(str) +'\r\n' + 'Old value: '+userIdAndNameMap.get(OldAcc[0].get(str).tostring()).name;
                        ///system.debug('*** status 333***'+status);
                }
                
                
                    if(NewAcc[0].get(str) !=null && OldAcc[0].get(str) !=null && M.get(str).getDescribe().getType() == Schema.DisplayType.REFERENCE && accIdAndNameMap.containskey(NewAcc[0].get(str).tostring()) && accIdAndNameMap.containskey(OldAcc[0].get(str).tostring())){
 status ='The following field associated to '+NewAcc[0].Name +' has been modified : '+M.get(str).getDescribe().getLabel() +'\r\n'+ 'New value: ' + accIdAndNameMap.get(NewAcc[0].get(str).tostring()).name +'\r\n' + 'Old value: '+accIdAndNameMap.get(OldAcc[0].get(str).tostring()).name;
                }
                else if(NewAcc[0].get(str) !=null && OldAcc[0].get(str) ==null && M.get(str).getDescribe().getType() == Schema.DisplayType.REFERENCE && accIdAndNameMap.containskey(NewAcc[0].get(str).tostring())){
 status ='The following field associated to '+NewAcc[0].Name +' has been modified : '+M.get(str).getDescribe().getLabel() +'\r\n'+ 'New value: ' + accIdAndNameMap.get(NewAcc[0].get(str).tostring()).name  +'\r\n' + 'Old value: '+OldAcc[0].get(str);
                } else if(NewAcc[0].get(str) ==null && OldAcc[0].get(str) !=null && M.get(str).getDescribe().getType() == Schema.DisplayType.REFERENCE && accIdAndNameMap.containskey(OldAcc[0].get(str).tostring())){
                     status ='The following field associated to '+NewAcc[0].Name +' has been modified : '+M.get(str).getDescribe().getLabel() +'\r\n'+ 'New value: ' +  NewAcc[0].get(str) +'\r\n' + 'Old value: '+accIdAndNameMap.get(OldAcc[0].get(str).tostring()).name;
                }   
                    // add the comments to Account chatter feed.
                    FeedItem post = new FeedItem(
                    ParentId = NewAcc[0].id,
                    Title = NewAcc[0].Name,
                    Body = status
                    );
                    posts.add(post);
                       
                    //}
                    if(posts.size()>0){
                        upsert posts;
                    }
                }
            }
            catch (Exception e) { 
                System.debug('Error: ' + e); 
            } 
        }
    }
    
    /*
     *@author : Sahil Khosla, SBOBNG-ITY/BCC 
     *Record Type : Implementation
   *Purpose : To Update TimeStamps of the Opportunity
   */
    public static Map<String, Integer> setPriorityStatus(){
        Map<String, Integer> st = new Map<String, Integer>();
        st.put('Prospect', 1);
        st.put('Lead', 2);
        st.put('Opportunity', 3);
        st.put('Intent', 4);
        st.put('Commitment', 5);
        st.put('Delivery', 6);
        st.put('Declined', 7);
        return st;
    }
    public static Map<String, Integer> setPriorityCPStage(){
        Map<String, Integer> cp = new Map<String, Integer>();
        cp.put('Contract initiation', 1);
        cp.put('Agreeing to T&C', 2);
        cp.put('Agreeing to commercial conditions', 3);
        cp.put('Generating contract PO in SHARP', 4);
        cp.put('Initiating contract approvals (or PO)', 5);
        cp.put('First deployed (yes/no + comment)', 6);
        cp.put('First invoice received', 7);
        cp.put('First invoice payed', 8);
        cp.put('Completed', 9);
        return cp;
    }
    public static void ImplementationTimeline(List<Opportunity__c> oldOpps, List<Opportunity__c> newOpps){
        for(Integer i=0; i<newOpps.size(); ++i){
            //set priority of status and cp stage
            Map<String, Integer> st = setPriorityStatus();
            Map<String, Integer> cp = setPriorityCPStage();
            
          //check for Implementation Record ID
            if(newOpps[i].RecordTypeId == Schema.SObjectType.Opportunity__c.getRecordTypeInfosByName().get('Implementation View').getRecordTypeId()){
                if(!newOpps[i].Status__c.equals(oldOpps[i].Status__c)){
                    
                    Opportunity__c opp = [SELECT Id, CreatedDate, Timestamp_Prospect__c,Timestamp_Lead__c,Timestamp_Opportunity__c,Timestamp_Intent__c,Timestamp_Commitment__c,Timestamp_Delivery__c FROM Opportunity__c WHERE Id =: newOpps[i].Id][0];
                    
                    List<Integer> timestamps = new List<Integer>();
                    
                    timestamps.add(0);
                    timestamps.add((Integer)opp.Timestamp_Prospect__c);
                    timestamps.add((Integer)opp.Timestamp_Lead__c);
                    timestamps.add((Integer)opp.Timestamp_Opportunity__c);
                    timestamps.add((Integer)opp.Timestamp_Intent__c);
                    timestamps.add((Integer)opp.Timestamp_Commitment__c);
                    timestamps.add((Integer)opp.Timestamp_Delivery__c);
                    timestamps.add(0);
                    
                    if(st.get(newOpps[i].Status__c) > st.get(oldOpps[i].Status__c)){
                        Integer totalTimestamp = 0;
                        for(Integer j : timestamps){
                            totalTimestamp += j;
                        }
                        
                        Integer intervals = (Integer)st.get(newOpps[i].Status__c) - st.get(oldOpps[i].Status__c);
                        DateTime created = opp.CreatedDate;
                        DateTime present = DateTime.now();
                        
                        Long numDays = (present.getTime() - created.getTime())/(1000*60*60*24) - totalTimestamp;
                        
                        Integer getIntervalDays = (Integer)numDays/intervals;
                        
                        for(Integer j = (Integer)st.get(oldOpps[i].Status__c) + 1; j < (Integer)st.get(newOpps[i].Status__c); ++j){
                            timestamps[j] += getIntervalDays;
                        }
                        timestamps[(Integer)st.get(oldOpps[i].Status__c)] += (Integer)numDays - (intervals - 1)*getIntervalDays;
                        
                    }
                    else{
                        for(Integer j = (Integer)st.get(oldOpps[i].Status__c); j > (Integer)st.get(newOpps[i].Status__c); j--){
                            timestamps[j] = 0;
                        }
                    }
                    opp.Timestamp_Prospect__c = Double.valueOf(timestamps[1]);
                    opp.Timestamp_Lead__c = Double.valueOf(timestamps[2]);
                    opp.Timestamp_Opportunity__c = Double.valueOf(timestamps[3]);
                    opp.Timestamp_Intent__c = Double.valueOf(timestamps[4]);
                    opp.Timestamp_Commitment__c = Double.valueOf(timestamps[5]);
                    opp.Timestamp_Delivery__c = Double.valueOf(timestamps[6]);
                    
                    update opp;
                }
                if(!newOpps[i].CP_Stage__c.equals(oldOpps[i].CP_Stage__c)){
                    Opportunity__c opp = [SELECT Id, CreatedDate,
                                          Timestamp_Contract_Initiation__c,
                                          Timestamp_Agreeing_to_T_C__c,
                                          Timestamp_Agreeing_Commercial_Conditions__c,
                                          Timestamp_Generating_Contract_PO__c,
                                          Timestamp_Initiation_Contract_Approvals__c,
                                          Timestamp_First_Deployed__c,
                                          Timestamp_First_Invoice_Received__c,
                                          Timestamp_First_Invoice_Payed__c
                                          FROM Opportunity__c WHERE Id =: newOpps[i].Id][0];
                    
                    List<Integer> timestamps = new List<Integer>();
                    
                    timestamps.add(0);
                    timestamps.add((Integer)opp.Timestamp_Contract_Initiation__c);
                    timestamps.add((Integer)opp.Timestamp_Agreeing_to_T_C__c);
                    timestamps.add((Integer)opp.Timestamp_Agreeing_Commercial_Conditions__c);
                    timestamps.add((Integer)opp.Timestamp_Generating_Contract_PO__c);
                    timestamps.add((Integer)opp.Timestamp_Initiation_Contract_Approvals__c);
                    timestamps.add((Integer)opp.Timestamp_First_Deployed__c);
                    timestamps.add((Integer)opp.Timestamp_First_Invoice_Received__c);
                    timestamps.add((Integer)opp.Timestamp_First_Invoice_Payed__c);
                    timestamps.add(0);
                    
                    if(cp.get(newOpps[i].CP_Stage__c) > cp.get(oldOpps[i].CP_Stage__c)){
                        Integer totalTimestamp = 0;
                        for(Integer j : timestamps){
                            totalTimestamp += j;
                        }
                        
                        Integer intervals = (Integer)cp.get(newOpps[i].CP_Stage__c) - cp.get(oldOpps[i].CP_Stage__c);
                        DateTime created = opp.CreatedDate;
                        DateTime present = DateTime.now();
                        
                        Long numDays = (present.getTime() - created.getTime())/(1000*60*60*24) - totalTimestamp;
                        
                        Integer getIntervalDays = (Integer)numDays/intervals;
                        
                        for(Integer j = (Integer)cp.get(oldOpps[i].CP_Stage__c) + 1; j < (Integer)cp.get(newOpps[i].CP_Stage__c); ++j){
                            timestamps[j] += getIntervalDays;
                        }
                        timestamps[(Integer)cp.get(oldOpps[i].CP_Stage__c)] += (Integer)numDays - (intervals - 1)*getIntervalDays;
                        
                    }
                    else{
                        for(Integer j = (Integer)cp.get(oldOpps[i].CP_Stage__c); j > (Integer)cp.get(newOpps[i].CP_Stage__c); j--){
                            timestamps[j] = 0;
                        }
                    }
                    opp.Timestamp_Contract_Initiation__c = Double.valueOf(timestamps[1]);
                    opp.Timestamp_Agreeing_to_T_C__c = Double.valueOf(timestamps[2]);
                    opp.Timestamp_Agreeing_Commercial_Conditions__c = Double.valueOf(timestamps[3]);
                    opp.Timestamp_Generating_Contract_PO__c = Double.valueOf(timestamps[4]);
                    opp.Timestamp_Initiation_Contract_Approvals__c = Double.valueOf(timestamps[5]);
                    opp.Timestamp_First_Deployed__c = Double.valueOf(timestamps[6]);
                    opp.Timestamp_First_Invoice_Received__c = Double.valueOf(timestamps[7]);
                    opp.Timestamp_First_Invoice_Payed__c = Double.valueOf(timestamps[8]);
                    
                    update opp;
                }
            }    
        }
    }
}