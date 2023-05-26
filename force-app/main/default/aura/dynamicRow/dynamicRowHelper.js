({
    createObjectData: function(component, event) {
        // Venkta code Added here . 
         var parentAction = component.get('c.CheckforApproval');
        parentAction.setParams({parentRecID:component.get("v.recordId")});
        
        parentAction.setCallback(this, function(response){           
           component.set("v.validateSave",response.getReturnValue());
             });
        $A.enqueueAction(parentAction);
        
        
        
        
        
        // get the contactList from component and add(push) New Object to List 
        
        var action = component.get('c.findFinancials');
        action.setParams({
            
            recId:component.get("v.recordId")
            
        });
        
        
        
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === 'SUCCESS') {
                console.log(response.getReturnValue());
                //alert('=Length='+response.getReturnValue().length);
                if(response.getReturnValue().length > 0){
                    component.set('v.contactList', response.getReturnValue());
                }
                else{
                    
                    var RowItemList = component.get("v.contactList");
                    RowItemList.push({
                        'sobjectType': 'Financial__c',
                        'NE_CAPEX__c': '',
                        'Non_NE_CAPEX_M__c': '',
                        'FEASEX_M__c': '',
                        'Year__c': '',
                        'OPEX_M__c' :'',
                        'NEPM_Total_net_credits__c':'',
                        'Project__c':component.get("v.recordId")
                    });
                    // set the updated list to attribute (contactList) again  
                    //alert('=RowItemList='+JSON.stringify(RowItemList));  
                    component.set("v.contactList", RowItemList);
                    
                    
                }
            }
        });
        
        $A.enqueueAction(action);
            
    },
    onloadGetRecordtype:function(component,event){
        
        var parentAction = component.get('c.checkforRecordtypeName');
        parentAction.setParams({parentRecID:component.get("v.recordId")});
        
        parentAction.setCallback(this, function(response){           
           component.set("v.RecordtypeDeveloperName",response.getReturnValue());
             });
        $A.enqueueAction(parentAction);
    },
    //The venkata code. 
   initialValidateMethod: function(component, event) {  
        var isValid;
    var parentAction = component.get('c.CheckforApproval');
        parentAction.setParams({parentRecID:component.get("v.recordId")});
        
        parentAction.setCallback(this, function(response){
           // component.set('v.validateSave', response.getReturnValue());
           // alert('suhas here '+component.get('v.validateSave'));
           isValid = response.getReturnValue();
            if(isValid == true)
           this.helperToast("Alert!","Record was locked","error");
            
             });
        $A.enqueueAction(parentAction);
       
       return isValid;
   },
    // helper function for check if first Name is not null/blank on save  
    validateRequired: function(component, event) {
        var isValid = true;
        var financeList = new Array();
        var allContactRows = component.get("v.contactList");
        for (var indexVar = 0; indexVar < allContactRows.length; indexVar++) {
            if (allContactRows[indexVar].Year__c < 1000 || allContactRows[indexVar].Year__c > 3000 || allContactRows[indexVar].Year__c ==null) {
                isValid = false;
                //alert('NE CAPEX Name Can\'t be Blank on Row Number ' + (indexVar + 1));
                //alert("Invalid Entry: Please enter the valid Year");
                this.helperToast("Alert!","Please enter the valid Year","error");
            }
            else if((isNaN(allContactRows[indexVar].FEASEX_M__c) &&(allContactRows[indexVar].FEASEX_M__c != null) )|| (isNaN(allContactRows[indexVar].NE_CAPEX__c) && (allContactRows[indexVar].NE_CAPEX__c !=null)) || (isNaN(allContactRows[indexVar].Non_NE_CAPEX_M__c) && (allContactRows[indexVar].Non_NE_CAPEX_M__c!=null)) || isNaN(allContactRows[indexVar].Year__c)){
                //alert('=Not a Number=');
                isValid = false;
                this.helperToast("Alert!","Input Invalid: Please Enter Valid Number","error");

            }
            else{
                
                financeList.push(allContactRows[indexVar].Year__c);
                
            }
        }
        if(financeList.length>0){
            //alert('=financeList='+financeList);
            //=financeList=2016,2018,2017,2015,2015
            for ( var i = 0; i < financeList.length; i++){
                
                for (var j = i+1; j< financeList.length; j++){
                    //if(financeList[i]!=null && financeList[j]!=null){
                    var x= financeList[i].toString();
                    var y= financeList[j].toString();
                    //alert('x'+x);
                    //alert('y'+y);
                    
                    //if (financeList [i] === financeList [j]){
                    if(x == y){
                        //alert('=Inside=')
                        isValid = false;
                        //console.log(array[i]);
                        //alert('duplicate found')
                        this.helperToast("Alert!","Single Entry is allowed per Year","error");
                    }
                //}
                   /* else{
                    	isValid = false;
						this.helperToast("Alert!","Please enter the valid Year","error");
                        
                    }*/
                }
            }
            
        }
        return isValid;
    },
     helperToast : function(title,message,type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message":message,
            "type":type
        });
        toastEvent.fire();          
    },
    toggleHelper : function(component,event) {
    var toggleText = component.find("tooltip");
    $A.util.toggleClass(toggleText, "toggle");
   }
    
})