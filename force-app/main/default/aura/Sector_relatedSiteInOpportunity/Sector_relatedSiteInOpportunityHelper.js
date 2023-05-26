({
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
        
        console.log('tempsortby');
        console.log(tempsortby);
        
        var cloneData = cmp.get("v.OpportunityList").slice(0);
        cloneData.sort((this.sortBy(tempsortby, sortDirection === 'asc' ? 1 : -1)));
        
        cmp.set('v.OpportunityList', cloneData);
        cmp.set('v.sortDirection', sortDirection);
        cmp.set('v.sortedBy', sortedBy);
    },
    viewRecord : function(component, event) {
        var row = event.getParam('row');
        var recordId = row.Id;
        var viewRec=$A.get("event.force:navigateToSObject");
        viewRec.setParams({
            "recordId": recordId,
            "slideDevName": "detail"
        });
        viewRec.fire();
    },
    
    editRecord : function(component, event) {
        var row = event.getParam('row');
        var recordId = row.Id;
        $A.get("e.force:editRecord").setParams({"recordId": recordId}).fire();
    },  
    
    deleteRecord : function(component, event) {
        component.set("v.isLoading", true);
        var accountRec = event.getParam('row');        
        var action = component.get("c.delAccount");
        action.setParams({
            "accountRec": accountRec
        });
        action.setCallback(this, function(response) {
            component.set("v.isLoading", false);            
            if (response.getState() === "SUCCESS" ) {
                var rows = component.get('v.results');
                var rowIndex = rows.indexOf(accountRec);
                rows.splice(rowIndex, 1);
                component.set('v.results', rows);
                this.showToast("Success!","success","The record has been delete successfully.");
            }
            else{
                this.showToast("ERROR","error",JSON.stringify(response.getError())); 
            }
        });
        $A.enqueueAction(action);
    },
    
    
})