({
    doinit : function(component, event, helper) {
        console.log("In dynamic init");
        
        var initRec = [{'sobjectType' : 'Implementation_Comment__c','Date__c' : '','Comment__c' : '' }];
        component.set("v.records", initRec);
    },
    
    add : function(component, event, helper) {
        var addRec = {'sobjectType' : 'Implementation_Comment__c','Date__c' : '','Comment__c' : '' };
        var existingRecords = component.get("v.records");
        existingRecords.push(addRec);
        component.set("v.records", existingRecords);
    },
    
    remove : function(component, event, helper) {
        
        var indexPosition = event.target.name;
        var existingRecords = component.get("v.records");
        console.log("indexPosition",indexPosition);
        existingRecords.splice(indexPosition, 1);
        component.set("v.records", existingRecords);
        //splice(indexPosition, howmany, item1, ....., itemX)
    },
    
    save : function(component, event, helper) {
        
        var existingRecords = component.get("v.records");
        var validRecords = [];
        var Dates = [];
        var Comments = [];
        for(var i = 0; i < existingRecords.length; i++) {
            if(existingRecords[i].Date__c && existingRecords[i].Comment__c) {
                Dates.push(existingRecords[i].Date__c);
                Comments.push(existingRecords[i].Comment__c);
            }
            else{
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Message',
                    message: 'Fill all fields of action log',
                    duration:' 3000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                toastEvent.fire();
                return;
            }
        }
        component.set("v.records", Dates);
        component.set("v.rows", Dates.length);
        
        
        console.log("validRecords", JSON.stringify(validRecords));
        console.log("valid Records length", validRecords.length);
        
        var action = component.get("c.saveaccs");
        action.setParams({
            'dates' : Dates,
            'comments' : Comments,
            'recId' : component.get("v.recordId")
        });
     
        action.setCallback(this, function(response){
           var state = response.getState();
            if(state === 'SUCCESS' || state === 'DRAFT'){
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Message',
                    message: 'Records saved successfully',
                    duration:' 3000',
                    key: 'info_alt',
                    type: 'success',
                    mode: 'pester'
                });
                toastEvent.fire();
                component.set("v.visible", true);
                window.setTimeout(
                    $A.getCallback(function() {
                        component.set("v.visible", false);
                    }), 3000);
                
                $A.enqueueAction(component.get('c.doinit'));
            }
            else if(state === 'ERROR' || state === 'WARNING'){
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " +
                                 errors[0].message);
                    }
                }
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    title : 'Message',
                    message: 'No Records saved successfully',
                    duration:' 3000',
                    key: 'info_alt',
                    type: 'error',
                    mode: 'pester'
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
        
    }
    
})