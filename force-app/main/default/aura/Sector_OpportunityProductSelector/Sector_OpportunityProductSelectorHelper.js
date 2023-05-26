({
    getproductdetails : function(component, event, helper)
    {
        var spinner = component.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
        // Starting...... Fetch the product details from controller 
        var action = component.get("c.getOpportunityProductdata");
        action.setParams({
            OppId : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            if(response.getState()=="SUCCESS")
            {
                var responsedata = response.getReturnValue();
                if(responsedata.responseStatus == 'success')
                {
                    
                    var prodetails = responsedata.ProductsList; 
                    if(prodetails == null || prodetails.length == 0)
                        component.set("v.ShowProducts", false);
                    else
                        component.set("v.ShowProducts", true);
                    
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
})