({
    init : function(component, event, helper)
    {
        console.log('line 4 init');
        console.log(component.get("v.EditProductsnew"));
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
    closeModel: function(component, event, helper)
    {
		component.set("v.showcomponent", false);
    },
    onRecordSubmit: function(component, event, helper)
    {
        var addedproduct  = component.get("v.AddedProductsList");
		if(addedproduct == null || addedproduct.length == 0)
            alert('Please select atleast one product.');
        else
        {
            var yearlist = [{label: 'Select Option' , value: null }];           
            const d = new Date();
            for(var i = 2020; i <= 2120; i++)
            {
                yearlist[yearlist.length] = {label: i , value: i } ;
            }
            for(var k = 0; k < addedproduct.length; k++)
            {
                addedproduct[k].Indexnum = k;
                addedproduct[k].Volume = 0;
                addedproduct[k].Revenue = 0;
                addedproduct[k].ProductProfit = 0;
                addedproduct[k].co2Emission = 0; 
                
                addedproduct[k].startyear = null; 
                addedproduct[k].optionsstartyear = yearlist; 
                addedproduct[k].endyear = null; 
                addedproduct[k].optionsendyear = []; 
                addedproduct[k].carbonEmission = 0;
            }
            component.set("v.AddedProductsList", addedproduct);
            component.set("v.EditProductsnew", true);
        }
    },
    ShowAddedProduct : function(component, event, helper)
    {
        if(component.get("v.ShowAddProduct") == true)
            component.set("v.ShowAddProduct", false);
        else
            component.set("v.ShowAddProduct", true);
    },
    AddProductRowAction : function(component, event, helper)
    {
        var action = event.getParam('action');
        var row = event.getParam('row');
        console.log('line 75 in add product');
        console.log(row);
        switch (action.name) {
            case 'Add_Product':
                var addedproduct  = component.get("v.AddedProductsList");
                console.log("line 80");
                console.log(addedproduct);
                addedproduct.push(row);
                console.log(addedproduct);
                component.set("v.Productaddedinfotext", 'Show Selected ('+addedproduct.length+')');
                component.set("v.AddedProductsList", addedproduct);
                break;
        }
    },
    AddedProductRowAction : function(component, event, helper)
    {
        var action = event.getParam('action');
        var row = event.getParam('row');
        switch (action.name) {
            case 'delete_Product':
                var addedproduct  = component.get("v.AddedProductsList");
                for(var i = 0; i < addedproduct.length; i++)
                {
                    if(row.ProductId == addedproduct[i].ProductId)
                    {
                        addedproduct.splice(i, 1);
                        component.set("v.Productaddedinfotext", 'Show Selected ('+addedproduct.length+')');
                        component.set("v.AddedProductsList", addedproduct);
                        break;
                    }
                }
                break;
        }
    },
    SearchProducts : function(component, event, helper)
    {
        helper.getproductdetails(component, event, helper);
    }
})