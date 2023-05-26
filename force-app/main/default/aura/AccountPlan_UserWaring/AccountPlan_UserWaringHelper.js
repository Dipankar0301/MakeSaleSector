({
	WarningMessage : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Warning',
            message: 'You have read-only access to this Account Plan - any changes you make cannot be saved. If you need to make changes, contact the Account Owner to be added to the account team first',
            duration:' 5000',
            key: 'info_alt',
            type: 'warning',
            mode: 'sticky'
        });
        toastEvent.fire();
	}
})