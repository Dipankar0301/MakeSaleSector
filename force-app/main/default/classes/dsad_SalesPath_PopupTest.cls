@IsTest
public class dsad_SalesPath_PopupTest {
     static testMethod void dsad_SalesPath_PopupTest() {
             
        String recTypeId = Schema.SObjectType.NEPM_Project__c.getRecordTypeInfosByName().get('DSAD').getRecordTypeId();
        
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'BOM Shell DSAD' LIMIT 1];
        
        User usr = new User(LastName = 'shelldDSAD',
                           FirstName='bom',
                           Alias = 'jliv',
                           Email = 'Test@gmail.com',
                           Username = 'bom.shellDSAD@shell.com',
                           ProfileId = profileId.id,
                           TimeZoneSidKey = 'GMT',
                           LanguageLocaleKey = 'en_US',
                           EmailEncodingKey = 'UTF-8',
                           LocaleSidKey = 'en_US'
                           );
        insert usr;
        
        GAL__c ga = New GAL__c();
        ga.name = 'SuhasTest';
        ga.email__c = 'test@gmail.com';
        insert ga;
        
        NEPM_Project__c p = new NEPM_Project__c();
        p.Name = 'DSADTest';
        p.RecordTypeId = recTypeId;
        p.NEPM_Stage__c ='Assess (post PCI)';
        p.NEPM_Status__c ='Ongoing';
        p.NEPM_BOM_GAL__c = ga.id;
        p.NEPM_BOM__c = usr.id;
        insert p;
        
        NEPM_Project__c p1 = new NEPM_Project__c();
        p1.Name = 'DSADTest1';
        p1.RecordTypeId = recTypeId;
        p1.NEPM_Stage__c ='Operate';
        p1.NEPM_Status__c ='Complete';
        p1.NEPM_BOM_GAL__c = ga.id;
        p1.NEPM_BOM__c = usr.id;
        insert p1;
        
        dsad_SalesPath_Popup.validateApporvals(p.Id,p.NEPM_Stage__c);
        dsad_SalesPath_Popup.validateApporvals(p1.Id,p1.NEPM_Stage__c);
        dsad_SalesPath_Popup.updateDeliverable(p.Id,p.NEPM_Stage__c,true,true);
        dsad_SalesPath_Popup.updateDeliverable(p.Id,p.NEPM_Stage__c,false,false);
        dsad_SalesPath_Popup.updateDeliverable(p1.Id,p1.NEPM_Stage__c,true,true);
        dsad_SalesPath_Popup.updateDeliverable(p1.Id,p1.NEPM_Stage__c,false,false);
     }
     static testMethod void dsad_SalesPath_PopupTest1() {
             
        String recTypeId = Schema.SObjectType.NEPM_Project__c.getRecordTypeInfosByName().get('DSAD').getRecordTypeId();
        
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'BOM Shell DSAD' LIMIT 1];
        
        User usr = new User(LastName = 'shelldDSAD',
                           FirstName='bom',
                           Alias = 'jliv',
                           Email = 'Test@gmail.com',
                           Username = 'bom.shellDSAD@shell.com',
                           ProfileId = profileId.id,
                           TimeZoneSidKey = 'GMT',
                           LanguageLocaleKey = 'en_US',
                           EmailEncodingKey = 'UTF-8',
                           LocaleSidKey = 'en_US'
                           );
        insert usr;
        
        GAL__c ga = New GAL__c();
        ga.name = 'SuhasTest';
        ga.email__c = 'test@gmail.com';
        insert ga;
        
        NEPM_Project__c p = new NEPM_Project__c();
        p.Name = 'DSADTest2';
        p.RecordTypeId = recTypeId;
        p.NEPM_Stage__c ='Select';
        p.NEPM_Status__c ='Ongoing';
        p.NEPM_BOM_GAL__c = ga.id;
        p.NEPM_BOM__c = usr.id;
        insert p;
        
        dsad_SalesPath_Popup.checkMandatoryFieldsFromASSESS(p.id);
        
     }
     static testMethod void dsad_SalesPath_PopupTest2() {
             
        String recTypeId = Schema.SObjectType.NEPM_Project__c.getRecordTypeInfosByName().get('DSAD').getRecordTypeId();
        
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'BOM Shell DSAD' LIMIT 1];
        
        User usr = new User(LastName = 'shelldDSAD',
                           FirstName='bom',
                           Alias = 'jliv',
                           Email = 'Test@gmail.com',
                           Username = 'bom.shellDSAD@shell.com',
                           ProfileId = profileId.id,
                           TimeZoneSidKey = 'GMT',
                           LanguageLocaleKey = 'en_US',
                           EmailEncodingKey = 'UTF-8',
                           LocaleSidKey = 'en_US'
                           );
        insert usr;
        
        GAL__c ga = New GAL__c();
        ga.name = 'SuhasTest';
        ga.email__c = 'test@gmail.com';
        insert ga;
        
        NEPM_Project__c p = new NEPM_Project__c();
        p.Name = 'DSADTest3';
        p.RecordTypeId = recTypeId;
        p.NEPM_Stage__c ='Select';
        p.NEPM_Status__c ='Ongoing';
        p.NEPM_BOM_GAL__c = ga.id;
        p.NEPM_BOM__c = usr.id;
        p.DS_Contact_for_Reporting__c = usr.id;
        p.DS_Decision_Executive__c = ga.id;
        p.DS_Expected_Date_into_SELECT__c = Date.Today()+2;
        p.DS_Expected_Date_into_EXECUTE__c = Date.Today()+3;
        p.DS_Expected_Date_into_OPERATE__c = Date.Today()+4;
        p.DS_Expected_SPA_JVA_APA_signed__c = Date.Today()+5;
        insert p;
        
        dsad_SalesPath_Popup.checkMandatoryFieldsFromASSESS(p.id);
        
     }
     static testMethod void dsad_SalesPath_PopupTest3() {
             
        String recTypeId = Schema.SObjectType.NEPM_Project__c.getRecordTypeInfosByName().get('DSAD MC').getRecordTypeId();
        
        Profile profileId = [SELECT Id FROM Profile WHERE Name = 'BOM Shell DSAD' LIMIT 1];
        
        User usr = new User(LastName = 'shelldDSAD',
                           FirstName='bom',
                           Alias = 'jliv',
                           Email = 'Test@gmail.com',
                           Username = 'bom.shellDSAD@shell.com',
                           ProfileId = profileId.id,
                           TimeZoneSidKey = 'GMT',
                           LanguageLocaleKey = 'en_US',
                           EmailEncodingKey = 'UTF-8',
                           LocaleSidKey = 'en_US'
                           );
        insert usr;
        
        GAL__c ga = New GAL__c();
        ga.name = 'SuhasTest';
        ga.email__c = 'test@gmail.com';
        insert ga;
        
        NEPM_Project__c p = new NEPM_Project__c();
        p.Name = 'DSADTest3';
        p.RecordTypeId = recTypeId;
        p.NEPM_Stage__c ='Select';
        p.NEPM_Status__c ='Ongoing';
        p.NEPM_BOM_GAL__c = ga.id;
        p.NEPM_BOM__c = usr.id;
        p.DS_Contact_for_Reporting__c = usr.id;
        p.DS_Decision_Executive__c = ga.id;
        p.DS_Expected_Date_into_SELECT__c = Date.Today()+2;
        p.DS_Expected_Date_into_EXECUTE__c = Date.Today()+3;
        p.DS_Expected_Date_into_OPERATE__c = Date.Today()+4;
        p.DS_Expected_SPA_JVA_APA_signed__c = Date.Today()+5;
        insert p;
        
        dsad_SalesPath_Popup.checkMandatoryFieldsFromASSESS(p.id);
        
     }
        
}