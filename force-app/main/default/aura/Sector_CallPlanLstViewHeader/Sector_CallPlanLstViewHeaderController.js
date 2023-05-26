({
    doInit : function(component, event, helper) {
        const device = $A.get("$Browser.formFactor");
        component.set('v.device',device);
        helper.getListViewDetails2(component, event, helper); 
    },
    //add column feature is removed for now
    /*addColumns:function (component, event,helper) {
         var appEvents = $A.get("e.c:Sector_CallPlanLstViewEvent");
                            appEvents.setParams({
                                "action":'addColumns'
                            }).fire();
        
    }, */
     createRecord : function (component, event, helper) {
        
         
         
        var appEvents = $A.get("e.c:Sector_CallPlanLstViewEvent");
                            appEvents.setParams({
                                "Record":component.get("v.row"),
                                "action":'newRecord',
                            }).fire();
         
    },
    //reloadafterEdit : function (component, event, helper) {
     // helper.getListViewsOnEdit(component, event, helper);
    //},
    handleEventAction : function (component, event, helper) {
    var createdId=event.getParam('currentListViewId');
        console.log('inside handleEventAction');
        console.log(createdId);
    var action=event.getParam('action');
        if(action == 'save'){
            var appEvents = $A.get("e.c:Sector_CallPlanLstViewEvent");
                            appEvents.setParams({
                                "action":''
                            }).fire();
        }
        
    },
})