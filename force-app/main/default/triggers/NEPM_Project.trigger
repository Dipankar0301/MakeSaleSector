trigger NEPM_Project on NEPM_Project__C(after insert, after update){
    
     DPM_rigger_Switch__c stoptrigger = DPM_rigger_Switch__c.getOrgDefaults();
     System.debug('****testing****'+stoptrigger.Stop_Trigger_Fire__c);
     
    if(trigger.isAfter && trigger.isInsert && !stoptrigger.Stop_Trigger_Fire__c){        
            NEPM_ProjectTriggerClass project = new NEPM_ProjectTriggerClass();
            project.insertProjects(Trigger.new);          
            
            Map<string,NEPM_Project__C> Promap = new Map<string,NEPM_Project__C>();
            set<string>         emailset     = new set<string>();
            Set<string>         emailsetGal  = new set<string>();
            Map<string,id>      usermap      = new Map<string,id>();
            Map<string,id>      galmap       = new Map<string,id>();
            Map<string,NEPM_Project__c> finCreatecheckduplicateMap    = new Map<string,NEPM_Project__c>();
            Map<integer,string> fincreateMap = new Map<integer,string>();
            integer p = 0;
            for(NEPM_Project__c newPro : [SELECT ID,
                                                 NAME,
                                                 NEPM_BA_Commercial_Lead_GAL__c,
                                                 NEPM_BA_Commercial_Lead_GAL__r.Email__c,
                                                 NEPM_BA__c,
                                                 NEPM_BA__r.email,
                                                 NEPM_BOM_GAL__c,
                                                 NEPM_BOM_GAL__r.email__c,
                                                 NEPM_BOM__c,
                                                 NEPM_BOM__r.Email,
                                                 NEPM_GAL_Finance__c,
                                                 NEPM_GAL_Finance__r.email__c,
                                                 NEPM_Finance__c,
                                                 NEPM_Finance__r.email,
                                                 NEPM_Commercial_Lead_GAL__c,
                                                 NEPM_Commercial_Lead_GAL__r.email__c,
                                                 NEPM_CL__c,
                                                 NEPM_CL__r.email,
                                                 NEPM_Decision_Executive_GAL__c,
                                                 NEPM_Decision_Executive_GAL__r.email__c,
                                                 NEPM_Decision_Executive__c,
                                                 NEPM_Decision_Executive__r.email,
                                                 NEPM_Technology_Lead__c,
                                                 NEPM_Technology_Lead__r.email,
                                                 NEPM_Technology_Lead_GAL__c,
                                                 NEPM_Technology_Lead_GAL__r.email__c,
                                                 RecordType.Name,
                                                 Recordtype.Developername
                                                 FROM NEPM_Project__c WHERE ID IN:Trigger.new AND NEPM_VP_Ship__c != 'DSAD']){
                                  
                if(newPro.NEPM_BOM_GAL__c != null || 
                    newPro.NEPM_GAL_Finance__c != null  || 
                    newPro.NEPM_Decision_Executive__c != null || 
                    newPro.NEPM_Technology_Lead_GAL__c != null ||
                    newPro.NEPM_BA_Commercial_Lead_GAL__c != null && newPro.Recordtype.Developername != 'Onshore_Power' ||
                    newPro.NEPM_Commercial_Lead_GAL__c != null && newPro.Recordtype.Developername == 'Onshore_Power')
                    {
                        
                        promap.put(newPro.id,newPro);
                        emailset.add(newPro.NEPM_BOM_GAL__r.email__c);
                        emailset.add(newPro.NEPM_GAL_Finance__r.email__c);
                        emailset.add(newPro.NEPM_Commercial_Lead_GAL__r.email__c);
                        emailset.add(newpro.NEPM_BA_Commercial_Lead_GAL__r.email__c);
                        emailset.add(newPro.NEPM_Decision_Executive_GAL__r.email__c);
                        emailset.add(newPro.NEPM_Technology_Lead_GAL__r.email__c);
                        emailsetGal.add(newPro.NEPM_Decision_Executive__r.email);
                        
                    }
            }
            if(emailset.size()>0){
            
                for(user u : [SELECT id,Email FROM USER WHERE Email IN:emailset and IsActive = True]){
                     
                      usermap.put(u.Email,u.id);
                      System.debug('****user*****'+u.email);
                }
            }
            if(emailsetGal.size()>0){
            
                for(GAL__c g : [SELECT Id,Email__c from GAL__c WHERE Email__c IN:emailsetGal and Email__c != null]){
                    
                      galmap.put(g.Email__c,g.id);
                      System.debug('***gal****'+g.Email__c);
                }
            }           
            if(!Promap.isEmpty() && !usermap.isEmpty()){
               
                project.AssignAccesstoUser(Promap,usermap,galmap);
            }
            for(NEPM_Project__c pro : [SELECT ID,NAME,RecordType.Name,Recordtype.Developername From NEPM_Project__c WHERE ID IN:Trigger.new AND Recordtype.Developername = 'Nature_Based_Solutions']){
                
                if(!finCreatecheckduplicateMap.containsKey(pro.id)){
                    
                    finCreatecheckduplicateMap.put(pro.id,pro);
                    fincreateMap.put(p+1,pro.id);
                }
            }
            if(!fincreateMap.isEmpty()){
                
                project.CreateFinaceRecords(fincreateMap);
            }
    }
    if(trigger.isAfter && trigger.isUpdate && !stoptrigger.Stop_Trigger_Fire__c){
        System.debug('***entered into After Update Trigger*****');        
        if(NEPM_AvoidRecursion.isFirstRun()){
             System.debug('****entered inside the login*****');
            NEPM_ProjectTriggerClass project = new NEPM_ProjectTriggerClass();
            project.updateProjects(Trigger.new,Trigger.oldMap);
            
            Map<string,NEPM_Project__c> Promap = new Map<string,NEPM_Project__c>();
            List<NEPM_Project__c>  prolist = new List<NEPM_Project__c>();
            List<NEPM_Project__c> prolistDeci = new List<NEPM_Project__c>();
            
            set<string> emailset = new set<string>();
            Set<string> emailsetGal = new set<string>();
            Map<string,id> usermap = new Map<String,id>();
            Map<string,id> galmap  = new Map<string,id>();
            for(NEPM_Project__c newPro : [SELECT ID,
                                                 NAME,
                                                 NEPM_BA_Commercial_Lead_GAL__c,
                                                 NEPM_BA_Commercial_Lead_GAL__r.Email__c,
                                                 NEPM_BA__c,
                                                 NEPM_BA__r.email,
                                                 NEPM_BOM_GAL__c,
                                                 NEPM_BOM_GAL__r.email__c,
                                                 NEPM_BOM__c,
                                                 NEPM_BOM__r.Email,
                                                 NEPM_GAL_Finance__c,
                                                 NEPM_GAL_Finance__r.email__c,
                                                 NEPM_Finance__c,
                                                 NEPM_Finance__r.email,
                                                 NEPM_Commercial_Lead_GAL__c,
                                                 NEPM_Commercial_Lead_GAL__r.email__c,
                                                 NEPM_CL__c,
                                                 NEPM_CL__r.email,
                                                 NEPM_Decision_Executive_GAL__c,
                                                 NEPM_Decision_Executive_GAL__r.email__c,
                                                 NEPM_Decision_Executive__c,
                                                 NEPM_Decision_Executive__r.email,
                                                 NEPM_Technology_Lead__c,
                                                 NEPM_Technology_Lead__r.email,
                                                 NEPM_Technology_Lead_GAL__c,
                                                 NEPM_Technology_Lead_GAL__r.email__c,
                                                 RecordType.Name,
                                                 Recordtype.Developername
                                           FROM NEPM_Project__c WHERE ID IN:Trigger.new AND NEPM_VP_Ship__c != 'DSAD']){
                System.debug('****entered into the triggerloop****');
                NEPM_Project__c oldPro = Trigger.oldMap.get(newPro.ID);
                if(newPro.NEPM_BOM_GAL__c != oldPro.NEPM_BOM_GAL__c && newPro.NEPM_BOM_GAL__c != null || 
                    newPro.NEPM_GAL_Finance__c != oldPro.NEPM_GAL_Finance__c && newPro.NEPM_GAL_Finance__c != null  || 
                    newPro.NEPM_Technology_Lead_GAL__c != oldPro.NEPM_Technology_Lead_GAL__c && newPro.NEPM_Technology_Lead_GAL__c != null ||
                    newPro.NEPM_Decision_Executive__c != oldPro.NEPM_Decision_Executive__c && newPro.NEPM_Decision_Executive__c != null || 
                    newPro.NEPM_BA_Commercial_Lead_GAL__c != oldPro.NEPM_BA_Commercial_Lead_GAL__c && newPro.NEPM_BA_Commercial_Lead_GAL__c != null && newPro.Recordtype.Developername != 'Onshore_Power' ||
                    newPro.NEPM_Commercial_Lead_GAL__c != oldPro.NEPM_Commercial_Lead_GAL__c && newPro.NEPM_Commercial_Lead_GAL__c != null && newPro.Recordtype.Developername == 'Onshore_Power')
                    {
                        System.debug('****entered into the Ifloop*****');
                        promap.put(newPro.id,newPro);
                        emailset.add(newPro.NEPM_BOM_GAL__r.email__c);
                        emailset.add(newPro.NEPM_GAL_Finance__r.email__c);
                        emailset.add(newPro.NEPM_Commercial_Lead_GAL__r.email__c);
                        emailset.add(newpro.NEPM_BA_Commercial_Lead_GAL__r.email__c);
                        emailset.add(newPro.NEPM_Decision_Executive_GAL__r.email__c);
                        emailset.add(newpro.NEPM_Technology_Lead_GAL__r.email__c);
                        emailsetGal.add(newPro.NEPM_Decision_Executive__r.email);
                        System.debug('*****newPro.NEPM_GAL_Finance__r.email__c****'+newPro.NEPM_GAL_Finance__r.email__c);
                        
                    }
                    else if(newPro.NEPM_BOM_GAL__c != oldPro.NEPM_BOM_GAL__c && newPro.NEPM_BOM_GAL__c == null || 
                    newPro.NEPM_GAL_Finance__c != oldPro.NEPM_GAL_Finance__c && newPro.NEPM_GAL_Finance__c == null  || 
                    newPro.NEPM_Decision_Executive__c != oldPro.NEPM_Decision_Executive__c && newPro.NEPM_Decision_Executive__c == null || 
                    newPro.NEPM_Technology_Lead_GAL__c != oldPro.NEPM_Technology_Lead_GAL__c && newPro.NEPM_Technology_Lead_GAL__c == null ||
                    newPro.NEPM_BA_Commercial_Lead_GAL__c != oldPro.NEPM_BA_Commercial_Lead_GAL__c && newPro.NEPM_BA_Commercial_Lead_GAL__c == null && newPro.Recordtype.Developername != 'Onshore_Power' ||
                    newPro.NEPM_Commercial_Lead_GAL__c != oldPro.NEPM_Commercial_Lead_GAL__c && newPro.NEPM_Commercial_Lead_GAL__c == null && newPro.Recordtype.Developername == 'Onshore_Power'){
                    
                           
                           prolist.add(newPro);
                    }
                    
            }
            System.debug('*****emailset.size()******'+emailset.size());
            System.debug('*****emailsetValue*****'+emailset);
            if(emailset.size() > 0){
                    
                    System.debug('******entered into the into user collection Login******');
                    for(user u : [SELECT id,Email FROM USER WHERE Email IN:emailset AND IsActive = True]){
                         
                          usermap.put(u.Email,u.id);
                          System.debug('****user*****'+u.email);
                    }
                    
            }
            if(emailsetGal.size() > 0){
            
                for(GAL__c g : [SELECT Id,Email__c from GAL__c WHERE Email__c IN:emailsetGal and Email__C != null]){
                    
                      galmap.put(g.Email__c,g.id);
                      System.debug('***gal****'+g.Email__c);
                }
            }   
            if(!Promap.isEmpty()){
               
                project.AssignAccesstoUser(Promap,usermap,galmap);
            }
            
            if(prolist.size() > 0){
            
                 project.RemoveAccesstoUser(prolist);
            }
             
        }
    }   
}