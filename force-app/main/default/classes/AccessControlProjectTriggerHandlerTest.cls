@isTest
Public class AccessControlProjectTriggerHandlerTest{
    
    public static String orgId = UserInfo.getOrganizationId();
    public static String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');
    public static Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
    public static String uniqueName = orgId + dateString + randomInt;
    @testSetup static void setup() {
        
        Profile pf = [SELECT Id FROM Profile WHERE Name = 'System Administrator' LIMIT 1];
        UserRole ur = new UserRole(Name = 'CEO');
        insert ur;
        User tuser = new User(  firstname = 'Test',
                                lastName = 'user1',
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
        User tuser2 = new User(  firstname = 'Test',
                                lastName = 'user2',
                                email = uniqueName + '@test' + orgId + '.org1',
                                Username = uniqueName + '@test' + orgId + '.org1',
                                EmailEncodingKey = 'ISO-8859-1',
                                Alias = uniqueName.substring(18, 23),
                                TimeZoneSidKey = 'America/Los_Angeles',
                                LocaleSidKey = 'en_US',
                                LanguageLocaleKey = 'en_US',
                                isActive = True,
                                ProfileId = pf.id,
                                UserRoleId = ur.id);
                               
     insert tuser2;
     System.runAS(tuser){
     Test.startTest();
         String recTypeId = Schema.SObjectType.NEPM_Project__c.getRecordTypeInfosByName().get('DSAD').getRecordTypeId();
                
            GAL__c g = new GAL__c();
            g.Name = 'testuser';
            g.Email__c = uniqueName + '@test' + orgId + '.org';
            insert g;
            
            NEPM_Project__c p = new NEPM_Project__c();
            p.Name = 'DSADTest';
            p.RecordTypeId = recTypeId;
            p.NEPM_Stage__c ='Assess (post PCI)';
            p.NEPM_Technology_Lead_GAL__c = g.id;
            p.NEPM_BOM_GAL__c = g.id;
            p.NEPM_Status__c ='Ongoing';
            insert p;
            
            DSAD_Access_Control__c ds = new DSAD_Access_Control__c();
            ds.Deal_Team_Member_User__c = tuser.id;
            ds.Project__c               = p.id;
            ds.Roles__c                 = 'IT';
            insert ds;
         Test.stopTest();
       }        
     }
     @isTest static void testMethod1() {
         
         user u = [select id,name,IsActive from user where lastname = 'user1' limit 1];
         NEPM_Project__c pro = [select id,name from NEPM_Project__c WHERE Name = 'DSADTest'];
         try{
              DSAD_Access_Control__c ds = new DSAD_Access_Control__c();
              ds.Deal_Team_Member_User__c = u.id;
              ds.Project__c               = pro.id;
              ds.Roles__c                 = 'IT';
              insert ds; 
          }
          catch(Exception e){
          
             System.debug('***exception***'+e);
          }
     }
      @isTest static void testMethod2() {
         
         user u = [select id,name,IsActive from user where lastname = 'user1' limit 1];
         NEPM_Project__c pro = [select id,name from NEPM_Project__c WHERE Name = 'DSADTest'];
         DSAD_Access_Control__c dsc = [Select id,Deal_Team_Member_User__c,Project__c,Roles__c From DSAD_Access_Control__c WHERE Deal_Team_Member_User__c =:u.id AND Project__c =:pro.id AND Roles__c = 'IT' limit 1];
         delete dsc;
     }
      @isTest static void testMethod3() {
         
         
         user u = [select id,name,IsActive from user where lastname = 'user1' limit 1];
         user u2 = [select id,name,IsActive from user where lastname = 'user2' limit 1];
         NEPM_Project__c pro = [select id,name from NEPM_Project__c WHERE Name = 'DSADTest'];
         DSAD_Access_Control__c dsc = [Select id,Deal_Team_Member_User__c,Project__c,Roles__c From DSAD_Access_Control__c WHERE Deal_Team_Member_User__c =:u.id AND Project__c =:pro.id AND Roles__c = 'IT' limit 1];
         DSAD_Access_Control__c dscontrol = new DSAD_Access_Control__c();
         dscontrol.id = dsc.id;
         dscontrol.Deal_Team_Member_User__c = u2.id;
         update dscontrol;
     }
}