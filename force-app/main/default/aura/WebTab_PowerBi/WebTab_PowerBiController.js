({
    doInit : function(component, event, helper) {
        //window.location.replace('https://shell-gc.lightning.force.com/analytics/dashboard/0FK670000004eWEGAY');
        var urlEvent = $A.get("e.force:navigateToURL");
        //var label = $A.get("$Label.c.NewEnergiesCRD");
        urlEvent.setParams({
            "url": 'https://app.powerbi.com/Redirect?action=OpenApp&appId=eb2edfa5-a912-423a-96c1-226e22cb432d&ctid=db1e96a8-a3da-442a-930b-235cac24cd5c'
            //"url" : 'https://shell-gc.lightning.force.com/analytics/dashboard/' + label
        });
        urlEvent.fire();
    }
})