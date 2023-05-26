({
    doInit : function(component, event, helper) {
        var evid= component.get("v.EventId");
        //alert(evid);
        var Planned = component.find("PlannedId");
        var cancelled = component.find("CancelledId");
        var Scheduled = component.find("ScheduledId");
        var MinutesRecorded = component.find("MinutesRecordedId"); 
        var action = component.get("c.getCallPlanFields");
       action.setParams({ "EventId" : evid });
        action.setCallback(this, function(response) {
            var state = response.getState();
             //alert(state);
            if (state === "SUCCESS") {
                var statusvalues = response.getReturnValue();
                 //alert(JSON.stringify(statusvalues));
                if(statusvalues.theme=='Theme4t'){
                   component.set("v.UITheme",true);
                }
                component.set("v.CallPlanDetails",statusvalues.eventRec);
                component.set("v.ScheduledCompleted",statusvalues.ScheduleCompleted);
                component.set("v.PlanCompleted",statusvalues.PlanCompleted);
                component.set("v.CallPlanType",statusvalues.CallPlantype);
                component.set("v.Cancelled",statusvalues.Cancelled);
                component.set("v.ShowOutputTextPlanned",true);
                component.set("v.ShowOutputText",true);
                component.set("v.ShowOutputTextMinutes",true);
               
                var schcomp = component.get("v.ScheduledCompleted");
                var plancomp = component.get("v.PlanCompleted");
                var cancel=component.get("v.Cancelled");
                //alert(cancel);
                if(schcomp==true && plancomp==false && cancel==false){
                    //alert('firstone');
                    $A.util.removeClass(Scheduled, 'slds-path__item slds-is-current slds-is-active');
                    $A.util.addClass(Scheduled, 'slds-path__item slds-is-complete');
                    $A.util.addClass(Planned, 'slds-path__item slds-is-current slds-is-active');
                    component.set("v.ScheduledClick",false);
                    component.set("v.PlannedClick",true);
                    component.set("v.MinutesClicked",false);
                }else if(schcomp==false && plancomp==false && cancel==false){
                    //alert('firstone');
                    $A.util.addClass(Scheduled, 'slds-path__item slds-is-current slds-is-active');
                     $A.util.removeClass(Planned, 'slds-path__item slds-is-current slds-is-active');
                    $A.util.removeClass(Planned, 'slds-path__item slds-is-complete');
                    $A.util.removeClass(MinutesRecorded, 'slds-path__item slds-is-current slds-is-active');
					
                    component.set("v.ScheduledClick",true);
                    component.set("v.PlannedClick",false);
                     component.set("v.MinutesClicked",false);
                }
                else if(plancomp==true && cancel==true){
                    //alert('Secondone');
                    $A.util.removeClass(Planned, 'slds-path__item slds-is-current slds-is-active');
                    $A.util.addClass(Planned, 'slds-path__item slds-is-complete');
                    $A.util.removeClass(Scheduled, 'slds-path__item slds-is-current slds-is-active');
                    $A.util.addClass(Scheduled, 'slds-path__item slds-is-complete');
                    $A.util.addClass(MinutesRecorded, 'slds-path__item slds-is-current slds-is-active');
                    component.set("v.MinutesClicked",true);
                    component.set("v.ScheduledClick",false);
                    component.set("v.PlannedClick",false);
                }else if(plancomp==true && cancel==false){
                    //alert('Thirdone');
                    $A.util.removeClass(Planned, 'slds-path__item slds-is-current slds-is-active');
                    $A.util.addClass(Planned, 'slds-path__item slds-is-complete');
                    $A.util.removeClass(Scheduled, 'slds-path__item slds-is-current slds-is-active');
                    $A.util.addClass(Scheduled, 'slds-path__item slds-is-complete');
                    $A.util.addClass(MinutesRecorded, 'slds-path__item slds-is-current slds-is-active');
                    component.set("v.MinutesClicked",true);
                    component.set("v.ScheduledClick",false);
                    component.set("v.PlannedClick",false);
                }else if(cancel==true){
                    $A.util.removeClass(Planned, 'slds-path__item slds-is-complete');
                    $A.util.removeClass(Planned, 'slds-path__item slds-is-current slds-is-active');
                    $A.util.removeClass(Scheduled, 'slds-path__item slds-is-complete');
                     $A.util.removeClass(Scheduled, 'slds-path__item slds-is-current slds-is-active');
                    $A.util.removeClass(MinutesRecorded, 'slds-path__item slds-is-complete');
                     $A.util.removeClass(MinutesRecorded, 'slds-path__item slds-is-current slds-is-active');
                    $A.util.addClass(cancelled, 'slds-path__item slds-is-current slds-is-active');
                    component.set("v.MinutesClicked",false);
                    component.set("v.ScheduledClick",false);
                    component.set("v.PlannedClick",false);
                    component.set("v.CancelClicked",true);
                }
            }
        }),
            $A.enqueueAction(action);
    },
    ClickScheduled : function(component, event, helper) {
        component.set("v.ScheduledClick",true);
        component.set("v.PlannedClick",false);
        component.set("v.MinutesClicked",false);
        component.set("v.CancelClicked",false);
        var Planned = component.find("PlannedId"); 
        var Scheduled = component.find("ScheduledId");
        var MinutesRecorded = component.find("MinutesRecordedId"); 
        var Cancelled = component.find("CancelledId");
        $A.util.addClass(Scheduled, 'slds-path__item slds-is-current slds-is-active');
        //$A.util.addClass(Planned, 'slds-path__item slds-is-current slds-is-active');
        $A.util.removeClass(Planned, 'slds-path__item slds-is-current slds-is-active');
        //$A.util.addClass(Scheduled, 'slds-path__item slds-is-incomplete');
        $A.util.removeClass(MinutesRecorded, 'slds-path__item slds-is-current slds-is-active');
        //$A.util.addClass(MinutesRecorded, 'slds-path__item slds-is-incomplete');
        $A.util.removeClass(Cancelled, 'slds-path__item slds-is-current slds-is-active');
    },
    
    ClickPlanned : function(component, event, helper) {
        component.set("v.ScheduledClick",false);
        component.set("v.PlannedClick",true);
        component.set("v.MinutesClicked",false);
        component.set("v.CancelClicked",false);
        var Planned = component.find("PlannedId"); 
        var Scheduled = component.find("ScheduledId");
        var MinutesRecorded = component.find("MinutesRecordedId"); 
        var Cancelled = component.find("CancelledId");
        $A.util.addClass(Planned, 'slds-path__item slds-is-current slds-is-active');
        $A.util.removeClass(Scheduled, 'slds-path__item slds-is-current slds-is-active');
        $A.util.addClass(Scheduled, 'slds-path__item slds-is-incomplete');
        $A.util.removeClass(MinutesRecorded, 'slds-path__item slds-is-current slds-is-active');
        $A.util.addClass(MinutesRecorded, 'slds-path__item slds-is-incomplete');
        $A.util.removeClass(Cancelled, 'slds-path__item slds-is-current slds-is-active');
    },
    ClickMinutes : function(component, event, helper) {
        component.set("v.ScheduledClick",false);
        component.set("v.PlannedClick",false);
        component.set("v.MinutesClicked",true);
        component.set("v.CancelClicked",false);
        var Planned = component.find("PlannedId"); 
        var Scheduled = component.find("ScheduledId");
        var MinutesRecorded = component.find("MinutesRecordedId"); 
        var Cancelled = component.find("CancelledId");
        $A.util.addClass(MinutesRecorded, 'slds-path__item slds-is-current slds-is-active');
        $A.util.removeClass(Scheduled, 'slds-path__item slds-is-current slds-is-active');
        $A.util.removeClass(Planned, 'slds-path__item slds-is-current slds-is-active');
        $A.util.removeClass(Cancelled, 'slds-path__item slds-is-current slds-is-active');
    },
    ClickCancel : function(component, event, helper) {
        component.set("v.ScheduledClick",false);
        component.set("v.PlannedClick",false);
        component.set("v.MinutesClicked",false);
        component.set("v.CancelClicked",true);
        var Planned = component.find("PlannedId"); 
        var Scheduled = component.find("ScheduledId");
        var MinutesRecorded = component.find("MinutesRecordedId"); 
        var Cancelled = component.find("CancelledId");
        $A.util.addClass(Cancelled, 'slds-path__item slds-is-current slds-is-active');
        $A.util.removeClass(Scheduled, 'slds-path__item slds-is-current slds-is-active');
        $A.util.removeClass(Planned, 'slds-path__item slds-is-current slds-is-active');
        $A.util.removeClass(MinutesRecorded, 'slds-path__item slds-is-current slds-is-active');
    },
    panelOne : function(component, event, helper) {
        helper.toggleAction(component, event, 'panelOne'); 
        
    },    
    EditClicked : function(component, event, helper) {
        component.set("v.EditClicked",true);
        component.set("v.ShowOutputText",false);
        component.set("v.EnableSaveCancel",true);
        
    },
    EditClickedPlanned : function(component, event, helper) {
        component.set("v.EditClickedPlanned",true);
        component.set("v.ShowOutputTextPlanned",false);
        component.set("v.EnableSaveCancelPlanned",true);
    },
    EditClickedMinutes : function(component, event, helper) {
        //alert('In Controller');
        component.set("v.EditClickedMinutes",true);
        component.set("v.ShowOutputTextMinutes",false);
        component.set("v.EnableSaveCancelMinutes",true);
    },
    ScheduledSave : function(component, event, helper) {
        helper.ScheduledSave(component, event, helper);
        
    },
    PlannedSave : function(component, event, helper) {
        helper.PlannedSave(component, event, helper);
        
    },
    MinutesSaved : function(component, event, helper) {
        helper.MinutesSaved(component, event, helper);
        
    },
    MinutesCancel : function(component, event, helper) {
        component.set("v.EditClickedMinutes",false);
        component.set("v.ShowOutputTextMinutes",true);
        component.set("v.EnableSaveCancelMinutes",false);
        
    },
    PlannedCancel : function(component, event, helper) {
        component.set("v.EditClickedPlanned",false);
        component.set("v.ShowOutputTextPlanned",true);
        component.set("v.EnableSaveCancelPlanned",false);
        
    },
    ScheduledCancel : function(component, event, helper) {
        component.set("v.EditClicked",false);
        component.set("v.ShowOutputText",true);
        component.set("v.EnableSaveCancel",false);
        
    },
    CloseWindow : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
        
    }
})