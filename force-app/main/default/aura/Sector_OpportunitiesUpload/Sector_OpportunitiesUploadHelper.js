({
    
    // helper method to update the opportunity in csv file
    getOpportunityData : function(component, event, helper)
    {
        component.set("v.ShowSpinner", true);
        var COLUMNS = [
            { label: 'Opportunity Name', fieldName: 'OpportunityIdURL', type: 'url', typeAttributes: {label: { fieldName: 'OpportunityName',target: "_blank" } } },
            { label: 'Account Name', fieldName: 'AccountIdURL', type: 'url', typeAttributes: {label: { fieldName: 'AccountName',target: "_blank" } } },
            { label: 'Stage', fieldName: 'StageName' },
            { label: 'Product Family', fieldName: 'Product_Family__c' },
            { label: 'Product Name', fieldName: 'Product2Name' },
            { label: 'Start Year', fieldName: 'Id', type: 'SectorPicklistCustom', wrapText: true,
             typeAttributes: {
                 options: { fieldName: 'startyearpicklistOptions' },
                 value: { fieldName: 'startyearvalue' },
                 opplineid: { fieldName: 'Id' },
                 columnstate: { fieldName: 'startyearvaluetag' }
             }
            },
            { label: 'End Year', fieldName: 'Id', type: 'SectorPicklistCustom', wrapText: true,
             typeAttributes: {
                 options: { fieldName: 'endyearpicklistOptions' },
                 value: { fieldName: 'endyearvalue' },
                 opplineid: { fieldName: 'Id' },
                 columnstate: { fieldName: 'endyearvaluetag' }
             }
            }
            
        ];
        component.set('v.columns', COLUMNS);
        
        
        
        var COLUMNSFORECASTING = [
            { label: 'Timestamp', fieldName: 'CreatedDate', type: 'date', 
             typeAttributes: {
                 day: "numeric",
                 month: "short",
                 year: "numeric"
             } 
            },
            { label: 'Name', fieldName: 'CreatedName' },
            { label: 'Opportunity Name', fieldName: 'OpportunityIdURL', type: 'url', typeAttributes: {label: { fieldName: 'OpportunityName',target: "_blank" } } },
            { label: 'Product Family', fieldName: 'Product2Family' },
            { label: 'Product Name', fieldName: 'Product2Name' }
        ];
        component.set('v.forecastingcolumns', COLUMNSFORECASTING);
        
        
        
        
        var action = component.get("c.SectorGetOwnOpportunities");
        action.setParams({
            showoppwithforecasting : component.get("v.showoppwithforecasting")
        });
        action.setCallback(this, function(response){
            if(response.getState() == "SUCCESS")
            {
                var responsedata = response.getReturnValue();
                if(responsedata.responseStatus = 'success')
                {
                    
                    const d = new Date();
                    var listofyears = [];
                    for(var k = 2020; k < 2020+101; k++)
                    {
                        if(d.getFullYear() === k)
                            listofyears[listofyears.length] = {label: k , value: k, defaultvalue: true } ;
                        else
                            listofyears[listofyears.length] = {label: k , value: k, defaultvalue: false } ;
                    }
                    
                    var listofendyear = [];
                    for(var k = d.getFullYear(); k < 2020+101; k++)
                    {
                        listofendyear[listofendyear.length] = {label: k , value: k, defaultvalue: false } ;
                    }
                    
                    for ( var i = 0; i < responsedata.opplines.length; i++ ) {
                        var row = responsedata.opplines[i];
                        if ( row.Opportunity ) {
                            row.OpportunityName = row.Opportunity.Name;
                            row.AccountName = row.Opportunity.Account.Name;
                            row.StageName = row.Opportunity.StageName;
                            row.AccountIdURL = '/lightning/r/Account/'+row.Opportunity.AccountId+'/view';
                            row.OpportunityIdURL = '/lightning/r/Opportunity/'+row.OpportunityId+'/view';
                            
                        }
                        if ( row.Product2 ) {
                            row.Product2Name = row.Product2.Name;
                        }
                        
                        row.startyearpicklistOptions = listofyears;
                        row.startyearvalue = d.getFullYear();
                        row.startyearvaluetag = 'Start_Year';
                        
                        row.endyearpicklistOptions = listofendyear;
                        row.endyearvalue = d.getFullYear();
                        row.endyearvaluetag = 'End_Year';
                        
                    }
                    
                    
                    
                    for ( var i = 0; i < responsedata.bulkforecastinglist.length; i++ ) 
                    {
                        var row = responsedata.bulkforecastinglist[i];
                        if ( row.Opportunity__c ) {
                            row.OpportunityName = row.Opportunity__r.Name;
                            row.OpportunityIdURL = '/lightning/r/Opportunity/'+row.Opportunity__c+'/view';
                        }
                        if ( row.Opportunity_Product__c ) {
                            row.Product2Name = row.Opportunity_Product__r.Product2.Name;
                            row.Product2Family = row.Opportunity_Product__r.Product2.Family;
                        }
                        if ( row.CreatedById )
                        {
                            row.CreatedName = row.CreatedBy.Name;
                        }
                    }
                    
                    
                    
                    component.set('v.forecastingdata', responsedata.bulkforecastinglist);
                    component.set('v.data', responsedata.opplines);
                    component.set("v.ShowSpinner", false); 
                    component.set("v.loadeddatadownloadopp", true);
                }
                
            }
            else
            {
                component.set("v.ShowSpinner", false);  
                var errors = response.getError();
                var errormessage = '';
                if(errors && errors.length > 0 &&  errors[0] && errors[0].message )
                {
                    errormessage = 'Something went wrong. '+errors[0].message+'. Please try again or contact your system admin.';
                }
                if(errors && errors.length > 0 &&  errors[0] && errors[0].pageErrors && errors[0].pageErrors.length > 0 &&  errors[0].pageErrors[0].message)
                    errormessage = errors[0].pageErrors[0].message;
                
                
                if(errors && errors.length > 0 && errors[0].fieldErrors)
                {
                    for(var fielderror  in errors[0].fieldErrors)
                    {
                        let eachfielderror = errors[0].fieldErrors[fielderror];
                        if(eachfielderror && eachfielderror.length > 0)
                        {
                            for(var eachfielderr  in eachfielderror)
                            {
                                let eachfielderrrow = eachfielderror[eachfielderr];
                                if(eachfielderrrow && eachfielderrrow.message)
                                {
                                    errormessage = eachfielderrrow.message;
                                    break;
                                }
                            }
                        }
                        if(errormessage !== '')
                            break;
                    }
                }
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"error",
                    "title": "Error!",
                    "message": errormessage,
                    "duration" : 6000000
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    
    
    
    
    
    
    // helper method to validate the data in csv file
    Validateproductdetails : function(component, event, helper)
    {
        component.set("v.ShowSpinner", true);
        var action = component.get("c.SectorOpportunityValidateFile");
        action.setParams({
            FileName : component.get("v.fileName"),
            FileContent : component.get("v.fileUploaded"),
            objectname : component.get("v.selectedobjectvalue")
        });
        action.setCallback(this, function(response){
            console.log(response);
            if(response.getState() == "SUCCESS")
            {
                var responsedata = response.getReturnValue();
                
                $A.get("e.force:showToast").setParams({
                    "type": responsedata.responseStatus,
                    "message": responsedata.responseMessage,
                    "duration": 10000
                }).fire();
                
                // Set the validation result file
                component.set("v.ValidateCSVMessage", responsedata.responsemessageinmodal);
                if(responsedata.ValidationResultCSV != null && responsedata.ValidationResultCSV != '')
                {
                    component.set("v.OpportunityValidationCSV", responsedata.ValidationResultCSV);
                }
                
                // show forecast data is about to override for existing data
                component.set("v.validationforecastoverridemessage", responsedata.validationforecastoverridemessage);
                
                // if the va;idation succeed then show Start update button
                if(responsedata.responseStatus != 'success')
                    component.set("v.DisableUpdateOpportunitiesButton", true);  
                
                component.set("v.ShowSpinner", false);   
            }
            else
            {
                component.set("v.ShowSpinner", false); 
                component.set("v.DisableUpdateOpportunitiesButton", true);
                var errormessage = '';
                var errors = response.getError();
                if(errors && errors.length > 0 &&  errors[0] && errors[0].message )
                {
                    errormessage = 'Something went wrong. '+errors[0].message+'. Please try again or contact your system admin.';
                }
                
                if(errors && errors.length > 0 &&  errors[0] && errors[0].pageErrors && errors[0].pageErrors.length > 0 &&  errors[0].pageErrors[0].message)
                    errormessage = errors[0].pageErrors[0].message;
                
                
                if(errors && errors.length > 0 && errors[0].fieldErrors)
                {
                    for(var fielderror  in errors[0].fieldErrors)
                    {
                        let eachfielderror = errors[0].fieldErrors[fielderror];
                        if(eachfielderror && eachfielderror.length > 0)
                        {
                            for(var eachfielderr  in eachfielderror)
                            {
                                let eachfielderrrow = eachfielderror[eachfielderr];
                                if(eachfielderrrow && eachfielderrrow.message)
                                {
                                    errormessage = eachfielderrrow.message;
                                    break;
                                }
                            }
                        }
                        if(errormessage !== '')
                            break;
                    }
                }
                
                
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"error",
                    "title": "Error!",
                    "message": errormessage,
                    "duration" : 6000000
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    // helper method to update the opportunity in csv file
    Saveproductdetails : function(component, event, helper)
    {
        component.set("v.ShowSpinner", true);
        var action = component.get("c.SectorUpdateOpportunity");
        action.setParams({
            FileName : component.get("v.fileName"),
            FileContent : component.get("v.fileUploaded"),
            objectname : component.get("v.selectedobjectvalue")
        });
        action.setCallback(this, function(response){
            console.log(response);
            if(response.getState() == "SUCCESS")
            {
                var responsedata = response.getReturnValue();
                
                $A.get("e.force:showToast").setParams({
                    "type": responsedata.responseStatus,
                    "message": responsedata.responseMessage,
                    "duration": 10000
                }).fire();
                // Set the updateion result file
                if(responsedata.UpdateOpportunityResult != null && responsedata.UpdateOpportunityResult != '')
                    component.set("v.OpportunityResultCSV", responsedata.UpdateOpportunityResult);
                
                // update the message in model
                component.set("v.UpdateCSVMessage", responsedata.responsemessageinmodal);
                component.set("v.ShowSpinner", false);
            }
            else
            {
                component.set("v.ShowSpinner", false);  
                var errors = response.getError();
                var errormessage = '';
                if(errors && errors.length > 0 &&  errors[0] && errors[0].message )
                {
                    errormessage = 'Something went wrong. '+errors[0].message+'. Please try again or contact your system admin.';
                }
                if(errors && errors.length > 0 &&  errors[0] && errors[0].pageErrors && errors[0].pageErrors.length > 0 &&  errors[0].pageErrors[0].message)
                    errormessage = errors[0].pageErrors[0].message;
                
                
                if(errors && errors.length > 0 && errors[0].fieldErrors)
                {
                    for(var fielderror  in errors[0].fieldErrors)
                    {
                        let eachfielderror = errors[0].fieldErrors[fielderror];
                        if(eachfielderror && eachfielderror.length > 0)
                        {
                            for(var eachfielderr  in eachfielderror)
                            {
                                let eachfielderrrow = eachfielderror[eachfielderr];
                                if(eachfielderrrow && eachfielderrrow.message)
                                {
                                    errormessage = eachfielderrrow.message;
                                    break;
                                }
                            }
                        }
                        if(errormessage !== '')
                            break;
                    }
                }
                
                var toastEvent = $A.get("e.force:showToast");
                toastEvent.setParams({
                    "type":"error",
                    "title": "Error!",
                    "message": errormessage,
                    "duration" : 6000000
                });
                toastEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },
    gotouploadscreen : function(cmp, event, helper)
    {
        var cmpTarget = cmp.find('generatefilestage');
        $A.util.addClass(cmpTarget, 'slds-is-complete');
        $A.util.removeClass(cmpTarget, 'slds-is-current');
        $A.util.removeClass(cmpTarget, 'slds-is-active');
        
        var cmpTarget = cmp.find('uploadstage');
        $A.util.addClass(cmpTarget, 'slds-is-current');
        $A.util.addClass(cmpTarget, 'slds-is-active');
        $A.util.removeClass(cmpTarget, 'slds-is-incomplete');
        
        var cmpTarget = cmp.find('validatestage');
        $A.util.addClass(cmpTarget, 'slds-is-incomplete');
        $A.util.removeClass(cmpTarget, 'slds-is-current');
        $A.util.removeClass(cmpTarget, 'slds-is-active');
        
        
        cmp.set("v.fileUploaded",null);
        cmp.set("v.csvHeader",null);  
        cmp.set("v.fileName",null);
        cmp.set("v.GenerateFile",false);
        cmp.set("v.ShowFileUpload",true);
        
        cmp.set("v.ShowValidationScreen",false);
        cmp.set("v.ShowFinishScreen",false);
        cmp.set("v.DisableProceedtoValidationButton",true);
        cmp.set("v.DisableUpdateOpportunitiesButton",false);
        cmp.set("v.OpportunityValidationCSV",'');
        cmp.set("v.OpportunityResultCSV",'');
        cmp.set("v.ValidateCSVMessage",'');
        cmp.set("v.UpdateCSVMessage",'');
        cmp.set("v.validationforecastoverridemessage",'');
        
        cmp.set("v.disablegeneratefile",true);
        cmp.set("v.diableProceedtoUploadFile",true);
        
    }
})