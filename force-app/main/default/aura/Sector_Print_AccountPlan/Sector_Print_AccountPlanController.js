({
    handlecancel : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
    PrintAccountPlan : function(component, event, helper) {
        var urlEvent = $A.get("e.force:navigateToURL");
        urlEvent.setParams({
            "url":"/apex/Sector_PrintPrompt_AccountPlan?Id="+component.get("v.recordId")
        });
        urlEvent.fire();
        $A.get("e.force:closeQuickAction").fire();
    }
})