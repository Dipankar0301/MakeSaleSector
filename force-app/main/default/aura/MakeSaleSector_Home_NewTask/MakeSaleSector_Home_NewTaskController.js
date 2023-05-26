({
    newtaskAction : function(component, event, helper) {
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Task"
        });
        createRecordEvent.fire();
    }
})