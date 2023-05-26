public class dsad_SalesPath_Popup 
{
  public dsad_SalesPath_Popup()
    {
        
    }
    
    @AuraEnabled
    public static string validateApporvals(String recId, String stageSelected)
    {
        list<NEPM_Project__c> projectList = new list<NEPM_Project__c>();
    list<NEPM_Deliverable__c> deliverablesList = new list<NEPM_Deliverable__c>();
       // system.debug(' Record id ' + recId + ' ' + ' Stage selected '+ stageSelected);
        
        String type='';
        
        
    if(stageSelected == 'Assess (post PCI)')   
        {
            type = 'PCI';
        }
        
        if(stageSelected == 'Define (post PCN)')   
        {
            type = 'PCN';
        }
        
        if(stageSelected == 'Execute (post GIP)')   
        {
            type = 'GDP/GIP';            
        }
        
        deliverablesList = [Select id,NEPM_Approved__c,NEPM_Deliverable_Type__c from NEPM_Deliverable__c where 
                            Project__c =: recId and NEPM_Deliverable_Type__c =:type];
        if(stageSelected == 'Operate'){
          projectList = [Select id, NEPM_Stage__c, NEPM_Status__c from NEPM_Project__c where id =: recId ];
        }
        
        //system.debug('deliverablesList'+deliverablesList);
       // system.debug('projectList'+projectList);
        if(deliverablesList.size()>0 && deliverablesList[0].NEPM_Approved__c == false)
        {
            return 'showApprovalPopup';
        }
        else if(projectList.size()>0 && projectList[0].NEPM_Status__c != 'Complete'){
            return 'showStatusPopup';
        }
        else{
            return 'noPopup';
        }
        
    }  
  @AuraEnabled
    public static boolean updateDeliverable(String recId, String stageSelected,Boolean approved,Boolean stageApproved)
    {
    list<NEPM_Deliverable__c> deliverablesList = new list<NEPM_Deliverable__c>();          
        String type;      
        
    if(stageSelected == 'Assess (post PCI)')   
        {
            type = 'PCI';
        }
        
        if(stageSelected == 'Define (post PCN)')   
        {
            type = 'PCN';
        }
        
        if(stageSelected == 'Execute (post GIP)')   
        {
            type = 'GDP/GIP';            
        }
        
        deliverablesList = [Select id, NEPM_Approved__c, NEPM_Deliverable_Type__c from NEPM_Deliverable__c where Project__c =: recId and NEPM_Deliverable_Type__c =:type];
        NEPM_Project__c nepmProject = [select Id,NEPM_Stage__c,NEPM_Status__c from NEPM_Project__c where Id=:recId];
        if(stageSelected == 'Operate' && stageApproved == true){
          nepmProject.NEPM_Stage__c = stageSelected;
            nepmProject.NEPM_Status__c = 'Complete';
            
        }else{
            nepmProject.NEPM_Stage__c = stageSelected;
        }

        
        if(deliverablesList.size()>0)
        {
            deliverablesList[0].NEPM_Approved__c = approved;
            try{
        update deliverablesList;
                update nepmProject;
                return true;
            }
                catch(Exception e){
                    System.debug('Exception'+e);
                    return false;
                }
            
        }  
        else{
            update nepmProject;
            return false;
        }
        
    }
    /*@AuraEnabled
    Public static Boolean checkBOM(id recId){
        
        NEPM_Project__c np = [select id,NEPM_BOM__c from NEPM_Project__c where id = :recId];
        if(np.NEPM_BOM__c == null){
            return true;                        
        }
        else{            
            return false;
        }
        
        
        
    }*/
    @AuraEnabled
    Public static string checkMandatoryFieldsFromASSESS(id recId){
        
        NEPM_Project__c dsad = [select id,
                                     DS_Contact_for_Reporting__c,
                                     DS_Decision_Executive__c,
                                     DS_Expected_Date_into_SELECT__c,
                                     DS_Expected_Date_into_EXECUTE__c,
                                     DS_Expected_Date_into_OPERATE__c,
                                     DS_Expected_SPA_JVA_APA_signed__c,
                                     RecordType.name
                              from NEPM_Project__c where id = :recId];
        if(dsad.RecordType.name == 'DSAD' || dsad.RecordType.name == 'DSAD Post Identify'){
            if(dsad.DS_Contact_for_Reporting__c == null   || dsad.DS_Decision_Executive__c == null
                                                          || dsad.DS_Expected_Date_into_SELECT__c == null
                                                          || dsad.DS_Expected_Date_into_EXECUTE__c == null
                                                          || dsad.DS_Expected_Date_into_OPERATE__c == null
                                                          || dsad.DS_Expected_SPA_JVA_APA_signed__c == null){
               System.debug('I Entered into the DSAD Records');
                                                              
                return 'DSAD';                        
            }
            else{ 
                System.debug('entered into te fales of DSAD');
                return 'fa';
            }
          }
          else if((dsad.DS_Expected_Date_into_SELECT__c   == null || dsad.DS_Expected_Date_into_EXECUTE__c  == null
                                                                  || dsad.DS_Expected_Date_into_OPERATE__c  == null
                                                                  || dsad.DS_Expected_SPA_JVA_APA_signed__c == null)
                                                                  && (dsad.RecordType.name != 'DSAD' && dsad.RecordType.name != 'DSAD Post Identify')){
            
             System.debug('I Entered into the DSAD MC Record');                                                
             return 'DSAD MC';  
           }
        else{
             System.debug('entered into te fales of DSAD MC');
             return 'fa';
        }
   }
}