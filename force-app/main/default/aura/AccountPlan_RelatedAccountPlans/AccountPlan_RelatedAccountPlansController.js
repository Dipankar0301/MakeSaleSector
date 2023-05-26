({
    myAction : function(component, event, helper) 
    {
        
        component.set('v.columns', [
            {label: 'Name', fieldName: 'Name', type: 'text' },
            {label: 'Title', fieldName: 'Title', type: 'Text' },
        ]);
        
        var ConList = component.get("c.getRelatedList");
        ConList.setParams
        ({
            recordId: component.get("v.recordId")
        });
        
        ConList.setCallback(this, function(data) 
                            {
                                component.set("v.AccountPlanList", data.getReturnValue());
                            });
            console.log('12345');
            console.log(component.get("v.AccountPlanList"));
        $A.enqueueAction(ConList);
    }
})