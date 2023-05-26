@isTest
public class Sector_CallPlanListViewTest {
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
        String columns ='Subject,Related To,Call Plan Type,Start Date Time,End Date Time,Status;Type;Agenda,Minutes';
        String coulmnResult = Sector_CallPlanListView.getListViewDetails();
        System.assertEquals(columns, coulmnResult);
        User us = [Select Id from User where email = 'sectortestclassuser@sector.shell.com'];
        System.runAs(us)
        {
            Id recTypeId = Schema.SObjectType.Event.getRecordTypeInfosByName().get('Sector Call Plan').getRecordTypeId();
            Id recTypeIdAccount = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Sector').getRecordTypeId();
            List<Account> li =new List<Account>();
            
            Id recordtypeidorg1= Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId();
        Account accOpp =new Account(Name='DK0301 Test new', RecordTypeId= recTypeIdAccount, Region__c='Europe', Sector__c='Technology');
        insert accOpp;
        Opportunity obj1 =new Opportunity(recordTypeId= recordtypeidorg1, 
                                                  Name= Integer.valueOf(math.rint(math.random()*1000000))+'Call Plan Last Date Test' +Integer.valueOf(math.rint(math.random()*1000000)) , AccountId =accOpp.id, 
                                          StageName= 'Align', CloseDate = system.today(), Product_Category_1__c= 'Power', 
                                          Product_Sub_Category_1__c='Renewable',Opportunity_Country__c='Afghanistan', 
                                          Opportunity_Region__c='Europe',Value_Amount__c = 10);
        
        insert obj1;
            Integer flag=0;
            for(integer i=0;i<50;i++){
                Account acc = new Account(Name= Integer.valueOf(math.rint(math.random()*1000000))+'Call Plan Last Date Test' +Integer.valueOf(math.rint(math.random()*1000000)) + i,recordTypeId=recTypeIdAccount );
                li.add(acc);
                
            }
            insert li;
            List<Event> e =new List<event>();
            Set<Id> eventAccount =new Set<Id>();
            Set<Id> eveId =new Set<Id>();
            integer x=0;
            for(account a:li){
                Event ev1= new Event(Subject='Last Date1 Test' + x,Call_Plan_Record_Type__c='Call Plan Lite',Status_Event__c='Scheduled',StartDateTime= System.now()+5,EndDateTime= System.now()+6,WhatId =a.id,OwnerId=UserInfo.getUserId(),Type='Virtual',recordTypeId=recTypeId);
                Event ev2= new Event(Subject='Last Date2 Test' + x,Call_Plan_Record_Type__c='Call Plan Lite',Status_Event__c='Scheduled',StartDateTime= System.now()+5,EndDateTime= System.now()+6,WhatId =obj1.id,OwnerId=UserInfo.getUserId(),Type='Virtual',recordTypeId=recTypeId);
                
                e.add(ev1);
                e.add(ev2);
                
                eventAccount.add(a.id);
                x++;
            }
            System.debug(e);
            System.debug(eventAccount);
            insert e;
            Sector_CallPlanListView.fetchAllEvents();
             List<event> eList=[select id,Subject,StartDateTime,EndDateTime,Call_Plan__c
                           from Event where id in: e];
        List<Account> accList=[select Id from Account ];
        List<Call_plan__c> cl=[select Id from Call_plan__c];
        User u=[select id from User limit 1];
        string recD= '[{"label":"Testing","value":"'+u.Id+'"}]';
        
        
        
        Date d=eList[0].StartDateTime.date();
        Date de=eList[0].EndDateTime.date();
        
        String cplstView='Subject,Related To,Call Plan Type,Start Date Time,End Date Time,Status;Type;Agenda,Minutes';
        
        Test.startTest();
        List<Sector_CallPlanListView.evtClPlnWrapper> esearch=Sector_CallPlanListView.searchEvents(cplstView,'Test','','',string.valueOf(d),string.valueOf(de),'Call Plan Lite','Scheduled','Test',0,10,'','test');
        
        Sector_CallPlanListView.evtClPlnWrapper esave=Sector_CallPlanListView.saveRow(JSON.serialize(esearch[0]),recD,'','');
        /*List<Sector_CallPlanListView.evtClPlnWrapper> updEvts=new List<Sector_CallPlanListView.evtClPlnWrapper>();
        Sector_CallPlanListView.evtClPlnWrapper wrapEvts=new Sector_CallPlanListView.evtClPlnWrapper();
        wrapEvts.EventId=eList[0].Id;
        wrapEvts.CallPlanId=eList[0].Call_Plan__c;
        wrapEvts.StartDateTime=cl[0].StartDateTime;
        wrapEvts.EndDateTime=cl[0].EndDateTime;
        wrapEvts.ReasonforCall='Audit';
        wrapEvts.AllDayEvent=false;
        wrapEvts.Type='Face to Face';
        updEvts.add(wrapEvts);
        
        Sector_CallPlanListView.updateEvents(updEvts);*/
        Test.stopTest();
            
        }
    }
     @isTest
    public static void testSearchEvents(){
        
        
        User u=[select id from User limit 1];
       
    }

    public class evtWrapper{ 
        @AuraEnabled public Id recordType{get;set;}
        @AuraEnabled public Integer totalEvents{get;set;}
        @AuraEnabled public String errorMsg {get;set;}
        @AuraEnabled public Map<Id,String> teamUserSet {get;set;}
    }
    public class evtClPlnWrapper{
        @AuraEnabled public String Subject{get;set;}
        @AuraEnabled public String AccountName{get;set;}
        @AuraEnabled public String OpportunityName{get;set;}
        @AuraEnabled public String AccountPlanName{get;set;}
        @AuraEnabled public String SubjectURL{get;set;}
        @AuraEnabled public String Location{get;set;}
        @AuraEnabled public DateTime StartDateTime{get;set;}
        @AuraEnabled public DateTime EndDateTime{get;set;}
        @AuraEnabled public Boolean AllDayEvent{get;set;}
        @AuraEnabled public String ShowTimeAs{get;set;}
        @AuraEnabled public Id RelatedTo{get;set;}
        @AuraEnabled public Id RecordtypeId{get;set;}        
        @AuraEnabled public String RelatedURL{get;set;}
        @AuraEnabled public String RelatedToName{get;set;}
        @AuraEnabled public String RelatedToType{get;set;}
        @AuraEnabled public String CallPlanType{get;set;}
        @AuraEnabled public String Agenda{get;set;}
        @AuraEnabled public String AgendaText{get;set;}
        @AuraEnabled public String Minutes{get;set;}
        @AuraEnabled public String MinutesActions{get;set;}   
        @AuraEnabled public String Objective{get;set;}
        @AuraEnabled public String Objectivetext{get;set;}
        @AuraEnabled public String Anticipate{get;set;}
        @AuraEnabled public String AnticipateText{get;set;}
        @AuraEnabled public String Premise{get;set;}
        @AuraEnabled public String PremiseText{get;set;}
        @AuraEnabled public String Purpose{get;set;}
        @AuraEnabled public String PurposeText{get;set;}
        @AuraEnabled public String Strategy{get;set;}
        @AuraEnabled public String StrategyText{get;set;}
        @AuraEnabled public Id Name{get;set;}
        @AuraEnabled public Id EventId{get;set;}
        @AuraEnabled public Id objId{get;set;}        
        @AuraEnabled public String ReasonforCall{get;set;}
        @AuraEnabled public String Status{get;set;}
        @AuraEnabled public String HuntingFarming{get;set;}
        @AuraEnabled public String Type{get;set;}
        @AuraEnabled public Id AssignedTo{get;set;}
        @AuraEnabled public Id CallPlanId{get;set;}
        @AuraEnabled public Id AccountId{get;set;}
        @AuraEnabled public Id OpportunityId{get;set;}
        @AuraEnabled public Id AccountPlanId{get;set;}
        @AuraEnabled public String AssignedToName{get;set;}
        @AuraEnabled public Boolean DVRBeUsed{get;set;}
        @AuraEnabled public String LinktoDVR{get;set;}
        @AuraEnabled public String sNo {get;set;}
        @AuraEnabled public List<String> ReasonforCallOpts {get;set;}
        @AuraEnabled public List<String> StatusOpts {get;set;}
        @AuraEnabled public List<String> HuntingFarmingOpts {get;set;}
        @AuraEnabled public List<String> TypeOpts {get;set;}
        @AuraEnabled public List<String> clPlnOpts {get;set;}  
        @AuraEnabled public List<EventRelation> Attendees {get;set;}
        @AuraEnabled public String errorMsg {get;set;}
        @AuraEnabled public String rowNo {get;set;}
        @AuraEnabled public String cssClass {get;set;}
        @AuraEnabled public String cssDotClass {get;set;}
        @AuraEnabled public String titleAttr{get;set;}
        @AuraEnabled public String subTheme{get;set;}
        @AuraEnabled public String callCategory{get;set;}
        @AuraEnabled public String stageAttr{get;set;}
        @AuraEnabled public Map<String,List<String>> mapPicklistVal {get;set;}
        @AuraEnabled public Boolean isShareMKTInfo{get;set;}
        @AuraEnabled public Boolean isReply{get;set;}
        @AuraEnabled public String callPlanRel{get;set;}
        @AuraEnabled public User userInformation{get;set;}
    }
}