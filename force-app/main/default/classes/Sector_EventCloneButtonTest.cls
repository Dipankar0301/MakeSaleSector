@isTest
public class Sector_EventCloneButtonTest {
    
    @testSetup static void IntialSetup() 
    {
        String orgId = UserInfo.getOrganizationId();  
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');  
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));  
        String uniqueName = orgId + dateString + randomInt; 
        Profile p = [SELECT Id FROM Profile WHERE Name='MakeSaledSector']; 
        User u = new User(Alias = 'standtxz', Email = 'sectortestclassuser@sector.shell.com', LastName = 'Testing', 
                          EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', 
                          LocaleSidKey = 'en_US', ProfileId = p.Id, 
                          TimeZoneSidKey = 'Europe/Amsterdam', UserName = uniqueName + '@test' + orgId + '.org');
        insert u;
        
    }
    
 	static testMethod void GetAddressInsert(){   
    Id recTypeId = Schema.SObjectType.Event.getRecordTypeInfosByName().get('Sector Call Plan').getRecordTypeId();
        List<Account> li =new List<Account>();
        Integer flag=0;
        for(integer i=0;i<1;i++){
            Account acc = new Account(Name='Test NM testing for clone 6' + i );
            li.add(acc);
        }
        insert li;
        List<Event> e =new List<event>();
        integer x=0;
        for(account a:li){
            Event ev= new Event(Subject='Test NM1' + x,StartDateTime= System.now()+1,EndDateTime= System.now()+1,WhatId =a.id,OwnerId=UserInfo.getUserId(),
                                Type='Virtual',recordTypeId=recTypeId);
            e.add(ev);
            x++;
        }
        insert e;
        
        //get the clone record
        Event newEvent = new Event(); 
                    newEvent.Subject = e[0].Subject;
                    system.debug('e.IsAllDayEvent '+ e[0].IsAllDayEvent);
                    newEvent.IsAllDayEvent = e[0].IsAllDayEvent; 
                    newEvent.StartDateTime = System.now()+1;
                    newEvent.ActivityDateTime = System.now()+1;
                    datetime dT=newEvent.StartDateTime;
                    newEvent.ActivityDate = date.newinstance(dT.year(), dT.month(), dT.day());
                    newEvent.EndDateTime = System.now()+1;
                    newEvent.Type = e[0].Type;
                    newEvent.DurationInMinutes = null;
                    newEvent.Location = e[0].Location;
                    newEvent.ShowAs = e[0].ShowAs;
                    newEvent.Reason_for_Call__c= e[0].Reason_for_Call__c;
                    newEvent.Call_Plan_Record_Type__c = e[0].Call_Plan_Record_Type__c;
                    newEvent.Description = '';
                    newEvent.Ownerid=UserInfo.getUserId();
                    newEvent.whoId = e[0].WhoId;
                    newEvent.WhatId = e[0].WhatId;
                    List<Call_Plan__c> cp =[select id from Call_Plan__c where EventId__c =: e[0].id];
                    newEvent.Cloned_Call_Plan_Id__c = cp[0].id;
                    newEvent.recordtypeId = e[0].recordtypeId;
                    system.debug('event status'+e[0].Status_Event__c);
                    newEvent.Status_Event__c = e[0].Status_Event__c;
                    newEvent.ISClonedd__c = true;
        
        Sector_EventCloneButton.responseWrapper result =Sector_EventCloneButton.getEventClone(e[0].id, e[0]); 
        System.assertEquals(result.eventre.Subject, newEvent.Subject);
    
	}
    static testMethod void GetAddressInsertTest(){
        User us = [Select Id from User where email = 'sectortestclassuser@sector.shell.com'];
        System.runAs(us)
        {
            List<Account> lstAccounts =new List<Account>();
            Integer flag=0;
            for(integer i=0;i<10;i++){
                Account acc = new Account(Name='Test NM clone 5' + i );
                lstAccounts.add(acc);
            }
            insert lstAccounts;
            Event evt = new Event();
            evt.WhatId=lstAccounts[0].id;
            evt.Subject='Meeting';
            evt.Type='Face to Face';
            evt.Call_Plan_Record_Type__c='Call Plan POPSA';
            evt.OwnerId=us.id;
            evt.StartDateTime=system.now()+1;
            evt.EndDateTime=system.now()+2;
            evt.IsAllDayEvent=false;
            //evt.Hunting_Farming__c='';
            insert evt;
            test.startTest();
            try{
                Sector_EventCloneButton.getEventClone(evt.id,evt);
            }catch(AuraHandledException ahe){
                System.debug('####### ahe = ' + ahe);
            }
            Sector_EventCloneButton.getselectOptions(evt,'Type');
            test.stopTest();
        }
    }
    
    static testmethod void getEventCloneTest1() {
        User us = [Select Id from User where email = 'sectortestclassuser@sector.shell.com'];
        System.runAs(us)
        {
            
            List<Account> lstAccounts =new List<Account>();
            Integer flag=0;
            for(integer i=0;i<10;i++){
                Account acc = new Account(Name='Test NM clone 4' + i );
                lstAccounts.add(acc);
            }
            insert lstAccounts;
            Call_Plan__c call_plan = new Call_Plan__c();
            //String s=ev.Subject;
            call_plan.Name= 'Call Plan of Testing for' ;
            insert call_plan;
            Event evt = new Event();
            evt.WhatId=call_plan.id;
            evt.Type='Face to Face';
            evt.Subject='Meeting';
            evt.Call_Plan_Record_Type__c='Call Plan POPSA';
            evt.OwnerId=us.id;
            evt.StartDateTime=system.now();
            evt.EndDateTime=system.now();
            evt.IsAllDayEvent=false;
            insert evt;
            Event evt1 = new Event();
            evt1.WhatId=call_plan.id;
            evt1.Type='Face to Face';
            evt1.Subject='Meeting';
            evt1.Call_Plan_Record_Type__c='Call Plan POPSA';
            evt1.OwnerId=us.id;
            evt1.StartDateTime=system.now()-2;
            evt1.EndDateTime=system.now()-1;
            evt1.IsAllDayEvent=false;
            //evt.isChild = true;
            insert evt1;
            
            test.startTest();
            try{
                Sector_EventCloneButton.getEventClone(evt.id,evt1);
            }catch(AuraHandledException ahe){
                System.debug('####### ahe = ' + ahe);
            }
            try{
                Sector_EventCloneButton.getEventClone(evt.id,evt);
            }catch(AuraHandledException ahe){
                System.debug('####### ahe = ' + ahe);
            }
            Sector_EventCloneButton.getselectOptions(evt,'Type');
        }
    }
    static testmethod void getEventCloneTest2() {
        User us = [Select Id from User where email = 'sectortestclassuser@sector.shell.com'];
        System.runAs(us)
        {
            
            List<Account> lstAccounts =new List<Account>();
            Integer flag=0;
            for(integer i=0;i<10;i++){
                Account acc = new Account(Name='Test NM clone 3' + i );
                lstAccounts.add(acc);
            }
            insert lstAccounts;
            Call_Plan__c call_plan = new Call_Plan__c();
            //String s=ev.Subject;
            call_plan.Name= 'Call Plan of Testing for' ;
            insert call_plan;
            Event evt = new Event();
            evt.WhatId=call_plan.id;
            evt.Type='Face to Face';
            evt.Subject='Meeting';
            evt.Call_Plan_Record_Type__c='Call Plan POPSA';
            evt.OwnerId=us.id;
            evt.StartDateTime=system.now()+1;
            evt.EndDateTime=system.now()+1;
            evt.IsAllDayEvent=false;
            insert evt;
            Event evt1 = new Event();
            evt1.WhatId=call_plan.id;
            evt1.Type='Face to Face';
            evt1.Subject='Meeting';
            evt1.Call_Plan_Record_Type__c='Call Plan POPSA';
            evt1.OwnerId=us.id;
            evt1.StartDateTime=system.now()+2;
            evt1.EndDateTime=system.now()+1;
            evt1.IsAllDayEvent=false;
            //evt.isChild = true;
            //insert evt1;
            
            test.startTest();
            try{
                system.debug('line 196');
                Sector_EventCloneButton.getEventClone(evt.id,evt1);
            }catch(AuraHandledException ahe){
                system.debug('line 199');
                System.debug('####### ahe = ' + ahe);
            }
            test.stopTest();
        }
    }
    static testmethod void getEventCloneTest3() {
        User us = [Select Id from User where email = 'sectortestclassuser@sector.shell.com'];
        System.runAs(us)
        {
            
            List<Account> lstAccounts =new List<Account>();
            Integer flag=0;
            for(integer i=0;i<10;i++){
                Account acc = new Account(Name='Test NM clone1' + i );
                lstAccounts.add(acc);
            }
            insert lstAccounts;
            Call_Plan__c call_plan = new Call_Plan__c();
            //String s=ev.Subject;
            call_plan.Name= 'Call Plan of Testing for' ;
            insert call_plan;
            Event evt = new Event();
            evt.WhatId=call_plan.id;
            evt.Type='Face to Face';
            evt.Subject='Meeting';
            evt.Call_Plan_Record_Type__c='Call Plan POPSA';
            evt.OwnerId=us.id;
            evt.StartDateTime=system.now();
            evt.EndDateTime=system.now();
            evt.IsAllDayEvent=false;
            insert evt;
            Event evt1 = new Event();
            evt1.WhatId=call_plan.id;
            evt1.Type='Face to Face';
            evt1.Subject='Meeting';
            evt1.Call_Plan_Record_Type__c='Call Plan POPSA';
            evt1.OwnerId=us.id;
            evt1.StartDateTime=evt.StartDateTime;
            evt1.EndDateTime=evt.EndDateTime;
            evt1.IsAllDayEvent=false;
            //evt.isChild = true;
            //insert evt1;
            
            test.startTest();
            try{
                system.debug('line 245');
                Sector_EventCloneButton.getEventClone(evt.id,evt1);
            }catch(AuraHandledException ahe){
                system.debug('line 248');
                System.debug('####### ahe = ' + ahe);
            }
            test.stopTest();
        }
    }
    static testmethod void getEventCloneTest4() {
        User u = [Select Id from User where email = 'sectortestclassuser@sector.shell.com'];
        System.runAs(u){
            List<Account> lstAccounts =new List<Account>();
            Integer flag=0;
            for(integer i=0;i<10;i++){
                Account acc = new Account(Name='Test NM' + i );
                lstAccounts.add(acc);
            }
            insert lstAccounts;
            Call_Plan__c call_plan = new Call_Plan__c();
            call_plan.Name= 'Call Plan of Testing for' ;
            insert call_plan;
            //Call_Plan__c[] call_plan = datagen.generateCallPlan (1, 'Test Call plan', lstAccounts[0].id, 'Future_Call_Plan');
            //insert call_plan ;
            Event evt = new Event();
            evt.WhatId=call_plan.id;
            evt.Type='Face to Face';
            evt.Subject='Meeting';
            evt.Call_Plan_Record_Type__c='Call Plan POPSA';
            evt.OwnerId=u.id;
            evt.StartDateTime=system.now();
            evt.EndDateTime=system.now();
            //evt.Hunting_Farming__c='';
            evt.IsAllDayEvent=false;
            //evt.isChild = true;
            insert evt;
            Event evt1 = new Event();
            evt1.WhatId=call_plan.id;
            evt1.Type='Face to Face';
            evt1.Subject='MeetingMeetingMeetingMeetingMeetingMeetingMeetingMeetingMeetingMeetingMeetingMeetingMeetingMeeting';
            evt1.Call_Plan_Record_Type__c='Call Plan POPSA';
            evt1.OwnerId=u.id;
            evt1.StartDateTime=evt.StartDateTime;
            evt1.EndDateTime=evt.EndDateTime;
            //evt1.Hunting_Farming__c='';
            evt1.IsAllDayEvent=false;
            //evt.isChild = true;
            insert evt1;
            test.startTest();
            try{
                Sector_EventCloneButton.getEventClone(evt.id,evt1);
            }catch(AuraHandledException ahe){
                System.debug('####### ahe = ' + ahe);
            }
            try{
                Sector_EventCloneButton.getEventClone(evt.id,evt);
            }catch(AuraHandledException ahe){
                System.debug('####### ahe = ' + ahe);
            }
            Sector_EventCloneButton.getselectOptions(evt,'Type');
            test.stopTest();
        }
    }
    
    static testmethod void getEventCloneTest5() {
        User u = [Select Id from User where email = 'sectortestclassuser@sector.shell.com'];
        System.runAs(u){
            List<Account> lstAccounts =new List<Account>();
            Integer flag=0;
            for(integer i=0;i<10;i++){
                Account acc = new Account(Name='Test NM clone 2' + i );
                lstAccounts.add(acc);
            }
            insert lstAccounts;
            Call_Plan__c call_plan = new Call_Plan__c();
            call_plan.Name= 'Call Plan of Testing for' ;
            insert call_plan;
            //Call_Plan__c[] call_plan = datagen.generateCallPlan (1, 'Test Call plan', lstAccounts[0].id, 'Future_Call_Plan');
            //insert call_plan ;
            Event evt = new Event();
            evt.WhatId=call_plan.id;
            evt.Type='Face to Face';
            evt.Subject='Meeting';
            evt.Call_Plan_Record_Type__c='Call Plan POPSA';
            evt.OwnerId=u.id;
            evt.StartDateTime=system.now();
            evt.EndDateTime=system.now();
            //evt.Hunting_Farming__c='';
            evt.IsAllDayEvent=true;
            //evt.isChild = true;
            insert evt;
            Event evt1 = new Event();
            evt1.WhatId=call_plan.id;
            evt1.Type='Face to Face';
            evt1.Subject='Meeting';
            evt1.Call_Plan_Record_Type__c='Call Plan POPSA';
            evt1.OwnerId=u.id;
            evt1.StartDateTime=system.now()+1;
            evt1.EndDateTime=system.now()+1;
            //evt1.Hunting_Farming__c ='';
            evt1.IsAllDayEvent=true;
            //evt.isChild = true;
            insert evt1;
            test.startTest();
            try{
                Sector_EventCloneButton.getEventClone(evt.id,evt1);
            }catch(AuraHandledException ahe){
                System.debug('####### ahe = ' + ahe);
            }
            try{
                Sector_EventCloneButton.getEventClone(evt.id,evt);
            }catch(AuraHandledException ahe){
                System.debug('####### ahe = ' + ahe);
            }
            Sector_EventCloneButton.getselectOptions(evt,'Type');
            test.stopTest();
            
        }
    }
    
}