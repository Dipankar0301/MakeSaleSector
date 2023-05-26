@isTest
Private class ScheduleEmailsToVPsTest{
    
   @isTest static void ScheduleEmailsToVPsmethod1() {
        List<string> recrodtypeName = new List<string>(); 
        List<NEPM_Project__c> prolist = new List<NEPM_Project__c>();
        VPEmails_Schedule_Date__c  customsettingpro =  new VPEmails_Schedule_Date__c();
        customsettingpro.name                       = 'Next Batch Schedule Date';
        customsettingpro.Number_of_Days_to_Add__c   = 7;
        insert customsettingpro;
        //Datetime DaysAgo = System.today().addDays(-7);
        for(NewEngergiesRecrodTypeNames__mdt recodtypenames : [SELECT id,RecordTypeName__c FROM NewEngergiesRecrodTypeNames__mdt]){
            string st = recodtypenames.RecordTypeName__c;
            Id devRecordTypeId = Schema.SObjectType.NEPM_Project__c.getRecordTypeInfosByName().get(st).getRecordTypeId();
            NEPM_Project__c proj = new NEPM_Project__c();
            proj.Name                = 'TestProject'+st;
            proj.NEPM_Stage__c       = 'Screening';
            //proj.Mandate_Strategy__c = 'M&A';
            proj.RecordTypeId        =  devRecordTypeId;     
            proj.NEPM_BOM__c         = userinfo.getuserId();
            proj.Last_Updated_Child_Records_Date__c = system.today();
            prolist.add(proj);
            recrodtypeName.add('TestProject'+recodtypenames.RecordTypeName__c);
        }
        insert prolist;
         Test.startTest();
            ScheduleEmailsToVPs tb = new ScheduleEmailsToVPs();
            Id batchId = Database.executeBatch(tb);
         Test.stopTest();
    }
    @isTest static void ScheduleEmailsToVPsmethod2() {
         
        List<string> recrodtypeName = new List<string>();
        List<NEPM_Project__c> prolist = new List<NEPM_Project__c>();
        VPEmails_Schedule_Date__c  customsettingpro =  new VPEmails_Schedule_Date__c();
        customsettingpro.name                       = 'Next Batch Schedule Date';
        customsettingpro.Number_of_Days_to_Add__c   = 7;
        insert customsettingpro;
        //Datetime DaysAgo = System.today().addDays(-7);
        for(NewEngergiesRecrodTypeNames__mdt recodtypenames : [SELECT id,RecordTypeName__c FROM NewEngergiesRecrodTypeNames__mdt]){
          
          if(recodtypenames.RecordTypeName__c != 'Nature Based Solutions'){
                string st = recodtypenames.RecordTypeName__c;
                Id devRecordTypeId = Schema.SObjectType.NEPM_Project__c.getRecordTypeInfosByName().get(st).getRecordTypeId();
                NEPM_Project__c proj = new NEPM_Project__c();
                proj.Name                = 'TestProject'+st;
                proj.NEPM_Stage__c       = 'Screening';
                //proj.Mandate_Strategy__c = 'M&A';
                proj.RecordTypeId        =  devRecordTypeId;     
                proj.NEPM_BOM__c         = userinfo.getuserId();
                proj.Last_Updated_Child_Records_Date__c = system.today();
                prolist.add(proj);
                recrodtypeName.add('TestProject'+recodtypenames.RecordTypeName__c);
           }
        }
        insert prolist;
         Test.startTest();
            ScheduleEmailsToVPs tb = new ScheduleEmailsToVPs();
            Id batchId = Database.executeBatch(tb);
         Test.stopTest();
    }
}