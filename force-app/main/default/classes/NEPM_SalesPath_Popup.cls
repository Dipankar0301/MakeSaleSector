public class NEPM_SalesPath_Popup 
{
    public NEPM_SalesPath_Popup()
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
            type = 'GIP';            
        }
        
        deliverablesList = [Select id, NEPM_Approved__c, NEPM_Deliverable_Type__c from NEPM_Deliverable__c where 
                            Project__c =: recId and NEPM_Deliverable_Type__c =:type];
        if(stageSelected =='Operate'){
            projectList = [Select id, NEPM_Stage__c, NEPM_Status__c from NEPM_Project__c where id =: recId ];
        }
        
        //system.debug('deliverablesList'+deliverablesList);
       // system.debug('projectList'+projectList);
        if(deliverablesList.size()>0 && deliverablesList[0].NEPM_Approved__c == false)
        {
            return 'showApprovalPopup';
        }
        else if(projectList.size()>0 && projectList[0].NEPM_Status__c!='Complete'){
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
            type = 'GIP';            
        }
        
        deliverablesList = [Select id, NEPM_Approved__c, NEPM_Deliverable_Type__c from NEPM_Deliverable__c where Project__c =: recId and NEPM_Deliverable_Type__c =:type];
        NEPM_Project__c nepmProject = [select Id,NEPM_Stage__c,NEPM_Status__c from NEPM_Project__c where Id=:recId];
        if(stageSelected =='Operate' && stageApproved == true){
            nepmProject.NEPM_Stage__c =stageSelected;
            nepmProject.NEPM_Status__c = 'Complete';
            
        }else{
            nepmProject.NEPM_Stage__c =stageSelected;
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
    @AuraEnabled
    Public static Boolean checkRecordLock(id recId){
        
        NEPM_Project__c np = [select id,NEPM_BOM_GAL__c,Approval_makes_Project_Read_Only__c,RecordType.name,Recordtype.Developername from NEPM_Project__c where id = :recId];
        if(np.Approval_makes_Project_Read_Only__c && (np.Recordtype.Developername == 'Global_Customer_Solutions' || np.Recordtype.Developername == 'NE_Americas' || np.Recordtype.Developername == 'NE_Asia' || np.Recordtype.Developername == 'NE_Australia' || np.Recordtype.Developername == 'NE_Europe' || np.Recordtype.Developername == 'Onshore_Power')){
            return true;                        
        }
        else{            
            return false;
        }
   }
}