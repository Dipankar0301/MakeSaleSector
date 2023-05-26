({
    myAction : function(component, event, helper) 
    {
        //component.set("v.recordId",componentAttributes.Text);
        
        component.set('v.columns', [
            {label: 'Account', fieldName: 'linkName1', type: 'url', typeAttributes: {label: { fieldName: 'Parent_Account_Name__c'},target: '_blank' }, sortable: true},
            {label: 'Opportunity', fieldName: 'linkName', type: 'url', typeAttributes: {label: { fieldName: 'Name' }, target: '_blank'}, sortable: true},
            {label: 'Stage', fieldName: 'StageName', type: 'Text', sortable: true },
            {label: 'Revenue (USD)', fieldName: 'Value_Amount__c', type: 'number', sortable: true },
            {label: 'Owner', fieldName: 'Owner_Name__c', type: 'Text', sortable: true },
        ]);
            
            var ConList = component.get("c.getRelatedList");
            ConList.setParams
            ({
            	recordId: component.get("v.recordId")
            });
            
            ConList.setCallback(this, function(data) 
            {
            	if(data.getState() === "SUCCESS"){
            
            	//component.set("v.OpportunityList", data.getReturnValue());
             	var records =data.getReturnValue();
            	records.forEach(function(record){
            		record.linkName = '/'+record.Id;
            		record.linkName1 = '/'+record.AccountId;
            		component.set("v.OpportunityList", records);
            	});
            	}
            
            });
            //console.log('12345');
            //console.log(component.get("v.OpportunityList"));
            $A.enqueueAction(ConList);
            },
            
            handleSort: function(cmp, event, helper) {
            helper.handleSort(cmp, event);
            }
            
            })