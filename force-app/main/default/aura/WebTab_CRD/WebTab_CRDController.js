({
    doInit : function(component, event, helper) {
        //window.location.replace('https://shell-gc.lightning.force.com/analytics/dashboard/0FK670000004eWEGAY');
        var urlEvent = $A.get("e.force:navigateToURL");
        var label = $A.get("$Label.c.NewEnergiesCRD");
        urlEvent.setParams({
            //"url": 'https://shell-gc.lightning.force.com/analytics/dashboard/0FK670000004eWEGAY'
            "url" : 'https://shell-gc.lightning.force.com/analytics/dashboard/' + label
        });
        urlEvent.fire();
    }
})