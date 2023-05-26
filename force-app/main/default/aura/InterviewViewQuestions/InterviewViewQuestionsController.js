({
	init : function(component, event, helper) {
        console.log(component.get("v.recordId"));        
        //console.log(component.get("v.pageReference").state.recordId);
        //$A.get('e.force:refreshView').fire();
        //helper.setRecordId(component,event,helper);
        helper.fetchQuestions(component, event, helper);
		helper.fetchSections(component, event, helper);        
        var section=component.find("Section");        
	},	
    saveData:function(component, event, helper){
        helper.saveData(component, event, helper);
    },
     print : function(component, event, helper) {
        window.print();
    }
})