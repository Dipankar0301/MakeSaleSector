({
	toastMethod : function() {
        var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":"success",
                        "title": "Success!",
                        "message": "Data is saved successfully"
                    });
                    toastEvent.fire();
		
	}
})