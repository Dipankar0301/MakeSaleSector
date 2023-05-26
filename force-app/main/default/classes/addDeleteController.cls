public with sharing class addDeleteController {
    @AuraEnabled
    public static Boolean CheckforApproval(string parentRecID){
        
       boolean returnVal =  [select id,name,Approval_makes_Project_Read_Only__c from NEPM_Project__c where id=:parentRecID].Approval_makes_Project_Read_Only__c;
        
        return returnVal;
    
    }
    @AuraEnabled
    public static string checkforRecordtypeName(string parentRecID){
        
       string returnVal =  [select id,name,recordtype.name,Recordtype.Developername from NEPM_Project__c where id=:parentRecID].recordtype.Developername;
        
        return returnVal;
    
    }
    @AuraEnabled
    public static List<Financial__c> saveContacts(List<Financial__c> ListFinancial,String currentRecId){
        System.debug('=ListFinancial='+ListFinancial);
        
        String sObjectName = 'Financial__c';
        
        String listSObjectTypeName = 'List<' + sObjectName + '>';
        
        Type sobjectListType = Type.ForName(listSObjectTypeName);
        
        List<SObject> recordsToUpsert = (List<SObject>) sobjectListType.NewInstance();
        recordsToUpsert.addAll(ListFinancial);
        upsert recordsToUpsert;
        List<Financial__c> FinancialOrderList = [select Id,Project__c,Year__c,FEASEX_M__c,Non_NE_CAPEX_M__c,NE_CAPEX__c,Project__r.Approval_makes_Project_Read_Only__c,NEPM_Total_net_credits__c,OPEX_M__c from Financial__c where Project__c=:currentRecId order by Year__c asc];
        //return recordsToUpsert;
        //upsert ListFinancial;
        return FinancialOrderList;
    }
    @AuraEnabled
    public static List<Financial__c> findFinancials(String recId){
        
        return[select Id,Project__c,Year__c,FEASEX_M__c,Non_NE_CAPEX_M__c,NE_CAPEX__c,Project__r.Approval_makes_Project_Read_Only__c,NEPM_Total_net_credits__c,OPEX_M__c from Financial__c where Project__c=:recId order by Year__c asc];
    }
    
    
    @AuraEnabled
    public static void deleteFinancials(String currentRecId){
        System.debug('=currentRecId='+currentRecId);
        Financial__c deleteRecord = [select Id,Project__r.Approval_makes_Project_Read_Only__c from Financial__c where Id=:currentRecId];
        if(!deleteRecord.Project__r.Approval_makes_Project_Read_Only__c){
            
            delete deleteRecord;
        }
    }
}