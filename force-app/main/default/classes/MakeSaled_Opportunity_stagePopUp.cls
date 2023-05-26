public without sharing class MakeSaled_Opportunity_stagePopUp {
    @AuraEnabled
    Public static Map<String,List<String>> getPicklistValues(id recId){
        system.debug('line 5');
        

		Schema.DescribeFieldResult depend = Opportunity.Status_Reason__c.getDescribe();
    Schema.sObjectField controlToken = depend.getController();
    if (controlToken == null) {
        return new Map<String, List<String>>();
    }
 
    Schema.DescribeFieldResult control = Opportunity.StageName.getDescribe();
    List<Schema.PicklistEntry> controlEntries;
    if(control.getType() != Schema.DisplayType.Boolean) {
        controlEntries = control.getPicklistValues();
    }
 
    String base64map = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
    Map<String,List<String>> dependentPicklistValues = new Map<String,List<String>>();
    for (Schema.PicklistEntry entry : depend.getPicklistValues()) {
        if (entry.isActive() && String.isNotEmpty(String.valueOf(((Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(entry))).get('validFor')))) {
            List<String> base64chars =
                    String.valueOf(((Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(entry))).get('validFor')).split('');
            for (Integer index = 0; index < (controlEntries != null ? controlEntries.size() : 2); index++) {
                Object controlValue =
                        (controlEntries == null
                                ?   (Object) (index == 1)
                                :   (Object) (controlEntries[index].isActive() ? controlEntries[index].getLabel() : null)
                        );
                Integer bitIndex = index / 6;
                if (bitIndex > base64chars.size() - 1) {
                    break;
                }
                Integer bitShift = 5 - Math.mod(index, 6);
                if  (controlValue == null || (base64map.indexOf( base64chars[ bitIndex ] ) & (1 << bitShift)) == 0)
                    continue;
                if (!dependentPicklistValues.containsKey((String) controlValue)) {
                    dependentPicklistValues.put((String) controlValue, new List<String>());
                }
                dependentPicklistValues.get((String) controlValue).add(entry.getLabel());
            }
        }
    }
        System.debug('line 66');
        System.debug(dependentPicklistValues);
    return dependentPicklistValues;
    }
    @AuraEnabled
    Public static Map<String,List<String>> getPicklistValuesWakeUp(id recId){
        system.debug('line 5');
        

		Schema.DescribeFieldResult depend = Opportunity.Wake_up_date__c.getDescribe();
    Schema.sObjectField controlToken = depend.getController();
    if (controlToken == null) {
        return new Map<String, List<String>>();
    }
 
    Schema.DescribeFieldResult control = Opportunity.StageName.getDescribe();
    List<Schema.PicklistEntry> controlEntries;
    if(control.getType() != Schema.DisplayType.Boolean) {
        controlEntries = control.getPicklistValues();
    }
 
    String base64map = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
    Map<String,List<String>> dependentPicklistValues = new Map<String,List<String>>();
    for (Schema.PicklistEntry entry : depend.getPicklistValues()) {
        if (entry.isActive() && String.isNotEmpty(String.valueOf(((Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(entry))).get('validFor')))) {
            List<String> base64chars =
                    String.valueOf(((Map<String,Object>) JSON.deserializeUntyped(JSON.serialize(entry))).get('validFor')).split('');
            for (Integer index = 0; index < (controlEntries != null ? controlEntries.size() : 2); index++) {
                Object controlValue =
                        (controlEntries == null
                                ?   (Object) (index == 1)
                                :   (Object) (controlEntries[index].isActive() ? controlEntries[index].getLabel() : null)
                        );
                Integer bitIndex = index / 6;
                if (bitIndex > base64chars.size() - 1) {
                    break;
                }
                Integer bitShift = 5 - Math.mod(index, 6);
                if  (controlValue == null || (base64map.indexOf( base64chars[ bitIndex ] ) & (1 << bitShift)) == 0)
                    continue;
                if (!dependentPicklistValues.containsKey((String) controlValue)) {
                    dependentPicklistValues.put((String) controlValue, new List<String>());
                }
                dependentPicklistValues.get((String) controlValue).add(entry.getLabel());
            }
        }
    }
        System.debug('line 66');
        System.debug(dependentPicklistValues);
    return dependentPicklistValues;
    }
	@AuraEnabled
	Public static Boolean checkRecordLock(id recId){
    	Id profileId = userInfo.getProfileId();
    	Opportunity op = [select id,RecordType.name,Recordtype.Developername from Opportunity where id = :recId];
    	Profile pf =[select id,name from Profile where id=: profileId];
    	if(op.Recordtype.Developername == 'Sector'){
        	return true;                        
    	}
    	else{            
        	return false;
    		}
	}
	@AuraEnabled
	public static Boolean updateStageRecord(String recId, String stageSelected, String statusReason,String Wakeupdate){
    	//Boolean bool;
    	System.debug('line 111');
        system.debug(stageSelected + '---' + statusReason + '----'+ Wakeupdate);
    	Opportunity li=[select id,StageName,Status_Reason__c,Wake_up_date__c from Opportunity where id=: recId];
        if(stageSelected == 'Closed Won' || stageSelected == 'Closed Lost' || stageSelected == 'Prepare/Build' || stageSelected == 'Delivery' ){
            li.StageName = stageSelected;
    		li.Status_Reason__c = statusReason;
        	//li.Wake_up_date__c=Wakeupdate;
        }
        else if(stageSelected == 'Sleeping'){
            li.StageName = stageSelected;
    		//li.Status_Reason__c = statusReason;
        	li.Wake_up_date__c=Wakeupdate;
        }
        else{
            li.StageName = stageSelected;
            li.Wake_up_date__c=Wakeupdate;
        }
    	
    	update li;
    	return true;
	}
	@AuraEnabled
	public static String getPreviousStage(String recId){
    	Opportunity li=[select id,StageName from Opportunity where id=: recId];
    	String StName=li.StageName;
    	return StName;
		}
	}