({
	WarningMessage : function(component, event, helper) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : 'Warning',
            message: 'You have read-only access to this account - any changes you make cannot be saved. If you need to make changes, contact the Account Owner to gain access',
            duration:' 5000',
            key: 'info_alt',
            type: 'warning',
            mode: 'sticky'
        });
        toastEvent.fire();
	}
})