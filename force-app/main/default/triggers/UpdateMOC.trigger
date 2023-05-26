//This trigger is related to NE HSSE APP related to H2 Ops Management application.
trigger UpdateMOC on NE_MOC__c (before insert, before update,after update) {

    List<Task> tskList = new List<Task>();
    map<id,NE_Site__c> siteMap= new map<id,NE_Site__c>();
    List<NE_MOC_Action__c> neMOCActionList= new List<NE_MOC_Action__c>();
    map<id,id> MocMap = new map<id,id>();
    map<id,NE_MOC_Action__c> ProjectManagerIDMap = new map<id, NE_MOC_Action__c>();
    List<Task> updatetskOwnerList = new List<Task>();
    List<Task> insertTaskist = new List<Task>();
    map<id,NE_MOC__c> insertProjectManagerMap = new map<id,NE_MOC__c>();
    map<id,NE_MOC__c> insertPorcessOwnerMap = new map<id,NE_MOC__c>();
    map<id,NE_MOC__c> insertInitiatorMap = new map<id,NE_MOC__c>();
    list<RecordType> RecordTypeId =[Select Id,SobjectType,Name From RecordType WHERE Name ='NE HSSE Task' and SobjectType ='Task'  limit 1];
    try{
        if(Trigger.isBefore && Trigger.isInsert){   
            //Check the NE MOC Fields and update stage.
            for(NE_MOC__c mocObj :Trigger.New){
            //Make sure status was changed to Completed from something else and record type is NE_HSSE_Task for updates to only NE MOC related tasks.
                if(mocObj.NE_Screener1__c ==null && mocObj.NE_Screener2__c ==null && mocObj.NE_Screener3__c ==null && mocObj.NE_Screener4__c ==null){
                    mocObj.Screening_Status__c = 'NA';              
                }
                if(mocObj.NE_Screener1__c !=null || mocObj.NE_Screener2__c !=null || mocObj.NE_Screener3__c !=null || mocObj.NE_Screener4__c !=null ){
                    mocObj.Screening_Status__c = 'In Progress';
                    mocObj.NE_Stage__c = 'Under Screening';
                }
                if((mocObj.NE_Screener1__c ==null && mocObj.NE_Screener2__c ==null && mocObj.NE_Screener3__c ==null && mocObj.NE_Screener4__c ==null) && (mocObj.NE_Reviewer1__c !=null || mocObj.NE_Reviewer2__c !=null || mocObj.NE_Reviewer2__c !=null || mocObj.NE_Reviewer4__c !=null )){
                    mocObj.Reviewer_Status__c = 'In Progress';
                    mocObj.NE_Stage__c = 'Under Review';        
                }               
            }
        }
        //Change the task owner from default owner to NE MOC Project manager.
        if(Trigger.isAfter && Trigger.isUpdate){
            for(NE_MOC__c mocObj : Trigger.new){
                if(Trigger.oldMap.get(mocObj.Id).NE_MOC_Project_Manager__c == null && mocObj.NE_MOC_Project_Manager__c !=null || (Trigger.oldMap.get(mocObj.Id).NE_MOC_Project_Manager__c != mocObj.NE_MOC_Project_Manager__c && mocObj.NE_MOC_Project_Manager__c != null )){
                    MocMap.put(mocObj.id,mocObj.NE_MOC_Project_Manager__c);
                }
                if(mocObj.NE_stage__c == 'Implementation' && Trigger.oldMap.get(mocObj.Id).NE_stage__c != mocObj.NE_stage__c && mocObj.NE_MOC_Project_Manager__c != null){
                    insertProjectManagerMap.put(mocObj.id,mocObj);                    
                }
                if(mocObj.NE_stage__c == 'Post implementation approval' && Trigger.oldMap.get(mocObj.Id).NE_stage__c != mocObj.NE_stage__c && mocObj.BackendField_MOC_Process_Owner_Approver__c != null){
                    insertPorcessOwnerMap.put(mocObj.id,mocObj);
                }
                if(mocObj.NE_stage__c == 'Rejected' && Trigger.oldMap.get(mocObj.Id).NE_stage__c != mocObj.NE_stage__c ){
                    insertInitiatorMap.put(mocObj.id,mocObj);
                }                
            }
            if(insertProjectManagerMap.keyset().size()>0){
                for(Id mocID : insertProjectManagerMap.keyset()){
                    Task tsk = new Task();                     
                        tsk.ActivityDate = System.Today()+ Integer.valueof(label.NE_MOC_Task_Due_Date);
                        tsk.IsVisibleInSelfService = TRUE;
                        tsk.OwnerId = insertProjectManagerMap.get(mocID).NE_MOC_Project_Manager__c;
                        tsk.NE_HSSE_H2_OPS_Line_Of_Business__c = insertProjectManagerMap.get(mocID).NE_Line_Of_Business__c;
                        tsk.NE_HSSE_MOC_Title__c = insertProjectManagerMap.get(mocID).NE_MoC_Title__c;
                        tsk.NE_HSSE_Site_Location__c = insertProjectManagerMap.get(mocID).Site_Location__c;
                        tsk.type='Project Manager';
                        tsk.Priority = 'Normal';                    
                        tsk.Status = 'Not started';
                        tsk.WhatId = mocID;                     
                        tsk.NE_MOC__c = mocID; 
                        tsk.Subject = Label.NE_MOC_Project_manager_Task_Sub;
                        if(RecordTypeId.size()>0){
                        tsk.RecordTypeId = RecordTypeId[0].id; 
                    }
                    insertTaskist.add(tsk);
                }
            }
            if(insertPorcessOwnerMap.keyset().size()>0){
                for(Id mocID : insertPorcessOwnerMap.keyset()){
                    Task tsk = new Task();                     
                        tsk.ActivityDate = System.Today()+ Integer.valueof(label.NE_MOC_Task_Due_Date);
                        tsk.IsVisibleInSelfService = TRUE;
                        tsk.OwnerId = insertPorcessOwnerMap.get(mocID).BackendField_MOC_Process_Owner_Approver__c;
                        tsk.NE_HSSE_H2_OPS_Line_Of_Business__c = insertPorcessOwnerMap.get(mocID).NE_Line_Of_Business__c;
                        tsk.NE_HSSE_MOC_Title__c = insertPorcessOwnerMap.get(mocID).NE_MoC_Title__c;
                        tsk.NE_HSSE_Site_Location__c = insertPorcessOwnerMap.get(mocID).Site_Location__c;
                        tsk.type='Process Owner';
                        tsk.Priority = 'Normal';                    
                        tsk.Status = 'Not started';
                        tsk.WhatId = mocID;                     
                        tsk.NE_MOC__c = mocID; 
                        tsk.Subject = Label.NE_MOC_Process_Owner_Task_Sub;
                        if(RecordTypeId.size()>0){
                        tsk.RecordTypeId = RecordTypeId[0].id; 
                    }
                    insertTaskist.add(tsk);
                }
            }
            if(insertInitiatorMap.keyset().size()>0){
                for(Id mocID : insertInitiatorMap.keyset()){
                    Task tsk = new Task();                     
                        tsk.ActivityDate = System.Today()+ Integer.valueof(label.NE_MOC_Task_Due_Date);
                        tsk.IsVisibleInSelfService = TRUE;
                        tsk.OwnerId = insertInitiatorMap.get(mocID).OwnerId;
                        tsk.NE_HSSE_H2_OPS_Line_Of_Business__c = insertInitiatorMap.get(mocID).NE_Line_Of_Business__c;
                        tsk.NE_HSSE_MOC_Title__c = insertInitiatorMap.get(mocID).NE_MoC_Title__c;
                        tsk.NE_HSSE_Site_Location__c = insertInitiatorMap.get(mocID).Site_Location__c;
                        tsk.type='MOC Initiator';
                        tsk.Priority = 'Normal';                    
                        tsk.Status = 'Not started';
                        tsk.WhatId = mocID;                     
                        tsk.NE_MOC__c = mocID; 
                        tsk.Subject = Label.NE_MOC_Initiator_Task_Sub;
                        if(RecordTypeId.size()>0){
                        tsk.RecordTypeId = RecordTypeId[0].id; 
                    }
                    insertTaskist.add(tsk);
                }
            }   
            //          commented below code to keep NE MOC Action item taks's owner from project manager to queue.
            /***if(MocMap.keyset() !=null){
                for(NE_MOC_Action__c mocAction:[SELECT id, Name,NE_MOC__c,NE_MOC__r.NE_MOC_Project_Manager__c FROM NE_MOC_Action__c WHERE NE_MOC__c IN :MocMap.keyset()]){
                    ProjectManagerIDMap.put(mocAction.id,mocAction); 
                }
            }
            
            if(ProjectManagerIDMap.keyset().size()>0){
                for(Task tsk: [SELECT id,OwnerId,WhatId FROM Task WHERE status ='Not started' AND WhatId IN: ProjectManagerIDMap.keyset()]){
                    if(ProjectManagerIDMap.containsKey(tsk.WhatId) && ProjectManagerIDMap.get(tsk.WhatId) != null){
                        //get the task owner from ProjectManagerIDMap map by passing MOC Action record id.
                        ID id = ProjectManagerIDMap.get(tsk.WhatId).NE_MOC__c;
                        tsk.OwnerId = MocMap.get(id);
                        updatetskOwnerList.add(tsk);                    
                    }               
                }
            }***/
            
            // If NE MOC is approved, then Update NE MOC Action Review Action Items to complete.
            for(NE_MOC_Action__c actionItem : [SELECT id,Name,Line_Of_Business__c,NE_MOC__c,NE_MOC__r.BackendField_MOC_Process_Owner_Approver__c FROM NE_MOC_Action__c WHERE NE_MOC__c IN:insertProjectManagerMap.keyset()])
            {
                
                if(actionItem.Name == label.NE_MOC_Action_Name_1_Review_Action_Items ){
                    actionItem.NE_Completed__c = TRUE;
                    neMOCActionList.add(actionItem);
                }
            }
            //          commented below code to keep NE MOC Action item taks's owner from project manager to queue.
            //if(updatetskOwnerList.size()>0){
            //    Update updatetskOwnerList;
            //}
            if(insertTaskist.size()>0){
                Insert insertTaskist;
            }  
            
            if(neMOCActionList.size()>0){
                Update neMOCActionList;
            }               
            
        }
        //Make Project Manager as mandatory before approving the record.
        if(Trigger.isBefore && Trigger.isUpdate){
            list<id> siteLocationId = new list<id>();
            for(NE_MOC__c mocObj :Trigger.New){
                if(mocObj.NE_stage__c == 'Implementation' && Trigger.oldMap.get(mocObj.Id).NE_stage__c != mocObj.NE_stage__c && mocObj.NE_MOC_Project_Manager__c == null ){
                    mocObj.addError('Project Manager is mandatory. Access the '+mocObj.Name + ' record and fill the "MOC Project Manager" before Approving the MOC.'); 
                }  
                if(mocObj.NE_stage__c == 'Post implementation approval' && mocObj.MOC_Actions_Completed_Count__c  != mocObj.MOC_Actions_Count__c ){
                    mocObj.addError('Please Complete All NE MOC Actions before completing the Task.'); 
                }              
                if((mocObj.NE_stage__c == 'Closed' || mocObj.NE_stage__c == 'Rejected' ) && mocObj.Site_Location__c !=null && Trigger.oldMap.get(mocObj.Id).Site_Location__c != mocObj.Site_Location__c ){
                    //mocObj.addError('You can not change the Site/Location if MOC Stage is in Closed or Rejected'); 
                }
                if( Trigger.oldMap.get(mocObj.Id).Site_Location__c != mocObj.Site_Location__c ){
                    siteLocationId.add(mocObj.Site_Location__c); 
                }
                
                
            }            
            if(siteLocationId.size()>0){
                for(NE_Site__c site:[SELECT id, NE_MOC_Process_Owner__c FROM NE_Site__c WHERE ID IN :siteLocationId]){
                    siteMap.put(site.id, site);
                }
            }
            //for(NE_MOC__c mocObj : [SELECT id,NE_Reviewer1__c,NE_Reviewer2__c,NE_Reviewer3__c,NE_Reviewer4__c,NE_Screener1__c,NE_Screener2__c,NE_Screener3__c,NE_Screener4__c,Name,NE_stage__c,BackendField_MOC_Process_Owner_Approver__c,NE_MoC_Title__c,NE_Line_Of_Business__c,Site_Location__c,NE_MOC_Project_Manager__c FROM NE_MOC__c WHERE id IN:Trigger.new]){
                for(NE_MOC__c mocObj : Trigger.new){
                //Change the process Owner(Approver) if there is any change in Site/Location.
                if( siteMap.containsKey(mocObj.Site_Location__c) && siteMap.get(mocObj.Site_Location__c).NE_MOC_Process_Owner__c !=null){
                    mocObj.BackendField_MOC_Process_Owner_Approver__c = siteMap.get(mocObj.Site_Location__c).NE_MOC_Process_Owner__c;
                }
                //Create the task and assign to screener or reviewers accordingly.
                
                
                if(mocObj.NE_Stage__c == 'Under Screening' && Trigger.oldMap.get(mocObj.Id).NE_Screener1__c == null && mocObj.NE_Screener1__c !=null ){
                    Task tsk = new Task();                     
                         tsk.ActivityDate = System.Today()+ Integer.valueof(label.NE_MOC_Task_Due_Date);
                         tsk.IsVisibleInSelfService = TRUE;
                         tsk.OwnerId = mocObj.NE_Screener1__c;
                         tsk.NE_HSSE_H2_OPS_Line_Of_Business__c = mocObj.NE_Line_Of_Business__c;
                         tsk.NE_HSSE_MOC_Title__c = mocObj.NE_MoC_Title__c;
                         tsk.NE_HSSE_Site_Location__c = mocObj.Site_Location__c;
                         tsk.Priority = 'Normal';                    
                         tsk.Status = 'Not started';
                         tsk.type ='Screener'; 
                         tsk.WhatId = mocObj.id;                     
                         tsk.NE_MOC__c = mocObj.id; 
                         tsk.Subject = Label.NE_MOC_Screener_Task_Subject;
                         if(RecordTypeId.size()>0){
                            tsk.RecordTypeId = RecordTypeId[0].id; 
                         }
                    tskList.add(tsk);           
                }
                if(mocObj.NE_Stage__c == 'Under Screening' && Trigger.oldMap.get(mocObj.Id).NE_Screener2__c == null && mocObj.NE_Screener2__c !=null ){
                    Task tsk = new Task();
                         tsk.ActivityDate = System.Today()+ Integer.valueof(label.NE_MOC_Task_Due_Date);
                         tsk.IsVisibleInSelfService = TRUE;
                         tsk.OwnerId = mocObj.NE_Screener2__c;
                         tsk.NE_HSSE_H2_OPS_Line_Of_Business__c = mocObj.NE_Line_Of_Business__c;
                         tsk.NE_HSSE_MOC_Title__c = mocObj.NE_MoC_Title__c;
                         tsk.NE_HSSE_Site_Location__c = mocObj.Site_Location__c;
                         tsk.Priority = 'Normal';                    
                         tsk.Status = 'Not started';
                         tsk.type ='Screener'; 
                         tsk.WhatId = mocObj.id;
                         tsk.NE_MOC__c = mocObj.id;
                         tsk.Subject = Label.NE_MOC_Screener_Task_Subject;
                         if(RecordTypeId.size()>0){
                            tsk.RecordTypeId = RecordTypeId[0].id; 
                         }
                    tskList.add(tsk);           
                }           
                if(mocObj.NE_Stage__c == 'Under Screening' && Trigger.oldMap.get(mocObj.Id).NE_Screener3__c == null && mocObj.NE_Screener3__c !=null ){
                    Task tsk = new Task();
                         tsk.ActivityDate = System.Today()+ Integer.valueof(label.NE_MOC_Task_Due_Date);
                         tsk.IsVisibleInSelfService = TRUE; 
                         tsk.OwnerId = mocObj.NE_Screener3__c;
                         tsk.NE_HSSE_H2_OPS_Line_Of_Business__c = mocObj.NE_Line_Of_Business__c;
                         tsk.NE_HSSE_MOC_Title__c = mocObj.NE_MoC_Title__c;
                         tsk.NE_HSSE_Site_Location__c = mocObj.Site_Location__c;
                         tsk.Priority = 'Normal';                    
                         tsk.Status = 'Not started';
                         tsk.type ='Screener'; 
                         tsk.WhatId = mocObj.id;
                         tsk.NE_MOC__c = mocObj.id;
                         tsk.Subject = Label.NE_MOC_Screener_Task_Subject;
                         if(RecordTypeId.size()>0){
                            tsk.RecordTypeId = RecordTypeId[0].id; 
                         }
                    tskList.add(tsk);           
                }
                if(mocObj.NE_Stage__c == 'Under Screening' && Trigger.oldMap.get(mocObj.Id).NE_Screener4__c == null && mocObj.NE_Screener4__c !=null ){
                    Task tsk = new Task();
                         tsk.ActivityDate = System.Today()+ Integer.valueof(label.NE_MOC_Task_Due_Date);
                         tsk.IsVisibleInSelfService = TRUE;
                         tsk.OwnerId = mocObj.NE_Screener4__c;
                         tsk.NE_HSSE_H2_OPS_Line_Of_Business__c = mocObj.NE_Line_Of_Business__c;
                         tsk.NE_HSSE_MOC_Title__c = mocObj.NE_MoC_Title__c;
                         tsk.NE_HSSE_Site_Location__c = mocObj.Site_Location__c;
                         tsk.Priority = 'Normal';                    
                         tsk.Status = 'Not started';
                         tsk.type ='Screener'; 
                         tsk.WhatId = mocObj.id;
                         tsk.NE_MOC__c = mocObj.id;
                         tsk.Subject = Label.NE_MOC_Screener_Task_Subject;
                         if(RecordTypeId.size()>0){
                            tsk.RecordTypeId = RecordTypeId[0].id; 
                         }
                    tskList.add(tsk);           
                }   
                //if(mocObj.NE_Stage__c =='Under Review' && ((mocObj.NE_Reviewer1__c !=null && Trigger.oldMap.get(mocObj.Id).NE_Reviewer1__c != mocObj.NE_Reviewer1__c)  ||  (Trigger.oldMap.get(mocObj.Id).NE_Reviewer1__c == null && mocObj.NE_Reviewer1__c !=null ))){
                if((Trigger.oldMap.get(mocObj.Id).NE_Stage__c == 'Under Screening' && mocObj.NE_Stage__c =='Under Review' && mocObj.NE_Reviewer1__c !=null) || (Trigger.oldMap.get(mocObj.Id).NE_Stage__c =='Under Review' && mocObj.NE_Stage__c =='Under Review' && Trigger.oldMap.get(mocObj.Id).NE_Reviewer1__c == null && mocObj.NE_Reviewer1__c !=null)){
                    Task tsk = new Task();
                         tsk.ActivityDate = System.Today()+ Integer.valueof(label.NE_MOC_Task_Due_Date);
                         tsk.IsVisibleInSelfService = TRUE;
                         tsk.OwnerId = mocObj.NE_Reviewer1__c;
                         tsk.NE_HSSE_H2_OPS_Line_Of_Business__c = mocObj.NE_Line_Of_Business__c;
                         tsk.NE_HSSE_MOC_Title__c = mocObj.NE_MoC_Title__c;
                         tsk.NE_HSSE_Site_Location__c = mocObj.Site_Location__c;
                         tsk.Priority = 'Normal';                    
                         tsk.Status = 'Not started';
                         tsk.type ='Reviewer'; 
                         tsk.WhatId = mocObj.id;
                         tsk.NE_MOC__c = mocObj.id;
                         tsk.Subject = Label.NE_MOC_Task_Subject;
                         if(RecordTypeId.size()>0){
                            tsk.RecordTypeId = RecordTypeId[0].id; 
                         }
                    tskList.add(tsk);           
                }
                    if((Trigger.oldMap.get(mocObj.Id).NE_Stage__c == 'Under Screening' && mocObj.NE_Stage__c =='Under Review' && mocObj.NE_Reviewer2__c !=null) || (Trigger.oldMap.get(mocObj.Id).NE_Stage__c =='Under Review' && mocObj.NE_Stage__c =='Under Review' && Trigger.oldMap.get(mocObj.Id).NE_Reviewer2__c == null && mocObj.NE_Reviewer2__c !=null)){
                    Task tsk = new Task();
                         tsk.ActivityDate = System.Today()+ Integer.valueof(label.NE_MOC_Task_Due_Date);
                         tsk.IsVisibleInSelfService = TRUE;
                         tsk.OwnerId = mocObj.NE_Reviewer2__c;
                         tsk.NE_HSSE_H2_OPS_Line_Of_Business__c = mocObj.NE_Line_Of_Business__c;
                         tsk.NE_HSSE_MOC_Title__c = mocObj.NE_MoC_Title__c;
                         tsk.NE_HSSE_Site_Location__c = mocObj.Site_Location__c;
                         tsk.Priority = 'Normal';                    
                         tsk.Status = 'Not started';
                         tsk.type ='Reviewer'; 
                         tsk.WhatId = mocObj.id;
                         tsk.NE_MOC__c = mocObj.id;
                         tsk.Subject = Label.NE_MOC_Task_Subject;
                         if(RecordTypeId.size()>0){
                            tsk.RecordTypeId = RecordTypeId[0].id; 
                         }
                    tskList.add(tsk);           
                }   
                    if((Trigger.oldMap.get(mocObj.Id).NE_Stage__c == 'Under Screening' && mocObj.NE_Stage__c =='Under Review' && mocObj.NE_Reviewer3__c !=null) || (Trigger.oldMap.get(mocObj.Id).NE_Stage__c =='Under Review' && mocObj.NE_Stage__c =='Under Review' && Trigger.oldMap.get(mocObj.Id).NE_Reviewer3__c == null && mocObj.NE_Reviewer3__c !=null)){
                    Task tsk = new Task();
                         tsk.ActivityDate = System.Today()+ Integer.valueof(label.NE_MOC_Task_Due_Date);
                         tsk.IsVisibleInSelfService = TRUE;
                         tsk.OwnerId = mocObj.NE_Reviewer3__c;
                         tsk.NE_HSSE_H2_OPS_Line_Of_Business__c = mocObj.NE_Line_Of_Business__c;
                         tsk.NE_HSSE_MOC_Title__c = mocObj.NE_MoC_Title__c;
                         tsk.NE_HSSE_Site_Location__c = mocObj.Site_Location__c;
                         tsk.Priority = 'Normal';                    
                         tsk.Status = 'Not started';
                         tsk.type ='Reviewer'; 
                         tsk.WhatId = mocObj.id;
                         tsk.NE_MOC__c = mocObj.id;
                         tsk.Subject = Label.NE_MOC_Task_Subject;
                         if(RecordTypeId.size()>0){
                            tsk.RecordTypeId = RecordTypeId[0].id; 
                         }
                    tskList.add(tsk);           
                }   
                      if((Trigger.oldMap.get(mocObj.Id).NE_Stage__c == 'Under Screening' && mocObj.NE_Stage__c =='Under Review' && mocObj.NE_Reviewer4__c !=null) || (Trigger.oldMap.get(mocObj.Id).NE_Stage__c =='Under Review' && mocObj.NE_Stage__c =='Under Review' && Trigger.oldMap.get(mocObj.Id).NE_Reviewer4__c == null && mocObj.NE_Reviewer4__c !=null)){
                    Task tsk = new Task();
                         tsk.ActivityDate = System.Today()+ Integer.valueof(label.NE_MOC_Task_Due_Date);
                         tsk.IsVisibleInSelfService = TRUE;
                         tsk.OwnerId = mocObj.NE_Reviewer4__c;
                         tsk.NE_HSSE_H2_OPS_Line_Of_Business__c = mocObj.NE_Line_Of_Business__c;
                         tsk.NE_HSSE_MOC_Title__c = mocObj.NE_MoC_Title__c;
                         tsk.NE_HSSE_Site_Location__c = mocObj.Site_Location__c;
                         tsk.Priority = 'Normal';                    
                         tsk.Status = 'Not started';
                         tsk.type ='Reviewer'; 
                         tsk.WhatId = mocObj.id;
                         tsk.NE_MOC__c = mocObj.id;
                         tsk.Subject = Label.NE_MOC_Task_Subject;
                         if(RecordTypeId.size()>0){
                            tsk.RecordTypeId = RecordTypeId[0].id; 
                         }
                    tskList.add(tsk);           
                }               
            }   
            
            if(tskList.size()>0){
                Insert tskList;
            }
        }
    }catch(Exception e){
            system.debug('Error occured in AssignMOCTask NE_MOC__c trigger '+e);
    }
    
}