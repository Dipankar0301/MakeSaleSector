({
    getOpplist : function(component, event, helper)
    {
        component.set("v.showdatatable", false);
        var spinner = component.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
        
        var actionp = component.get("c.getoppproducts");
        actionp.setParams({
            OppId : component.get("v.recordId"),
            listoffields: 'Name'
            
        });
        actionp.setCallback(this, function(responsep){
            if(responsep.getState()=="SUCCESS")
            {
                var responsedatap = responsep.getReturnValue();
                if(responsedatap.responseStatus == 'success')
                {
                    component.set("v.ShowAnnuals", responsedatap.Opp.MakeSaleSector_Accept_Annual_values__c);
                    var totalsfields = responsedatap.Opp.MakeSaleSector_Accept_Annual_values__c === true ?  $A.get("$Label.c.Sector_AnnualsFields") : $A.get("$Label.c.Sector_TotalsFields");
                    var arraylist = totalsfields.split(",");
                    var columns = [];
                    var fieldlist = '';
                    for(var indexeach = 0; indexeach < arraylist.length;  indexeach = indexeach+4)
                    {
                        fieldlist += ((fieldlist === '') ? arraylist[indexeach] : ','+arraylist[indexeach]);
                        columns.push({ label: arraylist[indexeach+2], fieldName: arraylist[indexeach+1], type: arraylist[indexeach+3],initialWidth: 150, sortable: true });
                    }
                    
                    columns.push({ type: 'action', typeAttributes: { rowActions: [ { label: 'Delete', name: 'delete' } ] } });
                    
                    component.set("v.columns", columns);

                    var action = component.get("c.getoppproducts");
                    action.setParams({
                        OppId : component.get("v.recordId"),
                        listoffields: fieldlist
                        
                    });
                    action.setCallback(this, function(response){
                        if(response.getState()=="SUCCESS")
                        {
                            var responsedata = response.getReturnValue();
                            if(responsedata.responseStatus == 'success')
                            {
                                
                                var oppproductdatatemp = responsedata.OppLine;
                                for ( var i = 0; i < oppproductdatatemp.length; i++ ) 
                                {
                                    oppproductdatatemp[i].Product2Name = oppproductdatatemp[i].Product2.Name;
                                    oppproductdatatemp[i].Product2Family = oppproductdatatemp[i].Product2.Family;
                                    oppproductdatatemp[i].QuantityUnit = oppproductdatatemp[i].Product2.QuantityUnitOfMeasure;
                                }
                                component.set("v.data", oppproductdatatemp);
                                
                                if(oppproductdatatemp != null && oppproductdatatemp.length > 0)
                                    component.set("v.showdatatable", true);
                                
                            }
                            else
                            {
                                $A.get("e.force:showToast").setParams({
                                    "type": responsedata.responseStatus,
                                    "message": responsedata.responseMessage,
                                    "duration": 10000
                                }).fire();
                            }
                            var spinner = component.find("mySpinner");
                            $A.util.addClass(spinner, "slds-hide");
                        }
                    });
                    $A.enqueueAction(action);
                }
                else
                {
                    $A.get("e.force:showToast").setParams({
                        "type": responsedatap.responseStatus,
                        "message": responsedatap.responseMessage,
                        "duration": 10000
                    }).fire();
                    var spinner = component.find("mySpinner");
                    $A.util.addClass(spinner, "slds-hide");
                }
            }
        });
        $A.enqueueAction(actionp);
      
    },
    
    
    deleteoppproductrow : function(component, event, helper)
    {
        var spinner = component.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
        
        var action = component.get("c.deleteOppProduct");
        action.setParams({
            OppId : component.get("v.recordId"),
            OppproductId: component.get("v.deleterecordId")
            
        });
        action.setCallback(this, function(response){
            if(response.getState()=="SUCCESS")
            {
                var responsedata = response.getReturnValue();
                $A.get("e.force:showToast").setParams({
                    "type": responsedata.responseStatus,
                    "message": responsedata.responseMessage,
                    "duration": 10000
                }).fire();
                if(responsedata.responseStatus == 'success')
                {
                    
                    $A.get('e.force:refreshView').fire();
                }
                
                component.set("v.deleterecordId", null);
                component.set("v.showmodaldelete", false);
                
                var spinner = component.find("mySpinner");
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
        
        var cloneData = cmp.get("v.data").slice(0);
        cloneData.sort((this.sortBy(tempsortby, sortDirection === 'asc' ? 1 : -1)));
        
        cmp.set('v.data', cloneData);
        cmp.set('v.sortDirection', sortDirection);
        cmp.set('v.sortedBy', sortedBy);
    }
})