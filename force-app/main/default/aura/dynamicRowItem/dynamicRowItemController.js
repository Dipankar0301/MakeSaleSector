({
    AddNewRow : function(component, event, helper){
       // fire the AddNewRowEvt Lightning Event 
       // Below if added by suhas.
       if(component.get('v.validateSave') == false)          
        component.getEvent("AddRowEvt").fire();  
        else 
           helper.helperToast("Alert!","Record was locked","error");
            
    },
    
    removeRow : function(component, event, helper){
     // fire the DeleteRowEvt Lightning Event and pass the deleted Row Index to Event parameter/attribute
       	var component_target = event.currentTarget;
    	var recId = component_target.dataset.myvalue;
        //alert('=recId='+recId);
    	//console.info(attribute);
         // Locking the record when prarent under Approval Process.
        if(component.get('v.validateSave') == false)
        {
        component.getEvent("DeleteRowEvt").setParams(
            {
               "indexVar" : component.get("v.rowIndex"),
                "currentRecordId":recId
            }).fire();
        }
        else
        {
             helper.helperToast("Alert!","Record was locked","error");
        }
   
    }, 
  
})