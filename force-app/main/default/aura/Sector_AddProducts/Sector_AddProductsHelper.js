({
	getproductdetails : function(component, event, helper) 
    {
        component.set("v.ShowSpinner", true);
        var action = component.get("c.getOpportunityProductdata");
        action.setParams({
            "OppId" : component.get("v.recordId"),
            "ProductName": component.get("v.ProductNameSearch"),
            "ProductFamily": component.get("v.ProductFamilySearch")
        });
        action.setCallback(this, function(response){
            if(response.getState()=="SUCCESS")
            {
                var responsedata = response.getReturnValue();
                if(responsedata.responseStatus == 'success')
                {
                    component.set("v.ProductsList", responsedata.ProductsList);
                }
                else
                {
                    $A.get("e.force:showToast").setParams({
                        "type": responsedata.responseStatus,
                        "message": responsedata.responseMessage,
                        "duration": 10000
                    }).fire();
                }
                component.set("v.ShowSpinner", false);
            }
        });
        $A.enqueueAction(action);
	}
})