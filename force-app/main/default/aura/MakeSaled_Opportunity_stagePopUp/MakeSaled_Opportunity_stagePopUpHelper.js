({
    
    toastMethod : function() {
        var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":"success",
                        "title": "Success!",
                        "message": "Stage changed"
                    });
                    toastEvent.fire();
		
	},
    toastMethod1 : function() {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type":"error",
            "title": "Error!",
            "message": "Either Record Type is not Sector or You don't have access"
        });
        toastEvent.fire();
        
    }, 
    
    errormethod : function() {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "type":"error",
            "title": "Error!",
            "message": "Error while finding previous stage"
        });
        toastEvent.fire();
        
    }
})