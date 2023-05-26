({
    getOpportunityDetails : function(cmp, event, helper)
    {
        var action = cmp.get("c.getAccountDetails");
        action.setParams({
            OppId : cmp.get("v.recordId")
        });
        action.setCallback(this, function(response){
            if(response.getState()=="SUCCESS"){
                var responseopp = response.getReturnValue();
                var billingStreet = responseopp.OppResponse.Billing_Street__c != null ? responseopp.OppResponse.Billing_Street__c : '';
                var billingCity = responseopp.OppResponse.Billing_City__c != null ? responseopp.OppResponse.Billing_City__c : '';
                var billingState = responseopp.OppResponse.Billing_State_Province__c != null ? responseopp.OppResponse.Billing_State_Province__c : '';
                var billingCountry = responseopp.OppResponse.Billing_Country__c != null ? responseopp.OppResponse.Billing_Country__c : '';
                var billingZipCode = responseopp.OppResponse.Billing_Zip_Postal_Code__c != null ? responseopp.OppResponse.Billing_Zip_Postal_Code__c : '';
                
                
                if(responseopp.responseStatus == 'success')
                {
                    cmp.set('v.mapMarkers', [
                        {
                            location: {
                                City: billingCity,
                                Country: billingCountry,
                                PostalCode: billingZipCode,
                                State: billingState,
                                Street: billingStreet
                            },
                            title: (billingStreet+' '+billingCity+' '+billingState+ ' '+billingCountry+' '+billingZipCode)
                        } 
                    ]);
                }
                else
                {
                    $A.get("e.force:showToast").setParams({
                        "type": responseopp.responseStatus,
                        "message": responseopp.responseMessage,
                        "duration": 10000
                    }).fire();
                }
                
            }
        });
        $A.enqueueAction(action);		
    }
})