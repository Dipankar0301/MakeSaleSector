({
    doInit : function(component, event, helper) {
        //debugger;
        console.log(JSON.stringify(component.get("v.row")));
        if(component.get("v.row")!= null && component.get("v.row")!= undefined){
            var eventDetails = component.get("v.row");
            component.set("v.recordId",eventDetails.EventId);
        }
            var recordId = component.get("v.recordId");
        
        console.log('doInit',recordId);
        console.log(event);
        var timeDiff = component.get("v.dateDiffernce"); 
        var action = component.get('c.getEventClone');
        action.setParams({"eventId": recordId,
                          "eventRecord": ''});
        action.setCallback(this, function(response) {
            //debugger;
            var responserece = response.getReturnValue();
            
            if(responserece.responseStatus === 'success')
            {
                if(responserece.eventre.Call_Plan_Record_Type__c == 'Call Plan Lite'){
                    
                    component.set("v.IsPopsa",false);
                    helper.showError();
                }
                else{
                    component.set("v.IsPopsa",true);
                }
                
                console.log('actionResult',responserece.eventre);
                component.set('v.event', responserece.eventre);
                console.log("v.event ",component.get("v.event"));
                var TF = component.get("v.event.IsAllDayEvent");
                component.set("v.AllDayEventCheck", component.get("v.event.IsAllDayEvent"));
                console.log("TF ",TF);
                var DtStartDate = new Date(component.get("v.event.StartDateTime"));
                var DtEndDate = new Date(component.get("v.event.EndDateTime"));
                if(TF)
                {
                    component.set("v.startDate",DtStartDate.toISOString());
                    component.set("v.endDate",DtEndDate.toISOString());
                }
            }
            else
            {
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    message:responserece.responseMessage,
                    duration:' 50000',
                    type: responserece.responseStatus
                });
                toastEvent.fire();
                $A.get("e.force:closeQuickAction").fire();
            }
            
           
            
            
        });
        
        $A.enqueueAction(action);
        helper.fetchPickListValReasonForCall(component,'Reason_for_Call__c','reasonForCall');
    },
    IsAllDayEvent: function(component, event, helper) {
        var isChecked = component.find("EventAllDay").get("v.checked");
        var StartDate = new Date(component.get("v.event.StartDateTime"));
        var EndDate = new Date(component.get("v.event.EndDateTime"));
        var StartDate1 = StartDate.toISOString();
        var EndDate1 = EndDate.toISOString();
        var newstartTime = StartDate1.substr(11, 13);
        var newendTime = EndDate1.substr(11, 13);
        
        if(isChecked){
            component.set("v.startDate",StartDate.toISOString());
            component.set("v.endDate",EndDate.toISOString());
        }
        else
        {
            var startdatetime = new Date(component.get("v.startDate"));
            var enddatetime = new Date(component.get("v.endDate"));
            var startdatetime1=startdatetime.toISOString();
            var enddatetime1 = enddatetime.toISOString();
            var newstartdate1 = startdatetime1.substr(0,11);
            var newenddate1 = enddatetime1.substr(0,11);
            var startdatetimeback = newstartdate1+newstartTime;
            var enddatetimeback = newenddate1+newendTime;
            component.set("v.event.StartDateTime",startdatetimeback);
            component.set("v.event.EndDateTime",enddatetimeback);
            
        }
        component.set("v.AllDayEventCheck",isChecked);
    },
    
    updateDate: function(component, event, helper){
        var parentValue = new Date(component.find('StartDateTime').get("v.value"));
        var newTime = new Date(parentValue.getTime()+(1*3600*1000));
        component.find("EndDateTime").set("v.value",newTime.toISOString());
    },
    updateDateOnly: function(component, event, helper){
        var parentValue1 = component.find("StartDate").get("v.value");
        component.find("EndDate").set("v.value",parentValue1);
    },
    myAction : function(component, event, helper) {
        
    },
    showSpinner: function(component, event, helper) {
        // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true); 
    },
    hideSpinner : function(component,event,helper){
        // make Spinner attribute to false for hide loading spinner    
        component.set("v.Spinner", false);
    },
    cancelClick : function(component,event,helper)
    {
        $A.get("e.force:closeQuickAction").fire();
        $A.get('e.force:refreshView').fire(); 
    },
    saveClick: function(component, event, helper) {
        component.set("v.event.IsAllDayEvent",component.get("v.AllDayEventCheck")); 
        var AllDayEvent = component.get("v.AllDayEventCheck");
        console.log("true or false? --> ",AllDayEvent);
        if(AllDayEvent)
        {
            var Startdate = new Date(component.get("v.startDate"));
            var Enddate = new Date(component.get("v.endDate"));
            console.log("format : ",Startdate);
            Startdate =  Startdate.toISOString();
            Enddate =  Enddate.toISOString();
            console.log("format : ",Startdate);
            component.set("v.event.EndDateTime",Enddate);
            component.set("v.event.StartDateTime",Startdate);
        } 
        
        var newRecords = component.get("v.event");
        
        var recordId = component.get("v.recordId");
        var AllDayEvent = component.get("v.AllDayEventCheck");
        console.log(newRecords);
        var recordId = component.get("v.recordId");
        var action = component.get("c.getEventClone");
        action.setParams({"eventId": recordId,
                          "eventRecord": newRecords});
        action.setCallback(this, function(response){
            var state = response.getState();
            if (component.isValid() && state === "SUCCESS") {
                
				var responserece = response.getReturnValue();				

                if(responserece.responseStatus === 'success')
                {
                    var returned = responserece.eventre;
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": returned.Id,
                    });
                    navEvt.fire(); 
                }
                else
                {
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        message:responserece.responseMessage,
                        duration:' 50000',
                        type: responserece.responseStatus
                    });
                    toastEvent.fire();
                    $A.get("e.force:closeQuickAction").fire();
                }
 
                
            }
            else
            {
                var errors = response.getError();
                component.set("v.custMessage", errors[0].message);
            }
        });
        $A.enqueueAction(action);          
    },
    onPicklistChange: function(component, event, helper) {
        //  alert(event.getSource().get("v.value"));
    },
    
})