({
	doInit : function(component, event, helper) {
        var origin= event.getSource().toString();
        var ab='forceChatter';
        var res=origin.indexOf(ab) > -1;
        console.log('==>origin==>'+origin);
        if(res==true){
            component.set("v.showheader",true);
        }else{
            component.set("v.showheader",false);
        }
        var eventid =component.get("v.recordId");
        var action = component.get("c.getCallPlanType");
        action.setParams({ "EventId" : eventid});
        action.setCallback(this, function(response) {
            var state = response.getState();
             alert(state);
            if (state === "SUCCESS") {
                var statusvalues = response.getReturnValue();
               // alert(JSON.stringify(statusvalues));
                if(statusvalues=='Call Plan POPSA'){
                    component.set("v.Popsa",true);
                    //component.set("v.CallPlanLite",false);
                   }
                else if(statusvalues=='Call Plan Challenger'){
                    //component.set("v.Popsa",true);
                    //component.set("v.CallPlanLite",false);
                }else if(statusvalues=='Call Plan Lite'  || statusvalues=='Argenti Call Plan'){
                    //component.set("v.CallPlanLite",true);
                    //component.set("v.Popsa",false);
                }else if(statusvalues=='NOT LINKED'){
                    //component.set("v.CallPlanLite",false);
                    //component.set("v.Popsa",false);
                    //component.set("v.NotLinked",true);
                }
            }
        }),
            $A.enqueueAction(action);
    }
})