@isTest
Public class NEMOCAndNEMOCActionTriggerClassTest{
    public  final static String SSK_RestrictedE2CDomainsValue = 'Review Action Items';
    @testVisible public static String supportSetting {
        get{
            if(supportSetting == null){
                NE_MOC_Action_ItemTasks__mdt supportSettingData = [SELECT Action_Type__c FROM NE_MOC_Action_ItemTasks__mdt WHERE Action_Type__c = :SSK_RestrictedE2CDomainsValue][0];
                supportSetting = supportSettingData.Action_Type__c;
            }
            return supportSetting;
        }
        public set;
    }
    
    @testVisible public static List<String> getSupportSetting{
        get{
            if(getSupportSetting == null){
                getSupportSetting = new List<String>();
                getSupportSetting.add(supportSetting);
            }
            return getSupportSetting;
        }
        public set;
    }   
    
    static testMethod void insertNEMOCActionTest() {
    
     //String recTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('NE_HSSE_Task').getRecordTypeId();
        ID ProfileID = [ Select id from Profile where name = 'H2_Ops_Site_Operators_External'].id;

        Account acc = new Account(Name = 'Test Account');

        insert acc ;

        List<Contact> ContactList = new List<Contact>();

        Contact Con = new Contact( AccountID = acc .id, FirstName = 'User', LastName = 'test',

        email = 'testuser@xyz.com' );

        insert Con;

        User u = new User( email='testuser@xyz.com', contactid = Con.id, profileid = profileid, UserName='testuser@xyz.com', alias='tuser', CommunityNickName='tuser',

        TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',

        LanguageLocaleKey='en_US', FirstName = 'User', LastName = 'Test' );

        insert u;
        
        /////Call Custom Metadata in test class



        NE_Site__c site = new NE_Site__c();
        site.Name = 'Test Site Shell Ventures 1';        
        site.NE_Line_Of_Business__c ='Shell Ventures';
        site.NE_MOC_Process_Owner__c = u.id;
        insert site;

        
        NE_MOC__c mOC = new NE_MOC__c();
        mOC.NE_MoC_Title__c = 'Test NE MOC';        
        mOC.NE_Line_Of_Business__c ='Shell Ventures';
        mOC.Site_Location__c =site.id;
        mOC.NE_Type_of_Change__c = 'Process';
        mOC.NE_Duration_of_Change__c = 'Permanent';
        mOC.NE_Description_of_Change__c = 'Test MOC';
        mOC.NE_Reason_for_Change__c = 'Test MOC';
        mOC.NE_Needed_Start_up_Date__c = System.today();
        mOC.NE_End_Date__c = System.today()+7;
        mOC.NE_MOC_Project_Manager__c = u.id;

        
        insert mOC;
        
        list<NE_MOC_Action__c> neMocActionList =  new list<NE_MOC_Action__c>();
        
        NE_MOC_Action__c neMocAction1 = new NE_MOC_Action__c();
        neMocAction1.Name = 'Review Action Items';
        neMocAction1.NE_MOC__c = mOC.id;
        neMocActionList.add(neMocAction1);
        
        NE_MOC_Action__c neMocAction2 = new NE_MOC_Action__c();
        neMocAction2.Name = 'Pre-Implementation Action Items';
        neMocAction2.NE_MOC__c = mOC.id;
        neMocActionList.add(neMocAction2);
        
        NE_MOC_Action__c neMocAction3 = new NE_MOC_Action__c();
        neMocAction3.Name = 'Post-Implementation Action Items';
        neMocAction3.NE_MOC__c = mOC.id;
        neMocActionList.add(neMocAction3);
        
        insert neMocActionList;
        

        
        
        mOC.NE_Screener1__c = u.id;
        mOC.NE_Screener2__c = u.id;
        mOC.NE_Screener3__c = u.id;
        mOC.NE_Screener4__c = u.id;
        mOC.NE_Reviewer1__c = u.id;
        mOC.NE_Reviewer2__c = u.id;
        mOC.NE_Reviewer3__c = u.id;
        mOC.NE_Reviewer4__c = u.id;
        mOc.NE_Stage__c = 'Under Screening';
        
        Update mOC;
        
        list<task> MocTask = new list<task>();
        
        mOc.NE_Stage__c = 'Implementation';
        
        Update mOC;
        list<NE_MOC_Action__c> nemocList = new list<NE_MOC_Action__c>();
        
        for(NE_MOC_Action__c neMocActionObj:[SELECT id,NE_Completed__c from NE_MOC_Action__c WHERE NE_MOC__c =: mOC.id ]){
            neMocActionObj.NE_Completed__c= TRUE;
            nemocList.add(neMocActionObj);
        }
        
        update nemocList;
        
        for(Task tsk:[SELECT id,status from Task WHERE WhatId =: mOC.id and status !='Completed' ]){
            tsk.status= 'Completed';
            MocTask.add(tsk);
        }
        update MocTask;
        list<NE_MOC_Action__c> nemocList2 = new list<NE_MOC_Action__c>();
        for(NE_MOC_Action__c neMocActionObj:[SELECT id,NE_Completed__c from NE_MOC_Action__c WHERE NE_MOC__c =: mOC.id ]){
            neMocActionObj.NE_Completed__c= TRUE;
            nemocList2.add(neMocActionObj);
        }
        
        update nemocList2;
        
        mOc.NE_Stage__c = 'Post implementation approval';

        Update mOC;
        for(Task tsk:[SELECT id,status from Task WHERE WhatId =: mOC.id and status !='Completed' ]){
            tsk.status= 'Completed';
            MocTask.add(tsk);
        }

        update MocTask;
        mOc.NE_Stage__c = 'Rejected';

        Update mOC;
        
        for(Task tsk:[SELECT id,status from Task WHERE WhatId =: mOC.id and status !='Completed' ]){
            tsk.status= 'Completed';
            MocTask.add(tsk);
        }

        update MocTask;

    }
    
    static testMethod void updateNEMOCActionTest() {
    
 //String recTypeId = Schema.SObjectType.task.getRecordTypeInfosByName().get('NE_HSSE_Task').getRecordTypeId();
        ID ProfileID = [ Select id from Profile where name = 'H2_Ops_Site_Operators_External'].id;

        Account acc = new Account(Name = 'Test Account');

        insert acc ;

        List<Contact> ContactList = new List<Contact>();

        Contact Con = new Contact( AccountID = acc .id, FirstName = 'User', LastName = 'test',

        email = 'testuser@xyz.com' );

        insert Con;

        User u = new User( email='testuser@xyz.com', contactid = Con.id, profileid = profileid, UserName='testuser@xyz.com', alias='tuser', CommunityNickName='tuser',

        TimeZoneSidKey='America/New_York', LocaleSidKey='en_US', EmailEncodingKey='ISO-8859-1',

        LanguageLocaleKey='en_US', FirstName = 'User', LastName = 'Test' );

        insert u;
        
        NE_Site__c site = new NE_Site__c();
        site.Name = 'Test Site Shell Ventures 1';        
        site.NE_Line_Of_Business__c ='Shell Ventures';
        site.NE_MOC_Process_Owner__c = u.id;
        insert site;
        
        NE_Site__c site2 = new NE_Site__c();
        site2.Name = 'Test Site Shell Ventures 2';        
        site2.NE_Line_Of_Business__c ='Shell Ventures';
        site2.NE_MOC_Process_Owner__c = u.id;
        insert site2;

        
        NE_MOC__c mOC = new NE_MOC__c();
        mOC.NE_MoC_Title__c = 'Test NE MOC';        
        mOC.NE_Line_Of_Business__c ='Shell Ventures';
        mOC.Site_Location__c =site.id;
        mOC.NE_Type_of_Change__c = 'Process';
        mOC.NE_Duration_of_Change__c = 'Permanent';
        mOC.NE_Description_of_Change__c = 'Test MOC';
        mOC.NE_Reason_for_Change__c = 'Test MOC';
        mOC.NE_Needed_Start_up_Date__c = System.today();
        mOC.NE_End_Date__c = System.today()+14;
        mOC.NE_MOC_Project_Manager__c = u.id;
        mOC.NE_Screener1__c = u.id;
        mOC.NE_Screener2__c = u.id;
        mOC.NE_Screener3__c = u.id;
        mOC.NE_Reviewer1__c = u.id;
        mOC.NE_Reviewer2__c = u.id;
        
        insert mOC;
        
        list<NE_MOC_Action__c> neMocActionList =  new list<NE_MOC_Action__c>();
        
        NE_MOC_Action__c neMocAction1 = new NE_MOC_Action__c();
        neMocAction1.Name = 'Review Action Items';
        neMocAction1.NE_MOC__c = mOC.id;
        neMocActionList.add(neMocAction1);
        
        NE_MOC_Action__c neMocAction2 = new NE_MOC_Action__c();
        neMocAction2.Name = 'Pre-Implementation Action Items';
        neMocAction2.NE_MOC__c = mOC.id;
        neMocActionList.add(neMocAction2);
        
        NE_MOC_Action__c neMocAction3 = new NE_MOC_Action__c();
        neMocAction3.Name = 'Post-Implementation Action Items';
        neMocAction3.NE_MOC__c = mOC.id;
        neMocActionList.add(neMocAction3);
        
        insert neMocActionList;
        

        list<task> MocTask2 = new list<task>();
        
        for(Task tsk:[SELECT id,status from Task WHERE WhatId =: mOC.id ]){
            tsk.status= 'Completed';
            MocTask2.add(tsk);
        }
        
        update MocTask2;
        
                
        mOC.NE_Screener4__c = u.id;
        mOC.NE_Screener2__c = u.id;
        mOC.NE_Screener3__c = u.id;
        mOC.NE_Reviewer3__c = u.id;
        mOC.NE_Reviewer4__c = u.id;
        mOC.Site_Location__c =site2.id;
        update moc;
        
        for(Task tsk:[SELECT id,status from Task WHERE WhatId =: mOC.id and status !='Completed' ]){
            tsk.status= 'Completed';
            MocTask2.add(tsk);
        }
        
        update MocTask2;
        
        for(Task tsk:[SELECT id,status from Task WHERE WhatId =: mOC.id and status !='Completed' ]){
        tsk.status= 'Completed';
        MocTask2.add(tsk);
        }

        update MocTask2;
    }
}