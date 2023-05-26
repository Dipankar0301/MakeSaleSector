@isTest
public class MakeSaled_Opportunity_stagePopUpTest {
    
    @isTest
    public static void stagePopUp(){
        Id recordtypeidorg1= Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId();
        Id recordtypeidorg2= Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Hydrogen').getRecordTypeId();
        Id recordtypeidorgaccount= Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId();
        Account acc =new Account(Name='DK0301', RecordTypeId= recordtypeidorgaccount, Region__c='Europe', Sector__c='Technology');
        insert acc;
        Opportunity obj1 =new Opportunity(recordTypeId= recordtypeidorg1, Name = 'test2', AccountId =acc.id, 
                                          StageName= 'Align', CloseDate = system.today(), Product_Category_1__c= 'Power', 
                                          Product_Sub_Category_1__c='Renewable',Opportunity_Country__c='Afghanistan', 
                                          Opportunity_Region__c='Europe',Value_Amount__c = 10);
        
        insert obj1;
        Boolean bool1=MakeSaled_Opportunity_stagePopUp.checkRecordLock(obj1.id);
        System.assertEquals(true, bool1);
        Opportunity obj2 =new Opportunity(recordTypeId= recordtypeidorg2, Name = 'test2', AccountId =acc.id, 
                                          StageName= 'Closed Won', CloseDate = system.today(), 
                                          Exclusivity_Start_Date__c =system.today(),ForecastCategoryName='Closed', Solution_Category__c= 'Energy Efficiency',
                                          Opportunity_Country__c='Afghanistan', Opportunity_Region__c='Europe',Value_Amount__c = 10);
        
        insert obj2;
        Boolean bool2=MakeSaled_Opportunity_stagePopUp.checkRecordLock(obj2.id);
        System.assertEquals(false, bool2);
        String s1=MakeSaled_Opportunity_stagePopUp.getPreviousStage(obj1.id);
        System.assertEquals('Align', s1);
        Boolean updateStage= MakeSaled_Opportunity_stagePopUp.updateStageRecord(obj1.Id, 'Closed Won','Price','');
        System.assertEquals(true, updateStage);
        
    }
    @isTest
    public static void statusComment(){
        Id recordtypeidorg1= Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId();
        Id recordtypeidorg2= Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Hydrogen').getRecordTypeId();
        Id recordtypeidorgaccount= Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId();
        Account acc =new Account(Name='DK0301status', RecordTypeId= recordtypeidorgaccount, Region__c='Europe', Sector__c='Technology');
        insert acc;
        Opportunity obj1 =new Opportunity(recordTypeId= recordtypeidorg1, Name = 'test2status', AccountId =acc.id, 
                                          StageName= 'Align', CloseDate = system.today(),Opportunity_Country__c='Afghanistan', 
                                          Opportunity_Region__c='Europe',Value_Amount__c = 10);
        
        insert obj1;
        Opportunity obj2 =new Opportunity(recordTypeId= recordtypeidorg1, Name = 'test3status', AccountId =acc.id, 
                                          StageName= 'Align', CloseDate = system.today(),Opportunity_Country__c='Afghanistan', 
                                          Opportunity_Region__c='Europe',Value_Amount__c = 10,Wake_up_date__c='');
        
        insert obj2;
        //getting the status reason values
        Schema.DescribeFieldResult depend = Opportunity.Status_Reason__c.getDescribe();
        Schema.sObjectField controlToken = depend.getController();
        
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
        
        
        //for testing status reason
        Map<String,List<String>> dependentPicklistValuesTest = new Map<String,List<String>>();        
        dependentPicklistValuesTest=MakeSaled_Opportunity_stagePopUp.getPicklistValues(obj1.id);
        for(String s : dependentPicklistValuesTest.keySet()){
            List<String> test = dependentPicklistValuesTest.get(s);
            List<String> test1 = dependentPicklistValues.get(s);
            System.assertEquals(test, test1);
        }
        
    }
    
    
    
    @isTest
    public static void WakeUpDatetest(){
        Id recordtypeidorg1= Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId();
        Id recordtypeidorg2= Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Hydrogen').getRecordTypeId();
        Id recordtypeidorgaccount= Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId();
        Account acc =new Account(Name='DK0301status', RecordTypeId= recordtypeidorgaccount, Region__c='Europe', Sector__c='Technology');
        insert acc;
        Opportunity obj1 =new Opportunity(recordTypeId= recordtypeidorg1, Name = 'test2status', AccountId =acc.id, 
                                          StageName= 'Align', CloseDate = system.today(),Opportunity_Country__c='Afghanistan', 
                                          Opportunity_Region__c='Europe',Value_Amount__c = 10,Wake_up_date__c='');
        
        insert obj1;
        //getting the status reason values
        Schema.DescribeFieldResult depend = Opportunity.Wake_up_date__c.getDescribe();
        Schema.sObjectField controlToken = depend.getController();
        
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
        
        
        //for testing status reason
        Map<String,List<String>> dependentPicklistValuesTest = new Map<String,List<String>>();        
        dependentPicklistValuesTest=MakeSaled_Opportunity_stagePopUp.getPicklistValuesWakeUp(obj1.id);
        for(String s : dependentPicklistValuesTest.keySet()){
            List<String> test = dependentPicklistValuesTest.get(s);
            List<String> test1 = dependentPicklistValues.get(s);
            System.assertEquals(test, test1);
        }
        
        
    }
}