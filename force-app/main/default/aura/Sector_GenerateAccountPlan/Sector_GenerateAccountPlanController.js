({
    handlecancel : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
    PrintAccountPlan : function(component, event, helper) {
        
        window.open('/apex/Sector_GeneratePDFTest?Id='+component.get("v.recordId"),'_blank');
        
        
        $A.get("e.force:closeQuickAction").fire();
    }
})