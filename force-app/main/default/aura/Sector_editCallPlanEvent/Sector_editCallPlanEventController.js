({
    doInit :function(component, event, helper) {
        console.log('inside doInit of edit row');
        console.log(component.get("v.row.CallPlanType"));
        var recType;
        
        if(component.get("v.row.CallPlanType")=='Call Plan POPSA'){
            recType='POPSA';
            
        }
            
        else if(component.get("v.row.CallPlanType")=='Call Plan Lite')
            recType='OPSA';
        component.set("v.recordType",recType);
        if(component.get("v.row.RelatedToType")=='Account'){
            component.set("v.SelectedObject",'Account');
            component.set("v.SelectedIcon",'standard:account');
            component.set("v.SelectedObjectLabel",'Account');
        }
        if(component.get("v.row.RelatedToType")=='Opportunity'){
            component.set("v.SelectedObject",'Opportunity');
            component.set("v.SelectedIcon",'standard:opportunity');
            component.set("v.SelectedObjectLabel",'Opportunity');
        }
        if(component.get("v.row.RelatedToType")=='SHL_Account_Plan__c'){
            component.set("v.SelectedObject",'SHL_Account_Plan__c');
            component.set("v.SelectedIcon",'custom:custom26');
            component.set("v.SelectedObjectLabel",'Account Plan');
        }
        component.set("v.startDate",component.get("v.row.StartDateTime"));
        component.set("v.endDate",component.get("v.row.EndDateTime"));
        var s=new Object();
        s.label=component.get("v.row.AssignedToName");
        s.value=component.get("v.row.AssignedTo");
        component.set("v.assignedTo",s);
        var sel=new Object();
        sel.label=component.get("v.row.RelatedToName");
        sel.value=component.get("v.row.RelatedTo");
        component.set("v.selectedRecord",sel);
        var userrec = component.get("v.row.userInformation");
        var profileList = [];
        profileList= $A.get("$Label.c.Sector_Profile_label").toString().split(',');
        if(profileList.includes(userrec.Profile.Name) &&
           (component.get("v.row.CallPlanType")==='Call Plan POPSA' ||
            component.get("v.row.CallPlanType")==='Call Plan Lite'))
        {
            component.set("v.isJapanSales",true);
            component.set("v.isJapanRT",true);
        }
        var isJapanUser = component.get("v.isJapanSales");
        var isJapanRecType = component.get("v.isJapanRT");
        

    },
    hidePopup : function(component, event, helper) {
        component.find("overlayLib").notifyClose();
    },
    updateDate: function(component, event, helper){
        var parentValue = new Date(component.find('startdate').get("v.value"));
        var newTime = new Date(parentValue.getTime()+(1*3600*1000));
        component.find("enddate").set("v.value",newTime.toISOString());
    },
    
    saveRow :function(component,record){
        console.log('inside saverow line 91');
        var subj=component.get("v.row.Subject");
        var startDate=component.get("v.row.StartDateTime");
        var endDate=component.get("v.row.EndDateTime");
        var today=new Date();
        var endDay=new Date(Date.parse(endDate));
        var start=new Date(Date.parse(startDate));
        var relTo=component.get("v.row.RelatedTo");
        var initStart=component.get("v.startDate");
        var initEnd=component.get("v.endDate");
        var diffStart=Math.floor((start.getTime() - today.getTime())/(1000*60*60*24));
        var diffEnd=Math.floor((endDay.getTime() - start.getTime())/(1000*60*60*24));
        var attendees=component.get("v.row.Attendees");
        var ppl=component.get("v.selectedRecords");
        var resources=component.get("v.selectedResources");
        var isJapanUser = component.get("v.isJapanSales");
        var isJapanRecType = component.get("v.isJapanRT");
        var cprelated=component.get("v.row.callPlanRel");
        var etype=component.get("v.row.Type");
        console.log('inside saverow line 109');
        console.log(etype);
        if($A.util.isEmpty(subj) || subj.length >80 ||  $A.util.isEmpty(relTo)
           || diffEnd <0 ||(initStart != component.get("v.row.StartDateTime") && diffStart <0 && component.get("v.row.CallPlanType")!='Call Plan Lite')
           || (initStart != component.get("v.row.StartDateTime") || initEnd != component.get("v.row.EndDateTime")) && component.get("v.row.CallPlanType")!='Call Plan Lite'
          ||etype == "--- None ---"){
            component.set("v.custMessage",'Fill all the Mandatory Fields' ); 
            console.log('inside saverow line 114');
            if($A.util.isEmpty(subj) || subj.length >80){
                component.set("v.subjError",'Subject should be filled (max 80 characters)');
            }
            if((initStart != component.get("v.row.StartDateTime") || initEnd != component.get("v.row.EndDateTime")) && component.get("v.row.CallPlanType")!='Call Plan Lite'){
                component.set("v.startError",'You cannot modify event date once it is created & you cannot log events which occurred in the past.' ); 
            }
            if(initStart != component.get("v.row.StartDateTime") && diffStart <0 && component.get("v.row.CallPlanType")!='Call Plan Lite'){
                component.set("v.startError",'Start Date cannot be past day' ); 
            }
            if(diffEnd <0 ){
                component.set("v.endError",'End Date cannot be less than Start Date' ); 
            }
            if($A.util.isEmpty(relTo) ){
                component.set("v.whatIdError",'This field is required' ); 
            }
            if($A.util.isEmpty(cprelated) && isJapanUser && isJapanRecType){
                component.set("v.CpRelatedError",'Please fill Call Plan Related.' );
            }
            if(etype == "--- None ---"){
                component.set("v.typeError",'Please fill Type.' );
            }
        }
        else{
            console.log('inside saverow line 132');
            component.set("v.row.Attendees",[]);
            var appEvent = $A.get("e.c:Sector_CallPlanLstViewEvent");
            appEvent.setParams({
                "Record":component.get("v.row"),
                "action":"save",
                "sNo":"1"});
            appEvent.fire();
            
            component.find("overlayLib").notifyClose();
        }
        
        
        
    },
    handleSaveSuccess:function(component,event,helper){
        component.find("overlayLib").notifyClose();
        var appEvent = $A.get("e.c:Sector_CallPlanLstViewEvent");
        appEvent.setParams({
            "Record":component.get("v.row"),
            "action":"save",
            "sNo":"1"});
        appEvent.fire();
    },
    handleEventAction : function(component,event,helper){
        var selRecs=component.get("v.row.Attendees");
        var delRecs=component.get("v.deleteRecords");
        var action=event.getParam('action');
        
        
    }
   
})