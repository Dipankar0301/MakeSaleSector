({
    myAction : function(component, event, helper) 
    {
        //component.set("v.recordId",'0013G00000GHQQjQAP');
        
        /*component.set('v.columns', [
            {label: 'Account', fieldName: 'linkName1', type: 'url', typeAttributes: {label: { fieldName: 'Parent_Account_Name__c'},target: '_blank' }, sortable: true},
            {label: 'Opportunity', fieldName: 'linkName', type: 'url', typeAttributes: {label: { fieldName: 'Name' }, target: '_blank'}, sortable: true},
            {label: 'Stage', fieldName: 'StageName', type: 'Text', sortable: true },
            {label: 'Revenue (USD)', fieldName: 'Value_Amount__c', type: 'number', sortable: true },
            {label: 'Owner', fieldName: 'Owner_Name__c', type: 'Text', sortable: true },
        ]); */
        
        //var ConList = component.get("c.getRelatedList");
        ConList.setParams
        ({
            recordId: component.get("v.recordId")
        });
        
        ConList.setCallback(this, function(data) 
                            {
                                if(data.getState() === "SUCCESS"){
                                    component.set("v.OpportunityList", data.getReturnValue());
                                    
                                }
                                
                            });
        //console.log('12345');
        console.log(component.get("v.OpportunityList"));
        $A.enqueueAction(ConList);
    },
    
    //handleSort: function(cmp, event, helper) {
    //helper.handleSort(cmp, event);
    //},
    createRecord : function (component, event, helper) {
        
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Site__c",
            "recordTypeId": $A.get("$Label.c.Sector_Site_RecordId"),
            "navigationLocation" : "LOOKUP",
            
            "defaultFieldValues": {
                //"State__c" : "West Bengal"
            },
            "panelOnDestroyCallback": function(event) {
                console.log('test');
                //console.log(event.getParam("id"));
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": "/lightning/r/Opportunity/0063G000003QGoWQAW/view",
                    "isredirect": "true"
                });
                urlEvent.fire();
            }
        });
    createRecordEvent.fire();
	},
 editRecord : function(component, event, helper) {
    var recordIdEdit =event.currentTarget.name;
    console.log('editRecord');
    console.log(recordIdEdit);
    var editRecordEvent = $A.get("e.force:editRecord");
    editRecordEvent.setParams({
        "recordId": recordIdEdit
    });
    editRecordEvent.fire();
    $A.get('e.force:refreshView').fire();
},
    /*handleRowAction: function (component, event, helper) {
        var action = event.getParam('action');
        switch (action.name) {
            case 'view':
                helper.viewRecord(component, event);
                break;
            case 'edit':
                helper.editRecord(component, event);
                break;
            case 'delete':
                helper.deleteRecord(component, event);
                break;
        }
    },*/
        refreshPage: function(component, event, helper) {
            console.log('12345');
            $A.get('e.force:refreshView').fire();
        }

})