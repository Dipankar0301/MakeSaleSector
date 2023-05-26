({ 
    init : function(component, event, helper) {
        //init method
        const device = $A.get("$Browser.formFactor");
        component.set('v.device',device);
        var defOpts=[]; 
        var opts=[];
        var cols=component.get("v.columns");
        var allCols=component.get("v.allColumns");
        
        console.log(allCols);
        cols.forEach(function(ele){
            if(!$A.util.isEmpty(ele.label)){
                
                if(ele.label == 'CP Type')
                    ele.label='Call Plan Type';
                
                defOpts.push(ele.label);  
            }          
        });
        
        allCols.forEach(function(elem){
            if(!$A.util.isEmpty(elem.label)){
                if(elem.label =='CP Type'){
                    elem.label='Call Plan Type';
                }
                var obj={value:elem.label,label:elem.label};
                opts.push(obj); 
            }          
        });

       opts.forEach(function(t){
            if((t.label=='Start Date Time' || t.label=='End Date Time'  ) && defOpts.indexOf(t.label)==-1) 
                defOpts.push(t.label);
           
        });

        component.set("v.options",opts);
        component.set("v.defaultOptions",defOpts);
        
    },
    handleChange : function(component, event, helper) {
        var selectedOptionValue = event.getParam("value");
        console.log(selectedOptionValue);
        
    },
    
    applyChanges : function(component,event,helper) {
        var col=[];
        var val = component.get("v.defaultOptions");
        var allCols=component.get("v.allColumns");
        var a;
        col.push(allCols[0].value);
        col.push(allCols[1].value);
        if(val.indexOf('Start Date Time')==-1){
            val.push('Start Date Time');
        }
        if(val.indexOf('End Date Time')==-1){
            val.push('End Date Time');
        }
        var i=0;
        var k=8-val.length;
        if(val.length <8){
            
         allCols.forEach(function(t){  
             if(i<k){
                 if( val.indexOf(t.label)==-1) {
                      i++;
                     val.push(t.label);
                 }
             }
        });   
        }
        console.log(val);
        val.forEach(function(e){
            if(!$A.util.isEmpty(e)){ 
                a=allCols.filter(function(v){ 
                    if(v.label==e  ) 
                        return v.label==e?v.value:''; 
                });
                if(!$A.util.isEmpty(a)){
                    if(val[val.length -1] !=e && val[val.length -2] !=e){
                    if($A.util.isEmpty(a[0].value.initialWidth))
                    a[0].value.initialWidth=100;
                    }
                    col.push(a[0].value); 
                }                    
                                       
            }      
        }); 
        
        //col[col.length -1].initialWidth=70;
        console.log(col);
        component.set("v.columns",col);
        var appEvents = $A.get("e.c:Sector_CallPlanLstViewEvent");
        appEvents.setParams({
            "columns":component.get("v.columns"),
            "action":"setCols"
        }).fire();          
        component.find("overlayLib").notifyClose();   
    }
})