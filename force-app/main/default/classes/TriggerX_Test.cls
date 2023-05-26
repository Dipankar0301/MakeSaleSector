@isTest
public class TriggerX_Test {
    public static testMethod void input(){
        Id reactive = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Reactive_Work_Order').getRecordTypeId();
        Id planned = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('Planned_Work_Order').getRecordTypeId();
        Id ccnareactive = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('CCNA_Reactive_Work_Order').getRecordTypeId();
        Id ccnaplanned = Schema.SObjectType.WorkOrder.getRecordTypeInfosByDeveloperName().get('CCNA_Planned_Work_Order').getRecordTypeId();
        List<Profile> Prof_li=[select id from profile where name!='System Administrator' order by id limit 1];
        User u=new User(Alias='DKarm', CommunityNickname='User160283932639387916799', Email='dipankar.karmakar.sfdc1@gmail.com', EmailEncodingKey='ISO-8859-1',
                        EmailPreferencesAutoBcc=true, EmailPreferencesAutoBccStayInTouch=false,EmailPreferencesStayInTouchReminder=true, 
                        LanguageLocaleKey='en_US', LastName='Karmakar', LocaleSidKey='en_US',ProfileId=Prof_li[0].id,TimeZoneSidKey='America/Los_Angeles', 
                        Username='dipankar.karmakar.sfdc1-a9@gmail.com');
        System.runAs(u){
            Case ca=new Case(Origin='Web', Status='New',Notification_Type__c='Z2');
            insert ca;
            
            WorkOrder wo1=new WorkOrder(CaseId=ca.id,Code__c='A',CodeDescription__c='B');
            insert wo1;
            
            WorkType wt=new WorkType(Name='AB',EstimatedDuration=3);
            insert wt;
            
            List<WorkOrder> li=[select id,RecordTypeId from WorkOrder where CaseId =: ca.id];
            
            System.assertEquals(li[0].RecordTypeId, reactive);
            Ca.Status='Working';
            update ca;
            Ca.Notification_Type__c = 'X2';
            update ca;
            Ca.Origin='CCNA';
            update ca;
            Ca.Notification_Type__c = 'Z2';
            update ca;
        }
    }
}