@isTest
public class LeadTriggerTest 
{
    
    @testSetup static void IntialSetup() 
    {
        String orgId = UserInfo.getOrganizationId();  
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');  
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));  
        String uniqueName = orgId + dateString + randomInt; 
        Profile p = [SELECT Id FROM Profile WHERE Name='SEUK']; 
        User u = new User(Alias = 'standt', Email = 'seuktestclassuser@seuk.shell.com', LastName = 'Testing', 
                          EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', 
                          LocaleSidKey = 'en_US', ProfileId = p.Id, 
                          TimeZoneSidKey = 'Europe/Amsterdam', UserName = uniqueName + '@test' + orgId + '.org');
        insert u;
        PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = 'SEUK_Super_User'];
        insert new PermissionSetAssignment(AssigneeId = u.id, PermissionSetId = ps.Id);
        
        //To test sector Leads
        Profile p1 = [SELECT Id FROM Profile WHERE Name='MakeSaledSector']; 
        User u1 = new User(Alias = 'standt', Email = 'sectortestclassuser121@sector.shell.com', LastName = 'Testing', 
                          EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', 
                          LocaleSidKey = 'en_US', ProfileId = p1.Id, 
                          TimeZoneSidKey = 'Europe/Amsterdam', UserName = uniqueName + '@testing' + orgId + '.org');
        insert u1;
    }
    static testmethod void SingleBackStopDateTest_GasMeter_Zero()
    {
		User us = [Select Id from User where email = 'seuktestclassuser@seuk.shell.com'];
        System.runAs(us)
        {
            Test.StartTest();
            List<Lead> leadlist = SEUK_TestDataFactory.createLead(1, Date.today() + 30, 0, 4000, 4000, Label.SEUK_Set_up_Requests);
            insert leadlist;
            leadlist.clear();
            for(Lead ld : [SELECT Id, Setup_backstop_date__c,Due_Date__c FROM Lead 
                           where Id in :leadlist])
            {
                System.assertEquals(BusinessHours.add(Label.SEUK_Business_Hours_ID, ld.Due_Date__c, -3*24*60*60*1000), ld.Setup_backstop_date__c);
                ld.Due_Date__c = null;
                leadlist.add(ld);
            }
            update leadlist;
            for(Lead ld : [SELECT Id, Setup_backstop_date__c FROM Lead 
                           where Id in :leadlist])
            {
                System.assertEquals(null, ld.Setup_backstop_date__c);
            }
            Test.StopTest(); 
        }
    }
    static testmethod void SingleBackStopDateTest_GasMeter_Greaterthan_Zero()
    {
		User us = [Select Id from User where email = 'seuktestclassuser@seuk.shell.com'];
        System.runAs(us)
        {
            Test.StartTest();
            List<Lead> leadlist = SEUK_TestDataFactory.createLead(1, Date.today() + 30, 3, 6000, 6000, Label.SEUK_Set_up_Requests);
            insert leadlist;
            leadlist.clear();
            for(Lead ld : [SELECT Id, Setup_backstop_date__c FROM Lead 
                           where Id in :leadlist])
            {
                System.assertEquals(BusinessHours.add(Label.SEUK_Business_Hours_ID, ld.Due_Date__c, -6*24*60*60*1000), ld.Setup_backstop_date__c);
                ld.Due_Date__c = null;
                leadlist.add(ld);
            }
            update leadlist;
            for(Lead ld : [SELECT Id, Setup_backstop_date__c FROM Lead 
                           where Id in :leadlist])
            {
                System.assertEquals(null, ld.Setup_backstop_date__c);
            }
            Test.StopTest();
        }
    }
    static testmethod void BulkBackStopDateTest_GasMeter_Zero()
    {
        User us = [Select Id from User where email = 'seuktestclassuser@seuk.shell.com'];
        System.runAs(us)
        {
            Test.StartTest();
            List<Lead> leadlist = SEUK_TestDataFactory.createLead(500, Date.today() + 30, 0, 4000, 4000, Label.SEUK_Set_up_Requests);
            insert leadlist;
            leadlist.clear();
            for(Lead ld : [SELECT Id, Setup_backstop_date__c FROM Lead 
                           where Id in :leadlist])
            {
                System.assertEquals(BusinessHours.add(Label.SEUK_Business_Hours_ID, ld.Due_Date__c, -3*24*60*60*1000), ld.Setup_backstop_date__c);
                ld.Due_Date__c = null;
                leadlist.add(ld);
            }
            update leadlist;
            for(Lead ld : [SELECT Id, Setup_backstop_date__c FROM Lead 
                           where Id in :leadlist])
            {
                System.assertEquals(null, ld.Setup_backstop_date__c);
            }
            Test.StopTest();
        }
    }
    static testmethod void BulkBackStopDateTest_GasMeter_Greaterthan_Zero()
    {
        User us = [Select Id from User where email = 'seuktestclassuser@seuk.shell.com'];
        System.runAs(us)
        {
            Test.StartTest();
            List<Lead> leadlist = SEUK_TestDataFactory.createLead(500, Date.today() + 30, 3, 6000, 6000, Label.SEUK_Set_up_Requests);
            insert leadlist;
            leadlist.clear();
            for(Lead ld : [SELECT Id, Setup_backstop_date__c FROM Lead 
                           where Id in :leadlist])
            {
                System.assertEquals(BusinessHours.add(Label.SEUK_Business_Hours_ID, ld.Due_Date__c, -6*24*60*60*1000), ld.Setup_backstop_date__c);
                ld.Due_Date__c = null;
                leadlist.add(ld);
            }
            update leadlist;
            for(Lead ld : [SELECT Id, Setup_backstop_date__c FROM Lead 
                           where Id in :leadlist])
            {
                System.assertEquals(null, ld.Setup_backstop_date__c);
            }
            Test.StopTest();
        }
    }
    
    static testmethod void BulkBackStopDateTest_GasMeter_Greaterthan_Zero_2()
    {
        User us = [Select Id from User where email = 'seuktestclassuser@seuk.shell.com'];
        System.runAs(us)
        {
            Test.StartTest();
            List<Lead> leadlist = SEUK_TestDataFactory.createLead(500, Date.today() + 30, 3, 6000, 6000, Label.SEUK_Set_up_Requests);
            insert leadlist;
            leadlist.clear();
            for(Lead ld : [SELECT Id, Setup_backstop_date__c FROM Lead 
                           where Id in :leadlist])
            {
                System.assertEquals(BusinessHours.add(Label.SEUK_Business_Hours_ID, ld.Due_Date__c, -6*24*60*60*1000), ld.Setup_backstop_date__c);
                ld.Due_Date__c = Date.today() - 30;
                leadlist.add(ld);
            }
            update leadlist;
            for(Lead ld : [SELECT Id, Setup_backstop_date__c FROM Lead 
                           where Id in :leadlist])
            {
                System.assertEquals(Date.today(), ld.Setup_backstop_date__c);
            }
            Test.StopTest();
        }
    }
    
    static testmethod void SingleSEUKB2BLead()
    {
        User us = [Select Id from User where email = 'seuktestclassuser@seuk.shell.com'];
        System.runAs(us)
        {
            Test.StartTest();
            List<Lead> leadlist = SEUK_TestDataFactory.createLead(1, Date.today() + 30, 3, 6000, 6000, SEUKStaticValues.Lead_SEUK_B2B_Leads);
            insert leadlist;
            for(Lead ld : [SELECT Id, Setup_backstop_date__c FROM Lead 
                           where Id in :leadlist])
            {
                System.assertEquals(null, ld.Setup_backstop_date__c);
            }
            Test.StopTest();
        }
    }
    static testmethod void NegativeTest()
    {
        User us = [Select Id from User where email = 'seuktestclassuser@seuk.shell.com'];
        System.runAs(us)
        {
            Test.StartTest();
            List<Lead> leadlist = SEUK_TestDataFactory.createLead(500, Date.today() - 30, null, null, null, Label.SEUK_Set_up_Requests);
            insert leadlist;
            for(Lead ld : [SELECT Id, Setup_backstop_date__c FROM Lead 
                           where Id in :leadlist])
            {
                System.assertEquals(Date.today(), ld.Setup_backstop_date__c);
            }
            Test.StopTest();
        }
    }
    static testmethod void NegativeTest_2()
    {
        User us = [Select Id from User where email = 'seuktestclassuser@seuk.shell.com'];
        System.runAs(us)
        {
            Test.StartTest();
            List<Lead> leadlist = SEUK_TestDataFactory.createLead(500, null, null, null, null, Label.SEUK_Set_up_Requests);
            insert leadlist;
            for(Lead ld : [SELECT Id, Setup_backstop_date__c FROM Lead 
                           where Id in :leadlist])
            {
                System.assertEquals(null, ld.Setup_backstop_date__c);
            }
            Test.StopTest();
        }
    }   
    static testmethod void testUpdateLeadConvert()
    {
        User us = [Select Id from User where email = 'sectortestclassuser121@sector.shell.com'];
        System.runAs(us)
        {
            List<Lead> newLeadList = new List<Lead>();
        	for(Integer i = 0; i < 50; i++)
        	{
            	Lead ld = new Lead();
            	ld.recordtypeid = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Standard_Lead').getRecordTypeId();
            	ld.FirstName = 'test3 '+i+' first name'+i;
            	ld.LastName = 'test3 '+i+' last name'+i;
            	ld.Company = 'test3 '+i+' company name'+i;
            	ld.email = 'abc3'+i+'@example'+i+'.com';
            	ld.Department__c = 'Sales';
            	ld.Region__c = 'Australia';
            	ld.Account_Type__c = 'Enterprise Account';
            	ld.Sector__c = 'Technology';
                ld.Estimated_Close_date__c = Date.today();
            	newLeadList.add(ld);
        	}
            insert newLeadList;
            //list leadsToConvert = new list();
        	LeadStatus convertStatus = [SELECT Id, MasterLabel FROM LeadStatus WHERE IsConverted=true LIMIT 1];
            //for(Lead leadlist: newLeadList){
                //System.debug(leadlist.id);
                Database.LeadConvert lc = new Database.LeadConvert();
                lc.setLeadId(newLeadList[0].id);
                lc.setConvertedStatus(convertStatus.MasterLabel);
                Database.LeadConvertResult lcr = Database.convertLead(lc);

        		try{
          			//convert the lead. Try Catch is used to display the error message
          			Database.LeadConvertResult lcResults = Database.convertLead(lc);
        		}Catch(Exception exp){
          			System.debug(exp.getMessage());
        		}

            //}
        }
    }
    
    
}