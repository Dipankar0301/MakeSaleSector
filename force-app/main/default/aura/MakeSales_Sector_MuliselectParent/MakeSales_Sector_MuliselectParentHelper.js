({
    
   
    doInitStartHelper : function(component) {
        $A.util.toggleClass(component.find('resultsDiv'),'slds-is-open');
        $A.util.toggleClass(component.find('resultsDiv1'),'slds-is-open');
        $A.util.toggleClass(component.find('resultsDiv2'),'slds-is-open');
        $A.util.toggleClass(component.find('resultsDiv3'),'slds-is-open');
        var fieldListtemp = component.get("v.fieldList");
        var values = component.get('v.values');
        var values1 = component.get('v.values1');
        var values2 = component.get('v.values2');
        var values3 = component.get('v.values3');
        var action1 = component.get("c.getPicklistValues");
        action1.setParams({
            recId : component.get("v.recordId")
        });
        action1.setCallback(this, function(response){
            if(response.getState()=="SUCCESS"){
                if(response.getReturnValue() != null){
                    var action2 = component.get("c.getRecord");
                    action2.setParams({
                        recId : component.get("v.recordId")
                    });
                    action2.setCallback(this, function(response){
                        if(response.getState()=="SUCCESS"){
                            if(response.getReturnValue() != null){
                                var selectedValues = response.getReturnValue();
                                
                                for(var field in fieldListtemp){
                                    var key = fieldListtemp[field];
                                    var arrayMapKeys = [];
                                    arrayMapKeys = selectedValues[key];
                                    let tempArray = []; 
                                    for(var element in arrayMapKeys){
                                        var name1 = arrayMapKeys[element];
                                        tempArray.push(name1); 
                                        
                                    }
                                    if(key == 'Fulfilled')
                                        component.set("v.values",tempArray);
                                    if(key == 'Region')
                                        component.set("v.values1",tempArray);
                                    if(key == 'Country')
                                        component.set("v.values2",tempArray);
                                    if(key == 'City')
                                        component.set("v.values3",tempArray);
                                }
                                //fullfilled by
                                var options = component.get("v.options");
                                var values = component.get("v.values");
                                var values1 = component.get("v.values1");
                                var values2 = component.get("v.values2");
                                var values3 = component.get("v.values3");
                                var countval=0;
                                var countval1=0;
                                var countval2=0;
                                var countval3=0;
                                if( !$A.util.isEmpty(values))
                                    countval=values.length;
                                if( !$A.util.isEmpty(values1))
                                    countval1=values1.length;
                                if( !$A.util.isEmpty(values2))
                                    countval2=values2.length;
                                if( !$A.util.isEmpty(values3))
                                    countval3=values3.length;
                                options.forEach( function(element, index) {
                                    if( !$A.util.isEmpty(values)){
                                        for(let i=0;i<values.length;i++){
                                            if(element.label == values[i]) {
                                                element.selected = true;
                                            }
                                        }
                                    }
                                });
                                component.set("v.options",options);
                                component.set('v.searchString', countval + ' options selected');
                                //region
                                
                                var options1 = component.get("v.options1");
                                var values1 = component.get("v.values1");
                                options1.forEach( function(element, index) {
                                    if( !$A.util.isEmpty(values1))
                                        for(let i=0;i<values1.length;i++){
                                            if(element.label == values1[i]) {
                                                element.selected = true;
                                            }
                                        }
                                });
                                component.set("v.options1",options1);
                                component.set('v.searchString1', countval1 + ' options selected');
                                //country
                                
                                var options2 = component.get("v.options2");
                                
                                var values2 = component.get("v.values2");
                                
                                options2.forEach( function(element, index) {
                                    if( !$A.util.isEmpty(values2))
                                        for(let i=0;i<values2.length;i++){
                                            if(element.label == values2[i]) {
                                                element.selected = true;
                                            }
                                        }
                                });
                                component.set("v.options2",options2);
                                component.set('v.searchString2', countval2 + ' options selected');
                                //city
                                
                                var options3 = component.get("v.options3");
                                var values3 = component.get("v.values3");
                                options3.forEach( function(element, index) {
                                    if( !$A.util.isEmpty(values3)){
                                        for(let i=0;i<values3.length;i++){
                                            if(element.label == values3[i]) {
                                                element.selected = true;
                                                console.log(element.selected);
                                            }
                                        }
                                    }
                                });
                                component.set("v.options3",options3);
                                component.set('v.searchString3', countval3 + ' options selected');
                            }
                        }
                    });
                    $A.enqueueAction(action2);                   
                    
                    
                    
                    
                    var result = response.getReturnValue();
                    for(var field in fieldListtemp){
                        var key = fieldListtemp[field];
                        var arrayMapKeys = [];
                        arrayMapKeys = result[key];
                        var test = result[key];
                        let tempArray = []; 
                        for(var element in arrayMapKeys){
                            var name1 = arrayMapKeys[element];
                            var opt= { label:name1, value:name1 }; 
                            tempArray.push(opt); 
                            
                        }
                        if(key == 'Fulfilled'){
                            component.set("v.options", tempArray);
                            if( !$A.util.isEmpty(values) ) {
                                var searchString;
                                var count = 0;
                                var multiSelect = component.get('v.multiSelect');
                                var options = component.get('v.options');
                                options.forEach( function(element, index) {
                                    if(multiSelect) {
                                        if(values.includes(element.value)) {
                                            element.selected = true;
                                            count++;
                                        }  
                                    } else {
                                        if(element.value == value) {
                                            searchString = element.label;
                                        }
                                    }
                                });
                                if(multiSelect)
                                    component.set('v.searchString', count + ' options selected');
                                else
                                    component.set('v.searchString', searchString);
                                component.set('v.options', options);
                            }
                        }
                        else if(key == 'Region'){
                            component.set("v.options1", tempArray);
                            if( !$A.util.isEmpty(values1) ) {
                                var searchString;
                                var count = 0;
                                var multiSelect = component.get('v.multiSelect');
                                var options1 = component.get('v.options1');
                                options1.forEach( function(element, index) {
                                    if(multiSelect) {
                                        if(values1.includes(element.value)) {
                                            element.selected = true;
                                            count++;
                                        }  
                                    } else {
                                        if(element.value == value) {
                                            searchString = element.label;
                                        }
                                    }
                                });
                                if(multiSelect)
                                    component.set('v.searchString1', count + ' options selected');
                                else
                                    component.set('v.searchString1', searchString);
                                component.set('v.options1', options1);
                            }
                        }
                            else if(key == 'Country'){
                                component.set("v.options2", tempArray);
                                if( !$A.util.isEmpty(values2) ) {
                                    var searchString;
                                    var count = 0;
                                    var multiSelect = component.get('v.multiSelect');
                                    var options2 = component.get('v.options2');
                                    options2.forEach( function(element, index) {
                                        if(multiSelect) {
                                            if(values2.includes(element.value)) {
                                                element.selected = true;
                                                count++;
                                            }  
                                        } else {
                                            if(element.value == value) {
                                                searchString = element.label;
                                            }
                                        }
                                    });
                                    if(multiSelect)
                                        component.set('v.searchString2', count + ' options selected');
                                    else
                                        component.set('v.searchString2', searchString);
                                    component.set('v.options2', options2);
                                }
                            }
                                else if(key == 'City'){
                                    component.set("v.options3", tempArray);
                                    if( !$A.util.isEmpty(values3) ) {
                                        var searchString;
                                        var count = 0;
                                        var multiSelect = component.get('v.multiSelect');
                                        var options3 = component.get('v.options3');
                                        options3.forEach( function(element, index) {
                                            if(multiSelect) {
                                                if(values3.includes(element.value)) {
                                                    element.selected = true;
                                                    count++;
                                                }  
                                            } else {
                                                if(element.value == value) {
                                                    searchString = element.label;
                                                }
                                            }
                                        });
                                        if(multiSelect)
                                            component.set('v.searchString3', count + ' options selected');
                                        else
                                            component.set('v.searchString3', searchString);
                                        component.set('v.options3', options3);
                                    }
                                }
                        
                    }
                    console.log('165');
                    console.log(component.get("v.options2"));
                }
                else{
                    console.log('Returned values are null');
                }
                
            }
        });
        $A.enqueueAction(action1);
    },
    
    filterOptionsDataHelper : function(component) {
        var a = event.getSource();
        var id = a.getLocalId();
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
    },
    
    selectOptionHelper : function(component, event) {
        var options = component.get('v.options');
        var multiSelect = component.get('v.multiSelect');
        var searchString = component.get('v.searchString');
        var values = component.get('v.values') || [];
        var count = 0;
        options.forEach( function(element, index) {
            if(element.value === event.currentTarget.id) {
                if(multiSelect) {
                    if(values.includes(element.value)) {
                        values.splice(values.indexOf(element.value), 1);
                    } else {
                        values.push(element.value);
                    }
                    element.selected = element.selected ? false : true;   
                } 
            }
            if(element.selected) {
                count++;
            }
        });
        component.set('v.values', values);
        component.set('v.options', options);
        if(multiSelect)
            component.set('v.searchString', count + ' options selected');
        else
            component.set('v.searchString', searchString);
        if(multiSelect)
            event.preventDefault();
        else
            $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
        
        console.log('line 128');
        console.log(component.get("v.values"));
        
    },
    selectOptionHelper3 : function(component, event) {
        var options3 = component.get('v.options3');
        var multiSelect = component.get('v.multiSelect');
        var searchString = component.get('v.searchString3');
        var values = component.get('v.values3') || [];
        var count = 0;
        options3.forEach( function(element, index) {
            if(element.value === event.currentTarget.id) {
                if(multiSelect) {
                    if(values.includes(element.value)) {
                        values.splice(values.indexOf(element.value), 1);
                    } else {
                        values.push(element.value);
                    }
                    element.selected = element.selected ? false : true;   
                } 
            }
            if(element.selected) {
                count++;
            }
        });
        component.set('v.values3', values);
        component.set('v.options3', options3);
        if(multiSelect)
            component.set('v.searchString3', count + ' options selected');
        else
            component.set('v.searchString3', searchString);
        if(multiSelect)
            event.preventDefault();
        else
            $A.util.removeClass(component.find('resultsDiv3'),'slds-is-open');
        
    },
    
    
    selectOptionHelper2 : function(component, event) {
        var options2 = component.get('v.options2');
        var multiSelect = component.get('v.multiSelect');
        var searchString = component.get('v.searchString2');
        var values = component.get('v.values2') || [];
        var count = 0;
        options2.forEach( function(element, index) {
            if(element.value === event.currentTarget.id) {
                if(multiSelect) {
                    if(values.includes(element.value)) {
                        values.splice(values.indexOf(element.value), 1);
                    } else {
                        values.push(element.value);
                    }
                    element.selected = element.selected ? false : true;   
                } 
            }
            if(element.selected) {
                count++;
            }
        });
        component.set('v.values2', values);
        component.set('v.options2', options2);
        if(multiSelect)
            component.set('v.searchString2', count + ' options selected');
        else
            component.set('v.searchString2', searchString);
        if(multiSelect)
            event.preventDefault();
        else
            $A.util.removeClass(component.find('resultsDiv2'),'slds-is-open');
        
    },
    selectOptionHelper1 : function(component, event) {
        //console.log(component.get('v.options1'));
        var options1 = component.get('v.options1');
        var multiSelect = component.get('v.multiSelect');
        var searchString = component.get('v.searchString1');
        var values = component.get('v.values1') || [];
        var count = 0;
        options1.forEach( function(element, index) {
            if(element.value === event.currentTarget.id) {
                if(multiSelect) {
                    if(values.includes(element.value)) {
                        values.splice(values.indexOf(element.value), 1);
                    } else {
                        values.push(element.value);
                    }
                    element.selected = element.selected ? false : true;  
                    //console.log('332');
                } 
            }
            if(element.selected) {
                count++;
            }
        });
        console.log('419');
        console.log(component.get('v.values1'));
        component.set('v.values1', values);
        component.set('v.options1', options1);
        if(multiSelect)
            component.set('v.searchString1', count + ' options selected');
        else
            component.set('v.searchString1', searchString);
        if(multiSelect)
            event.preventDefault();
        else
            $A.util.removeClass(component.find('resultsDiv1'),'slds-is-open');
        
    },
    //site
    selectOptionHelper4 : function(component, event) {
        var options1 = component.get('v.options4');
        var multiSelect = component.get('v.multiSelect');
        var searchString = component.get('v.searchString4');
        var values = component.get('v.values4') || [];
        
        var count = 0;
        var flag = 0;
        options1.forEach( function(element, index) {
            if(element.value === event.currentTarget.id) {
                
                if( !$A.util.isEmpty(values)){
                    for(let i=0;i<values.length;i++){
                        console.log(values.length);
                        
                        if(element.value === values[i].value){
                            values.splice(i,1);
                            flag=1;
                            break;
                            
                        }
                        
                    }
                    if(flag==0){
                        var data = [];
                            data = {"label": element.label, "value": element.value };
                            values.push(data);
                    }
                    
                }
                else{
                    var data = [];
                    data = {"label": element.label, "value": element.value };
                    values.push(data);
                }
                element.selected = element.selected ? false : true;
                
            }
            if(element.selected) {
                count++;
            }
        });
        component.set('v.values4', values);
        component.set('v.options4', options1);
        if(multiSelect)
            component.set('v.searchString4', count + ' options selected');
        else
            component.set('v.searchString4', searchString);
        if(multiSelect)
            event.preventDefault();
        else
            $A.util.removeClass(component.find('resultsDiv4'),'slds-is-open');
    },
    handleBlurHelper : function(component, event) {
        var a = event.getSource();
        var id = a.getLocalId();
        if(id === 'inputLookup'){
            var multiSelect = component.get('v.multiSelect');
            var previousLabel;
            var count = 0;
            var options = component.get("v.options");
            options.forEach( function(element, index) {
                if(element.selected) {
                    count++;
                }
            });
            if(multiSelect)
                component.set('v.searchString', count + ' options selected');
            else
                component.set('v.searchString', previousLabel);
        }
        else if(id === 'inputLookup1'){
            var multiSelect = component.get('v.multiSelect');
            var previousLabel;
            var count = 0;
            var options = component.get("v.options1");
            options.forEach( function(element, index) {
                if(element.selected) {
                    count++;
                }
            });
            if(multiSelect)
                component.set('v.searchString1', count + ' options selected');
            else
                component.set('v.searchString1', previousLabel);
        }
            else if(id === 'inputLookup2'){
                var multiSelect = component.get('v.multiSelect');
                var previousLabel;
                var count = 0;
                var options = component.get("v.options2");
                options.forEach( function(element, index) {
                    if(element.selected) {
                        count++;
                    }
                });
                if(multiSelect)
                    component.set('v.searchString2', count + ' options selected');
                else
                    component.set('v.searchString2', previousLabel);
            }
                else if(id === 'inputLookup3'){
                    var multiSelect = component.get('v.multiSelect');
                    var previousLabel;
                    var count = 0;
                    var options = component.get("v.options3");
                    options.forEach( function(element, index) {
                        if(element.selected) {
                            count++;
                        }
                    });
                    if(multiSelect)
                        component.set('v.searchString3', count + ' options selected');
                    else
                        component.set('v.searchString3', previousLabel);
                }
                    else if(id === 'inputLookup4'){
                        var multiSelect = component.get('v.multiSelect');
                        var previousLabel;
                        var count = 0;
                        var options = component.get("v.options4");
                        options.forEach( function(element, index) {
                            if(element.selected) {
                                count++;
                            }
                        });
                        if(multiSelect)
                            component.set('v.searchString4', count + ' options selected');
                        else
                            component.set('v.searchString4', previousLabel);
                    }
        if(multiSelect){
            $A.util.removeClass(component.find('resultsDiv'),'slds-is-open');
            $A.util.removeClass(component.find('resultsDiv1'),'slds-is-open');
            $A.util.removeClass(component.find('resultsDiv2'),'slds-is-open');
            $A.util.removeClass(component.find('resultsDiv3'),'slds-is-open');
            $A.util.removeClass(component.find('resultsDiv4'),'slds-is-open');
        }
    },
    /*doInitStartHelperSite : function(component){
        $A.util.toggleClass(component.find('resultsDiv4'),'slds-is-open');
        var values = component.get('v.values4');
        var action1 = component.get("c.getSiteRecords");
        action1.setParams({
            recId : component.get("v.recordId")
        });
        action1.setCallback(this, function(response){
            if(response.getState()=="SUCCESS"){
                if(response.getReturnValue() != null){
                    //get selected values
                    var action2 = component.get("c.getSelectedSiteRecords");
                    action2.setParams({
                        recId : component.get("v.recordId")
                    });
                    action2.setCallback(this, function(response){
                        if(response.getState()=="SUCCESS"){
                            if(response.getReturnValue() != null){
                                var selectedValues = response.getReturnValue();
                               
                                var tempArray1 = [];
                                for(var element in selectedValues){
                                    var name1 = selectedValues[element];
                                    var opt= { label:name1.Name, value:name1.Id }; 
                                    //console.log(opt);
                                    tempArray1.push(opt); 
                                    
                                }
                                component.set('v.values4', tempArray1);
                                
                                var countval=0;
                                var options1 = component.get("v.options4");
                                var values1 = component.get("v.values4");
                                options1.forEach( function(element, index) {
                                    if( !$A.util.isEmpty(values1))
                                        for(let i=0;i<values1.length;i++){
                                            if(element.label == values1[i].label) {
                                                element.selected = true;
                                                countval++;
                                            }
                                        }
                                });
                                
                                component.set("v.options4",options1);
                                component.set('v.searchString4', countval + ' options selected');
                                
                                
                            }
                        }
                    })
                    $A.enqueueAction(action2);            
                    
                    //
                    var searchString;
                    var count = 0;
                    var multiSelect = component.get('v.multiSelect');
                    var options = component.get('v.options4');
                    
                    let tempArray = [];
                    let arrayMapKeys = [];
                    arrayMapKeys = response.getReturnValue();
                    //console.log(arrayMapKeys);
                    for(var element in arrayMapKeys){
                        var name1 = arrayMapKeys[element];
                        var opt= { label:name1.Name, value:name1.Id }; 
                        tempArray.push(opt); 
                        
                    }
                    component.set('v.options4', tempArray);
                }
            }
        })
        $A.enqueueAction(action1);
    },*/
})