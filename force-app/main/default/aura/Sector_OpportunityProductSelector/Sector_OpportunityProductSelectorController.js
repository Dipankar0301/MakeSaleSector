({
    init: function(component, event, helper) 
    {
		helper.getproductdetails(component, event, helper);
    },
    AddProducts : function(component, event, helper) {
        component.set("v.AddProductsnew", true);
    },
    EditProducts : function(component, event, helper) {
        component.set("v.EditProductsnew", true);
    }
})