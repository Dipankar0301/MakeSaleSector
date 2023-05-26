({
    init: function(component, event, helper) {
        // Load data
        helper.init(component);
    },
    closeModel: function(component, event, helper)
    {
        component.set("v.ShowModalISOP", false);
    },
    search: function(component, event, helper) {
        // Filter list
        helper.search(component);
    },
    editregion:  function(component, event, helper) {
        component.set("v.ShowModalRegion", false);
        component.set("v.ShowModalRegion", true);
    },
    editcountry:  function(component, event, helper) {
        component.set("v.ShowModalCountry", false);
        component.set("v.ShowModalCountry", true);
    },
    editcity:  function(component, event, helper) {
        component.set("v.ShowModalCity", false);
        component.set("v.ShowModalCity", true);
    },
    editfullfulledby:  function(component, event, helper) {
        component.set("v.ShowModalFulfilledby", false);
        component.set("v.ShowModalFulfilledby", true);
    },
    onRecordSubmit: function(component, event, helper) 
    {
        component.set("v.ShowModalISOP", false);
        $A.get('e.force:refreshView').fire();
        $A.get("e.force:showToast").setParams({
            "type": 'success',
            "message": 'Opportunity is saved.',
            "duration": 10000
        }).fire();
    },
    toggleSection : function(component, event, helper) {
        // dynamically get aura:id name from 'data-auraId' attribute
        var sectionAuraId = event.target.getAttribute("data-auraId");
        // get section Div element using aura:id
        var sectionDiv = component.find(sectionAuraId).getElement();
        /* The search() method searches for 'slds-is-open' class, and returns the position of the match.
         * This method returns -1 if no match is found.
        */
            var sectionState = sectionDiv.getAttribute('class').search('slds-is-open'); 
            
            // -1 if 'slds-is-open' class is missing...then set 'slds-is-open' class else set slds-is-close class to element
            if(sectionState == -1){
                sectionDiv.setAttribute('class' , 'slds-section slds-is-open');
            }else{
                sectionDiv.setAttribute('class' , 'slds-section slds-is-close');
            }
        }
})