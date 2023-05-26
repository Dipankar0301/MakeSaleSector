({
    doInit : function( component, event, helper ) {
        var action1 = component.get("c.getPicklistValues");
        action1.setParams({
            recId : component.get("v.recordId")
        });
        action1.setCallback(this, function(response){
            if(response.getState()=="SUCCESS"){
                if(response.getReturnValue() != null){
                    console.log('line 10');
                    console.log(response.getReturnValue());
                    component.set("v.dependantPicklistMap", response.getReturnValue());
                    
                }
                
            }
        })
        $A.enqueueAction(action1); 
        
        
        var action2 = component.get("c.getPicklistValuesWakeUp");
        action2.setParams({
            recId : component.get("v.recordId")
        });
        action2.setCallback(this, function(response){
            if(response.getState()=="SUCCESS"){
                if(response.getReturnValue() != null){
                    console.log('line 26');
                    console.log(response.getReturnValue());
                    component.set("v.dependantWakeupMap", response.getReturnValue());
                    
                }
                
            }
        })
        $A.enqueueAction(action2);
        console.log('line 35');
        console.log(component.get("v.dependantWakeupMap"));
    },
    
    handleSelect : function(component, event, helper) {
        var stepName = event.getParam("detail").value;
        component.set("v.selectedStage", stepName);
        if(stepName == 'Suspect/Lead' || stepName == 'Prospect' || stepName == 'Sleeping' || stepName == 'Align' || stepName == 'Negotiate' 
           || stepName == 'Closed'
           || stepName == 'Prepare/Build'
           || stepName == 'Delivery'){
            
            if(stepName == 'Closed'|| stepName == 'Prepare/Build'
               || stepName == 'Delivery')
            {
                console.log('inside if');
                console.log(stepName);
                component.set("v.isTrueFalse", true);
                component.set("v.isButtonActive",false);
            }
            else{
                console.log('inside else');
                console.log(stepName);
                component.set("v.isTrueFalse", false);
                component.set("v.isButtonActive",true);
                component.set("v.isCheckboxTrue",'false');
                
                //to show the wake up field in sleeping stage
                
                
                
                
                
            }
            //component.set("v.buttonHeader", true);
            var action1 = component.get("c.checkRecordLock");
            action1.setParams({
                recId : component.get("v.recordId")
            });
            action1.setCallback(this, function(response){
                if(response.getState()=="SUCCESS"){
                    if(response.getReturnValue()== true){
                        console.log('line 18');
                        var action = component.get("c.getPreviousStage");
                        action.setParams(  {
                            recId : component.get("v.recordId")
                        });
                        action.setCallback(this, function(response){
                            //debugger;
                            let returnedValue = response.getReturnValue();
                            //component.set("v.previousStage", 'abc');
                            console.log(response.getReturnValue());
                            console.log(response.getState());
                            if(response.getState() === "SUCCESS"){
                                
                                component.set("v.previousStage",returnedValue);
                                component.set("v.modalWindow",true);
                            }
                            console.log(component.get("v.previousStage"));
                        });
                        $A.enqueueAction(action);
                    }
                    else{
                        helper.toastMethod1();
                    }
                }
            });
            $A.enqueueAction(action1);
            
        }
        
        
        
    },
    submitDetails : function(component,event,helper){ 		
        var action = component.get("c.updateStageRecord");
        console.log('line 71');
        console.log(component.get("v.selectedStage"));
        var stageName = component.get("v.selectedStage");
        if(stageName != 'Sleeping')
            component.set("v.WakeUpValue",null);
        console.log(component.get("v.StatusReasonValue"));
        var stageApproved ='True';
        action.setParams({
            
            "recId": component.get("v.recordId"),             
            "stageSelected": component.get("v.selectedStage"),
            "statusReason": component.get("v.StatusReasonValue"),
            "Wakeupdate": component.get("v.WakeUpValue"),
            
        });
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if(state === 'SUCCESS') { 
                
                let returnedValue= response.getReturnValue();
                $A.get('e.force:refreshView').fire();      
                component.set("v.modalWindow",'false');
                helper.toastMethod();                
            }
            else
            {
                var errors = response.getError();
                var errormessage = '';
                console.log(errors[0]);
                if(errors && errors.length > 0 &&  errors[0] && errors[0].pageErrors && errors[0].pageErrors.length > 0 &&  errors[0].pageErrors[0].message)
                    errormessage = errors[0].pageErrors[0].message;
                
                
                if(errors && errors.length > 0 && errors[0].fieldErrors)
                {
                    for(var fielderror  in errors[0].fieldErrors)
                    {
                        let eachfielderror = errors[0].fieldErrors[fielderror];
                        if(eachfielderror && eachfielderror.length > 0)
                        {
                            for(var eachfielderr  in eachfielderror)
                            {
                                let eachfielderrrow = eachfielderror[eachfielderr];
                                if(eachfielderrrow && eachfielderrrow.message)
                                {
                                    errormessage = eachfielderrrow.message;
                                    break;
                                }
                            }
                        }
                        if(errormessage !== '')
                            break;
                    }
                }
                
                
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"error",
                    "title": "Error!",
                    "message": errormessage,
                    "duration" : 6000000
                });
                toastEvent.fire();
            }
            
            
        });
        
        $A.enqueueAction(action);
        $A.get('e.force:refreshView').fire();
        
    },
    closeModel : function(component,event,helper){       
        $A.get('e.force:refreshView').fire();      
        component.set("v.modalWindow",'false');
        component.set("v.hideUpdateButton",true);
        //Commented as I am not finding any issue to refresh. If issue comes then uncomment the refresh
        //window.location.reload();
    },
    refresh : function(component,event,helper){
        
        // alert('reload done');
        
    },
    onCheck : function(component,event,helper){
        
        var stageCheck = component.get("v.isCheckboxTrue");
        console.log('line 146');
        let button = component.find('disablebuttonid');
        console.log(button.get('v.disabled'));
        if(stageCheck == 'false'){
            component.set("v.isCheckboxTrue",'true');
        }
        
        else{
            component.set("v.isCheckboxTrue",'false');
        }
        
    },
    handleChange : function(component,event,helper){
        var stepName1 = event.getParam("value");
        console.log('line 233');
        console.log(stepName1);
        if(stepName1 != 'Sleeping'){
        var depmap = component.get("v.dependantPicklistMap");
        var deplist;
        for(var key in depmap){
            console.log(key);
            if(stepName1 == key){
                deplist = depmap[key];
            }
        }
        component.set("v.dependantPicklist", deplist);
        component.set("v.selectedStage", stepName1);
        var st = deplist[0];
        component.set("v.StatusReasonValue", deplist[0]);
        component.set("v.isCheckboxTrue", 'true');
        var stepName2 = ''; 
        }
        else{
            var stepName1 = 'Sleeping';
                    console.log(stepName1);
                    var depmap = component.get("v.dependantWakeupMap");
                    var deplist;
                    for(var key in depmap){
                        console.log(key);
                        console.log('line 71');
                        if(stepName1 == key){
                            deplist = depmap[key];
                        }
                    }
                    component.set("v.dependantWakeuplist", deplist);
                    component.set("v.selectedStage", stepName1);
                    var st = deplist[0];
                    component.set("v.WakeUpValue", deplist[0]);
            		component.set("v.isCheckboxTrue", 'false');
                    var stepName2 = '';
        }
    },
    handleChange1 : function(component,event,helper){
        var stepName1 = event.getSource().get('v.value');
        console.log('180');
        console.log(stepName1);
        component.set("v.StatusReasonValue", stepName1);
        
    },
    handleChange2 : function(component,event,helper){
        var stepName1 = event.getSource().get('v.value');
        console.log('190');
        console.log(stepName1);
        component.set("v.StatusReasonValue", stepName1);
        
    },
    handleChangeWakeUp : function(component,event,helper){
        var stepName1 = event.getSource().get('v.value');
        console.log('190');
        console.log(stepName1);
        component.set("v.WakeUpValue", stepName1);
        
    },
    handleClick : function(component,event,helper){
        component.set("v.isTrueFalse", true);
        var action = component.get("c.getPreviousStage");
        action.setParams(  {
            recId : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            let returnedValue = response.getReturnValue();
            console.log(response.getReturnValue());
            console.log(response.getState());
            if(response.getState() === "SUCCESS"){
                component.set("v.previousStage",returnedValue);
                //component.set("v.selectedStage",returnedValue);
                component.set("v.modalWindow",true);
            }
            console.log(component.get("v.selectedStage"));
        });
        $A.enqueueAction(action);
        
    }
    
    
})