({
	doinit : function(component, event, helper) {
        
        if(component.get("v.printType")=='print')
		component.set("v.urlPDF",'/apex/Sector_Print_CallPlan?Id=');

        if(component.get("v.printType")=='print_cust')
		component.set("v.urlPDF",'/apex/Sector_Print_Customer_CallPlan?Id=');
        
	}
})