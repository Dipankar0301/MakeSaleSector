({
    /*
     fetch all records
      */
    fetchAllRecords: function(component, event, helper) {
        console.log('inside fetchallrecords');
        var fetchEvents = component.get("c.fetchAllEvents");
        fetchEvents.setCallback(this, function(response) {
            
            var resp = response.getReturnValue();
            if (response.getState() == 'SUCCESS') {
                component.set("v.totalNumberOfRows", resp.totalEvents);
                console.log('total events init');
                console.log('total ==>'+resp.totalEvents);
                component.set("v.RecordTypeId", resp.recordType);
                console.log(resp.recordType);
                
            } else {
                var errors = response.getError();
                var errMsg = 'Unknown error'; // Default error message
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    errMsg = errors[0].message;
                }
                helper.showToast(component,event,helper,'Error',errMsg,'error');
            }
        });
        $A.enqueueAction(fetchEvents);
    },
    fetchData: function(component, event, helper,disableColumns) {
        var x = "Total Height: " + screen.height;
        component.set("v.isLoading", true);
        component.set("v.displayEmpty", false);
        
        if (component.find("startDate").get("v.value") =='Invalid Date' 
            || $A.util.isEmpty(component.find("startDate").get("v.value"))) {
            component.set("v.searchStartDate", 'Start Date');
        }
        if (component.find("endDate").get("v.value") == 'Invalid Date' ||
            $A.util.isEmpty(component.find("endDate").get("v.value"))) {
            component.set("v.searchEndDate", 'End Date');
        }
        var meName = component.get("v.NoRecordsText");
        var termAcc = component.get("v.searchAccount"),
            termOpp = component.get("v.searchOpp"),
            termAccPln = component.get("v.searchAccPln"),
            termStart = component.find("startDate").get("v.value") !='Start Date' ? new Date(component.find("startDate").get("v.value")) : '', //component.get("v.searchStartDate"),
            termEnd = component.find("endDate").get("v.value") !='End Date' ? new Date(component.find("endDate").get("v.value")) : '',
            termClPlnType = component.get("v.searchClplnByType") !="All Call Plan Types" ? component.get("v.searchClplnByType") :'',
            termStatus = component.get("v.searchStatus") !="All Statuses" ? component.get("v.searchStatus") : '',
            termSubject = component.get("v.searchEvent"),
            termOwner = component.get("v.searchOwner"),
            
            termTeam=!$A.util.isEmpty(component.get("v.teamUserId"))? component.get("v.teamUserId") : '';
        	console.log('line 52');
        	console.log(termOwner);
        	console.log(component.get("v.searchOwner"));
        	console.log(termAcc);
        var action = component.get("c.searchEvents");
        action.setParams({
            "currentlistview": component.get("v.listViewsRec"),
            "acc": termAcc,
            "opp": termOpp,
            "accplan": termAccPln,
            "startdate": termStart,
            "enddate": termEnd,
            "callplantype": termClPlnType,
            "status": termStatus,
            "subject": termSubject,
            "offset": component.get("v.loadMoreOffset"),
            "rowsToLoad": component.get("v.rowsToLoad"),
            "teamUser": termTeam,
            "ownerName": termOwner
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            
            if (state === "SUCCESS") {
                if (!$A.util.isEmpty(response.getReturnValue())) {
                    
                    component.set("v.displayEmpty", false);
                    var storeResponse = response.getReturnValue();
                    console.log('storeResponse');
                    console.log(JSON.stringify(storeResponse));
                    component.set("v.RecordTypeId",storeResponse[0].RecordtypeId);
                    component.set("v.CallPlanList",storeResponse);
                    component.set("v.enableInfiniteLoading",true);
                    component.set("v.currentList",storeResponse);
                    
                    if(disableColumns){
                        this.setColumnsMap(component, event, helper);
                    }
                } else{
                    component.set("v.displayEmpty", true);
                }
                component.set("v.isLoading", false);
            } else {
                component.set("v.isLoading", false);var errors = response.getError();
                var errMsg = 'Unknown error'; // Default error message
                if (errors && Array.isArray(errors) && errors.length > 0) {
                    errMsg = errors[0].message;
                }
                helper.showToast(component,event,helper,'Error',errMsg,'error');
            }
        });
        $A.enqueueAction(action);
        
    },
    
    setColumnsMap: function(component, event, helper) {
        var items = [];
        var columns = [];
        var allcolumns = [];
        var fcolumns = [];
        component.set("v.allColumns", allcolumns);
        
        if($A.get("$Browser.formFactor") != 'PHONE') {
            
            var actions = [{
                label: 'Print',
                name: 'print'
            }, {
                label: 'Print Cust',
                name: 'print_cust'
            }, {
                label: 'Clone',
                name: 'clone'
            }];
            actions.push({
                label: 'Cancel',
                name: 'cancel'
            });
            
            items.push({
                "label": '',
                "value": {
                    label: '',
                    type: 'button',
                    fixedWidth: 60,
                    typeAttributes: {
                        label: '',
                        title: 'Click to Edit',
                        name: 'edit',
                        iconName: 'utility:edit',
                        variant: 'base'
                    },
                },
                "default": true
            }, {
                "label": '',
                "value": {
                    type: 'action',
                    fixedWidth: 40,
                    typeAttributes: {
                        rowActions: actions
                    },
                    
                },
                "default": true
            }, {
                "label": 'Subject',
                "value": {
                    label: 'Subject',
                    initialWidth: 230,
                    fieldName: 'SubjectURL',
                    type: 'url',
                    sortable: true,
                    typeAttributes: {
                        label: {
                            fieldName: 'Subject'
                        }
                    }
                },
                "default": true
            }, {
                "label": 'Related To',
                "value": {
                    label: 'Related To',
                    fieldName: 'RelatedURL',
                    type: 'url',
                    typeAttributes: {
                        label: {
                            fieldName: 'RelatedToName'
                        }
                    },
                    sortable: true
                },
                "default": true
            },{
                "label": 'Owner',
                "value": {
                    label: 'Owner',
                    fieldName: 'AssignedToName',
                    type: 'text',
                    sortable: true, 
                },
                "default": true
                
            },{
                "label": 'CP Type',
                "value": {
                    label: 'CP Type',
                    fieldName: 'CallPlanType',
                    type: 'text',
                    sortable: true, 
                    cellAttributes: {
                        class: {
                            fieldName: 'cssDotClass'
                        }
                    }
                },
                "default": true
            }, {
                "label": 'Start Date Time',
                "value": {
                    label: 'Start Date Time',
                    initialWidth: 200,
                    fieldName: 'StartDateTime',
                    type: 'date',
                    sortable: true,

                },
                "default": true
            }, {
                "label": 'End Date Time',
                "value": {
                    label: 'End Date Time',
                    initialWidth: 200,
                    fieldName: 'EndDateTime',
                    type: 'date',
                    sortable: true,
                    
                },
                "default": true
            }, {
                "label": 'Reason for call',
                "value": {
                    label: 'Reason for call',
                    fieldName: 'ReasonforCall',
                    type: 'text',
                    sortable: true
                },
                "default": false
            }, {
                "label": 'Status',
                "value": {
                    label: 'Status',
                    fieldName: 'Status',
                    type: 'text',
                    sortable: true
                },
                "default": true
            }, {
                "label": 'Minutes',
                "value": {
                    label: 'Minutes',
                    fieldName: 'MinutesActions',
                    type: 'text',
                    sortable: true,
                    
                },
                "default": false
            }, 
                       //to show the new column 'Owner'
                       {
                "label": 'Owner',
                "value": {
                    label: 'Owner',
                    fieldName: 'Owner',
                    type: 'text',
                    sortable: true,
                    
                },
                "default": false
            },	//till this point
                       {
                "label": 'Premise',
                "value": {
                    label: 'Premise',
                    fieldName: 'PremiseText',
                    type: 'text',
                    sortable: true
                },
                "default": false
            }, {
                "label": 'Purpose',
                "value": {
                    label: 'Purpose',
                    fieldName: 'PurposeText',
                    type: 'text',
                    sortable: true
                },
                "default": false
            },  {
                "label": 'Strategy',
                "value": {
                    label: 'Strategy',
                    fieldName: 'StrategyText',
                    type: 'text',
                    sortable: true
                },
                "default": false
            }, {
                "label": 'Agenda',
                "value": {
                    label: 'Agenda',
                    fieldName: 'AgendaText',
                    type: 'text',
                    sortable: true
                },
                "default": false
            }, {
                "label": 'Anticipate',
                "value": {
                    label: 'Anticipate',
                    fieldName: 'AnticipateText',
                    type: 'text',
                    sortable: true
                },
                "default": false
            }, {
                "label": 'Location',
                "value": {
                    label: 'Location',
                    fieldName: 'Location',
                    type: 'text'
                },
                "default": false
                
            }, {
                "label": 'Type',
                "value": {
                    label: 'Type',
                    fieldName: 'Type',
                    type: 'text',
                    sortable: true
                },
                "default": false
            },  {
                "label": 'Account Plan',
                "value": {
                    label: 'Account Plan',
                    fieldName: 'AccountPlanName',
                    type: 'text',
                    sortable: true
                },
                "default": false
            });
        }
        
        //console.log(items);
        items.forEach(function(element) {
            allcolumns.push({
                label: element.label,
                value: element.value,
                default: element.default
            });
            if (element.default) {
                if (element.label != '' && element.label !=
                    undefined)
                    fcolumns.push(element.label);
            }
        });
        if($A.get("$Browser.formFactor") != 'PHONE') {
            
            columns.push(items[0].value);
            columns.push(items[1].value);
        }
        //console.log('line 363');
        //console.log(columns);
        //console.log(fcolumns);
        var lst = [];
        var regex;
        var data;
        //var lstvrec = component.get("v.listColumn");
        var staticLabel = $A.get("$Label.c.Call_Plan_Cloumns");
        lst = staticLabel.split(",");
        //console.log(staticLabel);
        //console.log('line 357');
        //console.log(lst);
        if (lst.indexOf('Start Date Time') == -1) {
            lst.push('Start Date Time');
        }
        if (lst.indexOf('End Date Time') == -1) {
            lst.push('End Date Time');
        }
        var i = 0;
        var k = 10 - lst.length;
        if (lst.length < 10) {
            fcolumns.forEach(function(t) {
                if (i < k) {
                    if (lst.indexOf(t) == -1) {
                        i++;
                        lst.push(t);
                    }
                    
                }
            });
        }
        //console.log('line 394');
        //console.log(lst);
        //console.log(allcolumns);
        lst.forEach(function(p) {
            regex = new RegExp(p, 'i');
            data = allcolumns.filter(function(v) {
                //console.log('line 399');
                //console.log(v.label);
                //console.log(v.value);
                return v.label != '' && v.label == p ?
                    v.value : '';
            });
            if (!$A.util.isEmpty(data)) {
                if(lst[lst.length -1] !=p && lst[lst.length -2] !=p){
                    if(lst.length <=10){
                        //if($A.util.isEmpty(data[0].value.initialWidth))
                           //data[0].value.initialWidth=200;
                    }
                    else if(lst.length > 10){
                        if($A.util.isEmpty(data[0].value.initialWidth))
                            data[0].value.initialWidth=100;
                    }
                    
                }
                //console.log('line 413');
                console.log(data[0].value);
                //console.log(data);
                columns.push(data[0].value);
            }
        });
        //console.log('line 425');
        //console.log(lst);
        component.set("v.allColumns", allcolumns);
        component.set("v.columns", columns);
        //console.log(component.get("v.allColumns"));
        //console.log(component.get("v.columns"));
        
    }, 
    sortBy: function(component, field) {
        var sortAsc = component.get("v.sortAsc"),
            sortField = component.get("v.sortField"),
            records = component.get("v.CallPlanList");
        sortAsc = sortField != field || !sortAsc;
        records.sort(function(a, b) {
            var t1 = a[field] == b[field],
                t2 = (!a[field] && b[field]) || (a[field] < b[
                    field]);
            return t1 ? 0 : (sortAsc ? -1 : 1) * (t2 ? 1 : -1);
        });
        component.set("v.sortAsc", sortAsc);
        component.set("v.sortField", field);
        component.set("v.CallPlanList", records);
        this.renderPage(component);
    },
    renderPage: function(component) {
        var records = component.get("v.CallPlanList"),
            pageNumber = component.get("v.pageNumber"),
            pageRecords = records.slice((pageNumber - 1) * 20,pageNumber * 20);
        component.set("v.currentList", pageRecords);
    },
    saveRow: function(component, record, attList,resList,delLst) {
        
        component.set("v.isLoading", true);
        console.log('Inside saverow line 453');
        console.log(JSON.stringify(record))
        var saverow = component.get("c.saveRow");
        saverow.setParams({
            "e": JSON.stringify(record),
            "attList":JSON.stringify(attList),
            "resList":JSON.stringify(resList),
            "delLst":JSON.stringify(delLst)
        });
        saverow.setCallback(this, function(resp) {
            console.log('Error ==>');
            console.log(resp.getError());
            if (resp.getState() == 'SUCCESS') {
                
                this.showToast(component,event,helper,'Success!','The Record has been updated successfully.','success')
                component.set("v.isLoading", false);
                this.reloadDataTable();
            } else {
                component.set("v.isLoading", false);
                if(resp.getError()[0].message.indexOf('INSUFFICIENT_ACCESS_ON_CROSS_REFERENCE_ENTITY') > -1)
                    component.set("v.custMessage", 'You do not have access to the Record.Please contact Owner of the Record.');
                else
                    component.set("v.custMessage", resp.getError()[0].message);
                
            }
        });
        $A.enqueueAction(saverow);
        
    },
    
     filterByMySearchTerms:function(component,event,helper){
        component.set("v.searchStatus", document.getElementById('selectpick').value);
        component.set("v.searchClplnByType", document.getElementById('selectClType').value);
        if(component.get("v.currentListView") =='Team View')
            component.set("v.searchTeam",document.getElementById('selectTeam').value);
        component.set("v.displayEmpty",false);
        
        if(!$A.util.isEmpty(component.get("v.searchAccount")) || !$A.util.isEmpty(component.get("v.searchOpp")) || !$A.util.isEmpty(component.get("v.searchOwner")) ||!$A.util.isEmpty(component.get("v.searchAccPln")) ||
           (!$A.util.isEmpty(component.get("v.searchStartDate")) && component.get("v.searchStartDate")!='Start Date'  && component.get("v.searchStartDate")!='Invalid Date') ||
           (!$A.util.isEmpty(component.get("v.searchEndDate")) && component.get("v.searchEndDate")!='End Date'  && component.get("v.searchEndDate")!='Invalid Date') ||
           ((component.get("v.currentListView") =='Team View')&&(!$A.util.isEmpty(component.get("v.searchTeam")))) || component.get("v.searchClplnByType")!='All Call Plan Types' || component.get("v.searchStatus") !='All Statuses' || !$A.util.isEmpty(component.get("v.searchEvent"))
           || component.get("v.previouslySet") ==true){
            component.set("v.loadMoreOffset",0);
            component.set("v.previouslySet",true);
            component.set("v.NoRecordsText",'There are no records corresponding to your search terms');
            component.set("v.loadMoreStatus",'');
            
            helper.fetchData(component,event,helper,false);
        } 
    },
    sortData: function(component, fieldName, sortDirection) {
        var data = component.get("v.currentList");
        var reverse = sortDirection !== 'asc';
        data.sort(this.sortBylb(fieldName, reverse))
        component.set("v.currentList", data);
    },
    sortBylb: function(field, reverse, primer) {
        var key = primer ? function(x) {
            return primer(x[field])
        } : function(x) {
            return x[field]
        };
        //checks if the two rows should switch places
        reverse = !reverse ? 1 : -1;
        return function(a, b) {
            return a = key(a), b = key(b), reverse * ((a > b) - (b >
                                                                 a));
        }
    },
    
    reloadDataTable: function() {
        console.log('inside reloadDataTable');
        var refreshEvent = $A.get("e.force:refreshView");
        if (refreshEvent) {
            refreshEvent.fire();
        }
    },
    
    loadMoreRecords: function(component, event, helper) {
        //Add the current list view filters 
        
        event.getSource().set("v.isLoading", true);
        var rowsToLoad = component.get('v.rowsToLoad');
        var offset = component.get("v.loadMoreOffset");
        var currentData = component.get('v.currentList');
        var totalData = component.get('v.totalNumberOfRows');
        var newData;
        //console.log('load more lsit view==>'+component.get("v.currentListView")+'===='+component.get("v.teamUserId"));
        if (offset > totalData) {
            
            component.set('v.enableInfiniteLoading', false);
            component.set('v.loadMoreStatus', 'No more data to load');
        } else {
            component.set('v.loadMoreStatus', 'Loading');
            component.set('v.loadMoreOffset', offset + rowsToLoad);
            
            if (component.get("v.searchStartDate") =='Invalid Date' || $A.util.isEmpty(component.get("v.searchStartDate"))) {
                component.set("v.searchStartDate", 'Start Date');
            }
            if (component.get("v.searchEndDate") =='Invalid Date' || $A.util.isEmpty(component.get("v.searchEndDate"))) {
                component.set("v.searchEndDate", 'End Date');
            }
            var meName = component.get("v.NoRecordsText");
            var termAcc = component.get("v.searchAccount"),
                termOpp = component.get("v.searchOpp"),
                termAccPln = component.get("v.searchAccPln"),
                termStart = component.get("v.searchStartDate") !='Start Date' ? new Date(component.get("v.searchStartDate")) : '', //component.get("v.searchStartDate"),
                termEnd = component.get("v.searchEndDate")  !='End Date' ? new Date(component.get("v.searchEndDate") ) : '',
                termClPlnType = component.get("v.searchClplnByType") !="All Call Plan Types" ? component.get("v.searchClplnByType") : '',
                termStatus = component.get("v.searchStatus") !="All Statuses" ? component.get("v.searchStatus") : '',
                termSubject = component.get("v.searchEvent"),
                termOwner = component.get("v.searchOwner"),
                termTeam = !$A.util.isEmpty(component.get("v.teamUserId")) ? component.get("v.teamUserId") : '';
            //console.log('offset-->'+component.get('v.loadMoreOffset')+'--->'+totalData);
            console.log('line 650');
        	console.log(termOwner);
        	console.log(component.get("v.searchOwner"));
        	console.log(termAcc);
            var fetchRec = component.get("c.searchEvents");
            fetchRec.setParams({
                "currentlistview": component.get("v.listViewsRec"),
                "acc": termAcc,
                "opp": termOpp,
                "accplan": termAccPln,
                "startdate": termStart,
                "enddate": termEnd,
                "callplantype": termClPlnType,
                "status": termStatus,
                "subject": termSubject,
                "offset": component.get("v.loadMoreOffset"),
                "rowsToLoad": component.get("v.rowsToLoad"),
                "teamUser": termTeam,
                "ownerName": termOwner
            });
            //console.log('before call back');
            fetchRec.setCallback(this, function(response) {
                var state = response.getState();
                console.log(response);
                if (state === "SUCCESS") {
                    var storeResponse = response.getReturnValue();
                    console.log(storeResponse);
                    if (!$A.util.isEmpty(storeResponse)) {
                        newData = component.get("v.currentList").concat(storeResponse);
                        component.set('v.loadMoreStatus', '');
                        component.set("v.CallPlanList", newData);
                        component.set("v.currentList", newData);
                        component.set("v.displayEmpty",false);
                    } else {
                        component.set('v.loadMoreOffset',totalData + 1);
                        component.set('v.loadMoreStatus','No more data to load');
                    }
                }
                else{
                    console.log(response.getError());
                }
                
                
            });
            $A.enqueueAction(fetchRec);
        }
        
        event.getSource().set("v.isLoading", false);
        
    },
    
    createRecord: function(component, event, helper) {
        console.log('List View helper line 669');
       var staticRecordIdLabel = $A.get("$Label.c.Sector_Event_RecordtypeId");
        var createRecordEvent = $A.get("e.force:createRecord");
    createRecordEvent.setParams({
        "entityApiName": "Event",
        "recordTypeId": staticRecordIdLabel,
         "navigationLocation" : "LOOKUP",
            "panelOnDestroyCallback": function(event) {
                $A.get('e.force:refreshView').fire();
            }
    });
    createRecordEvent.fire();
    },
    
    showToast : function(component, event, helper, title, message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type 
        });
        toastEvent.fire();
    },
})