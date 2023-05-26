({
    handleSelect : function (component, event, helper) {
        var selectStatus = event.getParam("detail").value;
        console.log(selectStatus);
        component.set("v.onclickStatus", selectStatus);
        helper.StatusPath(component, event, helper);
        
    },
    init: function(component, event, helper) {
        console.log("init");
        var action = component.get("c.getCallPlanDetails");
            action.setParams({
                eventId : component.get("v.recordId")
            });
            action.setCallback(this, function(response){
                if(response.getState() == "SUCCESS")
                {
                    var responsedata = response.getReturnValue();
                    if(responsedata.responseStatus == 'success')
                    {
                        component.set("v.callPlanID", responsedata.CallPlanId);
                        component.set("v.onclickStatus", responsedata.EventDetails.Status_Event__c);
                        component.set("v.CallPlanType", responsedata.EventDetails.Call_Plan_Record_Type__c);
                        if(responsedata.iseventowner)
                            component.set("v.editstatus", 'view');
                        else
                            component.set("v.editstatus", 'readonly');
                    }
                    else
                    {
                        $A.get("e.force:showToast").setParams({
                            "type": responsedata.responseStatus,
                            "message": responsedata.responseMessage,
                            "duration":' 60000'
                        }).fire();
                    }                      
                }
            });
            $A.enqueueAction(action);
        
     /*   var action1 = component.get("c.getEventStatus");
            action1.setParams({
                recId : component.get("v.recordId")
            });
            action1.setCallback(this, function(response){
                if(response.getState()=="SUCCESS"){
                    console.log('hello' + response.getReturnValue());
                    component.set("v.onclickStatus", response.getReturnValue());
                                            
                }
            });
            $A.enqueueAction(action1);  */
        
         
    },
    inlineEditStatus: function(component, event, helper){
        var editValue = event.getParam("detail").value;
        component.set("v.StatusEditMode", 'true');
	},
    onclick1: function(component, event, helper){
        if(component.get("v.onclickFirstTime"))
        {
            component.set("v.onclickFirstTime", false);
            helper.StatusPath(component, event, helper);
            component.set("v.showCard", true);
            
            var cmpTarget = component.find('PathSection');
            $A.util.addClass(cmpTarget, 'slds-is-open');
            $A.util.removeClass(cmpTarget, 'slds-is-close');
        }
        
    },
    toggleSection: function(component, event, helper){
        var cmpTarget = component.find('PathSection');
        if(component.get("v.onclickFirstTime"))
        {
            component.set("v.onclickFirstTime", false);
            helper.StatusPath(component, event, helper);
            component.set("v.showCard", true);
            $A.util.addClass(cmpTarget, 'slds-is-open');
            $A.util.removeClass(cmpTarget, 'slds-is-close');
        }
        else
        {
            if(component.get("v.showCard") == true)
            {
                $A.util.addClass(cmpTarget, 'slds-is-close');
                $A.util.removeClass(cmpTarget, 'slds-is-open');
                component.set("v.showCard", false);
            }
            else
            {
                $A.util.addClass(cmpTarget, 'slds-is-open');
                $A.util.removeClass(cmpTarget, 'slds-is-close');
                component.set("v.showCard", true);  
            }
        }
        
    },
    Onload : function(component, event, helper){
       
        
    },
    onSuccess : function(component, event, helper) {
                var action = component.get("c.getEventStatus");
            action.setParams({
                recId : component.get("v.recordId")
            });
            action.setCallback(this, function(response){
                if(response.getState()=="SUCCESS"){
                    console.log(response.getReturnValue());
                    component.set("v.showFields", response.getReturnValue());
                           
        	$A.get('e.force:refreshView').fire();                         
                }
            });
            $A.enqueueAction(action);
        
    },
    cancelInit : function(component, event, helper) {
        var action = component.get("c.getEventStatus");
            action.setParams({
                recId : component.get("v.recordId")
            });
            action.setCallback(this, function(response){
                if(response.getState()=="SUCCESS"){
                    console.log(response.getReturnValue());
                    if(response.getReturnValue() === "Cancelled"){
                    component.set("v.showFields", response.getReturnValue());
                        component.set("v.onclickStatus", response.getReturnValue());
                     
                         }                           
                }
            });
            $A.enqueueAction(action);
    }
})