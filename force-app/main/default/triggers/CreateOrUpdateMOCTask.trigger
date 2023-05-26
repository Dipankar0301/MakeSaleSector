trigger CreateOrUpdateMOCTask on Task (before update,after update) {
    if(trigger.isBefore && trigger.isUpdate){
        Map<Id, Task> projectMapbeforeupdate= new Map<Id, Task>();
        map<id,NE_MOC__c> updateProjectManagerMap = new map<id,NE_MOC__c>();
        for(Task t :Trigger.New){
        //Make sure status was changed to Completed from something else and record type is NE_HSSE_Task for updates to only NE MOC related tasks.
            if(t.Status == 'Completed' && Trigger.oldMap.get(t.Id).Status != 'Completed' && (t.type=='Project Manager')){
                projectMapbeforeupdate.put(t.WhatId, t);
            }  
        }
        for(NE_MOC__c mocObj :[SELECT id, MOC_Actions_Completed_Count__c, MOC_Actions_Count__c, NE_MOC_Project_Manager__c,owner.id,BackendField_MOC_Process_Owner_Approver__c,NE_Reviewer3__c,NE_Reviewer4__c, Screening_Status__c, Reviewer_Status__c, NE_Stage__c FROM NE_MOC__c WHERE id IN: projectMapbeforeupdate.keySet()]){
            updateProjectManagerMap.put(mocObj.id,mocObj);
        }
        if(updateProjectManagerMap.keySet() != null){
            for(Task t :Trigger.New){
                if(updateProjectManagerMap.containsKey(t.WhatId))
                {
                    //Make sure status was changed to Completed from something else and record type is NE_HSSE_Task for updates to only NE MOC related tasks.
                    if(updateProjectManagerMap.get(t.WhatId) !=null && (updateProjectManagerMap.get(t.WhatId).MOC_Actions_Completed_Count__c  != updateProjectManagerMap.get(t.WhatId).MOC_Actions_Count__c )){
                        t.addError(label.NE_MOC_Show_error_to_Project_Manager); 
                    }   
                }       
            }
        }
    }
    if(trigger.isAfter && trigger.isUpdate){
    List<NE_MOC__c> neMOCList = new List<NE_MOC__c>();
    //List<NE_MOC__c> neMOCProjectManProcessOwnerList = new List<NE_MOC__c>();
    Map<id,list<Task>> taskMap = new Map<id,list<Task>>();
    Map<Id, Task> pMap= new Map<Id, Task>();
    Map<Id, Task> projectMap= new Map<Id, Task>();
    Map<Id, Task> processOwnerMap= new Map<Id, Task>();
    //Request for approval 
    Approval.ProcessSubmitRequest [] requestList = new Approval.ProcessSubmitRequest []{};
    //List<RecordType> HSSETaskRecordTypeId = new List<RecordType>();
   // HSSETaskRecordTypeId  = [Select Id,SobjectType,Name From RecordType Name ='NE_HSSE_Task' and SobjectType ='Task' limit 1];
   //This trigger is for NE HSSE App related to H2 Ops management application. Check the task status if all associated task statuses are completed then submit NE MOC Record  for aproval.
    for(Task t :Trigger.New){
    //Make sure status was changed to Completed from something else and record type is NE_HSSE_Task for updates to only NE MOC related tasks.
        if(t.Status == 'Completed' && Trigger.oldMap.get(t.Id).Status != 'Completed' && (t.type=='Screener' || t.type=='Reviewer' )){
            pMap.put(t.WhatId, t);
        }
        if(t.Status == 'Completed' && Trigger.oldMap.get(t.Id).Status != 'Completed' && (t.type=='Project Manager' || t.type=='MOC Initiator')){
            projectMap.put(t.WhatId, t);
        }
        if(t.Status == 'Completed' && Trigger.oldMap.get(t.Id).Status != 'Completed' &&  t.type=='Process Owner'){
            processOwnerMap.put(t.WhatId, t);
        }       
    }
    
    if(projectMap.size() > 0){
        for(NE_MOC__c mocObj :[SELECT id, NE_MOC_Project_Manager__c,owner.id,BackendField_MOC_Process_Owner_Approver__c,NE_Reviewer3__c,NE_Reviewer4__c, Screening_Status__c, Reviewer_Status__c, NE_Stage__c FROM NE_MOC__c WHERE id IN: projectMap.keySet()]){
            String stage = mocObj.NE_Stage__c;
            if(stage=='Implementation'){
                mocObj.NE_Stage__c='Post implementation approval';
            }
            if(stage=='Rejected'){
                mocObj.NE_Stage__c='Under Approval';
            }
            neMOCList.add(mocObj);
        }
    }
    
    if(processOwnerMap.size() > 0){
        for(NE_MOC__c mocObj :[SELECT id, NE_MOC_Project_Manager__c,owner.id,BackendField_MOC_Process_Owner_Approver__c,NE_Reviewer3__c,NE_Reviewer4__c, Screening_Status__c, Reviewer_Status__c, NE_Stage__c FROM NE_MOC__c WHERE id IN: processOwnerMap.keySet()]){
            String stage = mocObj.NE_Stage__c;            
            if(stage=='Post implementation approval'){
               mocObj.NE_Stage__c='Closed';
            }           
            neMOCList.add(mocObj);
        }
    }
            
        if(neMOCList.size()>0){
            Update neMOCList;
        }

    try{
        
        if(SV2020RecursiveTriggerHandler.isFirstTime){
            SV2020RecursiveTriggerHandler.isFirstTime = false;    
           
           //system.debug('***neMOCList***333'+neMOCList);
        // Check NE MOC has any taks
            if(pMap.size() > 0){
                Set<Id> pIds= pMap.keySet();         
                    // loop through NE MOC taks and add to map.
                    for(Task tsk :[SELECT id,WhatId,type,Status  FROM Task WHERE WhatId IN: pIds]){
                        
                        if(taskMap.containsKey(tsk.WhatId) && taskMap.get(tsk.WhatId) != null) {
                            List<Task> lst_task = taskMap.get(tsk.WhatId);
                            lst_task.add(tsk);
                            taskMap.put(tsk.WhatId,lst_task); 
                        }   
                        else {
                            taskMap.put(tsk.WhatId, new List<Task> {tsk});
                        }       
                    }
            // Check NE MOC has any taks and change the NE MOC stage based on tasks statuses.
            if(taskMap.keySet().size()>0){
                for(NE_MOC__c neMOCObj : [SELECT id, NE_Reviewer1__c,owner.id,NE_Reviewer2__c,NE_Reviewer3__c,NE_Reviewer4__c, Screening_Status__c, Reviewer_Status__c, NE_Stage__c FROM NE_MOC__c WHERE id IN: taskMap.keySet()]){
                list<task> tskList = taskMap.get(neMOCObj.id);
                String ScreenerStatus = 'Completed';
                String ReviewerStatus = 'Completed';
                    for(task tsk: tskList ){
                        //Check all Screener Task statuses.
                        IF(tsk.type=='Screener' && tsk.status != 'Completed'){
                            ScreenerStatus = 'In Progress';
                        }
                        //Check all Reviewer Task statuses.
                        IF(tsk.type=='Reviewer' && tsk.status != 'Completed'){
                            ReviewerStatus = 'In Progress';
                        }
                    }
                    
                    
                    if(neMOCObj.NE_Stage__c == 'Under Screening' && ScreenerStatus  == 'Completed'  && (neMOCObj.NE_Reviewer1__c != null || neMOCObj.NE_Reviewer2__c != null || neMOCObj.NE_Reviewer3__c != null || neMOCObj.NE_Reviewer4__c != null)){
                        neMOCObj.NE_Stage__c = 'Under Review';
                        neMOCObj.Screening_Status__c = ScreenerStatus ;
                    }else if(neMOCObj.NE_Stage__c == 'Under Review' && ScreenerStatus  == 'Completed'  && ReviewerStatus !='Completed'){
                        neMOCObj.NE_Stage__c = 'Under Review';
                    }else  if(ScreenerStatus  == 'Completed'  && ReviewerStatus =='Completed'){
                        neMOCObj.Reviewer_Status__c= ReviewerStatus ;
                        neMOCObj.Screening_Status__c = ScreenerStatus ;
                        neMOCObj.NE_Stage__c = 'Under Approval';
                    }
                    neMOCList.add(neMOCObj);
                }
            }
        }

            //system.debug('*** neMOCList***'+neMOCList);

            if(neMOCList.size()>0){
                Update neMOCList;
            }   

            set<Id> existingApprovalsSet = new set<Id>();
            // See whether NE MOC is already under approval?
            for(ProcessInstance e : [SELECT Id, TargetObjectId FROM ProcessInstance WHERE TargetObjectId IN : neMOCList AND Status = 'Pending']){        
            existingApprovalsSet.add(e.TargetObjectId);
            }    
            //system.debug('*** neMOCList***'+neMOCList);
            for(NE_MOC__c neMOCObj : neMOCList){        
            if(!existingApprovalsSet.contains(neMOCObj.Id)  && neMOCObj.NE_Stage__C =='Under Approval' ){   
            // Create an approval request for the NE MOC record.
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments('Please review and approve it.');
            req1.setObjectId(neMOCObj.id);
            req1.setSubmitterId(neMOCObj.Owner.id);
            // Submit the record to specific process
            req1.setProcessDefinitionNameOrId('New_NE_MOC_Approval_Process');
            requestList.add(req1);
            }
            }
            //system.debug('*** requestList***'+requestList);       
            if(requestList.size()>0){
            // Submit the approval request for the NE MOC
            Approval.ProcessResult[] result = Approval.process(requestList);
            }
        }

    }catch(Exception e){
            system.debug('Error occured in CreateOrUpdateMOCTask Task trigger '+e);
        }
    }
    
}