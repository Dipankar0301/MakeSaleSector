({
	toastMethod : function() {
        var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":"success",
                        "title": "Success!",
                        "message": "Stage Changed Successfully"
                    });
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire(); 
		
	},
    
    toastMethod2 : function() {
        var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":"error",
                        "title": "Error!",
                        "message": "The BOM field has to be filled before progressing to next stage"
                    });
                    toastEvent.fire();
		
	},
    
    toastMethod3 : function() {
        var toastEvent = $A.get("e.force:showToast");
                   toastEvent.setParams({
                        "type":"error",
                        "title": "Error!",
                        "message": "To move the stage please fill the mandatory fields "+"' All Targets Dates into Stages',"+" and 'Decision Executive Fields'" 
                    });
                    toastEvent.fire();
    },
    toastMethod4 : function() {
        var toastEvent = $A.get("e.force:showToast");
                   toastEvent.setParams({
                        "type":"error",
                        "title": "Error!",
                        "message": "To move the stage please fill the mandatory Fields "+"' ALL Target Date into Stages'"
                    });
                    toastEvent.fire();
    },
    
    updateStage : function(component,event,helper,stepName){
        var action = component.get("c.validateApporvals");
        let recordId = component.get("v.recordId");
        action.setParams({
            
            "recId": recordId, 
            
            "stageSelected": stepName
            
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            let returnedValue;
            if(state === 'SUCCESS') { 
                
                returnedValue= response.getReturnValue();
                if(returnedValue === 'showApprovalPopup'){
                	component.set("v.modalWindow",returnedValue);
                }
                else if(returnedValue === 'showStatusPopup'){
                    component.set("v.modalWindow",returnedValue);
                }
                else{
                    component.callServer();
                }
            } 
            
        });
        
        
        $A.enqueueAction(action);
        $A.get('e.force:refreshView').fire(); 

        
    }
})