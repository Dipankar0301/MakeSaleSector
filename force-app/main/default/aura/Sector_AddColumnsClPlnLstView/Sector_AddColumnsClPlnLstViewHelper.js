({
	saveColumns : function(component,recid,cols) {
		var action=component.get("c.saveColumns");
        action.setParams({"recordId":recid,"cols":JSON.stringify(cols)});
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                console.log('Success cols');
                component.set("v.onCreate",false);
                
            }
            else{
                console.log('Failure');
            }
        });
        $A.enqueueAction(action);
	}
})