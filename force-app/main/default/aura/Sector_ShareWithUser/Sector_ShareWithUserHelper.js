({
	loaddatainitial : function(cmp, event, helper) {

        var spinner = cmp.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
        
        cmp.set('v.columns', [
            {label: 'Attendee Name', fieldName: 'AttendeeName', type: 'text', sortable: true},
            {label: 'Email', fieldName: 'AttendeeEmail', type: 'email', sortable: true}
        ]);
        
        var action = cmp.get("c.getallAttendees");
        action.setParams({
            recordId : cmp.get("v.recordId")
        });
        action.setCallback(this, function(response){
            if(response.getState() == "SUCCESS")
            {
                var responsedata = response.getReturnValue();
                if(responsedata.responseStatus == 'success')
                {
                    cmp.set("v.recordidincmp",null);
                    cmp.set("v.recordidincmp",responsedata.neweventrecordId);
                    cmp.set("v.AttendeeList",responsedata.Attendees);  
                }
                else
                {
                    $A.get("e.force:showToast").setParams({
                        "type": responsedata.responseStatus,
                        "message": responsedata.responseMessage,
                        "duration": 10000
                    }).fire();
                }
                
                
                var spinner = cmp.find("mySpinner");
                $A.util.addClass(spinner, "slds-hide");
            }
        });
        $A.enqueueAction(action);
        
	},
    shareeventwithattendee  : function(cmp, event, helper) {
        
        var spinner = cmp.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
        var attendeeslist = [];
        attendeeslist = cmp.find('attendeedatatable').getSelectedRows();
        
        var action = cmp.get("c.SendemailtoAttendee");
        action.setParams({
            recordId : cmp.get("v.recordidincmp"),
            viewvalue : cmp.get("v.viewvalue"),
            Attendeelist : JSON.stringify(attendeeslist ),
            subjectemail : cmp.get("v.subjectemail"),
            bodyemail : cmp.get("v.bodyemail")
        });
        action.setCallback(this, function(response){
            if(response.getState() == "SUCCESS")
            {
                var responsedata = response.getReturnValue();
                $A.get("e.force:showToast").setParams({
                    "type": responsedata.responseStatus,
                    "message": responsedata.responseMessage,
                    "duration": 10000
                }).fire();
                
                if(responsedata.responseStatus === 'success')
                    $A.get("e.force:closeQuickAction").fire();
                
                $A.get('e.force:refreshView').fire();
                
                
                var spinner = cmp.find("mySpinner");
                $A.util.addClass(spinner, "slds-hide");
                
            }
        });
        $A.enqueueAction(action);
	    
    },
    
    
    sortBy: function(field, reverse, primer) {
        var key = primer
        ? function(x) {
            return primer(x[field]);
        }
        : function(x) {
            return x[field];
        };
        
        return function(a, b) {
            a = key(a);
            b = key(b);
            if (a === undefined) 
                a = "";
            else if(typeof a === 'string')
                a = a.toLowerCase();
            
            if (b === undefined) 
                b = "";
            else if(typeof b === 'string')
                b = b.toLowerCase();
            
            return reverse * ((a > b) - (b > a));
        };
    },
    
    handleSort: function(cmp, event) {
        var sortedBy = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        var tempsortby = sortedBy;
        
        var columnsv = cmp.get("v.columns");
        for(var columneach in columnsv)
        {
            if(columnsv[columneach].fieldName === sortedBy && columnsv[columneach].type === 'url')
            {
                if(columnsv[columneach].typeAttributes != null
                   && columnsv[columneach].typeAttributes.label != null && 
                   columnsv[columneach].typeAttributes.label.fieldName != null)
                {
                    tempsortby = columnsv[columneach].typeAttributes.label.fieldName;
                    break;
                }
            }
        }
        
        var cloneData = cmp.get("v.AttendeeList").slice(0);
        cloneData.sort((this.sortBy(tempsortby, sortDirection === 'asc' ? 1 : -1)));
        
        cmp.set('v.AttendeeList', cloneData);
        cmp.set('v.sortDirection', sortDirection);
        cmp.set('v.sortedBy', sortedBy);
    },
    /*showError : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Error',
            message:'This is an error message',
            duration:' 5000',
            key: 'info_alt',
            type: 'error',
            mode: 'pester'
        });
        toastEvent.fire();
    },*/
    
    
})