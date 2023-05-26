({
	init : function(component, event, helper) {
        console.log('init');
        console.log(component.get("v.recordId"));
        var userID1 = $A.get("$SObjectType.CurrentUser.Id");
        component.set("v.userID1", userID1);
        console.log('USERID');
        console.log(component.get("v.userID1"));
         var action1 = component.get("c.checkOpportunityRecord");
        action1.setParams({
            recId : component.get("v.recordId")
        });
        action1.setCallback(this, function(response){
            if(response.getState()=="SUCCESS"){
                if(response.getReturnValue()== true){
                    
                    helper.WarningMessage();
                }
            }
            
            
        });
        $A.enqueueAction(action1);
        
       /* var componentEvent =component.getEvent("appEvent");
        var msgString =component.get("v.messageString");
        componentEvent.setParams({
            "label" : "Custom Label",
            "message" : msgString
        });
        
        componentEvent.fire(); */
		//helper.WarningMessage();        
    },
})