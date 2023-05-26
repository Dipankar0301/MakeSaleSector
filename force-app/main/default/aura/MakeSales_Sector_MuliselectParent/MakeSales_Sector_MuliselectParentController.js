({
    doInit : function( component, event, helper ) {
        console.log('line 3');
        console.log(component.get("v.recordId"));
        console.log('5');
        helper.doInitStartHelper(component);
        console.log('6');
        //helper.doInitStartHelperSite(component);
        console.log('7');
        console.log(component.find("fruitsSection"));
        
    },
    
    handleComponentEvent : function( component, event, helper ) {
        var message = event.getParam("message");
        console.log('event catch 2134='+message);
        $A.get('e.force:refreshView').fire();
        if(message === 'Sector_scrolltoAdditionalSection')
        {
            
            var yeldiv = component.find("additionalsectiondiv").getElement();
            yeldiv.scrollIntoView({block:'center',behavior: 'smooth'});
            
          /*  var yeldiv = document.getElementById('additionalsectiondiv');
            console.log('yeldiv11');
            console.log(yeldiv);
            yeldiv.scrollIntoView({block:'center',behavior: 'smooth'});
            console.log('yeldiv');
            console.log(yeldiv);
            var offset=yeldiv.getBoundingClientRect();
            console.log('offset');
            console.log(offset);
            var scrollOptions = {
                left: offset.left,
                top: offset.top,
                behavior: 'smooth'
            }
            console.log(scrollOptions); */
            
           /*  var offset=yeldiv.getBoundingClientRect();
            console.log('offset');
            console.log(offset);
            var scrollOptions = {
                left: offset.left,
                top: offset.top,
                behavior: 'smooth'
            }
            console.log(scrollOptions);
            window.scrollTo(scrollOptions);*/
            
            
            
            event.stopPropagation();
        }

    },
    
    //search option in picklist
    filterOptions : function( component, event, helper ) {
        var a = event.getSource();
        var id = a.getLocalId();
        console.log('line 12');
        console.log(id);
        if( id === 'inputLookup') {
            console.log('filter');
            //helper.filterOptionsDataHelper(component);
            if(!$A.util.isEmpty(component.get('v.searchString'))){
                console.log(id);
                console.log('filter');
                component.set("v.message", '');
                var searchText = component.get('v.searchString');
                var options = component.get("v.options");
                var minChar = component.get('v.minChar');
                if(searchText.length >= minChar) {
                    var flag = true;
                    options.forEach( function(element,index) {
                        if(element.label.toLowerCase().trim().startsWith(searchText.toLowerCase().trim())) {
                            element.isVisible = true;
                            flag = false;
                        } else {
                            element.isVisible = false;
                        }
                    });
                    component.set("v.options",options);
                    if(flag) {
                        component.set("v.message", "No results found for '" + searchText + "'");
                    }
                }
                $A.util.addClass(component.find('resultsDiv'),'slds-is-open');
            }
        }
        else if (id === 'inputLookup1' ) {
            if(!$A.util.isEmpty(component.get('v.searchString1'))){
                console.log('filter inside lookup1');
                component.set("v.message", '');
                var searchText = component.get('v.searchString1');
                var options = component.get("v.options1");
                var minChar = component.get('v.minChar');
                if(searchText.length >= minChar) {
                    var flag = true;
                    options.forEach( function(element,index) {
                        if(element.label.toLowerCase().trim().startsWith(searchText.toLowerCase().trim())) {
                            element.isVisible = true;
                            flag = false;
                        } else {
                            element.isVisible = false;
                        }
                    });
                    component.set("v.options1",options);
                    if(flag) {
                        component.set("v.message", "No results found for '" + searchText + "'");
                    }
                }
                $A.util.addClass(component.find('resultsDiv1'),'slds-is-open');
            }
        }
            else if(id === 'inputLookup2'){
                if(!$A.util.isEmpty(component.get('v.searchString2'))){
                    console.log('filter inside lookup2');
                    component.set("v.message", '');
                    var searchText = component.get('v.searchString2');
                    var options = component.get("v.options2");
                    var minChar = component.get('v.minChar');
                    if(searchText.length >= minChar) {
                        var flag = true;
                        options.forEach( function(element,index) {
                            if(element.label.toLowerCase().trim().startsWith(searchText.toLowerCase().trim())) {
                                element.isVisible = true;
                                flag = false;
                            } else {
                                element.isVisible = false;
                            }
                        });
                        component.set("v.options2",options);
                        if(flag) {
                            component.set("v.message", "No results found for '" + searchText + "'");
                        }
                    }
                    $A.util.addClass(component.find('resultsDiv2'),'slds-is-open');
                }
            }
                else if(id === 'inputLookup3'){
                    if(!$A.util.isEmpty(component.get('v.searchString3'))){
                        component.set("v.message", '');
                        var searchText = component.get('v.searchString3');
                        var options = component.get("v.options3");
                        var minChar = component.get('v.minChar');
                        if(searchText.length >= minChar) {
                            var flag = true;
                            options.forEach( function(element,index) {
                                if(element.label.toLowerCase().trim().startsWith(searchText.toLowerCase().trim())) {
                                    element.isVisible = true;
                                    flag = false;
                                } else {
                                    element.isVisible = false;
                                }
                            });
                            component.set("v.options3",options);
                            if(flag) {
                                component.set("v.message", "No results found for '" + searchText + "'");
                            }
                        }
                        $A.util.addClass(component.find('resultsDiv3'),'slds-is-open');
                    }
                }
        //site
        
                    else if(id === 'inputLookup4'){
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
        
        
        
        
        
        
        //
                        else {
                            if(id === 'inputLookup')
                                $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
                            else if(id === 'inputLookup1')
                                $A.util.removeClass(component.find('resultsDiv1'),'slds-is-open');
                                else if(id === 'inputLookup2')
                                    $A.util.removeClass(component.find('resultsDiv2'),'slds-is-open');
                                    else if(id === 'inputLookup3')
                                        $A.util.removeClass(component.find('resultsDiv3'),'slds-is-open');
                        }
    },
    
    // option selected
    selectItem : function( component, event, helper ) {
        if(!$A.util.isEmpty(event.currentTarget.id)) {
            console.log('test line 20');
            console.log(event.currentTarget.id);
            console.log('line 174');
            console.log(component.find("fruitsSection"));
            helper.selectOptionHelper(component, event);
        }
    },
    selectItem1 : function( component, event, helper ) {
        if(!$A.util.isEmpty(event.currentTarget.id)) {
            helper.selectOptionHelper1(component, event);
        }
    },
    selectItem2 : function( component, event, helper ) {
        if(!$A.util.isEmpty(event.currentTarget.id)) {
            helper.selectOptionHelper2(component, event);
        }
    },
    selectItem3 : function( component, event, helper ) {
        if(!$A.util.isEmpty(event.currentTarget.id)) {
            helper.selectOptionHelper3(component, event);
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
        if(!disabled) {
            
            if(id == 'inputLookup'){
                component.set("v.message", '');
                component.set('v.searchString', '');
                var options = component.get("v.options");
                options.forEach( function(element,index) {
                    element.isVisible = true;
                });
                component.set("v.options", options);
                if(!$A.util.isEmpty(component.get('v.options'))) {
                    $A.util.addClass(component.find('resultsDiv'),'slds-is-open');
                }
            }
            else if(id == 'inputLookup1'){
                component.set("v.message", '');
                component.set('v.searchString1', '');
                var options = component.get("v.options1");
                options.forEach( function(element,index) {
                    element.isVisible = true;
                });
                component.set("v.options1", options);
                if(!$A.util.isEmpty(component.get('v.options1'))) {
                    $A.util.addClass(component.find('resultsDiv1'),'slds-is-open');
                }
            }
                else if(id == 'inputLookup2'){
                    component.set("v.message", '');
                    component.set('v.searchString2', '');
                    var options = component.get("v.options2");
                    options.forEach( function(element,index) {
                        element.isVisible = true;
                    });
                    component.set("v.options2", options);
                    if(!$A.util.isEmpty(component.get('v.options2'))) {
                        $A.util.addClass(component.find('resultsDiv2'),'slds-is-open');
                    }
                }
                    else if(id == 'inputLookup3'){
                        component.set("v.message", '');
                        component.set('v.searchString3', '');
                        var options = component.get("v.options3");
                        options.forEach( function(element,index) {
                            element.isVisible = true;
                        });
                        component.set("v.options3", options);
                        if(!$A.util.isEmpty(component.get('v.options3'))) {
                            $A.util.addClass(component.find('resultsDiv3'),'slds-is-open');
                        }
                    }
            		//Site
                        else if(id == 'inputLookup4'){
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
            
        }
    },
    
    // To remove the selected item.
    closePill : function( component, event, helper ){
        //helper.removeOptionPillHelper(component, event);
        var disable = component.get("v.disabled");
        if(disable == false){
            var value = event.getSource().get('v.name');
            var multiSelect = component.get('v.multiSelect');
            var count = 0;
            var options = component.get("v.options");
            var values = component.get('v.values') || [];
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
                component.set('v.searchString', count + ' options selected');
            component.set('v.values', values)
            component.set("v.options", options);
        }            
    },
    
    closePill1 : function( component, event, helper ){
        var disable = component.get("v.disabled");
        if(disable == false){
            var value = event.getSource().get('v.name');
            var multiSelect = component.get('v.multiSelect');
            var count = 0;
            var options = component.get("v.options1");
            var values = component.get('v.values1') || [];
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
                component.set('v.searchString1', count + ' options selected');
            component.set('v.values1', values)
            component.set("v.options1", options);
        }
    },
    closePill2 : function( component, event, helper ){
        var disable = component.get("v.disabled");
        if(disable == false){
            var value = event.getSource().get('v.name');
            var multiSelect = component.get('v.multiSelect');
            var count = 0;
            var options = component.get("v.options2");
            var values = component.get('v.values2') || [];
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
                component.set('v.searchString2', count + ' options selected');
            component.set('v.values2', values)
            component.set("v.options2", options);
        }
    },
    closePill3 : function( component, event, helper ){
        var disable = component.get("v.disabled");
        if(disable == false){
            var value = event.getSource().get('v.name');
            var multiSelect = component.get('v.multiSelect');
            var count = 0;
            var options = component.get("v.options3");
            var values = component.get('v.values3') || [];
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
                component.set('v.searchString3', count + ' options selected');
            component.set('v.values3', values)
            component.set("v.options3", options);
        }
        
    },
    /*closePill4 : function( component, event, helper ){
        var disable = component.get("v.disabled");
        if(disable == false){
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
        }
        
    },*/
    
    // To close the dropdown if clicked outside the dropdown.
    handleBlur : function( component, event, helper ){
        helper.handleBlurHelper(component, event);
    },
    handleSaveRecord : function( component, event, helper ){
        helper.handleBlurHelper(component, event);
        //console.log(component.get("v.values"));
        //console.log(component.get("v.values1"));
        //console.log(component.get("v.values2"));
        //console.log(component.get("v.values3"));
        console.log('398');
        console.log(component.get("v.values4"));
        
        var selectedvalues4 =[];
        var values4 = component.get('v.values4');
        for(let k in values4){
            selectedvalues4.push(values4[k].value);
        }
        //console.log('404');
        //console.log(selectedvalues4);
        var action1 = component.get("c.saveRecords")
        action1.setParams({
            recId : component.get("v.recordId"),
            selectedValueFulfill : component.get("v.values"),
            selectedValueRegion : component.get("v.values1"),
            selectedValueCountry : component.get("v.values2"),
            selectedValueCity : component.get("v.values3"),
            //selectedSite : selectedvalues4
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
        
    },
    handleEdit : function( component, event, helper ){
        
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
        component.set('v.disabled', edit)
        component.set("v.disabled1", save);
        $A.get('e.force:refreshView').fire();
    }
    
})