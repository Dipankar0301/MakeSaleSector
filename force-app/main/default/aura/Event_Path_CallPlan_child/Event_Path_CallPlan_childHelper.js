({
    toggleAction : function(component, event, secId) {
        var acc = component.find(secId);
        for(var cmp in acc) {
            $A.util.toggleClass(acc[cmp], 'slds-show');  
            $A.util.toggleClass(acc[cmp], 'slds-hide');  
        }
    },
    ScheduledSave : function(component, event, helper) {
        var evid= component.get("v.EventId");
        var callPlanType = component.get("v.CallPlanType"); 
        //alert(evid);
        var Premise= component.find("Premise").get("v.value");
        var Objective= component.find("Objective").get("v.value");
        if(callPlanType!='Call Plan Challenger'){
        var Purpose= component.find("Purpose").get("v.value");
       }
       if(callPlanType=='Call Plan Challenger'){
        var Purpose= '';
       }
        var Strategy= component.find("Strategy").get("v.value");
        var Anticipate= component.find("Anticipate").get("v.value");
        var Scheduled = component.find("ScheduledId");
        var Planned = component.find("PlannedId");
        component.set("v.IsLoading",true);
        
        /*if($A.util.isUndefinedOrNull(Premise) || $A.util.isEmpty(Premise)){
            component.set("v.ErrorOccured",true);  
            component.set("v.IsLoading",false);
        }
        if($A.util.isUndefinedOrNull(Objective) || $A.util.isEmpty(Objective)){
            component.set("v.ErrorOccured",true);
            component.set("v.IsLoading",false);
        }
        if($A.util.isUndefinedOrNull(Purpose) || $A.util.isEmpty(Purpose)){
            component.set("v.ErrorOccured",true); 
            component.set("v.IsLoading",false);
        }
        if($A.util.isUndefinedOrNull(Strategy) || $A.util.isEmpty(Strategy)){
            component.set("v.ErrorOccured",true);
            component.set("v.IsLoading",false);
        }if($A.util.isUndefinedOrNull(Anticipate) || $A.util.isEmpty(Anticipate)){
            component.set("v.ErrorOccured",true); 
            component.set("v.IsLoading",false);
        }
        alert(Premise);
        alert(Objective);
        alert(Purpose);
        alert(Strategy);
        alert(Anticipate);*/
        if((!$A.util.isUndefinedOrNull(Premise) || !$A.util.isUndefinedOrNull(Objective)  || 
            !$A.util.isUndefinedOrNull(Purpose) || !$A.util.isUndefinedOrNull(Strategy) || 
            !$A.util.isUndefinedOrNull(Anticipate)
           )|| (!$A.util.isEmpty(Premise) || !$A.util.isEmpty(Objective)  || 
                !$A.util.isEmpty(Purpose) || !$A.util.isEmpty(Strategy) ||
                !$A.util.isEmpty(Anticipate))){
            //alert('in If');
            var action = component.get("c.saveCallPlanSchFields");
            
            action.setParams({ "EventId":evid,
                              "Premise":Premise,
                              "Objective":Objective,
                              "Purpose":Purpose,
                              "Strategy":Strategy,
                              "Anticipate":Anticipate});
            action.setCallback(this, function(response) {
                var state = response.getState();
                //alert(state);
                if (state === "SUCCESS") {
                    var statusvalues = response.getReturnValue();
                   // alert(JSON.stringify(statusvalues));
                    component.set("v.CallPlanDetails",statusvalues.eventRec);
                    component.set("v.IsLoading",false);
                    component.set("v.ErrorOccured",false);
                    if(statusvalues.ErrorMessage==''){
                       if(((!$A.util.isUndefinedOrNull(Premise) && !$A.util.isUndefinedOrNull(Objective)  && !$A.util.isUndefinedOrNull(Purpose) && 
                        !$A.util.isUndefinedOrNull(Strategy) && !$A.util.isUndefinedOrNull(Anticipate))&& (!$A.util.isEmpty(Premise) && 
                        !$A.util.isEmpty(Objective)  && !$A.util.isEmpty(Purpose) && !$A.util.isEmpty(Strategy) && !$A.util.isEmpty(Anticipate)) 
                        && callPlanType!='Call Plan Challenger')|| ((!$A.util.isUndefinedOrNull(Premise) && !$A.util.isUndefinedOrNull(Objective)  
                        &&  !$A.util.isUndefinedOrNull(Strategy) && !$A.util.isUndefinedOrNull(Anticipate))&& (!$A.util.isEmpty(Premise) && 
                        !$A.util.isEmpty(Objective) && !$A.util.isEmpty(Strategy) && !$A.util.isEmpty(Anticipate)) && callPlanType=='Call Plan Challenger')){ 
                        
                        $A.util.removeClass(Scheduled, 'slds-path__item slds-is-current slds-is-active');
                        $A.util.addClass(Scheduled, 'slds-path__item slds-is-complete');
                        $A.util.addClass(Planned, 'slds-path__item slds-is-current slds-is-active');
                        component.set("v.ScheduledClick",false);
                        component.set("v.PlannedClick",true);
                           $A.get('e.force:refreshView').fire();
                    }else{
                        $A.util.removeClass(Scheduled, 'slds-path__item slds-is-complete');
                        $A.util.addClass(Scheduled, 'slds-path__item slds-is-current slds-is-active'); 
                        component.set("v.ScheduledClick",true);
                        $A.get('e.force:refreshView').fire();
                    } 
                    }else if(statusvalues.ErrorMessage!=''){
                    component.set("v.IsLoading",false);
                    var toastEvent = $A.get("e.force:showToast");
					if(callPlanType!='Call Plan Challenger'){
                    toastEvent.setParams({
                        title : 'Error Message',
                        message:'All POPSA Information must be filled for Current Status',
                        duration:'5000',
                        type: 'error',
                        mode: 'dismissible'
                    });
					}
					if(callPlanType=='Call Plan Challenger'){
                    toastEvent.setParams({
                        title : 'Error Message',
                        message:'All OPSA Information must be filled for Current Status' ,
                        duration:' 5000',
                        type: 'error',
                        mode: 'dismissible'
                    });
					}
                    toastEvent.fire();
                        
                    }
                    
                    
                }else if (state === "INCOMPLETE") {
                    component.set("v.IsLoading",false);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error Message',
                        message: 'Error occurred while saving. Please Save the details again.',
                        duration:' 5000',
                        type: 'error',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();
                }else if (state === "ERROR") {
                    component.set("v.IsLoading",false);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title : 'Error Message',
                        message: 'Error occurred while saving. Please Save the details again. If the problem persists, please reach out to Support team.',
                        duration:' 5000',
                        type: 'error',
                        mode: 'dismissible'
                    });
                    toastEvent.fire();
                }
                 component.set("v.EditClickedPlanned",false);
            component.set("v.EditClickedMinutes",false);
            component.set("v.EditClicked",false);
                component.set("v.ShowOutputText",true);
            component.set("v.ShowOutputTextPlanned",true);
            component.set("v.ShowOutputTextMinutes",true);
                component.set("v.EnableSaveCancel",false);
            component.set("v.EnableSaveCancelPlanned",false);
            component.set("v.EnableSaveCancelMinutes",false);
                
            }),
                
                
                $A.enqueueAction(action);
        } 
    },
    PlannedSave : function(component, event, helper) {
        var evid=component.get("v.EventId");
        //alert(evid);
        var Agenda=component.find("Agenda").get("v.value");
        var MinutesAction=component.find("MinutesAction").get("v.value");
        var Planned=component.find("PlannedId"); 
        var MinutesRecorded=component.find("MinutesRecordedId"); 
        component.set("v.IsLoading",true);
        if($A.util.isUndefinedOrNull(Agenda) || $A.util.isEmpty(Agenda)){
            component.set("v.ErrorOccured",true);
            component.set("v.IsLoading",false);
            Agenda='';
        }else{
            Agenda=component.find("Agenda").get("v.value");
        }
        if($A.util.isUndefinedOrNull(MinutesAction) || $A.util.isEmpty(MinutesAction)){
            component.set("v.ErrorOccured",true);  
            component.set("v.IsLoading",false);
            MinutesAction='';
        }else{
            MinutesAction=component.find("MinutesAction").get("v.value");
        }
        
        //alert(Agenda);
        // alert(MinutesAction);
        
        //alert('in If');
        var action = component.get("c.saveCallPlanPlannedFields");
        component.set("v.IsLoading",true);
        action.setParams({ "EventId":evid,
                          "Agenda":Agenda,
                          "MinutesAction":MinutesAction
                         });
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert(state);
            if (state === "SUCCESS") {
                
                var statusvalues = response.getReturnValue();
                //alert(JSON.stringify(statusvalues));
                component.set("v.CallPlanDetails",statusvalues.eventRec);
                component.set("v.IsLoading",false);
                component.set("v.ErrorOccured",false);
                if(statusvalues.ErrorMessage==''){
                    if(MinutesAction==''){
                    $A.util.removeClass(MinutesRecorded, 'slds-path__item slds-is-current slds-is-active');
                    $A.util.removeClass(Planned, 'slds-path__item slds-is-complete');
                    $A.util.addClass(Planned, 'slds-path__item slds-is-current slds-is-active');
                    component.set("v.PlannedClick",true);
                    $A.get('e.force:refreshView').fire();
                    
                }else if(MinutesAction!=''){
                    //alert('both not blank');
                    $A.util.removeClass(Planned, 'slds-path__item slds-is-current slds-is-active');
                    $A.util.addClass(Planned, 'slds-path__item slds-is-complete');
                    $A.util.addClass(MinutesRecorded, 'slds-path__item slds-is-current slds-is-active');
                    component.set("v.PlannedClick",false);
                    component.set("v.MinutesClicked",true);
                    $A.get('e.force:refreshView').fire();
                    
                    
                }
                }else if(statusvalues.ErrorMessage!=''){
                     component.set("v.IsLoading",false);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title:'Error Message',
                        message:'Error occurred while saving. Please Save the details again. If the problem persists, please reach out to Support team.',
                        duration:'5000',
                        type:'error',
                        mode:'dismissible'
                    });
                    toastEvent.fire();
                }
                
                
            }else if (state === "INCOMPLETE") {
                component.set("v.IsLoading",false);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title:'Error Message',
                        message:'Error occurred while saving. Please Save the details again.',
                        duration:'5000',
                        type:'error',
                        mode:'dismissible'
                    });
                    toastEvent.fire();
                }else if (state === "ERROR") {
                    component.set("v.IsLoading",false);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title:'Error Message',
                        message:'Error occurred while saving. Please Save the details again. If the problem persists, please reach out to Support team.  ',
                        duration:'5000',
                        type:'error',
                        mode:'dismissible'
                    });
                    toastEvent.fire();
                }
            component.set("v.EditClickedPlanned",false);
            component.set("v.EditClickedMinutes",false);
            component.set("v.EditClicked",false);
            component.set("v.ShowOutputText",true);
            component.set("v.ShowOutputTextPlanned",true);
            component.set("v.ShowOutputTextMinutes",true);
            component.set("v.EnableSaveCancel",false);
            component.set("v.EnableSaveCancelPlanned",false);
            component.set("v.EnableSaveCancelMinutes",false);
            component.set("v.ShowOutputTextMinutes",true);
            
            
        }),
            
            
            $A.enqueueAction(action);
        
    },
    MinutesSaved : function(component, event, helper) {
        var evid= component.get("v.EventId");
        //alert(evid);
        var MinutesAction=component.find("MinutesAction2").get("v.value");
        var Planned=component.find("PlannedId"); 
        var MinutesRecorded=component.find("MinutesRecordedId"); 
        component.set("v.IsLoading",true);
        if($A.util.isUndefinedOrNull(MinutesAction) || $A.util.isEmpty(MinutesAction)){
            component.set("v.IsLoading",false);
            MinutesAction='';
            component.find("MinutesAction2").get("v.value");
        }else{
            MinutesAction= component.find("MinutesAction2").get("v.value");
        }
        //alert(MinutesAction);
        var action = component.get("c.saveCallPlanMinutesFields");
        component.set("v.IsLoading",true);
        action.setParams({ "EventId" : evid,
                          "MinutesAction":MinutesAction
                         });
        action.setCallback(this, function(response) {
            var state = response.getState();
            //alert(state);
            if (state==="SUCCESS") {
                
                var statusvalues=response.getReturnValue();
                //alert(JSON.stringify(statusvalues));
                component.set("v.CallPlanDetails",statusvalues.eventRec);
                component.set("v.IsLoading",false);
                $A.util.addClass(MinutesRecorded, 'slds-path__item slds-is-current slds-is-active');
                if(statusvalues.ErrorMessage==''){
                    if(MinutesAction==''){
                    $A.util.removeClass(MinutesRecorded, 'slds-path__item slds-is-current slds-is-active');
                    $A.util.removeClass(Planned, 'slds-path__item slds-is-complete');
                    $A.util.addClass(Planned, 'slds-path__item slds-is-current slds-is-active');
                    component.set("v.PlannedClick",true);
                    component.set("v.MinutesClicked",false);
                    $A.get('e.force:refreshView').fire();
                }
                }else if(statusvalues.ErrorMessage!=''){
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        title:'Error Message',
                        message:'Error occurred while saving. Please Save the details again. If the problem persists, please reach out to Support team.',
                        duration:'5000',
                        type:'error',
                        mode:'dismissible'
                    });
                    toastEvent.fire();
                }
                
            }else if (state==="INCOMPLETE") {
                component.set("v.IsLoading",false);
                    var toastEvent=$A.get("e.force:showToast");
                    toastEvent.setParams({
                        title:'Error Message',
                        message:'Error occurred while saving. Please Save the details again.',
                        duration:'5000',
                        type:'error',
                        mode:'dismissible'
                    });
                    toastEvent.fire();
                }else if (state==="ERROR") {
                    component.set("v.IsLoading",false);
                    var toastEvent=$A.get("e.force:showToast");
                    toastEvent.setParams({
                        title:'Error Message',
                        message:'Error occurred while saving. Please Save the details again. If the problem persists, please reach out to Support team.',
                        duration:'5000',
                        type:'error',
                        mode:'dismissible'
                    });
                    toastEvent.fire();
                }
             component.set("v.EditClickedPlanned",false);
            component.set("v.EditClickedMinutes",false);
            component.set("v.EditClicked",false);
            component.set("v.ShowOutputText",true);
            component.set("v.ShowOutputTextPlanned",true);
            component.set("v.ShowOutputTextMinutes",true);
            component.set("v.EnableSaveCancel",false);
            component.set("v.EnableSaveCancelPlanned",false);
            component.set("v.EnableSaveCancelMinutes",false);
        }),
            
            
            $A.enqueueAction(action);
        
    }
    
})