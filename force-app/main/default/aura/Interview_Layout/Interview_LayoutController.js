({
	myAction : function(component, event, helper) {
		
	},
	waiting: function(component, event, helper) {
    	component.set("v.HideSpinner", true);
    },
	doneWaiting: function(component, event, helper) {
		component.set("v.HideSpinner", false);
	}
    
})