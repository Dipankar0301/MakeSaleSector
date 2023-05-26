public with sharing class NEPM_ProjectTriggerClass{
    list<ContentDocumentLink> insertNotesList = new list<ContentDocumentLink>();
    Map<id,ContentNote> insertContentNotesMap = new Map<id,ContentNote>();
    list<NEPM_Project__c> updateProjectList = new list<NEPM_Project__c>();
    list<NEPM_Project__c> insertProjectList = new list<NEPM_Project__c>();
    list<NEPM_Project__c> insertUpdateProjectList = new list<NEPM_Project__c>();
    list<ContentNote> updateContentNotesList =  new list<ContentNote>();   
    list<ContentDocumentLink> updateNotesList =  new list<ContentDocumentLink>();
    list<NEPM_Project__c> updateApprovalProjectReadonly = New List<NEPM_Project__c>();
    set<id> deliverableList =  new set<id>();
    list<id> processInstanceDelList =  new list<id>();
    Map<id, NEPM_Project__c> projectsMap = new Map<id, NEPM_Project__c>();
    Map<id, NEPM_Project__c> updateprojectsMap = new Map<id, NEPM_Project__c>();
    Map<id, NEPM_Deliverable__c> updateprojectwithPCIDelMap = new Map<id, NEPM_Deliverable__c>();
    list<id> projectIDsList = new list<id>();
    
    public void updateProjects(list<NEPM_Project__c> newprojectsList, Map<Id, NEPM_Project__c> projectOldMap){

        try{

            String userProfileName = [select Name from profile where id =: userinfo.getProfileId()].Name;
            for(NEPM_Deliverable__c nepmDelList :[SELECT id,Project__c from NEPM_Deliverable__c  WHERE Project__c IN: newprojectsList and NEPM_Deliverable_Type__c ='PCI']){
             updateprojectwithPCIDelMap.put(nepmDelList.id,nepmDelList);
            }
            
            
            for( ProcessInstance pcInstance :[Select Id,TargetObjectId From ProcessInstance WHERE TargetObjectId IN : updateprojectwithPCIDelMap.keyset() AND Status = 'Pending' ]){                
                deliverableList.add(updateprojectwithPCIDelMap.get(pcInstance.TargetObjectId).Project__c);
            }
            
            
            for(NEPM_Project__c project : newprojectsList)
            {
                if(project.NEPM_Status__c !=null &&  project.NEPM_Status__c != projectOldMap.get(project.Id).NEPM_Status__c && (project.NEPM_Status__c =='Inactive'|| project.NEPM_Status__c =='Cancelled') && project.Enter_Status_change_comments__c !=null){                
                    projectsMap.put(project.id,project);
                }

                if(deliverableList.contains(project.id)){
                    System.debug('****enterd into aproval pending*****'+project.id);
                    //project.adderror(system.label.NEPM_Project_PCI_lock_error);
                    NEPM_Project__c ne = new NEPM_Project__c();
                    ne.id  = project.id;
                    ne.Approval_makes_Project_Read_Only__c = True;
                    updateApprovalProjectReadonly.add(ne);
                }
            }
            
            
            
            //system.debug('projectsMap.values  333:'+projectsMap.values());
            if(projectsMap.values() !=null){ 
                for(NEPM_Project__c insertNotes : projectsMap.values()){     
                     ContentNote cnt = new ContentNote();
                    cnt.Content = Blob.valueof(insertNotes.Enter_Status_change_comments__c);
                    cnt.Title = 'Status changed to '+ insertNotes.NEPM_Status__c+'. See the comments below';  
                    insertContentNotesMap.put(insertNotes.id,cnt);
                }
            }
            
            if(insertContentNotesMap.values() !=null){ 
                insert insertContentNotesMap.values();
            }
            
            if(projectsMap.values() !=null){ 
                for(NEPM_Project__c insertNotes : projectsMap.values()){     
                        ContentDocumentLink clnk = new ContentDocumentLink();
                        clnk.LinkedEntityId = insertNotes.id;
                        clnk.ContentDocumentId = insertContentNotesMap.get(insertNotes.id).Id;
                        clnk.ShareType = 'I';
                        insertNotesList.add(clnk);
                }
            }
            
            if(insertNotesList.size()>0){
                insert insertNotesList;
            }
            
            if(updateProjectList.size()>0){
                update updateProjectList;   
            }
            if(updateApprovalProjectReadonly.size() > 0){
                System.debug('*****entered into the update of Approval****'+updateApprovalProjectReadonly.size());
                update updateApprovalProjectReadonly;
            }
        }              
        catch(Exception e){
            system.debug('Error while updating projects'+ e);            
        }
    }
    public void insertProjects(list<NEPM_Project__c> newprojectsList){

     try{
            for(NEPM_Project__c project : newprojectsList)
            {
                if(project.NEPM_Status__c !=null && (project.NEPM_Status__c =='Inactive'|| project.NEPM_Status__c =='Cancelled') && project.Enter_Status_change_comments__c !=null){                
                    projectsMap.put(project.id,project);
                }                   
            }
            system.debug('projectsMap.values  333:'+projectsMap.values());
            if(projectsMap.values() !=null){ 
                for(NEPM_Project__c insertNotes : projectsMap.values()){     
                     ContentNote cnt = new ContentNote();
                    cnt.Content = Blob.valueof(insertNotes.Enter_Status_change_comments__c);
                    cnt.Title = 'Status changed to '+ insertNotes.NEPM_Status__c+'. See the comments below';
                    insertContentNotesMap.put(insertNotes.id,cnt);
                }
            }
            
            if(insertContentNotesMap.values() !=null){ 
                insert insertContentNotesMap.values();
            }
            
            if(projectsMap.values() !=null){ 
                for(NEPM_Project__c insertNotes : projectsMap.values()){     
                        ContentDocumentLink clnk = new ContentDocumentLink();
                        clnk.LinkedEntityId = insertNotes.id;
                        clnk.ContentDocumentId = insertContentNotesMap.get(insertNotes.id).Id;
                        clnk.ShareType = 'I';
                        updateNotesList.add(clnk);
                }
            }
            
            if(updateNotesList.size()>0){
                insert updateNotesList;
            }
            
            if(insertUpdateProjectList.size()>0){
                update insertUpdateProjectList;   
            }
        }              
        catch(Exception e){
            system.debug('Error while inserting projects'+ e);            
        }
    }
    public void AssignAccesstoUser(Map<string,NEPM_Project__c> newprojectsMap,Map<string,id> emailmap,Map<string,id> emailmapGal){
        List<NEPM_Project__c> neprolist = new List<NEPM_Project__c>();
      try{ 
            for(NEPM_Project__c pro : newprojectsMap.values()){
                
                 NEPM_Project__c p = new NEPM_Project__c();
                 p.id = pro.id;
                 p.NEPM_BOM__c = pro.NEPM_BOM_GAL__c != null && emailmap.containsKey(pro.NEPM_BOM_GAL__r.Email__c) ? emailmap.get(pro.NEPM_BOM_GAL__r.Email__c) : pro.NEPM_BOM__r.Email != pro.NEPM_BOM_GAL__r.Email__c ? null : pro.NEPM_BOM__c;
                 p.NEPM_Finance__c = pro.NEPM_GAL_Finance__c != null && emailmap.containsKey(pro.NEPM_GAL_Finance__r.Email__c) ? emailmap.get(pro.NEPM_GAL_Finance__r.Email__c) : pro.NEPM_Finance__r.Email != pro.NEPM_GAL_Finance__r.Email__c ? null : pro.NEPM_Finance__c;
                 if(pro.Recordtype.Developername == 'Onshore_Power'){
                    p.NEPM_CL__c = pro.NEPM_Commercial_Lead_GAL__c != null && emailmap.containsKey(pro.NEPM_Commercial_Lead_GAL__r.Email__c) ? emailmap.get(pro.NEPM_Commercial_Lead_GAL__r.Email__c) : pro.NEPM_CL__r.Email != pro.NEPM_Commercial_Lead_GAL__r.Email__c ? null : pro.NEPM_CL__c;
                    p.NEPM_BA_Commercial_Lead_GAL__c = pro.NEPM_Commercial_Lead_GAL__c;
                 }
                 if(pro.Recordtype.Developername != 'Onshore_Power'){
                  
                     p.NEPM_BA__c = pro.NEPM_BA_Commercial_Lead_GAL__c != null && emailmap.containsKey(pro.NEPM_BA_Commercial_Lead_GAL__r.Email__c) ? emailmap.get(pro.NEPM_BA_Commercial_Lead_GAL__r.Email__c) : pro.NEPM_BA__r.Email != pro.NEPM_BA_Commercial_Lead_GAL__r.Email__c ? null : pro.NEPM_BA__c;
                     p.NEPM_Commercial_Lead_GAL__c = pro.NEPM_BA_Commercial_Lead_GAL__c;
                 }
                 if(pro.Recordtype.Developername == 'Nature_Based_Solutions'){
                 
                    p.NEPM_Technology_Lead__c = pro.NEPM_Technology_Lead_GAL__c != null && emailmap.containsKey(pro.NEPM_Technology_Lead_GAL__r.email__c) ? emailmap.get(pro.NEPM_Technology_Lead_GAL__r.email__c) : pro.NEPM_Technology_Lead__r.Email != pro.NEPM_Technology_Lead_GAL__r.email__c ? null : pro.NEPM_Technology_Lead__c;
                 }
                 p.NEPM_Decision_Executive_GAL__c = pro.NEPM_Decision_Executive__c != null && emailmapGal.containsKey(pro.NEPM_Decision_Executive__r.Email) ? emailmapGal.get(pro.NEPM_Decision_Executive__r.Email) : pro.NEPM_Decision_Executive__r.Email != pro.NEPM_Decision_Executive_GAL__r.Email__c ? null : pro.NEPM_Decision_Executive_GAL__c;
                 neprolist.add(p);
            }
            System.debug('****neprolist***'+neprolist.size());
            if(neprolist.size() > 0){
            
                update neprolist;
            }
        }
        catch(exception e){
        
              system.debug('Error while while Assigning access to user'+ e); 
        }
        
    }
    public void RemoveAccesstoUser(List<NEPM_Project__c> newproList){
        List<NEPM_Project__c> nepmprolist = new List<NEPM_Project__c>();
        try{    
            for(NEPM_Project__c pro : newproList){
                
                 NEPM_Project__c p = new NEPM_Project__c();
                 p.id = pro.id;
                 p.NEPM_BOM__c = pro.NEPM_BOM_GAL__c == null ? null: pro.NEPM_BOM__c;
                 p.NEPM_Finance__c = pro.NEPM_GAL_Finance__c == null  ? null : pro.NEPM_Finance__c;
                 if(pro.Recordtype.Developername == 'Onshore_Power'){
                
                     p.NEPM_CL__c = pro.NEPM_Commercial_Lead_GAL__c == null ? null : pro.NEPM_CL__c;
                     p.NEPM_BA_Commercial_Lead_GAL__c = pro.NEPM_Commercial_Lead_GAL__c;
                 }
                 if(pro.Recordtype.Developername != 'Onshore_Power'){
                     
                     p.NEPM_BA__c = pro.NEPM_BA_Commercial_Lead_GAL__c == null ? null : pro.NEPM_BA__c;
                     p.NEPM_Commercial_Lead_GAL__c = pro.NEPM_BA_Commercial_Lead_GAL__c;
                 }
                 if(pro.Recordtype.Developername == 'Nature_Based_Solutions'){
                     
                     p.NEPM_Technology_Lead__c = pro.NEPM_Technology_Lead_GAL__c == null ? null : pro.NEPM_Technology_Lead__c;
                 }
                 p.NEPM_Decision_Executive_GAL__c = pro.NEPM_Decision_Executive__c == null ? null : pro.NEPM_Decision_Executive_GAL__c;
                 nepmprolist.add(p);
            }
            System.debug('****nepmprolist***'+nepmprolist.size());
            if(nepmprolist.size() > 0){
            
                update nepmprolist;
            }  
            
        }
        catch(exception e){
     
          system.debug('Error while while Removing access to user'+ e); 
        }
     }
     public void CreateFinaceRecords(Map<integer,string> fincreateMap){
        List<Financial__c> finlist = new List<Financial__c>();  
        Integer j = 1;
        
        if(j <= fincreateMap.size()){
            
            Date dat = System.today();
            Integer yr = dat.year();
            System.debug('Year is ' + yr);
            for(integer i= 0;i <= 40; i++){
                
                Financial__c fin = new Financial__c();
                fin.Year__c      = yr + i;
                fin.Project__c   = fincreateMap.get(j);
                finlist.add(fin);

            }
            insert finlist;
        }
    }
}