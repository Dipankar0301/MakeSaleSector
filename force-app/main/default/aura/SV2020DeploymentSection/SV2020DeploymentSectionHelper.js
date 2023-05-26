({
    toast: function(msg, state) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Message',
            message: msg,
            duration:' 3000',
            key: 'info_alt',
            type: state,
            mode: 'pester'
        });
        toastEvent.fire();
    },
    modifyDraftValues: function(draftValues){
        var list = [];
        draftValues.forEach(function(value){
            list.push(value);
        });
        return list;
    },
    fetchFCFs : function(component, event, helper) {
        var action = component.get("c.listOfFreeCashFlows");
        action.setParams({
            OpportunityId : component.get("v.recordId") 
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            var fcfList = [];
            
            if(state == 'SUCCESS'){
                var rtnVal = response.getReturnValue();              
                for(var i in rtnVal){
                    fcfList.push(rtnVal[i]);
                }
                //set the table values with data
                component.set("v.data",fcfList);
            }
        });
        $A.enqueueAction(action);
    },
    saveData : function(component, event, helper) {
        var draftValues = event.getParam('draftValues');
        var data = helper.modifyDraftValues(draftValues);
        
        var action = component.get("c.saveFCFs");
        action.setParams({
            fcfs : data
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state == 'SUCCESS'){
                //set draftValues as null to remove the Cancel and Save Button from the UI.
                component.set('v.draftValues',[]);
                
                //reload the table with updated data.                
                helper.fetchFCFs(component, event, helper);
                
                //Fire Success Toast Message
                helper.toast('Successfully Saved!','success');
            } 
            else {
                //set draftValues as null to remove the Cancel and Save Button from the UI.
                component.set('v.draftValues',[]);
                
                //Fire Success Toast Message
                helper.toast('Some Error Occured','error');
            }
        });
        $A.enqueueAction(action);        
    }
})