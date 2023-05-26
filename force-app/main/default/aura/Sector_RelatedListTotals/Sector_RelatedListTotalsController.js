({
	init : function(component, event, helper) 
    {
		helper.getOpplist(component, event, helper);	
	},
    deleterow : function(component, event, helper) 
    {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'delete':
                {
                    component.set("v.deleterecordId", row.Id);
                    component.set("v.showmodaldelete", true);
                }
                break;
        }
    },
    submitdeleterow : function(component, event, helper) 
    {
        helper.deleteoppproductrow(component, event, helper);
    },
    closeModel: function(component, event, helper) 
    {
        component.set("v.deleterecordId", null);
        component.set("v.showmodaldelete", false);
    }
})