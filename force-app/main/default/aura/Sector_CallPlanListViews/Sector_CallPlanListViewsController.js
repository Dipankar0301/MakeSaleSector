({
    
    initRecords: function(component, event, helper) {
        component.set("v.isLoading",true);
        console.log('Inside List View');
        component.set("v.loadMoreOffset",0);
        helper.fetchAllRecords(component,event,helper);
        
    },
    
    clearFilters: function (component, event, helper) {
        component.set("v.loadMoreOffset",0);
        component.set("v.oldData",[]);
        component.set("v.displayEmpty",false);
        component.set("v.teamUserId",'');
        component.set("v.searchAccount",'');
        component.set("v.searchOpp",'');
        component.set("v.searchAccPln",'');
        component.set("v.searchStartDate",'Start Date');
        component.set("v.searchEndDate",'End Date');
        component.set("v.searchClplnByType",'All Call Plan Types');
        component.set("v.searchStatus",'All Statuses');
        component.set("v.searchEvent",'');
        component.set("v.searchOwner",'');
        component.set("v.searchTeam",'All Users');
        
        //component.set("v.enableInfiniteLoading",true);
        helper.fetchData(component,event,helper,false);
    },
    /*
    * Handler for all Row actions
    */
    handleRowAction: function (component, event, helper) {
        var temp='';
        var action = event.getParam('action');
        var row = event.getParam('row');
        component.set("v.custMessage",temp);
        console.log('handleRowAction ==>');
        console.log(JSON.stringify(row));
        if (action.name=='edit') {
            
            var device = $A.get("$Browser.formFactor");
            var modalBody; 
            
            if(device == 'DESKTOP'){
            $A.createComponent('c:Sector_editCallPlanEvent',{"eventId":row.eventId,"row":row},
                               function(content, status,errorMessage) {
                                   if (status === "SUCCESS") {
                                       modalBody = content;
                                       component.find('overlayLib').showCustomModal({
                                           header: 'Edit Call Plan',
                                           body: modalBody, 
                                           showCloseButton: true,
                                           cssClass: 'slds-modal_large slds-fade-in-open OverflowVisible',
                                           closeCallback: function() {}
                                       }).then(function (overlay) {
                                           
                                       });
                                   }
                                   else{
                                       helper.showToast(component,event,helper,'Error',errorMessage,'error');
                                   }
                               });
            
            }
        }
        
        if(action.name =='print'){
            var modalBody; 
            $A.createComponent('c:Sector_PrintCallPlanEvent',{"row":row,"printType":action.name},
                               function(content, status,errorMessage) {
                                   if (status === "SUCCESS") {
                                       modalBody = content;
                                       component.find('overlayLib').showCustomModal({
                                           header: 'Print Call Plan',
                                           body: modalBody, 
                                           showCloseButton: true,
                                           cssClass: 'slds-modal_large slds-fade-in-open OverflowVisible',
                                           closeCallback: function() {}
                                       }).then(function (overlay) {
                                           
                                       });
                                   }
                                   else{
                                       helper.showToast(component,event,helper,'Error',errorMessage,'error');
                                   }
                               });
        }
        
        if(action.name =='print_cust'){
            
            var modalBody; 
            $A.createComponent('c:Sector_PrintCallPlanEvent',{"row":row,"printType":action.name},
                               function(content, status,errorMessage) {
                                   if (status === "SUCCESS") {
                                       modalBody = content;
                                       component.find('overlayLib').showCustomModal({
                                           header: 'Print Call Plan',
                                           body: modalBody, 
                                           showCloseButton: true,
                                           cssClass: 'slds-modal_large slds-fade-in-open OverflowVisible',
                                           closeCallback: function() {}
                                       }).then(function (overlay) {
                                           
                                       });
                                   }
                                   else{
                                       helper.showToast(component,event,helper,'Error',errorMessage,'error');
                                   }
                               });
        }
        
        if(action.name =='clone'){
            
            var modalBody; 
            $A.createComponent('c:Sector_EventCloneButton',{"row":row},
                               function(content, status,errorMessage) {
                                   if (status === "SUCCESS") {
                                       modalBody = content;
                                       component.find('overlayLib').showCustomModal({
                                           header: 'Clone Event',
                                           body: modalBody, 
                                           showCloseButton: true,
                                           cssClass: 'slds-modal_large slds-fade-in-open OverflowVisible',
                                           closeCallback: function() {}
                                       }).then(function (overlay) {
                                           
                                       });
                                   }
                                   else{
                                       helper.showToast(component,event,helper,'Error',errorMessage,'error');
                                   }
                               });
        }
        
        if(action.name =='cancel'){
            component.set("v.isCancel",true);
            
            var inputVariables = [
                {
                    name : 'recordId',
                    type : 'String',
                    value : row.EventId
                }
            ];
            var flow = component.find("flowData");
            flow.startFlow("Sector_Cancel_Call_plan",inputVariables);
        }  
    },
    /*
    *
    */
    hidePopup:function(component,event,helper){
        component.set("v.isCancel",false);
        helper.reloadDataTable();
    },
    /*
    *
    
    handleSaveRows:function(component,event,helper){
        component.set("v.isSpinner",true);
        var editedRecords = [];
        editedRecords=event.getParam('draftValues');
        var curLst=component.get("v.currentList");
        var regex;
        
        var finalResults=[];
        for(var i=0;i<editedRecords.length;i++){
            var results;
            var result=editedRecords[i];
            regex=new RegExp(editedRecords[i].EventId,'i');
            results=(curLst.filter(row =>regex.test(row.EventId)));
            result.CallPlanId=results[0].CallPlanId;
            result.StartDateTime=result.StartDateTime !=null?result.StartDateTime:results[0].StartDateTime;
            result.EndDateTime=result.EndDateTime !=null?result.EndDateTime:results[0].EndDateTime;
            
            finalResults.push(result);
        }
        console.log('Controller ############');
        helper.saveRows(component, finalResults,helper);
    },
    */
    updateSelectedText: function (cmp, event) {
        var selectedRows = event.getParam('selectedRows');
        cmp.set('v.selectedRowsCount', selectedRows.length);
    },
    /*
    *
    */
    handleEventAction :function(component,event,helper){
        console.log('inside handleEventAction line 190 list views');
        console.log(event.getParam('action'));
        component.find("overlayLib").notifyClose();
        var s=null;
        var rec=event.getParam('Record');
        var cols=event.getParam('columns');
        var action =event.getParam('action');
        var listRecord=event.getParam('listViews');
        var currentRec=event.getParam('currentListView');
        var selAtt=event.getParam('attendeeList');
        var selRes=event.getParam('resourcesList');
        var delLst=event.getParam('deleteList');
        if(!$A.util.isEmpty(rec) && rec.ReasonforCall =="--- None ---")
            rec.ReasonforCall=s;
        
        if(action=="save"){           
            helper.saveRow(component,rec,selAtt,selRes,delLst);
        } 
        if(action=='listViews'){
            component.set("v.listViews",listRecord);
            if(listRecord.length >1){
                listRecord.forEach(function(element){
                    if(element.Id==event.getParam('currentListViewId')){
                        component.set("v.listViewsRec",element);
                        component.set("v.currentListView",'Default View');
                        
                    }
                });
            }
            else{
                component.set("v.listViewsRec",listRecord[0]);
                component.set("v.currentListView",'Default View');
            }
            
            if(component.get("v.currentListView")=='Team View'){
                //component.set("v.hideTable", true);
                component.set("v.isLoading",true);
                component.set("v.columns", []);
                component.set("v.currentList", []);
                component.set("v.loadMoreOffset",0);
                component.set("v.enableInfiniteLoading",false);
                helper.createTeamView(component,event,helper);
            }else{
                helper.fetchData(component,event,helper,true);  
            }
            
        }
        /*
        
        if(action=='addColumns'){
            helper.addColumns(component,event,helper,true);
        }*/
        if(action=='newRecord'){
            var device = $A.get("$Browser.formFactor");
            if(device == 'DESKTOP'){
                  helper.createRecord(component,event,helper,true);
            }
          
        }
    },
    backtoMyView : function(component,event,helper){
        component.set("v.hideTable", false);
        component.set("v.loadMoreOffset",0);
        helper.fetchAllRecords(component,event,helper);
    },
    cancel : function(component,event,helper){        
        $A.get('e.force:refreshView').fire(); 
    },
    /*
    *This Method is used to sort the lightning dataTable 
    */
    updateColumnSorting: function(component, event, helper) {
        var fieldName = event.getParam('fieldName');
        var sortDirection = event.getParam('sortDirection');
        // assign the latest attribute with the sorted column fieldName and sorted direction
        component.set("v.sortedBy", fieldName);
        component.set("v.sortedDirection", sortDirection);
        helper.sortData(component, fieldName, sortDirection);
    },
    filterByEnterKey:function(component,event,helper){
        if(event.getParams().keyCode == 13){
            helper.filterByMySearchTerms(component,event,helper);
        }
    },
    /*
    *This Method is used to filter records
    */
    filterBySearchTerms:function(component,event,helper){
        helper.filterByMySearchTerms(component,event,helper);
    },
    /*
    *  Infinite Loading
    */
    loadMoreData: function (component, event, helper) {
        
        helper.loadMoreRecords(component, event, helper); 
    },
    /*
    *
    
    addColumns :function (component, event, helper) {
        
        var modalBody; 
        $A.createComponent('c:LE_AddColumnsClPlnLstView',{"columns":component.get("v.columns"),"allColumns":component.get("v.allColumns")},
                           function(content, status,errorMessage) {
                               if (status === "SUCCESS") {
                                   modalBody = content;
                                   component.find('overlayLib').showCustomModal({
                                       header: 'Add columns',
                                       body: modalBody, 
                                       showCloseButton: true,
                                       cssClass: 'slds-modal_large slds-fade-in-open OverflowVisible',
                                       closeCallback: function() { }
                                   }).then(function (overlay) {
                                       
                                   });
                               }
                               else{
                                   helper.showToast(component,event,helper,'Error',errorMessage,'error');
                               }
                           });
        
        
    }*/
    
})