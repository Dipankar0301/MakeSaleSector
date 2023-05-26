({
	WarningMessage : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Warning',
            message: 'You are not the opportunity owner or part of the opportunity team - any changes you make cannot be saved. If you need to make changes, contact the opportunity owner to be added to the opportunity team',
            duration:' 5000',
            key: 'info_alt',
            type: 'warning',
            mode: 'sticky'
        });
        toastEvent.fire();
	}
})