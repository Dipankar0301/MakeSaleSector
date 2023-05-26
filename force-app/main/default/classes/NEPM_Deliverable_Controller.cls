Public with sharing class NEPM_Deliverable_Controller {
//public Blob csvFileBody{get;set;}


public String currentRecordId {get;set;}
public NEPM_Project__c nepmProjectlList {get; set;}
public NEPM_Deliverable__c detailObject = new NEPM_Deliverable__c();
public Boolean showInputForm{get;set;}
public Boolean showInputFormError{get;set;}
public Boolean showInputFormSuccess{get;set;}
// Project mandatory fields to check -- Start
public Boolean ProjectName{get;set;}
public Boolean Description{get;set;}
public Boolean HeadlineSize{get;set;}
public Boolean BOM{get;set;}
public Boolean DE{get;set;}
public Boolean ShellEquityShare{get;set;}
public Boolean Region{get;set;}
public Boolean TechnologyProjectType{get;set;}
public Boolean Strategymandate{get;set;}
// Project mandatory fields to check -- End
public String errorMessage{get;set;}
public String successMessage{get;set;}

/***MAP***/


    public NEPM_Deliverable_Controller(ApexPages.StandardController stdController){
        //this.xether_Opportunity = (XEther_Opportunity__c)stdController.getRecord();        
        currentRecordId = ApexPages.currentPage().getParameters().get('id');
        detailObject = [SELECT Id, Project__c,project__r.RecordType.name,project__r.Recordtype.Developername,DE_User__c, Decision_executive__c,Finance__c, Submitter__c, NEPM_Approved__c,NEPM_Deliverable_Type__c 
                     FROM NEPM_Deliverable__c WHERE Id =: currentRecordId LIMIT 1];
                     
        showInputForm = false;
        showInputFormError = false;
        showInputFormSuccess = false;
        if(detailObject !=null && detailObject.NEPM_Deliverable_Type__c!='PCI'){           
        showInputForm = False;
        showInputFormError = True;
        showInputFormSuccess = false;
        errorMessage='This approval process in only for PCI project deliverables. Click on Cancel button to go back.';
        }        
        else if(detailObject !=null && detailObject.NEPM_Approved__c==true){           
            showInputForm = False;
            showInputFormError = True;
            showInputFormSuccess = false;
            errorMessage='This record was already approved. Click on Cancel button to go back.';
        }
        else if(detailObject !=null && (detailObject.project__r.Recordtype.Developername <> 'Global_Customer_Solutions' 
                                    && detailObject.project__r.Recordtype.Developername <> 'NE_Americas' 
                                    && detailObject.project__r.Recordtype.Developername <> 'NE_Asia'
                                    && detailObject.project__r.Recordtype.Developername <> 'NE_Australia'
                                    && detailObject.project__r.Recordtype.Developername <> 'NE_Europe'
                                    && detailObject.project__r.Recordtype.Developername <> 'Onshore_Power')){
            showInputForm = False;
            showInputFormError = True;
            showInputFormSuccess = false;
            errorMessage=system.label.NEPM_Project_PCI_Energy_Solution_Error;
            
        }
        else if (![ Select Id From ProcessInstance WHERE TargetObjectId =: currentRecordId AND Status = 'Pending' ].isEmpty()){ 
            showInputForm = False;
            showInputFormError = True;
            showInputFormSuccess = false;
              errorMessage='Please note that this PCI in under an approval process. Click on Cancel button to go back.';              
                
        }else if(detailObject !=null && detailObject.Project__c !=null ){
            checkProjectDetails();
        }
        else{
            errorMessage='Some error occured. Click on Cancel button to go back.';
        }
    }
    
    public void checkProjectDetails(){

            errorMessage='Please check the CAPEX amount before submitting this record for approval.';
            nepmProjectlList = [select id, Name, NEPM_Decision_Executive__r.id, NEPM_Decision_Executive__r.Email, NEPM_Finance__r.Email , NEPM_Project_Description__c, NEPM_Headline_Size_M_USD__c, NEPM_BOM__c, NEPM_Decision_Executive__c, 
            NEPM_Shell_Equity_Share__c, NEPM_Region__c, NEPM_Technology__c, Mandate_Strategy__c FROM NEPM_Project__c WHERE id=: detailObject.Project__c LIMIT 1];
            system.debug('***nepmProjectlList***'+nepmProjectlList);
              if( nepmProjectlList !=null){
                    showInputForm = true;
                    showInputFormError = False;
                    showInputFormSuccess = False;
                    errorMessage='Please fill the below details and click on Save button.';
                    if(nepmProjectlList.Name !=null && nepmProjectlList.NEPM_Project_Description__c!=null && nepmProjectlList.NEPM_Headline_Size_M_USD__c!=null && 
                    nepmProjectlList.NEPM_Decision_Executive__c != null && nepmProjectlList.NEPM_Shell_Equity_Share__c!=null && nepmProjectlList.NEPM_Region__c !=null && nepmProjectlList.NEPM_Technology__c!=null && nepmProjectlList.Mandate_Strategy__c !=null){
                        showInputForm = False;
                        showInputFormError = False;
                        showInputFormSuccess = True;
                        successMessage='Do you have the approval email from line management (the GM if other than DE) to submit the PCI and have you made sure your project budget (FEASEX) is correct?.';                    
                    }
                    else{
                        if(nepmProjectlList.NEPM_Project_Description__c==null){
                            Description=true;                   
                        }
                        if(nepmProjectlList.NEPM_Headline_Size_M_USD__c==null){
                            HeadlineSize=true;                  
                        }
                        if(nepmProjectlList.NEPM_Decision_Executive__c==null){
                            DE=true;                    
                        }
                        if(nepmProjectlList.NEPM_Shell_Equity_Share__c==null){
                            ShellEquityShare=true;                  
                        }
                        if(nepmProjectlList.NEPM_Region__c==null){
                            Region=true;                    
                        }
                        if(nepmProjectlList.NEPM_Technology__c==null){
                            TechnologyProjectType=true;                    
                        }
                        if(nepmProjectlList.Mandate_Strategy__c==null){
                            Strategymandate=true;                  
                        }
                    }
            }
    }
  
    public void SaveProject(){   
        update nepmProjectlList;        
        checkProjectDetails();
    }
    
       
    public PageReference submitRecordForApproval(){
        try{
            
        User current_user=[SELECT Email FROM User WHERE Id= :UserInfo.getUserId() LIMIT 1] ;
        
        detailObject.Submit_For_Approval__c = true;
        detailObject.Approval_Tracking__c = 'Approval Submitted';
        detailObject.DE_User__c = nepmProjectlList.NEPM_Decision_Executive__r.id;
        detailObject.Decision_executive__c = nepmProjectlList.NEPM_Decision_Executive__r.Email;
        detailObject.Finance__c = nepmProjectlList.NEPM_Finance__r.Email;
        detailObject.Submitter__c = current_user.Email;
        
        update detailObject;
        
        Pagereference pageref = new Pagereference(System.Url.getSalesforceBaseUrl().toExternalForm() + '/one/one.app#/sObject/' + currentRecordId + '/view') ;
        pageref.setRedirect(false); 
        return pageref;
        
        }
        catch(Exception e){
        successMessage='';
        showInputFormSuccess=false;
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.Error,'Error occured while submiting the record for approval. Please contact system admin.'));
        return null;
        }
    }
}