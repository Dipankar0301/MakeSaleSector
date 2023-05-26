public with sharing class CaseTriggerHelper 
{ 
    
    public static void updatecasedetails(List<Case> oldList, List<Case> newList, Map<Id, Case> oldMap, 
                                            Map<Id, Case> newMap, System.TriggerOperation operationType)
    {/*  
        if(operationType == System.TriggerOperation.BEFORE_INSERT || operationType == System.TriggerOperation.BEFORE_UPDATE)
        {
            for(Case caserecord : newList)
            {
                if(caserecord.RecordTypeId != null && Schema.getGlobalDescribe().get('Case').getDescribe().getRecordTypeInfosById().get(caserecord.RecordTypeId).getDeveloperName() == 'SEUK_B2B_Cases')
                {
                    Boolean checkcondition = (caserecord.Number_of_Gas_meters__c > 0 || caserecord.AnnVol_HH__c >=5000 || caserecord.AnnVol_NHH__c >=5000);
                    if(caserecord.Due_Date__c != null)
                    {
                        Id SEUK_Business_Hours_ID = [SELECT Id, Name FROM BusinessHours 
                                                     where Name = :Label.SEUK_Business_Hours_Name limit 1].get(0).Id;
                        Datetime dtduedate = datetime.newInstance(caserecord.Due_Date__c.year(), caserecord.Due_Date__c.month(),caserecord.Due_Date__c.day());
                        Long millisecondoneday = 24*60*60*1000;
                        dtduedate = checkcondition == true ? 
                            BusinessHours.add(SEUK_Business_Hours_ID, dtduedate, -6*millisecondoneday) : 
                        BusinessHours.add(SEUK_Business_Hours_ID, dtduedate, -3*millisecondoneday);
                        Date duedate = date.newinstance(dtduedate.year(), dtduedate.month(), dtduedate.day());
                        if(Date.today() < duedate)
                            caserecord.Setup_backstop_date__c = duedate;
                        else
                            caserecord.Setup_backstop_date__c = Date.today(); 
                    }
                    else
                        caserecord.Setup_backstop_date__c  = null; 
                }
            }  
        }*/
    } 
}