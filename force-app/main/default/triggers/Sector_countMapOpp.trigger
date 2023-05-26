trigger Sector_countMapOpp on ALTF__Contact_Map_Details__c (after insert,after update,after delete,after undelete) {
    if(TriggerHandler__c.getInstance('Sector_countMapOpp') != null && TriggerHandler__c.getInstance('Sector_countMapOpp').Active__c == false)
        return;
    
    set<id> clsId= new set<id>();
    if(Trigger.isInsert||Trigger.isUndelete){
        if(Trigger.new !=null){
            for(ALTF__Contact_Map_Details__c std:Trigger.new){
                if(std.ALTF__Opportunity__c !=null){
                    clsId.add(std.ALTF__Opportunity__c);
                }
            }
        }
    }
    if(Trigger.isDelete){
        if(Trigger.old!=null){
            for(ALTF__Contact_Map_Details__c std:Trigger.old){
                system.debug('before delete');
                clsId.add(std.ALTF__Opportunity__c);
            }
        }
    }
    if(Trigger.isUpdate){
        for(ALTF__Contact_Map_Details__c std:Trigger.new){
            if(std.ALTF__Opportunity__c != Trigger.oldMap.get(std.id).ALTF__Opportunity__c){
                if(Trigger.oldMap.get(std.id).ALTF__Opportunity__c !=null){
                    clsId.add(Trigger.oldMap.get(std.id).ALTF__Opportunity__c);
                }
                if(std.ALTF__Opportunity__c!=null){
                    clsId.add(std.ALTF__Opportunity__c);
                }
            }
        }
    }
    List<Opportunity> clsList = [Select Id, Map_count__c ,(Select Id from ALTF__Altify_Contact_Details__r) from Opportunity where Id IN: clsId];
    if(clsList!=null){
        for(Opportunity clsObj : clsList){
            clsObj.Map_count__c = clsObj.ALTF__Altify_Contact_Details__r.size();
        }
    }
    if(!clsList.isempty()){
        update clsList;
    }
}