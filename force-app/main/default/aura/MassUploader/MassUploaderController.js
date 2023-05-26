({
    doInit : function(component, event, helper) {
        component.set("v.isOpen",false);
        component.set("v.showMain",false);
    },
    loadData:function(component,event,helper){
        component.set("v.isOpen", false);
        component.set("v.errorMsg",'');
        component.set("v.disableUploadButton",true);
        var callApex=true;
        if(component.get("v.totalCount")>10){
            component.find('notificationsLibrary').showToast({
                "duration":"10000",     
                "mode":"dismissible",  
                "title": "Error!",
                "message": 'Please upload only  10 orders per batch',
                "variant":"error"
            }); 
            callApex=false;
            
        }
        if(callApex==true){
            var action = component.get("c.insertWorkOrders");
            
            action.setParams({ fileData : component.get("v.fileContentData"),
                              sobjectName:component.get("v.SObject"),
                              fields:component.get("v.filecolumns"),
                              rowsize :component.get("v.totalCount")
                             })
            
            
            action.setCallback(this,function(a){
                var state = a.getState();
                if(state == "SUCCESS"){
                    component.set("v.disableUploadButton",false);
                    var result = a.getReturnValue();
                    if(result!=0){
                        if(result>1){
                            var mesg=result+' '+'Orders has been uploaded successfully.'
                            }
                        else{
                            var mesg=result+' '+'Order has been uploaded successfully.'
                            }
                        component.find('notificationsLibrary').showToast({
                            "duration":"5000",     
                            "mode":"dismissible",  
                            "title": "Success!",
                            "message": mesg,
                            "variant":"success"
                        }); 
                        
                        component.set("v.fileUploaded",true);
                        component.set("v.displayTable",false);
                        window.location.reload();
                    }
                    else{
                        component.find('notificationsLibrary').showToast({
                            "duration":"5000",     
                            "mode":"dismissible",  
                            "title": "Error!",
                            "message": 'No order has been uploaded',
                            "variant":"error"
                        }); 
                    }
                } else if (state === "ERROR") {
                    component.set("v.Spinner", false);
                    var errorMsg = action.getError()[0].message;
                    component.find('notificationsLibrary').showToast({
                        "duration":"5000",     
                        "mode":"dismissible",  
                        "title": "Orders file Upload",
                        "message": errorMsg,
                        "variant":"error"
                    }); 
                    component.set('v.errorMsg',errorMsg);
                }
            });     
            $A.enqueueAction(action);
        }
        
    },
    openModel: function(component,event,helper){
        component.set("v.isOpen", true);
    },
    closeModel: function(component, event, helper) {
        component.set("v.isOpen", false);
    },
    onFileUploaded:function(component,event,helper){
        var files = component.get("v.fileToBeUploaded");
        component.set("v.disableUploadButton",false);
        helper.upload(component,event,files);
    },
    clearOldData:function(component,event,helper){
        component.set("v.displayPreviewBtn",false);
        component.set("v.showMain",false);
        component.set("v.errorMsg",'');
        component.set("v.WorkOrderWrapper",[]);
        component.set("v.disableUploadButton",false);
    },
    showSpinner: function(component, event, helper) {
        component.set("v.Spinner", true); 
    },
    hideSpinner : function(component,event,helper){
        
        component.set("v.Spinner", false);
    }
    
})