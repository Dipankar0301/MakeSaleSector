({
    getproductdetails : function(component, event, helper)
    {
        var spinner = component.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
        // Starting...... Set the Years in Add year component 
        var listofyears = [];
        for(var k = 2020; k < 2020+101; k++)
        {
            listofyears[listofyears.length] = k;
        }
        component.set("v.yearsinselect",listofyears); 
        // Ending...... Set the Years in Add year component
        
        
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
                    
                    component.set("v.ProductDetails", prodetails);
                    
                    helper.Sortyears(component, event, helper);

                    if(prodetails != null && prodetails.length > 0 && prodetails[0].ProductDetails != null && prodetails[0].ProductDetails.length > 0)
                    {
                        component.set("v.newYear", (prodetails[0].ProductDetails[prodetails[0].ProductDetails.length - 1].YearOfProduct) + 1); 
                        component.set("v.ShowQuickFillButton",true); 
                    }
                    else
                    {
                        const d = new Date();
                        component.set("v.newYear",d.getFullYear()); 
                        component.set("v.ShowQuickFillButton",false); 
                    }
                    
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
        
        // Ending...... Fetch the product details from controller 
    },
    Saveproductdetails : function(component, event, helper)
    {
        var spinner = component.find("mySpinner");
        $A.util.removeClass(spinner, "slds-hide");
        
        var action = component.get("c.SaveOpportunityProductdata");
        action.setParams({
            ProductDetails : JSON.stringify(component.get("v.ProductDetails")),
            OppId : component.get("v.recordId")
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
                
                var spinner = component.find("mySpinner");
                $A.util.addClass(spinner, "slds-hide");
                
                $A.get('e.force:refreshView').fire();
            }
        });
        $A.enqueueAction(action);
    },
    
    Sortyears : function(component, event, helper)
    {
        var prodetails = component.get("v.ProductDetails");
        if(prodetails != null && prodetails.length > 0)
        {
            for(var eachproductdetails of prodetails)
            {
                if(eachproductdetails != null && eachproductdetails.ProductDetails != null && eachproductdetails.ProductDetails.length > 0 )
                {
                    eachproductdetails.ProductDetails.sort( function( a , b){
                        if(a.YearOfProduct > b.YearOfProduct) return 1;
                        if(a.YearOfProduct < b.YearOfProduct) return -1;
                        return 0;
                    });
                }
            }
        }
    }
})