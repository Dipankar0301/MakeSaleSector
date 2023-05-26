({
    doInit : function(component, event, helper) {
        //window.location.replace('https://shell-gc.lightning.force.com/analytics/dashboard/0FK670000004eWEGAY');
        var urlEvent = $A.get("e.force:navigateToURL");
        var label = $A.get("$Label.c.NewEnergiesCRD");
        urlEvent.setParams({
            //"url": 'https://shell-gc.lightning.force.com/analytics/dashboard/0FK670000004eWEGAY'
            "url" : 'https://forms.office.com/Pages/ResponsePage.aspx?id=qJYe29qjKkSTCyNcrCTNXJT8NoQHwMtDvm6Dmy2qTpNUODZNT0ozMk8yRElFVkNJR0xKTDhNSFE5Ny4u'
        });
        urlEvent.fire();
    }
})