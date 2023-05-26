@isTest
Public class AssignAccessToUserTest{
    
    
    @testSetup static void setup() {
    
    Profile pf = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
    UserRole ur = new UserRole(Name = 'CEO');
    insert ur;

    String orgId = UserInfo.getOrganizationId();
    String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
   
    Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
    String uniqueName = orgId + dateString + randomInt;
    User tuser = new User(  firstname = 'Test',
                            lastName = 'user',
                            email = uniqueName + '@test' + orgId + '.org',
                            Username = uniqueName + '@test' + orgId + '.org',
                            EmailEncodingKey = 'ISO-8859-1',
                            Alias = uniqueName.substring(18, 23),
                            TimeZoneSidKey = 'America/Los_Angeles',
                            LocaleSidKey = 'en_US',
                            LanguageLocaleKey = 'en_US',
                            isActive = True,
                            ProfileId = pf.id,
                            UserRoleId = ur.id);
                           
        insert tuser;
        System.runAS(tuser){
            Test.startTest();
                String recTypeId = Schema.SObjectType.NEPM_Project__c.getRecordTypeInfosByDeveloperName().get('Nature_Based_Solutions').getRecordTypeId();
                
                GAL__c g = new GAL__c();
                g.Name = 'testuser';
                g.Email__c = uniqueName + '@test' + orgId + '.org';
                insert g;
                
                NEPM_Project__c p = new NEPM_Project__c();
                p.Name = 'Nature Based Solutions';
                p.RecordTypeId = recTypeId;
                p.NEPM_Stage__c ='Assess (post PCI)';
                p.NEPM_Technology_Lead_GAL__c = g.id;
                p.NEPM_BOM_GAL__c = g.id;
                p.NEPM_Status__c ='Active';
                p.Mandate_Strategy__c='M&A';
                insert p;
                
                String recTypeId1 = Schema.SObjectType.NEPM_Project__c.getRecordTypeInfosByDeveloperName().get('Onshore_Power').getRecordTypeId();
                
                NEPM_Project__c p1 = new NEPM_Project__c();
                p1.Name = 'Onshore renewable power';
                p1.RecordTypeId = recTypeId1;
                p1.NEPM_Stage__c ='Assess (post PCI)';
                p1.NEPM_Technology_Lead_GAL__c = g.id;
                p1.NEPM_BOM_GAL__c = g.id;
                p1.NEPM_Status__c ='Active';
                p1.Mandate_Strategy__c ='Greenfield development';
                insert p1;
           Test.stopTest();
       }
     }
     @isTest static void testMethod1() {
         
         user u = [select id,name,IsActive from user where lastName = 'user' limit 1];
         
                 user us= new user();
                 us.id = u.id;
                 us.IsActive = false;
                 update us;  
           
       }

}