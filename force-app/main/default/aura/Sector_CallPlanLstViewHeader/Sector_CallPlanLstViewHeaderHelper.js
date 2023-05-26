({
    getListViewDetails2 : function(component, event, helper) {
        var listviewsafterCheck=[];
        var action = component.get("c.getListViewDetails");
        action.setCallback(this, function(response) {
            console.log('getListViewDetails2 state==>'+response.getState());
            var pinnedListId;
            var state = response.getState();
            if (state === "SUCCESS") {
                
                var storeResponse = response.getReturnValue();
                console.log(storeResponse);
                if(!$A.util.isEmpty(storeResponse)){
                    component.set("v.currentListView",'Default View');
                    component.set("v.listViewsRec",storeResponse);
                    component.set("v.listColumn",storeResponse);
                    component.set("v.listViews",listviewsafterCheck);
                    console.log('list views ==>');
                    console.log(component.get("v.listViews"));
                    console.log(component.get("v.listColumn"));
                    var appEvents = $A.get("e.c:Sector_CallPlanLstViewEvent");
                    appEvents.setParams({
                        "listViews":component.get("v.listViews"),
                        "currentListView":component.get("v.listViewsRec"),
                        "action":'listViews',
                        "currentListViewId":pinnedListId
                    }).fire();
                    
                }   
            }
        });
        $A.enqueueAction(action);
        
    },
    
    showToast : function(component, event, helper, title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type 
        });
        toastEvent.fire();
    },
})