({
    getEditProductDetails : function(component, event, helper) {
        //component.set("v.EditProductsListAPi",undefined); 
        component.set("v.ShowSpinner", true);
        var action = component.get("c.getEditProductdata");
        action.setParams({
            OppId : component.get("v.recordId")
        });
        action.setCallback(this, function(response){
            if(response.getState()=="SUCCESS")
            {
                var responsedata = response.getReturnValue();
                if(responsedata.responseStatus == 'success')
                {
                    component.set("v.EditProductsList", responsedata.ProductsList);
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
    },
    SaveEditProductDetails : function(component, event, helper) 
    {
        console.log('EditProductsList==');
        console.log(JSON.stringify(component.get("v.EditProductsList")));
        component.set("v.ShowSpinner", true);
        var action = component.get("c.SaveEditProductdata");
        action.setParams({
            OppId : component.get("v.recordId"),
            EditProductDetails : JSON.stringify(component.get("v.EditProductsList")),
            DeletOppLineList : component.get("v.deletedproducts")
            
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
                    component.set("v.showcomponent", false);
                    $A.get('e.force:refreshView').fire();
                }
                component.set("v.ShowSpinner", false);  
            }
        });
        $A.enqueueAction(action);            
    },
    //added for new Edit button in Select product
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
                    console.log('lne 78');
                    console.log( component.get("v.ProductsList"));
                    console.log(component.get("v.AddProductcolumn"));
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
        component.set('v.ShowAddProductspopUp',true);
        component.set('v.showAddnotEdit',false);
	},
    
})