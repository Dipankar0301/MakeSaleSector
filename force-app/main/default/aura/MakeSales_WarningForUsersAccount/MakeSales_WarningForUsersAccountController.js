({
    init : function(component, event, helper) {
        console.log('init');
        console.log(component.get("v.recordId"));
        var userID1 = $A.get("$SObjectType.CurrentUser.Id");
        component.set("v.userID1", userID1);
        console.log('USERID');
        console.log(component.get("v.userID1"));
        var action1 = component.get("c.checkUserRecordAccount");
        action1.setParams({
            recId : component.get("v.recordId"),
            userID1: component.get("v.userID1")
        });
        action1.setCallback(this, function(response){
            if(response.getState()=="SUCCESS"){
                if(response.getReturnValue()== true){
                    
                    helper.WarningMessage();
                }
            }
            
            
        });
        $A.enqueueAction(action1);
        
        
    },
    refresh : function(component,event,helper){
        
        var action1 = component.get("c.checkUserRecord");
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
        
    }
})