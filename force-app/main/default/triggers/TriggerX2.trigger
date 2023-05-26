trigger TriggerX2 on WorkOrder (before insert, before update) {
    
    Id reactive = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Reactive_Work_Order').getRecordTypeId();
    Id planned = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Planned_Work_Order').getRecordTypeId();
    Id ccnareactive = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('CCNA_Reactive_Work_Order').getRecordTypeId();
    Id ccnaplanned = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('CCNA_Planned_Work_Order').getRecordTypeId();
    Id user_profileid=UserInfo.getProfileId();
    List<Profile> prof= [select name from Profile where id=:user_profileid]; 
    List<Id> wo=new List<Id>();
    for(WorkOrder c1:Trigger.New)//Trigger.NewMap.keyset()
    {
        wo.add(c1.CaseId);
    }
    List<Case> li=[select id,Notification_Type__c,Origin from Case where id in: wo];  
    Map<id, Case> c=new Map<id,Case>();
    for(Case c1:li)
    {
        c.put(c1.id, c1);
    }
    String str;
    List<String> con=new List<String>();
    for(WorkOrder c1: Trigger.New)
    {
        str= c1.Code__c + c1.CodeDescription__c;
        con.add(str);
    }
    Map<String, id> wtid=new Map<String, id>();
    for(WorkType wtx:[select id,Name from WorkType where name in:con]){
        wtid.put(wtx.name,wtx.id);
    }  
    List<WorkOrder> p=new List<WorkOrder>();
    
    for(WorkOrder w1:Trigger.New){
        if(prof[0].name!='System Administrator'){
            Case ca=c.get(w1.caseId);
            String str1=w1.Code__c+w1.CodeDescription__c;
            Id wktype=wtid.get(str1);
            if(ca.Origin != 'CCNA' && ca.Notification_Type__c == 'Z2')
            {
                w1.RecordTypeId = reactive;
                p.add(w1);
            }
            else if(ca.Origin != 'CCNA')
            {
                w1.RecordTypeId = planned;
                p.add(w1);
            }
            else if(ca.Origin == 'CCNA' && ca.Notification_Type__c == 'X2')
            {
                w1.RecordTypeId = ccnareactive;
                w1.WorkTypeId=wktype;
                p.add(w1);
                
            }
            else if(ca.Origin == 'CCNA')
            {
                w1.RecordTypeId = ccnaplanned;
                w1.WorkTypeId=wktype;
                p.add(w1);
            }
        }
    }
    //update p;    
}