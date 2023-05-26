({
    doInitStartHelperSite : function(component){
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
                                console.log('selected site records');
                                console.log(response.getReturnValue());
                                var selectedValues = response.getReturnValue();
                                var tempArray1 = [];
                                var tempArray2 = [];
                                for(var element in selectedValues){
                                    var name1 = selectedValues[element];
                                    var opt= { label:name1.Name, value:name1.Id }; 
                                    tempArray1.push(opt);
                                    tempArray2.push(name1.Id);
                                    
                                }
                                console.log('tempArray1');
                                console.log(tempArray1);
                                component.set('v.values4', tempArray1);
                                component.set('v.values4id', tempArray2);
                                var countval=0;
                                var options1 = component.get("v.options4");
                                //var options2 = component.get("v.options4id");
                                var values1 = component.get("v.values4");
                                //var values2 = component.get("v.values4id");
                                options1.forEach( function(element, index) {
                                    if( !$A.util.isEmpty(values1))
                                        for(let i=0;i<values1.length;i++){
                                            if(element.value == values1[i].value) {
                                            console.log('element id');
                                            console.log(element.value);
                                            console.log('values id');
                                            console.log(values1[i].value);
                                            //if(element.id == values1[i].id) {
                                                element.selected = true;
                                                countval++;
                                            }
                                        }
                                });
                                console.log('options1');
                                console.log(options1);
                                component.set("v.options4",options1);
                                component.set('v.searchString4', countval + ' options selected');
                                console.log(component.get('v.searchString4'));
                            }
                        }
                    })
                    $A.enqueueAction(action2);  
                    var searchString;
                    var count = 0;
                    var multiSelect = component.get('v.multiSelect');
                    var options = component.get('v.options4');
                    
                    let tempArray = [];
                    //let tempArray1 = [];
                    let arrayMapKeys = [];
                    arrayMapKeys = response.getReturnValue();
                    //console.log(arrayMapKeys);
                    for(var element in arrayMapKeys){
                        var name1 = arrayMapKeys[element];
                        var opt= { label:name1.Name, value:name1.Id }; 
                        tempArray.push(opt);
                        //tempArray1.push(name1.Id);
                    }
                    component.set('v.options4', tempArray);
                   
                    //component.set('v.parentAccountId',arrayMapKeys[0].Account__c);
                     //console.log('line 81');
                    console.log(component.get('v.parentAccountId'));
                    //component.set('v.options4id', tempArray1);
                    console.log('options4');
                    console.log(tempArray);
                }
            }
        })
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
        if(id === 'inputLookup4'){
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
            $A.util.removeClass(component.find('resultsDiv4'),'slds-is-open');
        }
    },
})