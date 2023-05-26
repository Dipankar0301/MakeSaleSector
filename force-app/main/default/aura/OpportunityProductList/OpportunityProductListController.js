({
    init: function(component, event, helper) 
    {
		helper.getproductdetails(component, event, helper);
    },
    cancelClick : function(component, event, helper) {
        helper.getproductdetails(component, event, helper);
        $A.get('e.force:refreshView').fire();
    },
    AddYear : function(component, event, helper) {
        component.set("v.modalWindow", true);
       
        var prodetails = component.get("v.ProductDetails");
        if(prodetails != null && prodetails[0].ProductDetails != null && prodetails[0].ProductDetails.length > 0)
            component.set("v.newYear", ( parseInt(prodetails[0].ProductDetails[prodetails[0].ProductDetails.length - 1].YearOfProduct) ) + 1);
        else
        {
            const d = new Date();
            component.set("v.newYear",d.getFullYear()); 
        }
        
    },
    AddYears : function(component, event, helper) {
        
        var yearlist = [];           
        const d = new Date();
            
        for(var i = 2020; i <= 2120; i++)
        {
            yearlist[yearlist.length] = {label: i , value: i } ;
        }
        
        var endyearlist = [];  
        for(var i = d.getFullYear(); i <= 2120; i++)
        {
            endyearlist[endyearlist.length] = {label: i , value: i } ;
        }
        
        
        component.set("v.valuestartyear",d.getFullYear());
        component.set("v.valueendyear",d.getFullYear());
        component.set("v.optionsstartyear",yearlist);
        component.set("v.optionsendyear",endyearlist);
        component.set("v.modalWindowAddYears", true);
        
        
        
    },
    
     handlestartyearChange : function(component, event, helper) 
    {
       // var selectedOptionValue = parseInt(event.getParam("value"));
        var selectedOptionValue = parseInt(event.getSource().get("v.value"));
        
        
        var listofyears = [];
        for(var k = selectedOptionValue; k <= 2120; k++)
        {
            listofyears[listofyears.length] = {label: k , value: k, defaultvalue: false } ;
        }
        component.set("v.optionsendyear",listofyears);
        
        component.set("v.valuestartyear",selectedOptionValue);
        
        if(component.get("v.valueendyear") < component.get("v.valuestartyear"))
            component.set("v.valueendyear",selectedOptionValue);
        else
            component.set("v.valueendyear",component.get("v.valueendyear"));
        
        component.set("v.showendyear",false);
        component.set("v.showendyear",true);
       
    },
    
    handleendyearChange : function(component, event, helper) 
    {
        //var selectedOptionValue = parseInt(event.getParam("value"));
        var selectedOptionValue = parseInt(event.getSource().get("v.value"));
        component.set("v.valueendyear",selectedOptionValue);
    },
    
    QuickFillProducts : function(component, event, helper) 
    {
        component.set("v.modalWindowQuickFill",true);
    },
    
    closeModelQuickFill : function(component, event, helper) 
    {
        component.set("v.modalWindowQuickFill",false);
    },
    
    onRecordSubmitQuickFill : function(component, event, helper) 
    {
        var prodetails = component.get("v.ProductDetails");
        for(var productde of prodetails)
        {
            var EachVolume = productde.TotalVolume != null ? (productde.TotalVolume/productde.ProductDetails.length).toFixed(2) : 0;
            var EachRevenue = productde.TotalRevenue != null ? (productde.TotalRevenue/productde.ProductDetails.length).toFixed(2) : 0;
            var EacGrossMargin = productde.TotalGrossMargin != null ? (productde.TotalGrossMargin/productde.ProductDetails.length).toFixed(2) : 0;
            var EachCO2Emissions = productde.TotalCO2Emissions != null ? (productde.TotalCO2Emissions/productde.ProductDetails.length).toFixed(2) : 0;
            var EachCO2Emissionstonnes = productde.TotalCO2EmissionsTonnes != null ? (productde.TotalCO2EmissionsTonnes/productde.ProductDetails.length).toFixed(2) : 0;
            for(var eachproductyear of productde.ProductDetails)
            {
				eachproductyear.SalesVolume = EachVolume;
                eachproductyear.SalesRevenue = EachRevenue;
                eachproductyear.SalesProfit = EacGrossMargin;
                eachproductyear.pCo2Emission = EachCO2Emissions;
                eachproductyear.AnnualCo2Emission = EachCO2Emissionstonnes;
            } 
        }
        component.set("v.ProductDetails", prodetails);
        component.set("v.modalWindowQuickFill",false);
    },
    AddProducts : function(component, event, helper) {
        component.set("v.AddProductsnew", true);
    },
    EditProducts : function(component, event, helper) {
        component.set("v.EditProductsnew", true);
    },
    closeModel : function(component, event, helper) {
        event.preventDefault();
        component.set("v.modalWindow", false);
        var prodetails = component.get("v.ProductDetails");
        if(prodetails != null && prodetails.length > 0 && prodetails[0].ProductDetails != null && prodetails[0].ProductDetails.length > 0)
        {
            component.set("v.newYear", (prodetails[0].ProductDetails[prodetails[0].ProductDetails.length - 1].YearOfProduct) + 1);
        }
        else
        {
            const d = new Date();
            component.set("v.newYear",d.getFullYear()); 
        }
        component.set("v.removemodalWindow", false);
    },
    
    closeModelAddyears : function(component, event, helper) {
        event.preventDefault();
        component.set("v.modalWindowAddYears", false);
        component.set("v.removemodalWindow", false);
    },
    
    removeRow : function(component, event, helper) {
        component.set("v.removemodalWindow", true);
        var prodetails = component.get("v.ProductDetails");
        
        var component_target = event.currentTarget;
        var yeartodelete = component_target.dataset.myvalue;
        component.set("v.removeyear", yeartodelete);
    },
    removeyear : function(component, event, helper) {
        component.set("v.removemodalWindow", false);
        
         /* Removing extra year in table start **/
        var prodetails = component.get("v.ProductDetails");
        var yeartodelete = component.get("v.removeyear");
        for(var productde of prodetails)
        {
            var indexpd = 0;
            for(var eachproductyear of productde.ProductDetails)
            {
                if(eachproductyear.YearOfProduct == yeartodelete)
                {
                    productde.ProductDetails.splice(indexpd, 1);
                    break;
                }
                indexpd++;
            }
        }
        component.set("v.ProductDetails", prodetails);
        /* Removing extra year in table end **/
        
        if(prodetails != null && prodetails[0].ProductDetails != null && prodetails[0].ProductDetails.length > 0)
        {
            component.set("v.newYear", (prodetails[0].ProductDetails[prodetails[0].ProductDetails.length - 1].YearOfProduct) + 1);
            component.set("v.ShowQuickFillButton",true); 
        }
        else
        {
            const d = new Date();
            component.set("v.newYear",d.getFullYear()); 
            component.set("v.ShowQuickFillButton",false); 
        }
        
        
    },
    onRecordSubmit : function(component, event, helper) {
        event.preventDefault();
        if(component.get("v.newYear") != null && component.get("v.newYear") != '')
        {
            
            
            /* Adding extra year in table start **/
            var yeartoadd = component.get("v.newYear");
            var prodetails = component.get("v.ProductDetails");
            for(var productde of prodetails)
            {
                var indexpd = 0;
                var addedline = false;
                for(var eachproductyear of productde.ProductDetails)
                {
                    if(eachproductyear.YearOfProduct == yeartoadd)
                    {
                        alert('Year '+yeartoadd+ ' already added. Please select any other year.');
                        return;
                    }
                    if(eachproductyear.YearOfProduct > yeartoadd)
                    {
                        productde.ProductDetails.splice(indexpd , 0, {"YearOfProduct":yeartoadd,"SalesVolume":0,"SalesRevenue":0,"SalesProfit":0,"pCo2Emission":0,"AnnualCo2Emission":0,"RowSaved": false });
                        addedline = true;
                        break;
                    }
                    indexpd++;
                }
                if(addedline == false)
                    productde.ProductDetails[productde.ProductDetails.length] = {"YearOfProduct":yeartoadd,"SalesVolume":0,"SalesRevenue":0,"SalesProfit":0,"pCo2Emission":0,"AnnualCo2Emission":0,"RowSaved": false}; 
            }
            component.set("v.ProductDetails", prodetails);
            component.set("v.modalWindow", false);
            /* Adding extra year in table end **/
            
            if(prodetails != null && prodetails[0].ProductDetails != null && prodetails[0].ProductDetails.length > 0)
            {
                component.set("v.newYear", (prodetails[0].ProductDetails[prodetails[0].ProductDetails.length - 1].YearOfProduct) + 1);
                component.set("v.ShowQuickFillButton",true); 
            }
            else
            {
                const d = new Date();
                component.set("v.newYear",d.getFullYear()); 
            }

        }  
    },
    
    onRecordSubmitaddYears : function(component, event, helper) {
        event.preventDefault();
        
        var valuestartyear = component.get("v.valuestartyear");
        var valueendyear = component.get("v.valueendyear");
        var prodetails = component.get("v.ProductDetails");
        for(var k = parseInt(valuestartyear); k <= parseInt(valueendyear); k++)
        {
            /* Adding extra year in table start **/
            var yeartoadd = k;
            for(var productde of prodetails)
            {
                var indexpd = 0;
                var addedline = false;
                for(var eachproductyear of productde.ProductDetails)
                {
                    if(eachproductyear.YearOfProduct == yeartoadd)
                    {
                        addedline = true;
                        break;
                    }
                    if(eachproductyear.YearOfProduct > yeartoadd)
                    {
                        productde.ProductDetails.splice(indexpd , 0, {"YearOfProduct":yeartoadd,"SalesVolume":0,"SalesRevenue":0,"SalesProfit":0,"pCo2Emission":0,"AnnualCo2Emission":0,"RowSaved": false });
                        addedline = true;
                        break;
                    }
                    indexpd++;
                }
                if(addedline == false)
                    productde.ProductDetails[productde.ProductDetails.length] = {"YearOfProduct":yeartoadd,"SalesVolume":0,"SalesRevenue":0,"SalesProfit":0,"pCo2Emission":0,"AnnualCo2Emission":0,"RowSaved": false}; 
            }
        }
            
            
        component.set("v.ShowQuickFillButton",true); 
            component.set("v.ProductDetails", prodetails);
            component.set("v.modalWindowAddYears", false);
            /* Adding extra year in table end **/

            
         
    },
    
    saveproductdetails : function(component, event, helper) 
    {
        var prodetails = component.get("v.ProductDetails");
        var saveproduct = true;
        for(var productde of prodetails)
        {
            for(var eachproductyear of productde.ProductDetails)
            {
				if(eachproductyear.SalesVolume ===  ""  || eachproductyear.SalesRevenue ===  ""  || eachproductyear.SalesProfit ===  "" || eachproductyear.pCo2Emission ===  "" || eachproductyear.AnnualCo2Emission ===  "" )
                {
                    saveproduct = false;
                    alert('Annual Volume & Annual Revenue (USD$) & Annual Profit (USD$) & Annual CO2 Emissions (Tonnes) &  Annual CO2 Emissions Reduction (Tonnes) is required to save the product details.');
                    break;
                }
            }
        }
        if(saveproduct == true)
            helper.Saveproductdetails(component, event, helper);
    }
})