public class KPITracker_KPITriggerHandler {
    public void assignDueDateValue(List<KPI__c> newKPIRecords, Map<Id,KPI__c>oldKPIRecordsMap){
        Boolean changeDueDate = false;
        Date DueDate = null;
        Boolean ChangeKPICreatedFor=false; // this variable is created to check wether we want to change KPI Created For field or not
        List<KPI__c> MonthlyKPIsRecords = New List<KPI__c>();// This variable will be used for those KPis which will be monthly and need to set KPI Created for
        List<KPI__c> QuarterlyKPIsRecords = New List<KPI__c>();// This variable will be used for those KPis which will be monthly and need to set KPI Created for
        Set<String> desiredRecordTypeIds = New Set<String>();
        List<KPI__c> KPIRecForChildRecCheck = New List<KPI__c>();
        Set<String> EntitiesForChildKPI = New Set<String>();
        Schema.DescribeSObjectResult R = KPI__c.SObjectType.getDescribe();
        List<Schema.RecordTypeInfo> RT = R.getRecordTypeInfos();
        Map<String,String> recordTypes = New Map<String,String>();
        for(Schema.RecordTypeInfo rr:RT){
            recordTypes.Put(rr.getDeveloperName(),rr.getRecordTypeId());
            if(rr.getDeveloperName()=='Power_KPI' || rr.getDeveloperName()=='Hydrogen_KPI' ||
               rr.getDeveloperName()=='Limited_Financials' || rr.getDeveloperName()=='IT_KPI' ||  rr.getDeveloperName()=='Customer_Centricity'){
                   desiredRecordTypeIds.add(rr.getRecordTypeId());
               }
        }
        for(KPI__c KPI:newKPIRecords){
            
            changeDueDate = false;
            ChangeKPICreatedFor=false;
            DueDate = null;
            if(oldKPIRecordsMap==null){
                changeDueDate = true;
                ChangeKPICreatedFor=true;
                //Below if block checks for Monthly KPIs
                if(KPI.KPI_Frequency__c=='Monthly'){
                    MonthlyKPIsRecords.add(KPI);        
                }
                if(desiredRecordTypeIds.contains(KPI.RecordTypeId)){
                    KPIRecForChildRecCheck.add(KPI);
                    EntitiesForChildKPI.add(KPI.Entity__c);
                }
                if(KPI.KPI_Frequency__c =='Quarterly'){
                    QuarterlyKPIsRecords.add(KPI);
                }
            }
            else{
                if(KPI.KPI_Frequency__c!=oldKPIRecordsMap.get(KPI.Id).KPI_Frequency__c || KPI.KPI_Date__c!=oldKPIRecordsMap.get(KPI.Id).KPI_Date__c){
                    changeDueDate = true;
                    ChangeKPICreatedFor=true;
                    //Below if block checks for Monthly KPIs
                    if(KPI.KPI_Frequency__c=='Monthly'){
                        MonthlyKPIsRecords.add(KPI);        
                    }
                    if(KPI.KPI_Frequency__c =='Quarterly'){
                    QuarterlyKPIsRecords.add(KPI);
                }
                }
                else{
                    changeDueDate = false;
                    ChangeKPICreatedFor=false;
                }
                if(desiredRecordTypeIds.contains(KPI.RecordTypeId) &&(
                    KPI.RecordTypeId!=oldKPIRecordsMap.get(KPI.Id).RecordTypeId ||
                    KPI.Entity__c!=oldKPIRecordsMap.get(KPI.Id).Entity__c)){
                        KPIRecForChildRecCheck.add(KPI);
                        EntitiesForChildKPI.add(KPI.Entity__c);
                    }
            }
            if(changeDueDate){
                if(KPI.KPI_Frequency__c=='Bi-Monthly'){
                    DueDate = KPI.KPI_Date__c.addMonths(2);
                    DueDate = DueDate.toStartOfMonth();
                    KPI.Due_Date__c = DueDate;      
                }
                if(KPI.KPI_Frequency__c=='Monthly'){
                    system.debug('===KPI'+KPI.KPI_Date__c);
                    system.debug('===DueDate'+DueDate);
                    DueDate = KPI.KPI_Date__c.addMonths(1);
                    DueDate = DueDate.toStartOfMonth();
                    KPI.Due_Date__c = DueDate;      
                }
                if(KPI.KPI_Frequency__c=='Quarterly'){
                    //Already calculated Due date in Formula field. So using the same date for Due_Date__c.
                        /***"Quarterly", IF(AND(Month(KPI_Date__c)>=1,Month(KPI_Date__c)<=3),DATE(Year(ADDMONTHS(KPI_Date__c,3)), 4 , 1),
                        IF(AND(Month(KPI_Date__c)>=4,Month(KPI_Date__c)<=6),DATE(Year(ADDMONTHS(KPI_Date__c,3)), 7 , 1),
                        IF(AND(Month(KPI_Date__c)>=7,Month(KPI_Date__c)<=9),DATE(Year(ADDMONTHS(KPI_Date__c,3)), 10 , 1),
                        IF(AND(Month(KPI_Date__c)>=9,Month(KPI_Date__c)<=12),DATE(Year(ADDMONTHS(KPI_Date__c,3)), 1 , 1),NULL)))),
                        ***/
                        KPI.Due_Date__c = KPI.Calculated_Due_Date__c;

                        //commenting Ankur code.
                        //start 
                        /***
                        DueDate = KPI.KPI_Date__c.addMonths(3);
                        DueDate = DueDate.toStartOfMonth();
                        KPI.Due_Date__c = DueDate;      

                        ***/ 
                        //end
                }
                if(KPI.KPI_Frequency__c=='Mid-Year'){
                    DueDate = KPI.KPI_Date__c.addMonths(7-KPI.KPI_Date__c.month());
                    DueDate = DueDate.toStartOfMonth();
                    KPI.Due_Date__c = DueDate;      
                }
                if(KPI.KPI_Frequency__c=='Yearly'){
                    DueDate = KPI.KPI_Date__c.addMonths(13-KPI.KPI_Date__c.month());
                    DueDate = DueDate.toStartOfMonth();
                    KPI.Due_Date__c = DueDate;      
                }
            }
        }
        if(KPIRecForChildRecCheck.size()>0){
            validateChildValue(KPIRecForChildRecCheck,EntitiesForChildKPI);
        }
        checkOverlapping(newKPIRecords, oldKPIRecordsMap);
        if(MonthlyKPIsRecords.size()>0){
            fillKPICreatedForValue(MonthlyKPIsRecords, 'Monthly');    
        }
        if(QuarterlyKPIsRecords.size() > 0){
             fillKPICreatedForValue(QuarterlyKPIsRecords, 'Quarterly');    
        }
        
    }
    
    public void checkOverlapping(List<KPI__c> newKPIRecords, Map<Id,KPI__c>oldKPIRecordsMap){
        set<Id> entityIds = new Set<Id>();
        Map<String,Map<String,Map<Date,Date>>> KpiDateMap = New Map<String,Map<String,Map<Date,Date>>>();
        Map<Date,Date> DateMap = New Map<Date,Date>();
        Map<String,Map<Date,Date>> NameandDateMap = New Map<String,Map<Date,Date>>();
        Map<String,Map<Date,Date>> NameandDateMapValues = New Map<String,Map<Date,Date>>();
        String KPIName = '';
        String KPIRecordTypeId = '';
        String EntityId = '';
        for(KPI__c kpi:newKPIRecords){
            entityIds.add(kpi.Entity__c);    
        }
        if(entityIds.size()>0){
            for(KPI__c kpi:[Select Id, Name, KPI_Date__c,Calculated_Due_Date__c, Due_Date__c,Entity__c,recordtypeId from KPI__c where Entity__c IN:entityIds]){
                DateMap = New Map<Date,Date>();
                NameandDateMap = New Map<String,Map<Date,Date>>();
                if(kpi.Due_Date__c!=null){
                    DateMap.put(kpi.KPI_Date__c,kpi.Due_Date__c);
                    NameandDateMap.put(kpi.recordtypeId+kpi.Name,DateMap);
                    if(KpiDateMap.containsKey(kpi.Entity__c)){
                        NameandDateMapValues = New Map<String,Map<Date,Date>>();
                        NameandDateMapValues = KpiDateMap.get(kpi.Entity__c);
                        NameandDateMapValues.putAll(NameandDateMap);
                        KpiDateMap.put(kpi.Entity__c,NameandDateMapValues);
                    }
                    else{
                        KpiDateMap.put(kpi.Entity__c,NameandDateMap);           
                    }
                }
            } 
        }
        Map<String,Map<Date,Date>>getNameDatesMap = New Map<String,Map<Date,Date>>();
        Map<Date,Date> KPIDateAndCalDateMap = New Map<Date,Date>();

        for(KPI__c kpi:newKPIRecords){
            if(KpiDateMap.containsKey(kpi.Entity__c)){
                getNameDatesMap = KpiDateMap.get(kpi.Entity__c);            
            }
            for(String Names:getNameDatesMap.keySet()){
                KPIDateAndCalDateMap =  getNameDatesMap.get(Names);
                Date firstElement = new List<Date> (KPIDateAndCalDateMap.keySet()).get(0);
                KPIRecordTypeId=Names.substring(0, 18);
                KPIName = Names.substring(18);                
                system.debug(KPIName+' !!! '+KPIName+' @@@@ '+kpi.KPI_Date__c+' ##### '+firstElement+' $$$ '+kpi.KPI_Date__c+' %%%% '+KPIDateAndCalDateMap.get(firstElement));
                if(KPIName!=kpi.Name && KPIRecordTypeId==kpi.RecordTypeId && ((kpi.KPI_Date__c<=firstElement && kpi.Due_Date__c>firstElement) || 
                                                                              (kpi.KPI_Date__c<KPIDateAndCalDateMap.get(firstElement) && kpi.Due_Date__c>=KPIDateAndCalDateMap.get(firstElement)) ||
                                                                              (kpi.KPI_Date__c<=firstElement && kpi.Due_Date__c>=KPIDateAndCalDateMap.get(firstElement)) ||
                                                                              (kpi.KPI_Date__c>=firstElement && kpi.Due_Date__c<=KPIDateAndCalDateMap.get(firstElement)))){
                                                                                  kpi.addError('KPI Duration is overlapping with '+KPIName);
                                                                              }
            }
        }
    }
    
    public void updateEthicalLeadershipKPI(List<KPI__c> newKPIRecords, Map<Id,KPI__c>oldKPIRecordsMap){
        set<Id> EntityIds = new set<Id>();
        set<Date> dueDateofKpis = new set<Date>();
        List<KPI__c> KPIListforDesiredDueDate = New List<KPI__c>();
        List<KPI__c> ParentKPIListforDesiredDueDate = New List<KPI__c>();
        Map<String,Double> ParentEntityComplianceTrainingMap = New Map<String,Double>();
        Map<String,Integer> ParentEntityCounterMap = New Map<String,Integer>();
        Map<String,Double> ParentEntityEngagementsMap = New Map<String,Double>();
        double tempvalue = 0.00;
        Integer counter = 0;
        String mapKey = '';
        Id EthicalLeadershipRecordTypeId = Schema.SObjectType.KPI__c.getRecordTypeInfosByDeveloperName().get('Ethical_Leadership').getRecordTypeId();
        Id L1EthicalLeadershipRecordTypeId = Schema.SObjectType.KPI__c.getRecordTypeInfosByDeveloperName().get('Ethical_Leadership_L1').getRecordTypeId();
        List<KPI__c> KPIsToUpdate = New List<KPI__c>();
        for(KPI__c KPI:newKPIRecords){
            
            if(KPI.RecordTypeId==L1EthicalLeadershipRecordTypeId){
                dueDateofKpis.add(KPI.Due_Date__c);               
                
                EntityIds.add(KPI.Entity__c);                
            }       
            
            //Update Nomination
        }
        if(dueDateofKpis.size()>0){
            for(KPI__c kpis: [Select id,Entity__c,Entity__r.Parent_Entity__c,Due_Date__c,E_C_Compliance_training_on_time__c,E_C_Engagements__c from KPI__c where Due_Date__c IN:dueDateofKpis and recordtypeid=:L1EthicalLeadershipRecordTypeId]){              
                mapKey = '';
                tempvalue = 0.00;
                counter = 0;
                if(kpis.Entity__r.Parent_Entity__c!=NULL){
                    mapKey = kpis.Entity__r.Parent_Entity__c+string.valueOf(kpis.Due_Date__c);
                    if(ParentEntityComplianceTrainingMap.containsKey(mapKey)){
                        tempvalue = ParentEntityComplianceTrainingMap.get(mapKey);
                        counter = ParentEntityCounterMap.get(mapKey);
                        tempvalue = tempvalue+kpis.E_C_Compliance_training_on_time__c;
                        ParentEntityComplianceTrainingMap.put(mapKey,tempvalue);
                        ParentEntityCounterMap.put(mapKey,counter+1);
                        tempvalue = ParentEntityEngagementsMap.get(mapKey);
                        tempvalue = tempvalue+kpis.E_C_Engagements__c;
                        ParentEntityEngagementsMap.put(mapKey,tempvalue);
                    }
                    else{
                        ParentEntityComplianceTrainingMap.put(mapKey,kpis.E_C_Compliance_training_on_time__c);
                        ParentEntityCounterMap.put(mapKey,1);
                        ParentEntityEngagementsMap.put(mapKey,kpis.E_C_Engagements__c);
                    }
                }       
            }
            for(KPI__c kpis: [Select id,Entity__c,Due_Date__c,E_C_Compliance_training_on_time__c,E_C_Engagements__c from KPI__c where Due_Date__c IN:dueDateofKpis and recordtypeid=:EthicalLeadershipRecordTypeId]){               
                mapKey = kpis.Entity__c+string.valueOf(kpis.Due_Date__c);
                KPI__c KpiObj = New KPI__c();
                if(ParentEntityComplianceTrainingMap.containsKey(mapKey)){
                    KpiObj = New KPI__c();
                    KpiObj.Id=kpis.Id; 
                    KpiObj.E_C_Compliance_training_on_time__c = ParentEntityComplianceTrainingMap.get(mapKey)/ParentEntityCounterMap.get(mapKey);
                    KpiObj.E_C_Engagements__c = ParentEntityEngagementsMap.get(mapKey);
                    KPIsToUpdate.add(KpiObj);
                }    
            }            
        }
        if(KPIsToUpdate.size()>0){
            update KPIsToUpdate;    
        }
        
    }
    
    
    
    public void updateNominiesEthical(List<KPI__c> newKPIRecords, Map<Id,KPI__c>oldKPIRecordsMap){
        set<Id> EntityIds = new set<Id>();
        List<Entity__c> updateEntities= new List<Entity__c>();        
        Map<Id,Decimal> totalNominies = New Map<Id,Decimal>();
        Map<Id,Decimal>  overdues= New Map<Id,Decimal>(); 
        Id EthicalLeadershipRecordTypeId = Schema.SObjectType.KPI__c.getRecordTypeInfosByDeveloperName().get('Ethical_Leadership').getRecordTypeId();
        //Id L1EthicalLeadershipRecordTypeId = Schema.SObjectType.KPI__c.getRecordTypeInfosByDeveloperName().get('Ethical_Leadership_L1').getRecordTypeId();
        List<KPI__c> KPIsToUpdate = New List<KPI__c>();   
        if(newKPIRecords.size()>0){     
            for(KPI__c KPI:newKPIRecords){
                
                if(oldKPIRecordsMap==null && KPI.RecordTypeId==EthicalLeadershipRecordTypeId){                   
                    EntityIds.add(KPI.Entity__c);
                    overdues.put(KPI.Entity__c,KPI.Number_of_overdues__c);
                    totalNominies.put(KPI.Entity__c,KPI.Total_nominations__c); 
                    if(KPI.Total_nominations__c != NULL && KPI.Number_of_overdues__c != NULL){
                        KPI.E_C_Compliance_training_on_time__c=((KPI.Total_nominations__c-KPI.Number_of_overdues__c)/KPI.Total_nominations__c)*100;                 
                    }
                    else if(KPI.Total_nominations__c != NULL){
                        KPI.E_C_Compliance_training_on_time__c = ((KPI.Total_nominations__c)/KPI.Total_nominations__c)*100;
                    }
                }
                else {
                    if(KPI.RecordTypeId==EthicalLeadershipRecordTypeId && ( KPI.KPI_Frequency__c!=oldKPIRecordsMap.get(KPI.Id).KPI_Frequency__c || KPI.KPI_Date__c!=oldKPIRecordsMap.get(KPI.Id).KPI_Date__c 
                                                                           ||                      KPI.Number_of_overdues__c != oldKPIRecordsMap.get(KPI.Id).Number_of_overdues__c 
                                                                           || KPI.Total_nominations__c != oldKPIRecordsMap.get(KPI.Id).Total_nominations__c 
                                                                           ||                       KPI.Active_KPI__c != oldKPIRecordsMap.get(KPI.Id).Active_KPI__c 
                                                                           || KPI.E_C_Engagements__c != oldKPIRecordsMap.get(KPI.Id).E_C_Engagements__c)){                         
                                                                               EntityIds.add(KPI.Entity__c);
                                                                               overdues.put(KPI.Entity__c,KPI.Number_of_overdues__c);
                                                                               totalNominies.put(KPI.Entity__c,KPI.Total_nominations__c); 
                                                                               if(KPI.Total_nominations__c != NULL && KPI.Number_of_overdues__c != NULL){
                                                                                   KPI.E_C_Compliance_training_on_time__c=((KPI.Total_nominations__c-KPI.Number_of_overdues__c)/KPI.Total_nominations__c)*100;                 
                                                                               }
                                                                               else if(KPI.Total_nominations__c != NULL){
                                                                                   KPI.E_C_Compliance_training_on_time__c = ((KPI.Total_nominations__c)/KPI.Total_nominations__c)*100;
                                                                               }else
                                                                               {
                                                                                   KPI.E_C_Compliance_training_on_time__c = null;
                                                                               }
                                                                           }
                }
                if(EntityIds !=null && !EntityIds.isEmpty()){
                    List<Entity__c> ec=[Select L1_Total_nominations__c,L1_Number_of_overdues__c from Entity__c where Id IN :EntityIds];
                    if(!ec.isEmpty()){
                        for(Entity__c cc:ec){
                            cc.L1_Total_nominations__c=totalNominies.get(cc.Id);
                            cc.L1_Number_of_overdues__c=overdues.get(cc.Id);
                            updateEntities.add(cc);
                        }
                    }
                    if(updateEntities != null){
                        update updateEntities;
                    }
                }
            }
        }
    }
    
    public void deleteEthicalLeadershipValuesInEntities(List<KPI__c> KPIRecords){
        //system.debug('deleteEthicalLeadershipValuesInEntities 111');
        set<Id> EntityIds = new set<Id>();
        List<Entity__c> updateEntities= new List<Entity__c>();        
        Map<Id,Decimal> totalNominies = New Map<Id,Decimal>();
        Map<Id,Decimal>  overdues= New Map<Id,Decimal>();
        Id EthicalLeadershipRecordTypeId = Schema.SObjectType.KPI__c.getRecordTypeInfosByDeveloperName().get('Ethical_Leadership').getRecordTypeId();
        //Id L1EthicalLeadershipRecordTypeId = Schema.SObjectType.KPI__c.getRecordTypeInfosByDeveloperName().get('Ethical_Leadership_L1').getRecordTypeId();
        List<KPI__c> KPIsToUpdate = New List<KPI__c>(); 
        for(KPI__c KPI: KPIRecords){
            if(KPI.RecordTypeId==EthicalLeadershipRecordTypeId){                         
                EntityIds.add(KPI.Entity__c);
                overdues.put(KPI.Entity__c,0);
                totalNominies.put(KPI.Entity__c,0);
            }
        }
        if(EntityIds !=null && !EntityIds.isEmpty()){
            //system.debug('deleteEthicalLeadershipValuesInEntities 222'+EntityIds);
            List<Entity__c> ec=[Select L1_Total_nominations__c,L1_Number_of_overdues__c from Entity__c where Id IN :EntityIds];
            if(!ec.isEmpty()){
                for(Entity__c cc:ec){
                    cc.L1_Total_nominations__c=totalNominies.get(cc.Id);
                    cc.L1_Number_of_overdues__c=overdues.get(cc.Id);
                    updateEntities.add(cc);
                }
            }
            if(updateEntities != null){
                update updateEntities;
            }
        }
    }
    
    
    // If Selected Entity Level is L2 is it is having Child on L3 Level then this method is created to show error message.
    public void validateChildValue(List<KPI__c> newKPIRecords,Set<String> entitiesforChild){
        Set<String> desiredParentEntity = New Set<String>();
        for(Entity__c ent: [Select Id, Name, Parent_Entity__c from Entity__c where Parent_Entity__c IN :entitiesforChild]){
            desiredParentEntity.add(ent.Parent_Entity__c);      
        }
        for(KPI__c KPI:newKPIRecords){
            if(desiredParentEntity.contains(KPI.Entity__c)){ 
                KPI.addError('This Entity cannot be assigned because it is having L3 Entity corresponding to it.');     
            }    
        }
        
    }
    // Below method is created to set value in KPI Created For Field.
    public void fillKPICreatedForValue(List<KPI__c> KPIRecords, String frequencyOfKPI){
        String KPICreatedFor = '';
        Date KPIDate=NULL;
        Map<Integer,String> monthsYear = New Map<Integer,String>();
        
        monthsYear.put(1,'January');
        monthsYear.put(2,'February');
        monthsYear.put(3,'March');
        monthsYear.put(4,'April');
        monthsYear.put(5,'May');
        monthsYear.put(6,'June');
        monthsYear.put(7,'July');
        monthsYear.put(8,'August');
        monthsYear.put(9,'September');
        monthsYear.put(10,'October');
        monthsYear.put(11,'November');
        monthsYear.put(12,'December');
        
        
        Map<String,String> quarterMonth = new Map<String,String>();
        quarterMonth.put('January','Q1');
        quarterMonth.put('February','Q1');
        quarterMonth.put('March','Q1');
        quarterMonth.put('April','Q2');
        quarterMonth.put('May','Q2');
        quarterMonth.put('June','Q2');
        quarterMonth.put('July','Q3');
        quarterMonth.put('August','Q3');
        quarterMonth.put('September','Q3');
        quarterMonth.put('October','Q4');
        quarterMonth.put('November','Q4');
        quarterMonth.put('December','Q4');
        
        
        if(frequencyOfKPI=='Monthly'){
            for(KPI__c KPI:KPIRecords){
                KPIDate = KPI.KPI_Date__c;
                if(KPIDate!=NULL){
                    KPIDate = KPIDate.addMonths(-1);
                    KPICreatedFor=  monthsYear.get(KPIDate.month())+' '+KPIDate.year();
                    KPI.KPI_Created_For__c = KPICreatedFor;
                }
                
            }       
        }
        else if(frequencyOfKPI=='Quarterly'){
            for(KPI__c KPI:KPIRecords){
                KPIDate = KPI.KPI_Date__c;
                if(KPIDate!=NULL){
                    KPIDate = KPIDate.addMonths(-3);
                    String quarterMon = quarterMonth.get(monthsYear.get(KPIDate.month())); 
                    //KPICreatedFor= quarterMon +' ';
                    /*if(quarterMon == 'Q4'){
                        KPIDate = KPIDate.addYears(-1);
                        KPICreatedFor = quarterMon + ' ' +KPIDate.year();
                    }
                    else*/
                      KPICreatedFor = quarterMon + ' ' +KPIDate.year();
                    KPI.KPI_Created_For__c = KPICreatedFor;
                }
                
            }
        }
    }
    
    public void calculateCustomerGrowth(List<KPI__c> newKPIRecords, Map<Id,KPI__c> oldKPIRecordsMap){
        Id customerCentricityRecordTypeId =  Schema.SObjectType.KPI__c.getRecordTypeInfosByName().get('Customer Centricity').getRecordTypeId();
        system.debug('==customerCentricityRecordTypeId'+customerCentricityRecordTypeId);
        List<KPI__c> customerCentricityKPIs = new List<KPI__c>();
        List<Id> relatedEntities = new List<Id>();
        for(KPI__c kpi: newKPIRecords){
            system.debug('===Kpi'+kpi);
          if(kpi.RecordTypeId == customerCentricityRecordTypeId && 
                ((oldKPIRecordsMap== null && (kpi.Net_customer_with_trend_B2B__c!=null  ||  kpi.Net_customer_with_trend_B2C__c!=null))
               || ( oldKPIRecordsMap!=null && 
                   (kpi.Net_customer_with_trend_B2B__c!= oldKPIRecordsMap.get(kpi.Id).Net_customer_with_trend_B2B__c ||
                 kpi.Net_customer_with_trend_B2C__c!=oldKPIRecordsMap.get(kpi.Id).Net_customer_with_trend_B2C__c
               || kpi.KPI_Date__c!=oldKPIRecordsMap.get(kpi.Id).KPI_Date__c))) ){
               customerCentricityKPIs.add(kpi);
               relatedEntities.add(kpi.Entity__c);
            }
           /* }else if(oldKPIRecordsMap!=null &&  kpi.RecordTypeId==customerCentricityRecordTypeId &&
                     (kpi.Net_customer_with_trend_B2B__c!= oldKPIRecordsMap.get(kpi.Id).Net_customer_with_trend_B2B__c ||
                 kpi.Net_customer_with_trend_B2C__c!=oldKPIRecordsMap.get(kpi.Id).Net_customer_with_trend_B2C__c
                                                 || kpi.KPI_Date__c!=oldKPIRecordsMap.get(kpi.Id).KPI_Date__c)){
                                                   customerCentricityKPIs.add(kpi);
               relatedEntities.add(kpi.Entity__c);   
            }
         */
    
        }
        if(customerCentricityKPIs.size() > 0 ){
            List<KPI__c> childKPIsForEntity =[Select Id,Entity__c,Net_customer_with_trend_B2B__c,Net_customer_with_trend_B2C__c from KPI__c where Entity__c=:relatedEntities AND recordtypeId=:customerCentricityRecordTypeId AND (NOT ID IN:customerCentricityKPIs) order by Entity__c,KPI_Date__c desc ];
            Map<Id,KPI__c> entityKPIs = new Map<Id,KPI__c>();
            List<KPI__c> updateKPIs = new List<KPI__c>();
            if(childKPIsForEntity!= null && childKPIsForEntity.size() > 0){
                for(KPI__c kpiRec: childKPIsForEntity){
                    if(!entityKPIs.containsKey(kpiRec.Entity__c)){
                        entityKPIs.put(kpiRec.Entity__c,kpiRec);
                    }
              }
            }
            for(KPI__c kpi: customerCentricityKPIs){
                if(entityKPIs!= null && entityKPIs.containsKey(kpi.Entity__c)){
                    Double growthB2B,growthB2C=0.00;
                        
                    KPI__c lastMonthKPI = entityKPIs.get(kpi.Entity__c);
                    
                    if(kpi.Net_customer_with_trend_B2B__c!= null && lastMonthKPI.Net_customer_with_trend_B2B__c!=null && kpi.Net_customer_with_trend_B2B__c!= 0 && lastMonthKPI.Net_customer_with_trend_B2B__c!=0){
                        growthB2B =  ((kpi.Net_customer_with_trend_B2B__c - lastMonthKPI.Net_customer_with_trend_B2B__c)/(lastMonthKPI.Net_customer_with_trend_B2B__c))*100;
                    }
                    else if((kpi.Net_customer_with_trend_B2B__c== null && kpi.Net_customer_with_trend_B2B__c!= 0) &&  (lastMonthKPI.Net_customer_with_trend_B2B__c !=null && lastMonthKPI.Net_customer_with_trend_B2B__c !=0)){
                        growthB2B = ( (0 - lastMonthKPI.Net_customer_with_trend_B2B__c)/( lastMonthKPI.Net_customer_with_trend_B2B__c))*100;
                    }else if((lastMonthKPI.Net_customer_with_trend_B2B__c== null && lastMonthKPI.Net_customer_with_trend_B2B__c!= 0) && (kpi.Net_customer_with_trend_B2B__c !=null && kpi.Net_customer_with_trend_B2B__c!=0)){
                       growthB2B =  (kpi.Net_customer_with_trend_B2B__c/kpi.Net_customer_with_trend_B2B__c)*100 ;
                    }
                    
                    if(kpi.Net_customer_with_trend_B2C__c!= null && lastMonthKPI.Net_customer_with_trend_B2C__c!=null && kpi.Net_customer_with_trend_B2C__c!= 0 && lastMonthKPI.Net_customer_with_trend_B2C__c!=0){
                        growthB2C= ((kpi.Net_customer_with_trend_B2C__c - lastMonthKPI.Net_customer_with_trend_B2C__c)/(lastMonthKPI.Net_customer_with_trend_B2C__c))*100;
                    }else if((kpi.Net_customer_with_trend_B2C__c== null && kpi.Net_customer_with_trend_B2C__c!= 0) && (lastMonthKPI.Net_customer_with_trend_B2C__c !=null  && lastMonthKPI.Net_customer_with_trend_B2C__c !=0)){
                        growthB2C= ((0 - lastMonthKPI.Net_customer_with_trend_B2C__c)/(lastMonthKPI.Net_customer_with_trend_B2C__c))*100;
                    }else if((lastMonthKPI.Net_customer_with_trend_B2C__c== null && lastMonthKPI.Net_customer_with_trend_B2C__c!= 0) && (kpi.Net_customer_with_trend_B2C__c !=null && kpi.Net_customer_with_trend_B2B__c!=0)){
                        growthB2C= (kpi.Net_customer_with_trend_B2C__c/kpi.Net_customer_with_trend_B2C__c)*100 ;
                    }
                    KPI__c kpiRec= new KPI__c(Id=kpi.Id,Customer_growth_B2C__c=growthB2C,Customer_growth_B2B__c=growthB2B,Last_Month_Total_Customer_B2C__c=lastMonthKPI.Net_customer_with_trend_B2C__c,Last_Month_Total_Customer_B2B__c=lastMonthKPI.Net_customer_with_trend_B2B__c);
                    updateKPIs.add(kpiRec);
                    
                    
                }
                else {
                    KPI__c kpiRec= new KPI__c(Id=kpi.Id,Customer_growth_B2C__c=kpi.Net_customer_with_trend_B2C__c!=null?kpi.Net_customer_with_trend_B2C__c*100:0,Customer_growth_B2B__c=kpi.Net_customer_with_trend_B2B__c!=null?kpi.Net_customer_with_trend_B2B__c*100:0);
                    updateKPIs.add(kpiRec);
                }
                
            }
            if(updateKPIs.size()> 0){
                update updateKPIs;
            }
            
            
        }
        
    }
  
}