({
	init : function(component, event, helper) {
        //Set the columns of the data table
        component.set('v.columns',[
            {label: 'Year', fieldName: 'Year__c', type: 'text'},
            {label: 'Unrisked FCF (in M$)', fieldName: 'FCF__c', type: 'number', editable: true},
            {label: 'Final Risked FCF (in M$)', fieldName: 'Risked_FCF_after_Tax_Shell_Share__c', type: 'number'},
            {label: 'HSSE Exposed Hours (in hrs)', fieldName: 'HSSE_Exposed_Hours__c', type: 'number',editable: true},
            {label: 'CO2e Avoided (in Kg)', fieldName: 'CO2e_Avoided_kg__c', type: 'number', editable: true}
        ]);
        
        //fill data in the table
		helper.fetchFCFs(component, event, helper);
	},
    saveData:function(component, event, helper){
        //save data of the table
        helper.saveData(component, event, helper);
    }
})