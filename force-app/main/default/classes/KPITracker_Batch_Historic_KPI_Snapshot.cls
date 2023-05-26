/*
* Author:  Aman Jaiswal & Y J, Sowmya
* Description: It's used to create Historic KPI Record every month of date 28.
*/

global class KPITracker_Batch_Historic_KPI_Snapshot implements Database.Batchable<sobject>,Database.Stateful {
    
    set<Id> setEntityId = new set<Id>();
    integer failureCount = 0;
    integer successCount = 0;
    List<KPITracker_EntityHistoricalKPIMapping__mdt> lstFieldsMapping= new List<KPITracker_EntityHistoricalKPIMapping__mdt>();
    
    public KPITracker_Batch_Historic_KPI_Snapshot(set<Id> getEntityId){
        setEntityId = getEntityId;
    }
    
    public KPITracker_Batch_Historic_KPI_Snapshot(){
    }
    
    //get all the entity record 
    global Database.QueryLocator start(Database.BatchableContext bc){
        string query;
        string entityFields;
        
        //query on custom meta data
        lstFieldsMapping =[SELECT Id,Label,Entity_Field_API__c,Historical_Field_API__c FROM KPITracker_EntityHistoricalKPIMapping__mdt];
        
        //get all the fields from custom meta data to perform SOQL
        for(KPITracker_EntityHistoricalKPIMapping__mdt field:lstFieldsMapping){
            if(String.isNotBlank(entityFields) && string.isNotEmpty(entityFields))
                entityFields+=',' + field.Entity_Field_API__c;
            else
                entityFields=',' + field.Entity_Field_API__c;
        }
        
        // dyncamic SOQL to get enitity record
        if(setEntityId.size()>0){
            query = 'SELECT Id '+entityFields+' FROM Entity__c where Id IN:setEntityId'; 
        }
        else{
            query = 'SELECT Id '+entityFields+' FROM Entity__c'; 
        }
        return Database.getQueryLocator(query);
    }
    
    //iterate the enitity record to create Historic KPI record 
    global void execute(Database.BatchableContext bc,List<Entity__c> lstEntityRec){
        try{        
            List<KPITracker_Historic_KPI__c> lstHisKpi = new List<KPITracker_Historic_KPI__c>();
            for(Entity__c objEnti:lstEntityRec){
                KPITracker_Historic_KPI__c objHisKpi = new KPITracker_Historic_KPI__c();
                for(KPITracker_EntityHistoricalKPIMapping__mdt field:lstFieldsMapping){
                    objHisKpi.put(field.Historical_Field_API__c,objEnti.get(field.Entity_Field_API__c));
                }
                lstHisKpi.add(objHisKpi);
            }
            Database.SaveResult[] saveResultList= Database.insert(lstHisKpi,false);
            for(Database.SaveResult sr:saveResultList){
                if(!sr.isSuccess()){
                    failureCount++;
                    for(Database.Error err:sr.getErrors()){
                        System.debug('error:: '+err.getMessage());
                    }
                }
                else{
                    successCount++;
                }
            }
        }
        catch(Exception ex){
            System.debug('exc: '+ex.getLineNumber()+' '+ex.getMessage()+' '+ex.getCause());
        }
        
    }
    // send email to notify the count of success and count of failure record
    global void finish(Database.BatchableContext bc){
        try{ 
            List<KPITracker_General_Setting__c> lstKpiGenralSetting = KPITracker_General_Setting__c.getall().values();
            AsyncApexJob asyncJob = [SELECT Id,Status,JobType,NumberOfErrors,JobItemsProcessed,TotalJobItems,CompletedDate,ExtendedStatus
                                     FROM AsyncApexJob WHERE Id =:BC.getJobId()];
            
            Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
            String[] toAddress = new String[]{lstKpiGenralSetting[0].To_Address__c};
                email.setToAddresses(toAddress);
            email.setSubject(lstKpiGenralSetting[0].Subject__c);
            
            email.setPlainTextBody
                ('The batch Apex job completed on  ' + asyncJob.CompletedDate + ',\n\n' +
                 'Job Status : ' + asyncJob.Status + '\n'+
                 'Total Job Items processed : ' + asyncJob.TotalJobItems + '\n'+
                 'Number of Job Items processed : ' + asyncJob.JobItemsProcessed + '\n' +
                 'Number of Success : '+ successCount+ '\n' +
                 'Number of Failures : '+ failureCount);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { email });
        }
        catch(Exception ex){
            System.debug('exc: '+ex.getLineNumber()+' '+ex.getMessage()+' '+ex.getCause());
        }
    }
    
}