({
    handleSelect : function (component, event, helper) {
        var stepName = event.getParam("detail").value;        
        component.set("v.selectedStage",stepName);
        var toastEvent = $A.get("e.force:showToast");
        
        var recordId = component.get("v.recordId");
        
        if(stepName == 'Assess (post PCI)' || stepName == 'Define (post PCN)' 
                                           || stepName == 'Select' 
                                           || stepName == 'Identify'
                                           || stepName == 'Execute (post GIP)'
                                           || stepName == 'Operate') {
            var action = component.get("c.checkRecordLock");
            action.setParams({                
                "recId": recordId  
            });
            action.setCallback(this, function(response) {
                
                var state = response.getState();
                if(state === 'SUCCESS') { 
                    
                    var returnedValue= response.getReturnValue();
                    console.log('returnedValue',returnedValue)
                    if(returnedValue == true){
                    helper.toastMethod2();
                        $A.get('e.force:refreshView').fire();
                    }
                    else{
                        helper.updateStage(component,event,helper,stepName);
                        
                    }
                    //component.set("v.modalWindow",'noPopup');
                } 
                
            });
            
            $A.enqueueAction(action);
        }
        else{
            
            helper.updateStage(component,event,helper,stepName);
        }
        
    },
    closeModel : function(component,event,helper){       
        $A.get('e.force:refreshView').fire();      
        component.set("v.modalWindow",'noPopup');
    },
    
    donotUpdateDeliverable : function(component,event,helper){
        
        var action = component.get("c.updateDeliverable");
        var approved = 'False';
        action.setParams({
            
            "recId": component.get("v.recordId"),             
            "stageSelected": component.get("v.selectedStage"),
            "approved": approved,
            
        });
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if(state === 'SUCCESS') { 
                
                let returnedValue= response.getReturnValue();
                
                helper.toastMethod();
                
                component.set("v.modalWindow",'noPopup');
            } 
            
        });
        
        $A.enqueueAction(action);
        $A.get('e.force:refreshView').fire();
        // component.set("v.modalWindow",false);
        //component.set("v.approved",false);
        //component.callServer();
    },
    
    saveChildRecord : function(component,event,helper){ 		
        var action = component.get("c.updateDeliverable");
        var approved = 'True';
        var stageApproved ='False';
        action.setParams({
            
            "recId": component.get("v.recordId"),             
            "stageSelected": component.get("v.selectedStage"),
            "approved": approved,
            "stageApproved":stageApproved,
            
        });
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if(state === 'SUCCESS') { 
                
                let returnedValue= response.getReturnValue();
                
                helper.toastMethod();
                
                component.set("v.modalWindow",'noPopup');
            } 
            
        });
        
        $A.enqueueAction(action);
        $A.get('e.force:refreshView').fire(); 
        
        
    },
    
    changeStatus : function(component,event,helper){ 		
        var action = component.get("c.updateDeliverable");
        var approved = 'True';
        var stageApproved ='True';
        action.setParams({
            
            "recId": component.get("v.recordId"),             
            "stageSelected": component.get("v.selectedStage"),
            "approved": approved,
            "stageApproved":stageApproved,
            
        });
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if(state === 'SUCCESS') { 
                
                let returnedValue= response.getReturnValue();
                
                helper.toastMethod();
                
                component.set("v.modalWindow",'noPopup');
            } 
            
            
        });
        
        $A.enqueueAction(action);
        $A.get('e.force:refreshView').fire(); 
        
        
    },    
    
    refresh : function(component,event,helper){
        
        // alert('reload done');
        
    }
    
    
})