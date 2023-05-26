({
 doInit : function(component, event, helper) {
        var caseId = component.get("v.recordId");
        var action = component.get("c.changeOwnerMethod");
        action.setParams({
            caseId : caseId
        });
        action.setCallback(this, function(response) {
            if(response.getState() === "SUCCESS") {
                console.log("Case Owner Changed To Current login User");
             var rec = response.getReturnValue();
             console.log(rec.OwnerId);
            }
        });
        $A.enqueueAction(action);
        $A.get('e.force:refreshView').fire();
 }
})