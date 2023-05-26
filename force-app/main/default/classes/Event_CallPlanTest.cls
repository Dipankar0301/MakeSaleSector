@isTest
public class Event_CallPlanTest {
    @isTest
    static void insertretrieve(){
        Id recTypeId = Schema.SObjectType.Event.getRecordTypeInfosByName().get('Hydrogen').getRecordTypeId();
        List<Account> li =new List<Account>();
        Integer flag=0;
        for(integer i=0;i<10;i++){
            Account acc = new Account(Name='Test NM' + i );
            li.add(acc);
        }
        insert li;
        List<Event> e =new List<event>();
        integer x=0;
        for(account a:li){
            Event ev= new Event(Subject='Test NM1' + x,StartDateTime= System.now(),EndDateTime= System.now(),WhatId =a.id,OwnerId=UserInfo.getUserId(),Type='Virtual',recordTypeId=recTypeId);
            e.add(ev);
            x++;
        }
        insert e;
        Set<Id> ids=new Set<Id>();
        Id returnedId;
        String returnedStatus;
        Set<Id> eventId =new Set<Id>();
        Map<id,String> listatus =new Map<id,String>();
        for(event e1:e){
            returnedId=Event_Callplan.getCallPlanRecordId(e1.id);
            eventId.add(e1.id);
            ids.add(returnedId);
            returnedStatus = Event_Callplan.getEventStatus(e1.id);
            listatus.put(e1.id,returnedStatus);
            
            
            Event_Callplan.responseWrapper response = Event_Callplan.getCallPlanDetails(e1.id);
            System.assertEquals('success', response.responseStatus);
            
            Event_Callplan.responseWrapper response1 = Event_Callplan.getCallPlanDetails(null);
            System.assertEquals('error', response1.responseStatus);
        }
        
        List<Call_Plan__c> callPlanId =[select id,Status__c,EventId__c from Call_Plan__c where EventId__c in: eventId];
        for(Call_Plan__c cp: callPlanId){
            for(Id id: listatus.keySet()){
                if(cp.EventId__c == id){
                    System.assertEquals(listatus.get(id), cp.Status__c);
                }
            }
        }
        
        for(Call_Plan__c cpc: callPlanId){
            for(Id var:ids){
                if(var==cpc.id){
                    flag++;
                }
            }
        }
        System.assertEquals(flag, ids.size());
        e[0].Subject ='Test new';
        update e;
    }
    
    @isTest
    static void updateStatusTest1(){
        List<Call_Plan__c> li =new List<Call_Plan__c>();
        
        for(integer i=0;i<50;i++){
            Call_Plan__c cp =new Call_Plan__c(Name = 'Test NM2' + i , Purpose__c='a' + i, Objective__c='b', Premise__c='c', Anticipate__c ='e', Strategy__c='s');
            li.add(cp);
            
        }
        insert li;
        List<Call_Plan__c> soqlli1 =[select id,Purpose__c,Objective__c, Minutes_and_Action__c, Strategy__c, Premise__c,Anticipate__c,Agenda__c from Call_Plan__c where id in: li];
        List<Call_Plan__c> li1 =new List<Call_Plan__c>();
        for(Call_Plan__c cpp: soqlli1){
            cpp.Purpose__c = 'xyz';
            cpp.Objective__c = 'abc';
            cpp.Premise__c = 'mno';
            cpp.Minutes_and_Action__c = 'pqr';
            cpp.Strategy__c='d';
            cpp.Anticipate__c ='anticipate';
            cpp.Agenda__c ='agenda';
            li1.add(cpp);
        }
        update li1;
    }
    
    
    @isTest
    static void updateStatusTest2(){
                
        List<Call_Plan__c> li =new List<Call_Plan__c>();
        
        for(integer i=0;i<50;i++){
            Call_Plan__c cp =new Call_Plan__c(Name = 'Test NM3' + i , Purpose__c='a' + i, Objective__c='b', Premise__c='c', Anticipate__c ='e', Strategy__c='s');
            li.add(cp);
            
        }
        insert li;
        List<Call_Plan__c> soqlli1 =[select id,Purpose__c,Objective__c, Minutes_and_Action__c, Strategy__c, Premise__c,Anticipate__c,Agenda__c from Call_Plan__c where id in: li];
        List<Call_Plan__c> li1 =new List<Call_Plan__c>();
        for(Call_Plan__c cpp: soqlli1){
            cpp.Purpose__c = '';
            cpp.Objective__c = 'abc';
            cpp.Premise__c = 'mno';
            cpp.Minutes_and_Action__c = 'pqr';
            cpp.Strategy__c='d';
            cpp.Anticipate__c ='anticipate';
            cpp.Agenda__c ='agenda';
            li1.add(cpp);
        }
        update li1;
        
    }
    @isTest
    static void updateStatusTest3(){
                
        List<Call_Plan__c> li =new List<Call_Plan__c>();
        
        for(integer i=0;i<50;i++){
            Call_Plan__c cp =new Call_Plan__c(Name = 'Test NM4' + i , Purpose__c='a' + i, Objective__c='b', Premise__c='c', Anticipate__c ='e', Strategy__c='s');
            li.add(cp);
            
        }
        insert li;
        List<Call_Plan__c> soqlli1 =[select id,Purpose__c,Objective__c, Minutes_and_Action__c, Strategy__c, Premise__c,Anticipate__c,Agenda__c from Call_Plan__c where id in: li];
        List<Call_Plan__c> li1 =new List<Call_Plan__c>();
        for(Call_Plan__c cpp: soqlli1){
            cpp.Purpose__c = 'mno';
            cpp.Objective__c = 'abc';
            cpp.Premise__c = 'mno';
            cpp.Minutes_and_Action__c = '';
            cpp.Strategy__c='d';
            cpp.Anticipate__c ='anticipate';
            cpp.Agenda__c ='';
            li1.add(cpp);
        }
        update li1;
        
    }
    @isTest
    static void getEventStatusTest(){
        Id recTypeId = Schema.SObjectType.Event.getRecordTypeInfosByName().get('Hydrogen').getRecordTypeId();
        List<Account> li =new List<Account>();
        Integer flag=0;
        for(integer i=0;i<50;i++){
            Account acc = new Account(Name='Test' + i );
            li.add(acc);
        }
        insert li;
        List<Event> e =new List<event>();
        integer x=0;
        for(account a:li){
            Event ev= new Event(Subject='Test NM5' + x,StartDateTime= System.now(),EndDateTime= System.now(),WhatId =a.id,OwnerId=UserInfo.getUserId(),Type='Virtual', recordTypeId=recTypeId);
            e.add(ev);
            x++;
        }
        insert e;
        
    }
    
    @isTest
    static void getEventStatusSectorTest_Scheduled()
    {
        Id recTypeId = Schema.SObjectType.Event.getRecordTypeInfosByDeveloperName().get('Sector_Call_Plan').getRecordTypeId();
        List<Account> li =new List<Account>();
        Integer flag=0;
        for(integer i=0;i<50;i++){
            Account acc = new Account(Name='Test NM5' + i );
            li.add(acc);
        }
        insert li;
        List<Event> e =new List<event>();
        integer x=0;
        for(account a:li){
            Event ev= new Event(Subject='Test NM6' + x,StartDateTime= System.now()+1,
                                EndDateTime= System.now()+1,WhatId =a.id,OwnerId=UserInfo.getUserId(),Type='Virtual', 
                                recordTypeId=recTypeId,Call_Plan_Record_Type__c = 'Call Plan POPSA'
                               );
            e.add(ev);
            x++;
        }
        insert e; 
        
        List<String> listids = new List<String>();
        for(Event ev: e)
        {
            listids.add(ev.Id);
        }
        List<Call_Plan__c> callplanlist = new List<Call_Plan__c>();
        for(Call_Plan__c callplan : [select id,Purpose_Objective__c,Premise_Stakeholder__c, Anticipate__c, Strategy_Approach__c
                                     from Call_Plan__c 
                                     where EventId__c in :listids])
        {
            callplan.Purpose_Objective__c = 'Test objective';
            callplan.Premise_Stakeholder__c = 'Test objective';
            callplan.Anticipate__c = 'Test objective';
            callplanlist.add(callplan);
        }
        update callplanlist;
        
        for(Event ev : [SELECT Id, Status_Event__c FROM Event where Id in : e])
        {
            System.assertEquals('Scheduled', ev.Status_Event__c);
        }
    }
    
    @isTest
    static void getEventStatusSectorTest_Planned()
    {
        Id recTypeId = Schema.SObjectType.Event.getRecordTypeInfosByDeveloperName().get('Sector_Call_Plan').getRecordTypeId();
        List<Account> li =new List<Account>();
        Integer flag=0;
        for(integer i=0;i<50;i++){
            Account acc = new Account(Name='Test NM7' + i );
            li.add(acc);
        }
        insert li;
        List<Event> e =new List<event>();
        integer x=0;
        for(account a:li){
            Event ev= new Event(Subject='Test NM8' + x,StartDateTime= System.now()+1,
                                EndDateTime= System.now()+1,WhatId =a.id,OwnerId=UserInfo.getUserId(),Type='Virtual', 
                                recordTypeId=recTypeId,Call_Plan_Record_Type__c = 'Call Plan POPSA'
                               );
            e.add(ev);
            x++;
        }
        insert e; 
        
        List<String> listids = new List<String>();
        for(Event ev: e)
        {
            listids.add(ev.Id);
        }
        List<Call_Plan__c> callplanlist = new List<Call_Plan__c>();
        for(Call_Plan__c callplan : [select id,Purpose_Objective__c,Premise_Stakeholder__c, Anticipate__c, Strategy_Approach__c
                                     from Call_Plan__c 
                                     where EventId__c in :listids])
        {
            callplan.Purpose_Objective__c = 'Test objective';
            callplan.Premise_Stakeholder__c = 'Test objective';
            callplan.Anticipate__c = 'Test objective';
            callplan.Strategy_Approach__c = 'Test objective';
            callplanlist.add(callplan);
        }
        
        Event_CallPlan_TriggerContext.firstRun = true;
        
        update callplanlist;
        
        for(Event ev : [SELECT Id, Status_Event__c FROM Event where Id in : e])
        {
            System.assertEquals('Planned', ev.Status_Event__c);
        }
        
    }
    @isTest
    static void getEventStatusSectorTest_MinutesRecorded()
    {
        Id recTypeId = Schema.SObjectType.Event.getRecordTypeInfosByDeveloperName().get('Sector_Call_Plan').getRecordTypeId();
        List<Account> li =new List<Account>();
        Integer flag=0;
        for(integer i=0;i<50;i++){
            Account acc = new Account(Name='Test NM9' + i );
            li.add(acc);
        }
        insert li;
        List<Event> e =new List<event>();
        integer x=0;
        for(account a:li){
            Event ev= new Event(Subject='Test NM10' + x,StartDateTime= System.now()+1,
                                EndDateTime= System.now()+1,WhatId =a.id,OwnerId=UserInfo.getUserId(),Type='Virtual', 
                                recordTypeId=recTypeId,Call_Plan_Record_Type__c = 'Call Plan POPSA'
                               );
            e.add(ev);
            x++;
        }
        insert e; 
        
        List<String> listids = new List<String>();
        for(Event ev: e)
        {
            listids.add(ev.Id);
        }
        List<Call_Plan__c> callplanlist = new List<Call_Plan__c>();
        for(Call_Plan__c callplan : [select id,Purpose_Objective__c,Premise_Stakeholder__c, Anticipate__c, Strategy_Approach__c
                                     from Call_Plan__c 
                                     where EventId__c in :listids])
        {
            callplan.Purpose_Objective__c = 'Test objective';
            callplan.Premise_Stakeholder__c = 'Test objective';
            callplan.Anticipate__c = 'Test objective';
            callplan.Strategy_Approach__c = 'Test objective';
            callplan.Minutes_and_Action__c = 'Test minutes recorded';
            callplanlist.add(callplan);
        }
        
        Event_CallPlan_TriggerContext.firstRun = true;
        
        update callplanlist;
        
        for(Event ev : [SELECT Id, Status_Event__c FROM Event where Id in : e])
        {
            System.assertEquals('Minutes Recorded', ev.Status_Event__c);
        }
        
    }
    @isTest
    static void insertEvent(){
        Id recTypeId = Schema.SObjectType.Event.getRecordTypeInfosByName().get('Sector Call Plan').getRecordTypeId();
        Id recTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sector').getRecordTypeId();
        List<Account> li =new List<Account>();
        Integer flag=0;
        for(integer i=0;i<100;i++){
            Account acc = new Account(Name= Integer.valueOf(math.rint(math.random()*1000000))+'Call Plan Last Date' +Integer.valueOf(math.rint(math.random()*1000000)) + i,recordTypeId=recTypeIdAccount );
            li.add(acc);
        }
        insert li;
        List<Event> e =new List<event>();
        Set<Id> eventAccount =new Set<Id>();
        Set<Id> eveId =new Set<Id>();
        integer x=0;
        for(account a:li){
            Event ev1= new Event(Subject='Last Date1' + x,StartDateTime= System.now(),EndDateTime= System.now(),WhatId =a.id,OwnerId=UserInfo.getUserId(),Type='Virtual',recordTypeId=recTypeId);
            Event ev2= new Event(Subject='Last Date2' + x,StartDateTime= System.now(),EndDateTime= System.now(),WhatId =a.id,OwnerId=UserInfo.getUserId(),Type='Virtual',recordTypeId=recTypeId);
           
            e.add(ev1);
            e.add(ev2);
            
            eventAccount.add(a.id);
            x++;
        }
        System.debug(e);
        System.debug(eventAccount);
        insert e;
        System.debug(e);
        for(Event ev: e)
        {
            eveId.add(ev.id);
        }
        
       
    	Date expected;
        Date Actual;
        //System.debug(listAllAccount);
        for(Account acc: [Select Id, Name, Last_Contacted_Date__c,(Select Id,EndDate from Events where Status_Event__c != 'Cancelled' and isDeleted =: False and EndDate <=: Date.today() order by EndDate desc limit 1) 
                                    from Account where id in:eventAccount and recordTypeId = :Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId()]){
            Actual = acc.Last_Contacted_Date__c;
            for(Event ev :acc.Events)
            { 
                
                expected = ev.EndDate;
                
            }
            System.assertEquals(expected, Actual);
        }
        for(Event ev :e){
            //ev.EndDateTime =DateTime.newInstance(2997, 1, 31, 7, 8, 16);
            ev.EndDateTime = ev.EndDateTime + 2;
            System.debug(ev.EndDateTime);
        }
        update e;
        //List<Account> listAllAccount1 = ;
    	Date expected1;
        Date Actual1;
        //System.debug(listAllAccount1);
        for(Account acc: [Select Id, Name, Last_Contacted_Date__c,(Select Id,EndDate from Events where Status_Event__c != 'Cancelled' and isDeleted =: False and EndDate <=: Date.today() order by EndDate desc limit 1) 
                                    from Account where id in:eventAccount and recordTypeId = :Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId()]){
            Actual1 = acc.Last_Contacted_Date__c;
            for(Event ev :acc.Events)
            { 
                
                expected1 = ev.EndDate;
                
            }
            System.assertEquals(expected1, Actual1);
        }
        List<Event> eventTodelete = new List<Event>();
            eventTodelete.add(e[0]);
        eventTodelete.add(e[1]);
        delete eventTodelete;
        //List<Account> listAllAccount2 = ;
    	Date expected2;
        Date Actual2;
        //System.debug(listAllAccount2);
        for(Account acc: [Select Id, Name, Last_Contacted_Date__c,(Select Id,EndDate from Events where Status_Event__c != 'Cancelled' and isDeleted =: False and EndDate <=: Date.today() order by EndDate desc limit 1) 
                                    from Account where id in :eventAccount and recordTypeId = :Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId()]){
            Actual2 = acc.Last_Contacted_Date__c;
            for(Event ev :acc.Events)
            { 
                
                expected2 = ev.EndDate;
                
            }
            if(acc.Events.Size()>0)
            System.assertEquals(expected2, Actual2);
            else
                System.assertEquals(null, Actual2);
        }
        
    }
    
    
    @isTest
    static void testTriggeroff()
    {
        insert (new TriggerHandler__c(Name = 'Event_CallPlan', Active__c = false) );
        
        Id recTypeId = Schema.SObjectType.Event.getRecordTypeInfosByName().get('Sector Call Plan').getRecordTypeId();
        Id recTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sector').getRecordTypeId();
        List<Account> li =new List<Account>();
        Integer flag=0;
        for(integer i=0;i<10;i++){
            Account acc = new Account(Name= Integer.valueOf(math.rint(math.random()*1000000))+'Call Plan Last Date'+ Integer.valueOf(math.rint(math.random()*1000000)) + i,recordTypeId=recTypeIdAccount );
            li.add(acc);
        }
        insert li;
        List<Event> e =new List<event>();
        Set<Id> eventAccount =new Set<Id>();
        Set<Id> eveId =new Set<Id>();
        integer x=0;
        for(account a:li){
            Event ev1= new Event(Subject='Last Date1' + x,StartDateTime= System.now(),EndDateTime= System.now(),WhatId =a.id,OwnerId=UserInfo.getUserId(),Type='Virtual',recordTypeId=recTypeId);
            Event ev2= new Event(Subject='Last Date2' + x,StartDateTime= System.now(),EndDateTime= System.now(),WhatId =a.id,OwnerId=UserInfo.getUserId(),Type='Virtual',recordTypeId=recTypeId);
            
            e.add(ev1);
            e.add(ev2);
            
            eventAccount.add(a.id);
            x++;
        }
        System.debug(e);
        System.debug(eventAccount);
        insert e;
        System.debug(e);
        for(Event ev: e)
        {
            eveId.add(ev.id);
        }
        
        
        Date expected;
        Date Actual;
        //System.debug(listAllAccount);
        for(Account acc: [Select Id, Name, Last_Contacted_Date__c,(Select Id,EndDate from Events where Status_Event__c != 'Cancelled' and isDeleted =: False order by EndDate desc limit 1) 
                          from Account where id in:eventAccount and recordTypeId = :Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId()]){
                              Actual = acc.Last_Contacted_Date__c;
                              /*for(Event ev :acc.Events)
                              { 
                                  
                                  expected = ev.EndDate;
                                  
                              }*/
                              System.assertEquals(null, Actual);
                          }
        
    }
    
}