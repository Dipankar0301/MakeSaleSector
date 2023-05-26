({
    handleSelect : function (component, event, helper) {
        var selectStatus = event.getParam("detail").value;
        console.log(selectStatus);
        component.set("v.onclickStatus", selectStatus);
        helper.StatusPath(component, event, helper);
        
    },
    init: function(component, event, helper) {
        console.log("init");
        var action = component.get("c.getCallPlanRecordId");
            action.setParams({
                recId : component.get("v.recordId")
            });
            action.setCallback(this, function(response){
                if(response.getState()=="SUCCESS"){
                    console.log(response.getReturnValue());
                    component.set("v.callPlanID", response.getReturnValue());
                                            
                }
            });
            $A.enqueueAction(action);
        
        var action1 = component.get("c.getEventStatus");
            action1.setParams({
                recId : component.get("v.recordId")
            });
            action1.setCallback(this, function(response){
                if(response.getState()=="SUCCESS"){
                    console.log('hello' + response.getReturnValue());
                    component.set("v.onclickStatus", response.getReturnValue());
                                            
                }
            });
            $A.enqueueAction(action1);
        
         
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
                     
                         }                           
                }
            });
            $A.enqueueAction(action);
    }
})