public class KPITracker_EntityTriggerHandler {
    
    public void CountChildEntities(List<Entity__c> entityRecords){
        System.debug('jnjhijkdxsdhikn');
        
        Set<Id> ParentEntityIds = New Set<Id>();
        List<Entity__c> updateITParent = new List<Entity__c>();
        Map<Id,Id> MapCurrentEntandParent = New Map<Id,Id>();
        Map<Id,Id> ITVulnerability = New Map<Id,Id>();
        
        Map<Id,Integer> childEntityCOuntMap = New Map<Id,Integer>();
        List<Entity__c> ListToupdateEntities = New List<Entity__c>();
        for(Entity__c ent:entityRecords){
            if(ent.Parent_Entity__c!=NULL){
                ParentEntityIds.add(ent.Parent_Entity__c);
                MapCurrentEntandParent.put(ent.Id,ent.Parent_Entity__c);
            }    
        }
        
        if(ParentEntityIds.size()>0){
            for(Entity__c ent:[Select Id, (SELECT id FROM Child_Entities__r) from Entity__c Where ID IN : ParentEntityIds]){
                
                if(ent.Child_Entities__r.size()==0){
                    childEntityCOuntMap.put(ent.Id,null);    
                }
                else{
                    
                    childEntityCOuntMap.put(ent.Id,ent.Child_Entities__r.size());
                  
                }
            }    
        }
      
        if(!childEntityCOuntMap.isEmpty()){
            Entity__c entObj = New Entity__c();
            for(Id Ids:childEntityCOuntMap.keySet()){
                entObj = New Entity__c();
                entObj.Id=Ids;
                entObj.Count_of_Child_Entities__c=childEntityCOuntMap.get(Ids);
                ListToupdateEntities.add(entObj);
            }
        }
        if(ListToupdateEntities.size()>0){
            update ListToupdateEntities;
        }
    }
    
   /* public void updateFields(List<Entity__c> entityRecords){
        System.debug('jnjhijkdxsdhikn');
        
        Set<Id> ParentEntityIds = New Set<Id>();
        List<Entity__c> updateITParent = new List<Entity__c>();
        Map<Id,Id> MapCurrentEntandParent = New Map<Id,Id>();
        Map<Id,Id> ITVulnerability = New Map<Id,Id>();
        
        Map<Id,Integer> childEntityCOuntMap = New Map<Id,Integer>();
        List<Entity__c> ListToupdateEntities = New List<Entity__c>();
        for(Entity__c ent:entityRecords){
            if(ent.Parent_Entity__c!=NULL){
                ParentEntityIds.add(ent.Parent_Entity__c);
            }    
        }
        
        if(ParentEntityIds.size()>0){
            for(Entity__c ent:[Select Id,Hierarchy_Level__c,L2_Uptime_Service_Desk_Ticket_Per_User__c,L1_Uptime_Service_Desk_Ticket_Per_User__c,L0_Uptime_Service_Desk_Ticket_Per_User__c, (SELECT id,L3_Uptime_Service_Desk_Ticket_Per_User__c,L2_Uptime_Service_Desk_Ticket_Per_User__c,L1_Uptime_Service_Desk_Ticket_Per_User__c,L0_Uptime_Service_Desk_Ticket_Per_User__c FROM Child_Entities__r) from Entity__c Where ID IN : ParentEntityIds]){
                
                if(ent.Child_Entities__r.size()!=0){
                    
                    
                    childEntityCOuntMap.put(ent.Id,ent.Child_Entities__r.size());
                    ent.L1_Uptime_Service_Desk_Ticket_Per_User__c=0;
                    ent.L2_Uptime_Service_Desk_Ticket_Per_User__c=0;
                    ent.L0_Uptime_Service_Desk_Ticket_Per_User__c=0;
                    Integer count1=0;
                    Integer count2=0;
                    Integer count3=0;
                    for(Entity__c ce:ent.Child_Entities__r){
                        if(ent.Hierarchy_Level__c=='L2'  && ce.L2_Uptime_Service_Desk_Ticket_Per_User__c!=null){
                            ent.L2_Uptime_Service_Desk_Ticket_Per_User__c=ent.L2_Uptime_Service_Desk_Ticket_Per_User__c+ce.L3_Uptime_Service_Desk_Ticket_Per_User__c;
                        count1++;
                        }
                        else if(ent.Hierarchy_Level__c=='L1' && ce.L2_Uptime_Service_Desk_Ticket_Per_User__c!=null){
                            ent.L1_Uptime_Service_Desk_Ticket_Per_User__c=ent.L1_Uptime_Service_Desk_Ticket_Per_User__c+ce.L1_Uptime_Service_Desk_Ticket_Per_User__c;
                           count2++;
                        }else if(ent.Hierarchy_Level__c=='L0' && ce.L1_Uptime_Service_Desk_Ticket_Per_User__c!=null ){
                            ent.L0_Uptime_Service_Desk_Ticket_Per_User__c=ent.L0_Uptime_Service_Desk_Ticket_Per_User__c+ce.L1_Uptime_Service_Desk_Ticket_Per_User__c;
                            count3++;
                        }
                        
                    }
                    if(ent.L2_Uptime_Service_Desk_Ticket_Per_User__c != 0){  
                        ent.L2_Uptime_Service_Desk_Ticket_Per_User__c=ent.L2_Uptime_Service_Desk_Ticket_Per_User__c/count1;
                        
                    }else if(ent.L1_Uptime_Service_Desk_Ticket_Per_User__c!=0){
                        ent.L1_Uptime_Service_Desk_Ticket_Per_User__c=ent.L1_Uptime_Service_Desk_Ticket_Per_User__c/count2;
                        
                    }
                  else if( ent.L0_Uptime_Service_Desk_Ticket_Per_User__c!=0){
                      ent.L0_Uptime_Service_Desk_Ticket_Per_User__c=ent.L0_Uptime_Service_Desk_Ticket_Per_User__c/count3;
                                                               
                  }
                                                           updateITParent.add(ent);
                   }
             }
            }    
        
        if(updateITParent != null){
            update updateITParent;
        }
        
    }
*/
    
}