({
    myAction : function(component, event, helper) 
    {
        //component.set("v.recordId",componentAttributes.Text);
        
        component.set('v.columns', [
            {label: 'Campaign Name', fieldName: 'linkName3', type: 'url', typeAttributes: {label: { fieldName: 'linkName4'},target: '_blank' }, sortable: true},
            //{label: 'Campaign Owner', fieldName: 'linkName2', type: 'text', sortable: true},
            {label: 'Opportunity', fieldName: 'linkName', type: 'url', typeAttributes: {label: { fieldName: 'Name' }, target: '_blank'}, sortable: true},
            {label: 'Opportunity Owner', fieldName: 'Owner_Name__c', type: 'Text', sortable: true },
            {label: 'Stage', fieldName: 'StageName', type: 'Text', sortable: true },
            {label: 'Revenue (USD)', fieldName: 'Value_Amount__c', type: 'number', sortable: true },
            /*{label: 'Parent Account', fieldName: 'linkName1', type: 'url', typeAttributes: {label: { fieldName: 'Parent_Account_Name__c'},target: '_blank' }, sortable: true},
            {label: 'Parent Account Owner', fieldName: 'Account_Owner_Name__c', type: 'Text', sortable: true}, */
            
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
            		record.linkName = '/'+record.Id;//opportunity
            		record.linkName1 = '/'+record.Account.Name;//account
            		record.linkName2 = record.Campaign.Owner_Name__c;//account
            		record.linkName3 = '/'+record.CampaignId;
            		record.linkName4 = record.Campaign.Name;
            		console.log('line 35'+ record.linkName2);
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