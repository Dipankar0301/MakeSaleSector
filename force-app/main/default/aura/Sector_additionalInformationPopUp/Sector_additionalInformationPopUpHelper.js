({
    WarningMessage : function(component, event, helper) {
        /*var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : "Don't Forget!",
            message: "Please fill in the additional information section.",
            duration: '30000',
            key: 'info_alt',
            type: 'Informational',
            mode: 'dismissible'
            
            
            
        });
        toastEvent.fire();  */
        
        
        
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title : "Don't Forget!",
            message: "Please fill in the additional information section. ",
            messageTemplate: 'Please fill in the additional information section. {0}.',
            duration: '300000', 
            key: 'info_alt',
            type: 'Informational',
            mode: 'dismissible',
            messageTemplateData: [ {
                url: '#',
                label: 'Take me there',
                executionComponent: {
                descriptor: "markup://c:Sector_MultiSelectEvent", 
                    attributes: { "message" : 'Sector_scrolltoAdditionalSection' }, 
                    componentName: 'appEvent', isEvent: true, 
                    isClientSideCreateable: true 
            }
            }]
        });
        toastEvent.fire();

        
        /*var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:MakeSales_Sector_MuliselectParent",
            
        });
        evt.fire();*/
    }
    })