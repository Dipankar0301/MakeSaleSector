({
    openDialog : function(component, event, helper) {
        var selected = event.getSource().get("v.value");
         component.set("v.ShowDialog",true);
    },
    ok : function(component, event, helper) {
        component.set("v.ShowDialog",false);
    },
    handleSuccess : function(component,event,helper){
        
        var urlEvent = $A.get("e.force:navigateToSObject");
        var recID = component.get("v.recordId");
        urlEvent.setParams({
            "recordId": recID
        });
        urlEvent.fire();   
    },
    returntodetail : function(component,event,helper){
        var urlEvent = $A.get("e.force:navigateToSObject");
        var recID = component.get("v.recordId");
        event.preventDefault();
        urlEvent.setParams({
             "recordId": recID 
             //"slideDevName": "related"
        });
        urlEvent.fire();      
    }
})