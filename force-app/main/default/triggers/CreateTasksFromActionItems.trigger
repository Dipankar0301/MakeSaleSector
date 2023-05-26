//This trigger is related to NE HSSE APP related to H2 Ops Management application.
trigger CreateTasksFromActionItems on NE_MOC_Action__c (after insert) {
//After creating Action Items, create no of tasks based on data present in Custom Metadata(MOC Questionnaire).

List<Task> NewTasks = new List<Task>();
Set<String> actionType = new Set<String>();
Map<String, NE_MOC_Action_ItemTasks__mdt    > mocCMDMap = new Map<String, NE_MOC_Action_ItemTasks__mdt  >();
Map<String, NE_MOC_Action__c> actionItemMap = new Map<String, NE_MOC_Action__c>();
Map<String, NE_Site__c> sitemMap = new Map<String, NE_Site__c>();
map<ID,string> neSiteID = new map<ID,string>();
list<RecordType> RecordTypeId =[Select Id,SobjectType,Name From RecordType WHERE Name ='NE HSSE Task' and SobjectType ='Task'  limit 1];
queuesobject que = [Select id, Queue.Id From QueueSObject where Queue.Name = 'HSSE Management Tool' limit 1];
/** always we have to bulkify trigger code assuming that multiple records will be inserted/updated at once  **/

    // collect codes
    for(NE_MOC_Action__c actionItem : [SELECT id,Name,NE_MOC__r.NE_MoC_Title__c,NE_MOC__r.NE_MOC_Project_Manager__c,Line_Of_Business__c,NE_MOC__c,NE_MOC__r.Site_Location__c FROM NE_MOC_Action__c WHERE id IN:Trigger.new])
    {
    if(String.isNotBlank(actionItem.name))
        actionItemMap.put(actionItem.name,actionItem);
        neSiteID.put(actionItem.NE_MOC__r.Site_Location__c,actionItem.name);
    }
    
    for(NE_Site__c siteObj : [SELECT id,Name,NE_MOC_Process_Owner__c FROM NE_Site__c WHERE id IN:neSiteID.keyset()])
    {
    if(siteObj.NE_MOC_Process_Owner__c != null)
        sitemMap.put(neSiteID.get(siteObj.id),siteObj);
    }
    
    try{
    // query matching mdt based on collected codes and keep mappings in a map.
        if(!actionItemMap.isEmpty()){

            for(NE_MOC_Action_ItemTasks__mdt mocMCDSetting : [SELECT Action_Type__c,Discipline_Category__c,Line_Of_Business__c,Question_Name__c,Question_Description_Helptext__c
            FROM NE_MOC_Action_ItemTasks__mdt    
            WHERE Action_Type__c IN: actionItemMap.keySet()])
            {
                if(actionItemMap.containsKey(mocMCDSetting.Action_Type__c) && ( mocMCDSetting.Line_Of_Business__c == null  || (mocMCDSetting.Line_Of_Business__c != null && mocMCDSetting.Line_Of_Business__c == actionItemMap.get(mocMCDSetting.Action_Type__c).Line_Of_Business__c)))
                {
                    Task tsk = new Task();
                        tsk.ActivityDate = System.Today()+ Integer.valueof(label.NE_MOC_Action_Task_Due_Date);
                        tsk.IsVisibleInSelfService = TRUE;
                        tsk.Status = label.NE_MOC_Action_Task_Status; //'Not started';
                        //system.debug('sitemMap.get(mocMCDSetting.Action_Type__c).NE_MOC_Process_Owner__c'+sitemMap.get(mocMCDSetting.Action_Type__c).NE_MOC_Process_Owner__c);
                        IF(sitemMap.containsKey(label.NE_MOC_Action_Name_1_Review_Action_Items )){
                            //system.debug('sitemMap.get(mocMCDSetting.Action_Type__c).NE_MOC_Process_Owner__c'+sitemMap.get(mocMCDSetting.Action_Type__c).NE_MOC_Process_Owner__c);
                            //if NE MOC Action Name is "Review Action Items" then assign the task to NE MOC Process Owner.
                            //tsk.OwnerId = sitemMap.get(mocMCDSetting.Action_Type__c).NE_MOC_Process_Owner__c;
                            //tsk.Status = 'Completed';
                        }
                        //          commented below code to keep NE MOC Action item taks's owner from project manager to queue.
                        //if(actionItemMap.get(mocMCDSetting.Action_Type__c).NE_MOC__r.NE_MOC_Project_Manager__c !=null){
                        //    tsk.OwnerId = actionItemMap.get(mocMCDSetting.Action_Type__c).NE_MOC__r.NE_MOC_Project_Manager__c;
                        //}
                        tsk.OwnerId = que.Queue.Id;
                        tsk.Priority = 'Normal'; 
                        //tsk.type ='Screener'; 
                        tsk.NE_HSSE_H2_OPS_Line_Of_Business__c = actionItemMap.get(mocMCDSetting.Action_Type__c).Line_Of_Business__c;
                        tsk.NE_HSSE_MOC_Title__c = actionItemMap.get(mocMCDSetting.Action_Type__c).NE_MOC__r.NE_MoC_Title__c;
                        tsk.NE_HSSE_Site_Location__c = actionItemMap.get(mocMCDSetting.Action_Type__c).NE_MOC__r.Site_Location__c;
                        tsk.NE_HSSE_H2_OPS_Discipline_Category__c =mocMCDSetting.Discipline_Category__c;
                        tsk.Subject = mocMCDSetting.Question_Name__c;
                        tsk.NE_HSSE_H2_Question_description_Helptext__c=mocMCDSetting.Question_Description_Helptext__c;
                        tsk.WhatId = actionItemMap.get(mocMCDSetting.Action_Type__c).id;
                        tsk.NE_MOC__c =  actionItemMap.get(mocMCDSetting.Action_Type__c).NE_MOC__c;
                         if(RecordTypeId.size()>0){
                            tsk.RecordTypeId = RecordTypeId[0].id; 
                         }
                    NewTasks.add(tsk);  
                }

            }
            if(NewTasks.size()>0){
                insert NewTasks;
            }
        }
    }catch(Exception e){
        system.debug('Error occured during task creation in Action Item object'+e);
    }
    
}