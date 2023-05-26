({
    openModel: function(component, event, helper) {
        // Set isModalOpen attribute to true
        component.set("v.isModalOpen", true);
    },
    
    closeModel: function(component, event, helper) {
        // Set isModalOpen attribute to false  
        component.set("v.isModalOpen", false);
    },
    openLink: function(component, event, helper) {
        //var label = $A.get("$Label.c.Sector_disclaimer_URL");
        var eUrl= $A.get("e.force:navigateToURL");
        eUrl.setParams({
            "url": 'https://forms.office.com/Pages/ResponsePage.aspx?id=qJYe29qjKkSTCyNcrCTNXJT8NoQHwMtDvm6Dmy2qTpNUM1I4REFJMlQ0NjFRWjVLMlJTNjdZOUlDVS4u' 
        //"url": 'label';
        });
        eUrl.fire();
    },
    OpenURL: function(component, event, helper) {
        var eUrl= $A.get("e.force:navigateToURL");
        eUrl.setParams({
            "url": 'https://eu001-sp.shell.com/sites/AAFAA5088/SECO Primary Document Library/AT Rule - Managing CSI.pdf' 
        //"url": 'label';
        });
        eUrl.fire();
    },
    OpenURLLegal: function(component, event, helper) {
        var eUrl= $A.get("e.force:navigateToURL");
        eUrl.setParams({
            "url": 'https://legalbot.shell.com/' 
        //"url": 'label';
        });
        eUrl.fire();
    },
})