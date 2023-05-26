({
    
    // test data
    
    init: function(cmp, event, helper) {
       helper.getOpportunityData(cmp, event, helper);
    },
    // test data
    
    
    // Once the file is uploaded this method is called.
    handleUploadFinished: function (cmp, event, helper) {
        var files = event.getSource().get("v.files");
        // check the uploaded file is csv file or not
        if(!files[0].name.endsWith(".csv"))
        {
            
            var toastEvent = $A.get("e.force:showToast");
            toastEvent.setParams({
                "type":"info",
                "message": $A.get("$Label.c.Sector_BulkUpdate_OnlyCSVFile"),
                "duration" : 6000000
            });
            toastEvent.fire();
        }
        else
        {
            /** Header of the column check start here **/
            try{
                
                var Opportunityheadercheck = $A.get("$Label.c.Sector_Bulk_Update_Opportunities_Header");  // this label contain opportunity header with data type & api name	
                var Opportunityproductheadercheck = $A.get("$Label.c.Sector_Bulk_Update_Opportunities_Product_Header"); // this label contain opportunity product header with data type & api name
                var OpportunityForecastingheadercheck = $A.get("$Label.c.Sector_Bulk_Update_Opportunities_Forecasting_Header"); // this label contain opportunity product forecasting header with data type & api name
                var headercheck = cmp.get("v.selectedobjectvalue") == 'Opportunity' ? Opportunityheadercheck : ( cmp.get("v.selectedobjectvalue") == 'OpportunityProduct' ? Opportunityproductheadercheck : OpportunityForecastingheadercheck ); // depending on object selected in screen the header will check
                var headercolumnswithdatatype = headercheck.split(",");
                var headercolumns = [];
                var columnname = '';
                
                
                for (let i = 0; i < headercolumnswithdatatype.length; i = i + 3) 
                {
                    columnname += (columnname != '') ? ' & ' + headercolumnswithdatatype[i] : headercolumnswithdatatype[i] ;
                    headercolumns.push(headercolumnswithdatatype[i]) ;                   
                }
                
                var reader = new FileReader();
                reader.readAsText(files[0]); 
                reader.onload=function()
                {
                    var csvfile = reader.result; 
                    // check if the file has atleast 2 rows
                    if(csvfile.split('\r\n').length <= 1 )
                    {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type":"info",
                            "message": $A.get("$Label.c.Sector_BulkUpdate_NoRowinCSV"),
                            "duration" : 6000000
                        });
                        toastEvent.fire();
                    }
                    // check if the header count is matches with expected columns count
                    else if(csvfile.split('\r\n')[0].split(',').length !=  headercolumns.length)
                    {
                        var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "type":"info",
                            "message": $A.get("$Label.c.Sector_BulkUpdate_ColumnNotMatch")+' '+columnname,
                            "duration" : 6000000
                        });
                        toastEvent.fire();
                        return;
                    }
                    else 
                    {
                        // check if the 2nd row have the value or empty row
                        if(csvfile.split('\r\n')[1].split(',').length < 2)
                        {
                            
                            var toastEvent = $A.get("e.force:showToast");
                            toastEvent.setParams({
                                "type":"info",
                                "message": $A.get("$Label.c.Sector_BulkUpdate_NoRowinCSV"),
                                "duration" : 6000000
                            });
                            toastEvent.fire();
                            return;
                        }
                        
                        var csvheadervalues = csvfile.split('\r\n')[0].split(',');
                        var headercolumnsinCSV = [];
                        for (let i = 0; i < csvheadervalues.length; i++) 
                        {
                            headercolumnsinCSV.push(csvheadervalues[i]) ;  
                        }
                        
                        for (let i = 0; i < headercolumns.length; i++) 
                        {
                            if(!headercolumnsinCSV.includes(headercolumns[i]))
                            {
                                
                                var toastEvent = $A.get("e.force:showToast");
                                toastEvent.setParams({
                                    "type":"info",
                                    "message": $A.get("$Label.c.Sector_BulkUpdate_ColumnNotMatch")+' '+columnname,
                                    "duration" : 6000000
                                });
                                toastEvent.fire();
                                return;
                            }
                        }
                        
                        cmp.set("v.fileUploaded",csvfile);
                        cmp.set("v.csvHeader",csvfile.split('\r\n')[0]);   
                        cmp.set("v.DisableProceedtoValidationButton",false);
                        cmp.set("v.fileName",files[0].name); 
                    }

                }
            }catch(err){
                console.log(err);
                alert('Something went wrong. Please try again or contact system admin.');
            }
            /** Header of the column check end here **/
        }
    },
    // Navigate to Opportunity list view
    GoBackToOppList: function (cmp, event, helper) 
    {
        var navEvent = $A.get("e.force:navigateToList");
        navEvent.setParams({
            "scope": "Opportunity"
        });
        navEvent.fire();
    },
    
    // If row in selected in LWC
    rowselectiononLWC: function (cmp, event, helper) 
    {
        var rowcount = event.getParam('selectedrowlength');;
        if(rowcount != null && rowcount > 0)
            cmp.set("v.disablegeneratefile",false);
        else
            cmp.set("v.disablegeneratefile",true);
    },
    
    // once the user Generates the File 
    nextsteptoupload: function (cmp, event, helper) 
    {
        var cmpTarget = cmp.find('generatefilestage');
        $A.util.addClass(cmpTarget, 'slds-is-complete');
        $A.util.removeClass(cmpTarget, 'slds-is-current');
        $A.util.removeClass(cmpTarget, 'slds-is-active');
        
        var cmpTarget = cmp.find('uploadstage');
        $A.util.addClass(cmpTarget, 'slds-is-current');
        $A.util.addClass(cmpTarget, 'slds-is-active');
        $A.util.removeClass(cmpTarget, 'slds-is-incomplete');
        
        cmp.set("v.GenerateFile",false);
        cmp.set("v.ShowFileUpload",true);
    },
    
    // Download teh csv file by calling lwc method
    downloadcsvfromlwc: function (cmp, event, helper) 
    {
        try
        {
            cmp.find('forecastdownloadcsv').downloadaanualforecasting();
            cmp.set("v.diableProceedtoUploadFile",false);
        }
        catch(err)
        {
            alert('Selected products file could not be generated. Error: ' + err.message +'. Please reinitiate the process and try again.');
        }
    },
    
    // once the user click on validate button 
    ProceedtoValidateFile: function (cmp, event, helper) 
    {
        var cmpTarget = cmp.find('uploadstage');
        $A.util.addClass(cmpTarget, 'slds-is-complete');
        $A.util.removeClass(cmpTarget, 'slds-is-current');
        $A.util.removeClass(cmpTarget, 'slds-is-active');
        
        var cmpTarget = cmp.find('validatestage');
        $A.util.addClass(cmpTarget, 'slds-is-current');
        $A.util.addClass(cmpTarget, 'slds-is-active');
        $A.util.removeClass(cmpTarget, 'slds-is-incomplete');
        
        cmp.set("v.ShowFileUpload",false);
        cmp.set("v.ShowValidationScreen",true);
        // call the helper method to validate the data in csv
        helper.Validateproductdetails(cmp, event, helper);
    },
    // call this method when Start update button is clicked
    ProceedtoUpdateOpportunities: function (cmp, event, helper) 
    {
        var cmpTarget = cmp.find('validatestage');
        $A.util.addClass(cmpTarget, 'slds-is-complete');
        $A.util.removeClass(cmpTarget, 'slds-is-current');
        $A.util.removeClass(cmpTarget, 'slds-is-active');
        
        var cmpTarget = cmp.find('updateresultstage');
        $A.util.addClass(cmpTarget, 'slds-is-current');
        $A.util.addClass(cmpTarget, 'slds-is-active');
        $A.util.removeClass(cmpTarget, 'slds-is-incomplete');
        
        cmp.set("v.ShowValidationScreen",false);
        cmp.set("v.ShowFinishScreen",true);
        // call the helper method to save opportunity data
        helper.Saveproductdetails(cmp, event, helper);
    },
    Reload: function (cmp, event, helper) 
    {
        $A.get('e.force:refreshView').fire();
    },
    // once this method is called then validation file will be downloaded in browser window
    DownloadValidationOpportunities: function (cmp, event, helper) 
    {
        var hiddenElement = document.createElement('a');
        hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(cmp.get("v.OpportunityValidationCSV"));
        hiddenElement.target = '_self'; //
        hiddenElement.download = 'Validation Result ' + cmp.get("v.fileName");  
        document.body.appendChild(hiddenElement); 
        hiddenElement.click(); 

        helper.gotouploadscreen(cmp, event, helper);
    },
    // once this method is called then updation result file will be downloaded in browser window
    DownloadOpportunitiesResult: function (cmp, event, helper) 
    {
        var hiddenElement = document.createElement('a');
        hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(cmp.get("v.OpportunityResultCSV"));
        hiddenElement.target = '_self'; //
        hiddenElement.download = 'Update Result ' + cmp.get("v.fileName");  
        document.body.appendChild(hiddenElement); 
        hiddenElement.click(); 
    },
    DownloadOpportunitytemplate: function (cmp, event, helper) 
    {
        var Opportunityheadercheck = $A.get("$Label.c.Sector_Bulk_Update_Opportunities_Header");  // this label contain opportunity header with data type & api name	
        var headercolumnswithdatatype = Opportunityheadercheck.split(",");
        var columnname = '';
        for (let i = 0; i < headercolumnswithdatatype.length; i = i + 3) 
        {
            columnname += (columnname != '') ? ',' + headercolumnswithdatatype[i] : headercolumnswithdatatype[i] ;                  
        }
        
        
        
        var hiddenElement = document.createElement('a');
        hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(columnname);
        hiddenElement.target = '_self'; //
        hiddenElement.download = 'Bulk_Opportunity_Template.csv';  
        document.body.appendChild(hiddenElement); 
        hiddenElement.click(); 
    },
    DownloadOpportunityProducttemplate: function (cmp, event, helper) 
    {
        var Opportunityproductheadercheck = $A.get("$Label.c.Sector_Bulk_Update_Opportunities_Product_Header"); // this label contain opportunity product header with data type & api name
        var headercolumnswithdatatype = Opportunityproductheadercheck.split(",");
        var columnname = '';
        for (let i = 0; i < headercolumnswithdatatype.length; i = i + 3) 
        {
            columnname += (columnname != '') ? ',' + headercolumnswithdatatype[i] : headercolumnswithdatatype[i] ;                  
        }
        
        var hiddenElement = document.createElement('a');
        hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(columnname);
        hiddenElement.target = '_self'; //
        hiddenElement.download = 'Bulk_Opportunity_Product_Template.csv';  
        document.body.appendChild(hiddenElement); 
        hiddenElement.click(); 
    },
    DownloadOpportunityForecastingtemplate: function (cmp, event, helper) 
    {
        var Opportunityproductheadercheck = $A.get("$Label.c.Sector_Bulk_Update_Opportunities_Forecasting_Header"); // this label contain opportunity product header with data type & api name
        var headercolumnswithdatatype = Opportunityproductheadercheck.split(",");
        var columnname = '';
        for (let i = 0; i < headercolumnswithdatatype.length; i = i + 3) 
        {
            columnname += (columnname != '') ? ',' + headercolumnswithdatatype[i] : headercolumnswithdatatype[i] ;                  
        }
        
        var hiddenElement = document.createElement('a');
        hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(columnname);
        hiddenElement.target = '_self'; //
        hiddenElement.download = 'Bulk_Annual_Forecasting_Template.csv';  
        document.body.appendChild(hiddenElement); 
        hiddenElement.click(); 
    },
    
    
    downloadforecastingwithdata: function (cmp, event, helper) 
    {
        var Opportunityproductheadercheck = $A.get("$Label.c.Sector_Bulk_Update_Opportunities_Forecasting_Header"); // this label contain opportunity product header with data type & api name
        var headercolumnswithdatatype = Opportunityproductheadercheck.split(",");
        var columnname = '';
        var selectedRows = cmp.get("v.selectedOpportunities");
        for (let i = 0; i < headercolumnswithdatatype.length; i = i + 3) 
        {
            columnname += (columnname != '') ? ',' + headercolumnswithdatatype[i] : headercolumnswithdatatype[i] ;                  
        }
        
        console.log('length='+selectedRows.length);
        console.log('selectedRows='+selectedRows);
        for (let i = 0; i < selectedRows.length; i++)
        {
            columnname += '\n';
            var eachrow = selectedRows[i];
            console.log(eachrow);
            columnname += '"'+eachrow.OpportunityId+'"'+',';   // Opportunity Id
            columnname += '"'+eachrow.Product_Family__c+'"'+',';  // Product family 
            columnname += '"'+eachrow.Product2Name+'"'+',';  // product name
            columnname += ''+',';                      // Year
            columnname += ''+',';						// Annual Volume
            columnname += ''+',';						// Annual Revenue
            columnname += ''+',';						// Annual gross margin
            columnname += ''+',';						// Annual CO2 Emmision
            columnname += ''+',';						// Annual CO2 Emmision red
        }
       
        
        
        
        
        var hiddenElement = document.createElement('a');
        hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(columnname);
        hiddenElement.target = '_self'; //
        hiddenElement.download = 'Bulk_Annual_Forecasting_Template.csv';  
        document.body.appendChild(hiddenElement); 
        hiddenElement.click();  
    },
    handleSelect : function(component, event, helper) {              
        var selectedRows = event.getParam('selectedRows');        
        var currentSelectedRows = component.get("v.selectedRows");
        var selectedOpportunities = component.get("v.selectedOpportunities");
        console.log('before selectedRows.length='+selectedRows.length);
        selectedOpportunities = selectedRows;
     /*   for ( var i = 0; i < selectedRows.length; i++ ) { 
            console.log('selected='+selectedRows[i].Id);
            currentSelectedRows.push(selectedRows[i].Id);
            selectedOpportunities.push(selectedRows[i]);
        }    */
       // component.set("v.selectedRows", currentSelectedRows);    
        component.set("v.selectedOpportunities", selectedOpportunities); 
    },
    
    handletogglechangeforecast : function(cmp, event, helper)
    {
        cmp.set("v.loadeddatadownloadopp", false);
        cmp.set("v.ShowSpinner", true);
        helper.getOpportunityData(cmp, event, helper);
        cmp.set("v.disablegeneratefile",true);
        cmp.set("v.diableProceedtoUploadFile",true);

    }
    
})