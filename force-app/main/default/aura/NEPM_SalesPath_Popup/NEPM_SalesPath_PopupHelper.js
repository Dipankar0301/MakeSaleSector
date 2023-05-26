({
	toastMethod : function() {
        var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":"success",
                        "title": "Success!",
                        "message": "Stage Changed Successfully"
                    });
                    toastEvent.fire();
		
	},
    
    toastMethod2 : function() {
        var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":"error",
                        "title": "Error!",
                        "message": "Project was under PCI Approval Process Cannot update the Stage"
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
        
    }
})