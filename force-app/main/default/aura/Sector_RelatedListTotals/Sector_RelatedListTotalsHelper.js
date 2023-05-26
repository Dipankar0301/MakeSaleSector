({
    getOpplist : function(component, event, helper)
    {
         var spinner = component.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
        
        var totalsfields = $A.get("$Label.c.Sector_TotalsFields");
        var arraylist = totalsfields.split(",");
        var columns = [];
        var fieldlist = '';
        for(var indexeach = 0; indexeach < arraylist.length;  indexeach = indexeach+4)
        {
            fieldlist += ((fieldlist === '') ? arraylist[indexeach] : ','+arraylist[indexeach]);
            columns.push({ label: arraylist[indexeach+2], fieldName: arraylist[indexeach+1], type: arraylist[indexeach+3],initialWidth: 150 });
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
                    console.log('refresh data fetch===');
                    var oppproductdatatemp = responsedata.OppLine;
                    for ( var i = 0; i < oppproductdatatemp.length; i++ ) 
                    {
                        oppproductdatatemp[i].Product2Name = oppproductdatatemp[i].Product2.Name;
                        oppproductdatatemp[i].Product2Family = oppproductdatatemp[i].Product2.Family;
                        oppproductdatatemp[i].QuantityUnit = oppproductdatatemp[i].Product2.QuantityUnitOfMeasure;
                    }
                    component.set("v.data", oppproductdatatemp);
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
                 component.set("v.showmodaldelete", false);
                 var spinner = component.find("mySpinner");
                $A.util.addClass(spinner, "slds-hide");
            }
        });
        $A.enqueueAction(action);            
    }
})