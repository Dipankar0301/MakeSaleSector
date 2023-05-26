({
    init : function(component, event, helper)
    {
        if(component.get("v.LoadProduct") == true)
            helper.getEditProductDetails(component, event, helper);
        
    },
    closeModel: function(component, event, helper)
    {
        component.set("v.showcomponent", false);
    },
    onRecordSubmit: function(component, event, helper)
    {
        var editproductlist = component.get("v.EditProductsList");
        console.log('line 15');
        console.log(editproductlist);
        var savedetails = true;
        for(var k = 0; k < editproductlist.length; k++)
        {
            if(editproductlist[k].Volume ===  "" || editproductlist[k].Revenue === "" ||  editproductlist[k].ProductProfit === "" || editproductlist[k].co2Emission === "" || editproductlist[k].carbonEmission === ""  )
            {
                savedetails = false;
                alert('Total Volume & Total Revenue (USD$) & Total Profit (USD$) & Total CO2 Emissions (Tonnes) & Total CO2 Emissions Reduction (Tonnes) is required to save the product details.');
                break;
            }
        }
        if(savedetails == true)
            helper.SaveEditProductDetails(component, event, helper);
        $A.get('e.force:refreshView').fire();
    },
    removeRow: function(component, event, helper)
    {
        var component_target = event.currentTarget;
        var deleterowId = component_target.dataset.myvalue;
        var editproductlist = component.get("v.EditProductsList");
        var deletedlist = component.get("v.deletedproducts");
        console.log('34');
        console.log(component_target);
        console.log(deleterowId);
        console.log(editproductlist);
        for(var k = 0; k < editproductlist.length; k++)
        {
            if(editproductlist[k].Indexnum == deleterowId)
            {
                if(editproductlist[k].OpportunityLineId != null)
                    deletedlist.push(editproductlist[k].OpportunityLineId);
                editproductlist.splice(k, 1);
                component.set("v.EditProductsList", editproductlist);
                component.set("v.deletedproducts", deletedlist);
                break;
            }
        }
    },
    
    onhandleChange: function(component, event, helper)
    {
        console.log('onchange==');
        console.log(event.getSource().get("v.name"));
        console.log(event.getSource().get("v.value"));
        
        var EditProductsList = component.get("v.EditProductsList");
        
        for(var k = 0; k < EditProductsList.length; k++)
        {
            if(EditProductsList[k].Indexnum === event.getSource().get("v.name"))
            {
                EditProductsList[k].startyear = EditProductsList[k].startyear;
                if(EditProductsList[k].startyear == null || EditProductsList[k].startyear == '')
                {
                    EditProductsList[k].endyear = null; 
                    EditProductsList[k].optionsendyear = []; 
                    console.log('inside null start date==');
                    console.log(EditProductsList[k].optionsendyear);
                }
                else
                {
                    var endyearlist = [];  
                    for(var i = EditProductsList[k].startyear; i <= 2120; i++)
                    {
                        endyearlist[endyearlist.length] = {label: i , value: i } ;
                    }
                    EditProductsList[k].endyear = EditProductsList[k].startyear; 
                    EditProductsList[k].optionsendyear = endyearlist; 
                }
                break;
            }
        }
        
        component.set("v.EditProductsList", EditProductsList);  
        
    },
    //added for new button in Product Selector. It will help us to visit the add products pop up again. from next line to till the end of all line.
    editRecord : function(component, event, helper) {
        
        
        var component_target = event.currentTarget;
        var editrowId = component_target.dataset.myvalue;
        var editproductlist = component.get("v.EditProductsList");
        console.log('104');
        console.log(component_target);
        console.log(editrowId);
        console.log(editproductlist);
        component.set("v.EditRowId",editrowId)
        var ShowAddProductspopUp = component.get('v.ShowAddProductspopUp');
        console.log('112');
        console.log(ShowAddProductspopUp);
        //component.set('v.ShowAddProductspopUp',true);
        //component.set('v.showAddnotEdit',false);
        
        component.set('v.AddProductcolumn', [
            {type: "button-icon", fixedWidth: 50, typeAttributes: {   
                name: 'Add_Product',
                iconName: 'utility:add'
            }},
            {label: 'Product Family', fieldName: 'ProductFamily', type: 'Text'},
            {label: 'Product Name', fieldName: 'ProductName', type: 'text'},
            {label: 'Product Unit', fieldName: 'ProductUnit', type: 'Text'}
        ]);
        component.set('v.AddedProductcolumn', [
            {label: 'Product Family', fieldName: 'ProductFamily', type: 'Text'},
            {label: 'Product Name', fieldName: 'ProductName', type: 'text'},
            {label: 'Product Unit', fieldName: 'ProductUnit', type: 'Text'},
            {type: "button-icon", fixedWidth: 70, typeAttributes: {   
                name: 'delete_Product',
                iconName: 'utility:delete',
                variant: 'error',
                class: "slds-icon slds-icon_small",
                size: "small"
            }}
        ]);
        helper.getproductdetails(component, event, helper);
        
    },
    AddProductRowAction : function(component, event, helper)
    {
        var deletedlist = component.get("v.deletedproducts");
        var action = event.getParam('action');
        var row = event.getParam('row');
        console.log('line 135');
        var jsObject = JSON.stringify(row);
        var objectValue = JSON.parse(jsObject);
        //console.log(JSON.parse(row));
        console.log(objectValue);
        console.log(objectValue.Product2Id);
        switch (action.name) {
            case 'Add_Product':
                var addedproduct  = component.get("v.EditProductsList");
                var editProductId = component.get("v.EditRowId");
                console.log(addedproduct);
                console.log(editProductId);
                for(var i = 0; i < addedproduct.length; i++)
                {
                    console.log(editProductId);
                    console.log(addedproduct[i].ProductId);
                    if(editProductId === addedproduct[i].Product2Id || editProductId === addedproduct[i].ProductId)
                    {
                        console.log('line 149');
                        console.log(addedproduct[i]);
                        deletedlist.push(addedproduct[i].OpportunityLineId);
                        addedproduct[i].Product2Id = objectValue.Product2Id;
                        addedproduct[i].ProductId = objectValue.ProductId;
                        addedproduct[i].OpportunityLineId = null;
                        addedproduct[i].Product = addedproduct[i].Product;
                        
                        component.set("v.deletedproducts", deletedlist);
                        console.log(component.get("v.EditProductsList"));
                        component.set("v.EditProductsList",addedproduct);
                        console.log(component.get("v.EditProductsList"));
                        break;
                    }
                }
                //component.set("v.EditProductsList",addedproduct);
                break;
        }
        var a = component.get('c.onRecordSubmit');
        $A.enqueueAction(a);
    },
    SearchProducts : function(component, event, helper)
    {
        helper.getproductdetails(component, event, helper);
    },
    calculateEmissions :function(component, event, helper)
    {
        var editproductlist = component.get("v.EditProductsList");
        let editproductlistApi;
        editproductlistApi = component.get("v.EditProductsListAPi");
        console.log(editproductlist);
        console.log(editproductlistApi);
        var recordId = component.get("v.recordId");
        console.log('line 185');
        var countCorrectProduct = 0;
        var errorMessage= '';
        var errorMessage1='Salesforce could not get emissions data for the following product(s), because the Emissions Factor Library did not contain emissions factors.';
        var errorMessage2 = '';
        var errorMessage3 = 'Emissions data was successfully retrieved for the following Product(s):';
        var errorMessage4 = '';
        for(var k = 0; k < editproductlist.length; k++)
        {
            console.log(editproductlist[k].Volume);
            if(editproductlist[k].Volume ===  "" || editproductlist[k].Volume ===  0 || editproductlist[k].Volume == 0 || editproductlist[k].Volume == "0" || editproductlist[k].Volume === "0")
            {
                console.log('line 198');
                console.log(editproductlist[k].Volume);
                errorMessage = errorMessage + editproductlist[k].ProductFamily +' - '+editproductlist[k].ProductName+'\n';
                
            }
            else if(editproductlist[k].Volume > 0){
                countCorrectProduct++;
                editproductlistApi.push(editproductlist[k]);
                //editproductlistApi.splice(0,);
            }
            if(editproductlist[k].carbonEmission === '')
            {
                editproductlist[k].carbonEmission = 0;
            }
            
        }
        console.log('line 214');
        console.log(errorMessage);
        console.log(countCorrectProduct);
        console.log(editproductlist);
        console.log(editproductlistApi);
        if(errorMessage != null && errorMessage !=""){
            $A.get("e.force:showToast").setParams({
                "title":'Please enter a Total Volume for the following product(s) in order to get Total Emissions from the Emissions Factor Library.',
                "mode": 'sticky',
                "type": 'info',
                "message": errorMessage,
                
            }).fire();
        }
        if(countCorrectProduct >0){
            console.log('line 229');
            var action = component.get("c.callApi");
            action.setParams({
                EditProductDetails : JSON.stringify(editproductlistApi),
                OppId : recordId,
            });
            action.setCallback(this, function(response){
                if(response.getState()=="SUCCESS")
                {
                    var responsedata = response.getReturnValue();
                    const map = new Map();
                    Object.keys(responsedata).forEach((key) => {
                        map.set(key, responsedata[key]);
                    });
                        console.log('line 243');
                        console.log(responsedata);
                        console.log(map);
                        for(var i = 0; i < editproductlist.length; i++){
                        
                        if(isNaN(map.get(editproductlist[i].ProductId + editproductlist[i].Volume))){
                        console.log('line 249');
                        console.log(map.get(editproductlist[i].ProductId + editproductlist[i].Volume));
                        if(map.get(editproductlist[i].ProductId + editproductlist[i].Volume) != null)
                        errorMessage2 = errorMessage2 + '\n' +map.get(editproductlist[i].ProductId + editproductlist[i].Volume);
                        editproductlist[i].carbonEmission = 0;
                    }
                        else{
                        console.log('line 256');
                        var coValue = parseFloat(map.get(editproductlist[i].ProductId + editproductlist[i].Volume));
                        console.log('line 258');
                        console.log(coValue);
                        editproductlist[i].carbonEmission = coValue;
                        errorMessage4 = errorMessage4 + '\n'+ editproductlist[i].ProductFamily +' - '+editproductlist[i].ProductName;
                    }
                        
                        
                    }
                        component.set("v.EditProductsList",editproductlist);  
                        //component.set("v.EditProductsListAPi",undefined); 
                        editproductlistApi.splice(0,editproductlist.length);
                        component.set("v.EditProductsListAPiTemp",editproductlistApi);
                        $A.get('e.force:refreshView').fire();  
                        if(errorMessage2 != '' && errorMessage2 != null){
                        	errorMessage1 = errorMessage1 + errorMessage2;
                        	$A.get("e.force:showToast").setParams({
                        		"title":'Unable to get Emissions data',
                        		"mode": 'sticky',
                        		"type": 'info',
                        		"message": errorMessage1,
                        
                    		}).fire();
                    
                		}
                		if(errorMessage4 != '' && errorMessage4 != null){
                        	errorMessage3 = errorMessage3 + errorMessage4;
                        	$A.get("e.force:showToast").setParams({
                        		"title":'Emissions Successfully Retrieved',
                        		"mode": 'sticky',
                        		"type": 'success',
                        		"message": errorMessage3,
                        
                    		}).fire();
                    
                }
            }
                               });
            
            $A.enqueueAction(action);
            console.log('line 252');
            $A.get('e.force:refreshView').fire();
        }
        console.log('line 243');
        
        
    },
    refresh : function(component,event,helper){
        
        // alert('reload done');
        
    },
    
})