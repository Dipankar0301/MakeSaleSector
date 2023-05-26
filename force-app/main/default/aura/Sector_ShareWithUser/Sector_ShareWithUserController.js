({
    loaddata : function(cmp, event, helper) {

        cmp.set("v.subjectemail",$A.get("$Label.c.SectorSharewithUser_Subject"));
        cmp.set("v.bodyemail",$A.get("$Label.c.SectorSharewithUser_Body"));
        
        helper.loaddatainitial(cmp, event, helper);
        
    },
    
    handleSort: function(cmp, event, helper) {
        helper.handleSort(cmp, event);
    },
    handlecancel : function(component, event, helper) {
        $A.get("e.force:closeQuickAction").fire();
    },
    PrintAccountPlan : function(component, event, helper) {
        var attendeeslist = [];
        attendeeslist = component.find('attendeedatatable').getSelectedRows();
        var viewType = component.find("viewType").get("v.value");
        var substr = '@shell.com';
        var len = attendeeslist.length;
        var flag =0;
        console.log(viewType);
        console.log(attendeeslist[0]);
        for (let x = 0; x < len; x++)
        {
            var attendee=attendeeslist[x];
            var attendeeName = attendee.AttendeeEmail;
            if(attendeeName.includes(substr) == false)
            {
                flag= 1;
                break;
            }
        }
        if(attendeeslist == null || attendeeslist.length === 0)
        {
            $A.get("e.force:showToast").setParams({
                "type": 'info',
                "message": 'Please select atleast one attendee in "To" list.',
                "duration": 10000
            }).fire();
        }
        
        else if(viewType === 'InternalView' && flag === 1)
        {
            $A.get("e.force:showToast").setParams({
                "title":'Unable to Send Email',
                "type": 'info',
                "message": '"Internal View" should only be sent to internal Shell staff, NOT external customers. For external customers, please use "Customer View".',
                "duration": 10000
            }).fire();
        }
        else
            helper.shareeventwithattendee(component, event, helper);
        
        
    },
    changeviewc: function (cmp, event, helper) {
        if(event.getParam('value') === "Customerview")
        {
             cmp.set("v.showInternalview",false);
        }
        else
        {
             cmp.set("v.showInternalview",true);
        }
    },
    handleclickinternalattendee : function(cmp, event, helper)
    {
        
        $A.createComponent("c:makesalessectorcalenderattendeeslwc", {"recordId":cmp.get("v.recordId")},
                           function(content, status) {
                               if (status === "SUCCESS") {
                                   
                                    cmp.set("v.showmodal",false);
                                   
                                   cmp.find('cmp1').showCustomModal({
                                       body: content,
                                       showCloseButton: false,
                                       showCloseButton: true,
                                       closeCallback: function() {
                                           cmp.set("v.showmodal",true);
                                           helper.loaddatainitial(cmp, event, helper);
                                       }
                                   })
                               }
                           }); 
        
    },
    handleclickexternalattendee : function(cmp, event, helper)
    {
        
        $A.createComponent("c:sectorexternalattendeelist", {"recordId":cmp.get("v.recordId")},
                           function(content, status) {
                               if (status === "SUCCESS") {
                                   cmp.set("v.showmodal",false);
                                   cmp.find('cmp1').showCustomModal({
                                       body: content,
                                       showCloseButton: false,
                                       showCloseButton: true,
                                       closeCallback: function() {
                                           cmp.set("v.showmodal",true);
                                           helper.loaddatainitial(cmp, event, helper);
                                       }
                                   })
                               }
                           }); 
        
    }
})