({
    
    // function call on component Load
    doInit: function(component, event, helper) {
        // create a Default RowItem [Contact Instance] on first time Component Load
        // by call this helper function  
        helper.createObjectData(component, event);
        helper.onloadGetRecordtype(component,event);
    },
    
    // function for save the Records 
    Save: function(component, event, helper) {
        //Venkata code. if Approval_makes_Project_Read_Only__c is false then only allow.
        
        if(! helper.initialValidateMethod(component, event)) {
            
        // first call the helper function in if block which will return true or false.
        // this helper function check the "first Name" will not be blank on each row.
        if (helper.validateRequired(component, event)) {
            //alert('=Inside helper=');
            // call the apex class method for save the Contact List
            // with pass the contact List attribute to method param.  
            var action = component.get("c.saveContacts");
            action.setParams({
                ListFinancial: component.get("v.contactList"),
                currentRecId: component.get("v.recordId")
            });
            //alert('=='+JSON.stringify(component.get("v.contactList")));
            // set call back 
            action.setCallback(this, function(response) {
                var state = response.getState();
                //alert(state);
                if (state === "SUCCESS") {
                    
                    //alert('record Saved');
                    component.set("v.contactList",response.getReturnValue());
                    helper.helperToast("Alert!","Record Saved Successfully","Success");
                }
            });
            // enqueue the server side action  
            $A.enqueueAction(action);
        }
        }
    },
    
    // function for create new object Row in Contact List 
    addNewRow: function(component, event, helper) {
        // call the comman "createObjectData" helper method for add new Object Row to List  
        //helper.createObjectData(component, event);
        var RowItemList = component.get("v.contactList");
        RowItemList.push({
            'sobjectType': 'Financial__c',
            'NE_CAPEX__c': '',
            'Non_NE_CAPEX_M__c': '',
            'FEASEX_M__c': '',
            'OPEX_M__c' :'',
            'NEPM_Total_net_credits__c':'',
            'Project__c':component.get("v.recordId")
        });
        // set the updated list to attribute (contactList) again  
        //alert('=RowItemList='+JSON.stringify(RowItemList));  
        component.set("v.contactList", RowItemList);
        
    },
    
    // function for delete the row 
    removeDeletedRow: function(component, event, helper) {
        // get the selected row Index for delete, from Lightning Event Attribute  
        var index = event.getParam("indexVar");
        var currentRec = event.getParam("currentRecordId");
        //alert('***'+currentRec);
        // get the all List (contactList attribute) and remove the Object Element Using splice method    
        var AllRowsList = component.get("v.contactList");
        AllRowsList.splice(index, 1);
        // set the contactList after remove selected row element  
        component.set("v.contactList", AllRowsList);
        
        
        var action = component.get('c.deleteFinancials');
        action.setParams({
            
            currentRecId:currentRec
            
        });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === 'SUCCESS') {
                //alert("Record Deleted Successfully");
                helper.helperToast("Alert!","Record Deleted Successfully","Success");
                
            }
        });
        
        $A.enqueueAction(action);
        
        //alert('=Index='+index);
        //Add Empty Row
        if(index == 0 && AllRowsList.length == 0){
            var RowItemList = component.get("v.contactList");
            RowItemList.push({
                'sobjectType': 'Financial__c',
                'NE_CAPEX__c': '',
                'Non_NE_CAPEX_M__c': '',
                'FEASEX_M__c': '',
                'OPEX_M__c' :'',
                'NEPM_Total_net_credits__c':'',
                'Project__c':component.get("v.recordId")
            });
            // set the updated list to attribute (contactList) again  
            //alert('=RowItemList='+JSON.stringify(RowItemList));  
            component.set("v.contactList", RowItemList);
            
            
        }
        
    },
    display : function(component, event, helper) {
    helper.toggleHelper(component, event);
  },

  displayOut : function(component, event, helper) {
   helper.toggleHelper(component, event);
  }
})