({
    
    init : function(component, event, helper) {
        //component.set('v.today', today);
        var today = new Date();
        component.set('v.today', today.getFullYear());
    },
    submitDetails : function(component,event,helper){ 	
        //console.log(component.get("v.current"));
        //component.set("revenueList[0]",component.get("v.current"));
        //for (let i = 0; i < 10; i++) {
        //}
        var current=component.get("v.current");
        var current1=component.get("v.current1");
        var current2=component.get("v.current2");
        var current3=component.get("v.current3");
        var current4=component.get("v.current4");
        var current5=component.get("v.current5");
        var current6=component.get("v.current6");
        var current7=component.get("v.current7");
        var current8=component.get("v.current8");
        var current9=component.get("v.current9");
        component.set("v.revenueList[0]",current);
        component.set("v.revenueList[1]",current1);
        component.set("v.revenueList[2]",current2);
        component.set("v.revenueList[3]",current3);
        component.set("v.revenueList[4]",current4);
        component.set("v.revenueList[5]",current5);
        component.set("v.revenueList[6]",current6);
        component.set("v.revenueList[7]",current7);
        component.set("v.revenueList[8]",current8);
        component.set("v.revenueList[9]",current9);
        
        console.log('s123');
        console.log(component.get("v.revenueList"));
        
        
        
        var action = component.get("c.storeData");
        
        action.setParams({
            
            "recId": component.get("v.recordId"),             
            "revenueData": component.get("v.revenueList"),
            
        });
        action.setCallback(this, function(response) {
            
            var state = response.getState();
            if(state === 'SUCCESS') { 
                let returnedValue= response.getReturnValue();
                $A.get('e.force:refreshView').fire();      
        		component.set("v.modalWindow",'false');
                helper.toastMethod();                
            } 
            
            
        });
        
        $A.enqueueAction(action);
        $A.get('e.force:refreshView').fire();
        
    },
})