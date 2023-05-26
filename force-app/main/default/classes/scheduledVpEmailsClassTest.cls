@isTest
public class scheduledVpEmailsClassTest {
    
    @isTest static void executeTest(){
    
       Test.StartTest();
        VPEmails_Schedule_Date__c  customsettingpro =  new VPEmails_Schedule_Date__c();
        customsettingpro.name                       = 'Next Batch Schedule Date';
        customsettingpro.Number_of_Days_to_Add__c   = 7;
        insert customsettingpro;
        scheduledVpEmailsClass sh1 = new scheduledVpEmailsClass();
            String sch = '0 0 23 * * ?';
            system.schedule('Test schexample', sch, sh1);
        Test.stopTest();
 
         
    }
}