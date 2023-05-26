public class LeadTriggerHelper 
    { 
        //Used 3 context variable to see if account/contact/opportunity is inserted from a lead
        public static Boolean hasInsertRunAccount = false;
    	public static Boolean hasInsertRunOpportunity = false;
    	public static Boolean hasInsertRunContact = false;
        
        public static void updateleaddetails(List<Lead> oldList, List<Lead> newList, Map<Id, Lead> oldMap, 
                                             Map<Id, Lead> newMap, System.TriggerOperation operationType)
        {  
            if(operationType == System.TriggerOperation.BEFORE_INSERT || operationType == System.TriggerOperation.BEFORE_UPDATE)
            {
                /************************* Setup BackStop Date ***************************************/
                updateBackStopDate(newList);
                /************************* Setup BackStop Date ***************************************/
            }
        }
        public static void updateBackStopDate(List<Lead> newList)
        {
            for(lead leadrecord : newList)
            {
                if(leadrecord.RecordTypeId != null && Schema.SObjectType.Lead.getRecordTypeInfosById().get(leadrecord.RecordTypeId).getDeveloperName() == Label.SEUK_Set_up_Requests)
                {
                    Boolean checkcondition = (leadrecord.Number_of_Gas_meters__c > SEUKStaticValues.min_Gas_meters || leadrecord.AnnVol_HH__c >= SEUKStaticValues.min_AnnVol_HH || leadrecord.AnnVol_NHH__c >= SEUKStaticValues.min_AnnVol_NHH);
                    if(leadrecord.Due_Date__c != null)
                    {
                        if(leadrecord.Setup_backstop_date__c == null)
                        {
                            Datetime dtduedate = datetime.newInstance(leadrecord.Due_Date__c.year(), leadrecord.Due_Date__c.month(),leadrecord.Due_Date__c.day());
                            dtduedate = checkcondition == true ? 
                                BusinessHours.add(Label.SEUK_Business_Hours_ID, dtduedate, SEUKStaticValues.millisecond_6_day) : 
                            BusinessHours.add(Label.SEUK_Business_Hours_ID, dtduedate, SEUKStaticValues.millisecond_3_day);
                            Date duedate = date.newinstance(dtduedate.year(), dtduedate.month(), dtduedate.day());
                            if(Date.today() < duedate)
                                leadrecord.Setup_backstop_date__c = duedate;
                            else
                                leadrecord.Setup_backstop_date__c = Date.today(); 
                        }
                    }
                    else
                        leadrecord.Setup_backstop_date__c  = null; 
                }
                
            }
        }
        public static void updateLeadConvert(List<Lead> oldList, List<Lead> newList, Map<Id, Lead> oldMap, Map<Id, Lead> newMap, 
                                             System.TriggerOperation operationType)
        {
            System.debug('Hello all 0');
            System.debug(operationType);
            System.debug(System.TriggerOperation.AFTER_UPDATE);
            System.debug(hasInsertRunAccount);
            System.debug(hasInsertRunOpportunity);
            System.debug(hasInsertRunContact);
            if(operationType == System.TriggerOperation.AFTER_UPDATE && (hasInsertRunAccount == True || hasInsertRunOpportunity == True || hasInsertRunContact ==True))
            {
                System.debug('Hello all 1');
                for(Lead leadrecord : newList)
            {
                if(leadrecord.RecordTypeId != null && Schema.SObjectType.Lead.getRecordTypeInfosById().get(leadrecord.RecordTypeId).getDeveloperName() == 
                   Label.Sector_Lead_DevRecordTypeName && ( (newMap != null && oldMap != null && newMap.get(leadrecord.Id).isConverted != oldMap.get(leadrecord.Id).isConverted )))
                {
                    System.debug('Hello all 2');
                    String errormessage = '';
                    
                    
                    if(hasInsertRunAccount == True){
                        if(leadrecord.Account_Type__c  == null)
                            errormessage += (errormessage != '' ? ' & ' : '')+Schema.getGlobalDescribe().get('Lead').getDescribe().fields.getMap().get('Account_Type__c').getDescribe().getLabel();
                    }
                    if(hasInsertRunAccount == True || hasInsertRunOpportunity == true){    
                    	if(leadrecord.Region__c  == null)
                            errormessage += (errormessage != '' ? ' & ' : '')+Schema.getGlobalDescribe().get('Lead').getDescribe().fields.getMap().get('Region__c').getDescribe().getLabel();
                    }
                    if(hasInsertRunContact == True)   { 
                    	if(leadrecord.Department__c  == null )
                            errormessage += (errormessage != '' ? ' & ' : '')+Schema.getGlobalDescribe().get('Lead').getDescribe().fields.getMap().get('Department__c').getDescribe().getLabel();
                    }
                    if(hasInsertRunOpportunity == true){
                        if(leadrecord.Estimated_Close_date__c  == null)
                            errormessage += (errormessage != '' ? ' & ' : '')+Schema.getGlobalDescribe().get('Lead').getDescribe().fields.getMap().get('Estimated_Close_date__c').getDescribe().getLabel();
                    }
                    if(hasInsertRunAccount == True){ 	
                    if(leadrecord.Sector__c  == null)
                            errormessage += (errormessage != '' ? ' & ' : '')+Schema.getGlobalDescribe().get('Lead').getDescribe().fields.getMap().get('Sector__c').getDescribe().getLabel();
                    }
                    if(errormessage != '')
                        leadrecord.addError(Label.Sector_Lead_validation_error_message + ' ' + errormessage);
                }
            }
            }
            
            
            
            
        }
        
        
        
    }