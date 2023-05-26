({
    doInit : function( component, event, helper ) {
        helper.doInitStartHelperSite(component);
        var staticRecordLabel = $A.get("$Label.c.SiteSectorRecordType");
        component.set("v.recordTypeId",staticRecordLabel);
    },
    filterOptions : function( component, event, helper ) {
        var a = event.getSource();
        var id = a.getLocalId();
        console.log('line 12');
        console.log(id);
        if(id === 'inputLookup4'){
            if(!$A.util.isEmpty(component.get('v.searchString4'))){
                component.set("v.message", '');
                var searchText = component.get('v.searchString4');
                var options = component.get("v.options4");
                var minChar = component.get('v.minChar');
                if(searchText.length >= minChar) {
                    var flag = true;
                    options.forEach( function(element,index) {
                        if(element.label.toLowerCase().trim().includes(searchText.toLowerCase().trim())) {
                            console.log('Line 209');
                            console.log(element.label.toLowerCase().trim().startsWith(searchText.toLowerCase().trim()));
                            element.isVisible = true;
                            flag = false;
                        } else {
                            element.isVisible = false;
                        }
                    });
                    component.set("v.options4",options);
                    if(flag) {
                        component.set("v.message", "No results found for '" + searchText + "'");
                    }
                }
                $A.util.addClass(component.find('resultsDiv4'),'slds-is-open');
            }
            else{
                component.set("v.message", '');
                var options = component.get("v.options4");
                options.forEach( function(element,index) {
                    element.isVisible = true;
                });
                component.set("v.options4",options);
                $A.util.addClass(component.find('resultsDiv4'),'slds-is-open');
                
            }
        }
    },
    
    selectItem4 : function( component, event, helper ) {
        if(!$A.util.isEmpty(event.currentTarget.id)) {
            helper.selectOptionHelper4(component, event);
        }
    },
    
    showOptions : function( component, event, helper ) {
        var a = event.getSource();
        var id = a.getLocalId();
        console.log(id);
        
        var disabled = component.get("v.disabled");
        //if(!disabled) {
        if(id == 'inputLookup4'){
            component.set("v.message", '');
            component.set('v.searchString4', '');
            var options = component.get("v.options4");
            options.forEach( function(element,index) {
                element.isVisible = true;
            });
            component.set("v.options4", options);
            if(!$A.util.isEmpty(component.get('v.options4'))) {
                $A.util.addClass(component.find('resultsDiv4'),'slds-is-open');
            }
        }
        
        //}
    },
    closePill4 : function( component, event, helper ){
        var disable = component.get("v.disabled");
        //if(disable == false){
        var value = event.getSource().get('v.name');
        var multiSelect = component.get('v.multiSelect');
        var count = 0;
        var options = component.get("v.options4");
        var values = component.get('v.values4') || [];
        options.forEach( function(element, index) {
            if(element.value === value) {
                element.selected = false;
                values.splice(values.indexOf(element.value), 1);
            }
            if(element.selected) {
                count++;
            }
        });
        if(multiSelect)
            component.set('v.searchString4', count + ' options selected');
        component.set('v.values4', values)
        component.set("v.options4", options);
        //}
        
    },
    
    // To close the dropdown if clicked outside the dropdown.
    handleBlur : function( component, event, helper ){
        helper.handleBlurHelper(component, event);
    },
    handleSaveRecord : function( component, event, helper ){
        helper.handleBlurHelper(component, event);
        console.log('398');
        console.log(component.get("v.values4"));
        
        var selectedvalues4 =[];
        console.log('112');
        var values4 = component.get('v.values4');
        console.log('114');
        for(let k in values4){
            selectedvalues4.push(values4[k].value);
            console.log('117');
        }
        var action1 = component.get("c.saveRecords")
        action1.setParams({
            recId : component.get("v.recordId"),
            selectedSite : selectedvalues4
        });
        action1.setCallback(this, function(response){
            console.log('409');
            console.log(response.getState());
            if(response.getState()=="SUCCESS"){
                console.log('411');
                var result = response.getReturnValue();
                if(result[0] == 'true'){
                    console.log('412');
                    //alert('record saved');
                    var save = component.get("v.disabled");
                    var edit = component.get("v.disabled1");
                    component.set('v.disabled', edit)
                    component.set("v.disabled1", save);
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "type":"Success",
                        "title": "Success!",
                        "message": 'Record Saved Successfully!',
                        "duration" : 60000
                    });
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                    
                } 
                //}
                else{
                    console.log('431');
                    var result = response.getReturnValue();
                    console.log('line 341');
                    console.log(result);
                    for(let i=0;i<result.length;i++){
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type":"error",
                            "title": "Error!",
                            "message": result[i],
                            "duration" : 60000
                        });
                        toastEvent.fire();
                    }
                }
            }
            else if (response.getState() === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        // log the error passed in to AuraHandledException
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
            
        });
        $A.enqueueAction(action1);
        component.set("v.showcomponent", false);
        $A.get('e.force:refreshView').fire();
    },
    toggleSection : function(component, event, helper) {
        // dynamically get aura:id name from 'data-auraId' attribute
        var sectionAuraId = event.target.getAttribute("data-auraId");
        console.log(sectionAuraId);
        // get section Div element using aura:id
        var sectionDiv = component.find(sectionAuraId).getElement();
        /* The search() method searches for 'slds-is-open' class, and returns the position of the match.
         * This method returns -1 if no match is found.
        */
        var sectionState = sectionDiv.getAttribute('class').search('slds-is-open'); 
        
        // -1 if 'slds-is-open' class is missing...then set 'slds-is-open' class else set slds-is-close class to element
        if(sectionState == -1){
            sectionDiv.setAttribute('class' , 'slds-section slds-is-open');
        }else{
            sectionDiv.setAttribute('class' , 'slds-section slds-is-close');
        }
    },
    handleMode: function(component, event, helper) {
        var save = component.get("v.disabled");
        var edit = component.get("v.disabled1");
        //component.set('v.disabled', edit)
        //component.set("v.disabled1", save);
        $A.get('e.force:refreshView').fire();
    },
    
    closeModel: function(component, event, helper)
    {
        component.set("v.showcomponent", false);
    },
    addNewSite: function(component, event, helper)
    {
        var staticRecordLabel = $A.get("$Label.c.SiteSectorRecordType");
        var action1 = component.get("c.getParentAccountRecordId");
        action1.setParams({
            recId : component.get("v.recordId")
        });
        action1.setCallback(this, function(response){
            if(response.getState()=="SUCCESS"){
                if(response.getReturnValue() != null){
                    console.log('line 225');
        			console.log(response.getReturnValue());
                    component.set("v.parentAccountId",response.getReturnValue());
                    
                    var accountId = component.get("v.parentAccountId");
        console.log('line 231');
        console.log(accountId);
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Site__c",
            "recordTypeId": staticRecordLabel,
            "defaultFieldValues": {
            "Account__c" : accountId,
            },
           "navigationLocation" : "LOOKUP",
            "panelOnDestroyCallback": function(event) {
                $A.get('e.force:refreshView').fire();
                //$A.util.addClass(component.find('resultsDiv4'),'slds-is-close');
            }
        });
        createRecordEvent.fire();
                    
                }
            }
        });
        $A.enqueueAction(action1);
        /*var accountId = component.get("v.parentAccountId");
        console.log('line 231');
        console.log(accountId);
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Site__c",
            "recordTypeId": staticRecordLabel,
            'Account__c' : accountId,
            "navigationLocation" : "LOOKUP",
            "panelOnDestroyCallback": function(event) {
                //console.log('123');
                //alert('welcome');
                $A.get('e.force:refreshView').fire();
            }
        });
        createRecordEvent.fire();*/
        //$A.get('e.force:refreshView').fire();
    },
    addNewSite1: function(component, event, helper)
    {
        component.set("v.disabled1", true);
    },
    //add new site close
    noBtn : function(component, event, helper) {
        	component.set("v.disabled1", false);
	},
    onCancel : function(component, event, helper) {
		component.set("v.disabled1", false);
	},
    
})