({
    myAction : function(component, event, helper) 
    {
        
        component.set('v.columns', [
            {label: 'Name', fieldName: 'Name', type: 'text' },
            {label: 'Title', fieldName: 'Title', type: 'Text' },
            {label: 'Department', fieldName: 'Department__c', type: 'text' },
            {label: 'Shell Counterpart', fieldName: 'Shell_Counterpart__c', type: 'text' },
            {label: 'Management Style', fieldName: 'Management_Style__c', type: 'text' },
            {label: 'Buyer Profile', fieldName: 'Buyer_Profile__c', type: 'text' },
            {label: 'Vendor Preference', fieldName: 'Vendor_Preference__c', type: 'text' },
            {label: 'Buying group', fieldName: 'Buying_group__c', type: 'text' },
            {label: 'Individual Relationship Insights', fieldName: 'Individual_Relationship_Insights__c', type: 'text' }
        ]);
        
        var ConList = component.get("c.getRelatedList");
        ConList.setParams
        ({
            recordId: component.get("v.recordId")
        });
        
        ConList.setCallback(this, function(data) 
                            {
                                if(data.getState() === 'SUCCESS')
                                {
                                    component.set("v.ContactList", data.getReturnValue());
                                }
                                else
                                {
                                    var errors = data.getError();
                                    var errormessage = 'Something went wrong. Please try again or contact system admin.';
                                    if(errors && errors.length > 0 &&  errors[0] && errors[0].message)
                                        errormessage = 'Something went wrong. '+errors[0].message+'. Please try again or contact system admin.';
                                    else if(errors && errors.length > 0 &&  errors[0] && errors[0].pageErrors && errors[0].pageErrors.length > 0 &&  errors[0].pageErrors[0].message)
                                        errormessage = 'Something went wrong. '+errors[0].pageErrors[0].message+'. Please try again or contact system admin.';
                                    var toastEvent = $A.get("e.force:showToast");
                                    toastEvent.setParams({
                                        "type":"error",
                                        "title": "Error!",
                                        "message": errormessage,
                                        "duration" : 30000
                                    });
                                    toastEvent.fire();
                                }
                                
                            });
        
        $A.enqueueAction(ConList);
    },
    createRecord : function (component, event, helper) {
        
        var Idlist = component.get("c.getAccountId");
        Idlist.setParams
        ({
            recordId: component.get("v.recordId")
        });
        
        Idlist.setCallback(this, function(data) 
                           {
                               if(data.getState() === 'SUCCESS')
                               {
                                   var returnvalue = data.getReturnValue();
                                   var createRecordEvent = $A.get("e.force:createRecord");
                                   createRecordEvent.setParams({
                                       "entityApiName": "Contact",
                                       "defaultFieldValues": {
                                           'AccountId' : returnvalue[0]
                                       }
                                   });
                                   createRecordEvent.fire();
                               }
                               else
                               {
                                   var errors = data.getError();
                                   var errormessage = 'Something went wrong. Please try again or contact system admin.';
                                   if(errors && errors.length > 0 &&  errors[0] && errors[0].message)
                                       errormessage = 'Something went wrong. '+errors[0].message+'. Please try again or contact system admin.';
                                   else if(errors && errors.length > 0 &&  errors[0] && errors[0].pageErrors && errors[0].pageErrors.length > 0 &&  errors[0].pageErrors[0].message)
                                       errormessage = 'Something went wrong. '+errors[0].pageErrors[0].message+'. Please try again or contact system admin.';
                                   var toastEvent = $A.get("e.force:showToast");
                                   toastEvent.setParams({
                                       "type":"error",
                                       "title": "Error!",
                                       "message": errormessage,
                                       "duration" : 30000
                                   });
                                   toastEvent.fire();
                               }

                           });
        
        $A.enqueueAction(Idlist);
        
        
    }
})