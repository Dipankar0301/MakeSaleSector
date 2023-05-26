@isTest
public class Sector_marketingCloud_lead_assignTest {
   
    @testSetup static void IntialSetup() 
    {
        String orgId = UserInfo.getOrganizationId();  
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');  
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));  
        String uniqueName = orgId + dateString + randomInt; 
        Profile p = [SELECT Id FROM Profile WHERE Name='MakeSaledSector']; 
        User u = new User(Alias = 'standt', Email = 'sectortestclassuser@sector.shell.com', LastName = 'Testing', 
                          EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', 
                          LocaleSidKey = 'en_US', ProfileId = p.Id, 
                          TimeZoneSidKey = 'Europe/Amsterdam', UserName = uniqueName + '@test' + orgId + '.org');
        insert u;
        
    }
    static testmethod void ConsentLeadTest()
    {
        User us = [Select Id from User where email = 'sectortestclassuser@sector.shell.com'];
        System.runAs(us)
        {
            String recordtypeid1 = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get('Standard_Lead').getRecordTypeId();
            List<Lead> Leadlist = new List<Lead>();
            
            Lead lead1 = new Lead(firstname ='X1',lastname= 'Duplicate',Company= 'NA',recordtypeid= recordtypeid1,Engagement_Source__c ='RAQ',Sync_with_MC__c = True);
            Lead lead2 = new Lead(firstname ='X2',lastname= 'Duplicate1',Company= 'NA1',recordtypeid= recordtypeid1,LeadSource = 'Website',Sync_with_MC__c = True);
            Lead lead3 = new Lead(firstname ='X3',lastname= 'Duplicate2',Company= 'NA1',recordtypeid= recordtypeid1,Department__c= 'Sustainability',Job_Role__c='Specialist',LeadSource = 'Website',Sync_with_MC__c = True);
            Lead lead4 = new Lead(firstname ='X4',lastname= 'Duplicate3',Company= 'NA1',recordtypeid= recordtypeid1,Department__c= 'Sustainability',Job_Role__c='Manager',LeadSource = 'Website',Sync_with_MC__c = True);
            Lead lead5 = new Lead(firstname ='X5',lastname= 'Duplicate4',Company= 'NA1',recordtypeid= recordtypeid1,Department__c= 'Contracting/Procurement',Job_Role__c='Manager',LeadSource = 'Website',Sync_with_MC__c = True);
            Lead lead6 = new Lead(firstname ='X6',lastname= 'Duplicate5',Company= 'NA',recordtypeid= recordtypeid1,Department__c= 'Sustainability',Job_Role__c='Specialist',LeadSource = 'Website',Sync_with_MC__c = True);
            Lead lead7 = new Lead(firstname ='X7',lastname= 'Duplicate6',Company= 'NA',recordtypeid= recordtypeid1,Department__c= 'Sustainability',Job_Role__c='Manager',LeadSource = 'Website',Sync_with_MC__c = True);
            Lead lead8 = new Lead(firstname ='X8',lastname= 'Duplicate7',Company= 'NA',recordtypeid= recordtypeid1,Department__c= 'Contracting/Procurement',Job_Role__c='Manager',LeadSource = 'Website',Sync_with_MC__c = True);
            Lead lead9 = new Lead(firstname ='X9',lastname= 'Duplicate',Company= '3M',recordtypeid= recordtypeid1,Department__c= 'Sustainability',Job_Role__c='Specialist',Engagement_Source__c ='RAQ',Sync_with_MC__c = True);
            Lead lead10 = new Lead(firstname ='X10',lastname= 'Duplicate',Company= '3M',recordtypeid= recordtypeid1,Department__c= 'Sustainability',Job_Role__c='Specialist',Engagement_Source__c ='RAQ1',Sync_with_MC__c = True);
            Lead lead11 = new Lead(firstname ='X11',lastname= 'Duplicate',Company= '3M1',recordtypeid= recordtypeid1,Department__c= 'Sustainability',Job_Role__c='Specialist',Engagement_Source__c ='RAQ',Sync_with_MC__c = True);
            Lead lead12 = new Lead(firstname ='X12',lastname= 'Duplicate',Company= '3M1',recordtypeid= recordtypeid1,Department__c= 'Sustainability',Job_Role__c='Specialist',Engagement_Source__c ='RAQ1',Sync_with_MC__c = True);
            Lead lead13 = new Lead(firstname ='X13',lastname= 'Duplicate',Company= '3M1',recordtypeid= recordtypeid1,Department__c= 'Finance',Job_Role__c='Specialist',Engagement_Source__c ='RAQ1',Sync_with_MC__c = True);
            //Lead lead14 = new Lead(firstname ='X14',lastname= 'Duplicate',Company= '3M1',recordtypeid= recordtypeid1,Department__c= 'Finance',Job_Role__c='Specialist',Engagement_Source__c ='RAQ');
            
            
            
            
            leadList.add(lead1);
            leadList.add(lead2);
            leadList.add(lead3);
            leadList.add(lead4);
            leadList.add(lead5);
            leadList.add(lead6);
            leadList.add(lead7);
            leadList.add(lead8);
            leadList.add(lead9);
            leadList.add(lead10);
            leadList.add(lead11);
            leadList.add(lead12);
            leadList.add(lead13);
            insert Leadlist;
            
            List<Id> leadids = new List<Id>();
            for(Lead leadrecord1 : Leadlist)
            {
                leadids.add(leadrecord1.Id);                
            }
            
            Sector_marketingCloud_lead_assignment.updateOwnerIdWithQueues(leadids);
            
            for(Lead leadrecord1 : [Select Id,OwnerId from Lead 
                                where Id in :leadids ])
            {
                System.assertEquals(true, leadrecord1.OwnerId != null);
            }
        }
}
}