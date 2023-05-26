({
	helperToast : function(title,message,type) {
         // Below if added by suhas.
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message":message,
            "type":type
        });
        toastEvent.fire();          
    }
})