import { LightningElement, track, wire, api } from 'lwc';
import getoppproducts from '@salesforce/apex/Sector_OpportunitiesUploadController.SectorGetOwnOpportunities';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import Sector_Bulk_Update_Opportunities_Forecasting_Header from '@salesforce/label/c.Sector_Bulk_Update_Opportunities_Forecasting_Header';

/*
const columns = [
    { label: 'Opportunity Name', fieldName: 'OpportunityIdURL', type: 'url', typeAttributes: {label: { fieldName: 'OpportunityName',target: '_blank' } } },
    { label: 'Account Name', fieldName: 'AccountIdURL', type: 'url', typeAttributes: {label: { fieldName: 'AccountName',target: '_blank' } } },
    { label: 'Stage', fieldName: 'StageName' },
    { label: 'Product Family', fieldName: 'Product2Family' },
    { label: 'Product Name', fieldName: 'Product2Name' }
    
]; */

export default class SectorDownloadOpportunities extends LightningElement 
{

    
    @api 
    oppproductdata;

    @api 
    columns;



   // @wire(getoppproducts) oppproducts;


   // oppproductdata =  this.oppproducts != null && this.oppproducts.opplines != null ? this.oppproducts.opplines : [];

    /*
    @wire(getoppproducts) 	
    wiredOpportunities({data, error}){
		if(data) {

           console.log('called data');
            
            
            if(data.responseStatus === 'success')
            {
                console.log('data.opplines');
                console.log(data.opplines);
                var datareceived = data.opplines;
                var oppporductlist = [];
                console.log('called responseStatus');
                for ( var i = 0; i < datareceived.length; i++ ) {
                    var row = datareceived[i];
                    var eachrow = {};
                    eachrow.Product2Family  = row.Product_Family__c;
                    if ( row.Opportunity ) {
                        eachrow.OpportunityName = row.Opportunity.Name;
                        eachrow.AccountName = row.Opportunity.Account.Name;
                        eachrow.StageName = row.Opportunity.StageName;
                        eachrow.AccountIdURL = '/lightning/r/Account/'+row.Opportunity.AccountId+'/view';
                        eachrow.OpportunityIdURL = '/lightning/r/Opportunity/'+row.OpportunityId+'/view';
                        
                    }
                    if ( row.Product2 ) {
                        eachrow.Product2Name = row.Product2.Name;
                    }
                    oppporductlist.push(eachrow);
                   // this.oppproductdata.push(eachrow);
                }
                this.oppproductdata = oppporductlist;
                console.log('called oppproductdata');
                console.log(this.oppproductdata);
                console.log('called oppporductlist');
                console.log(oppporductlist);



                  
            }
            else
            {
                console.log('called error');
                this.dispatchEvent(
                    new ShowToastEvent({
                        message: data.responsemessageinmodal,
                        variant: data.responseStatus
                    })
                );

            }  
			
		}else {
			console.log('called error');
            console.log(error);
			this.dispatchEvent(
                new ShowToastEvent({
                    message: error,
                    variant: 'error'
                })
            );
		}
	}
       */ 



    getSelectedName(event) {
        const selectedRows = event.detail.selectedRows;
        const selectedrowlength = selectedRows.length;
        const valueChangeEvent = new CustomEvent("rowselectionchange", {
            detail: { selectedrowlength }
          });
        this.dispatchEvent(valueChangeEvent);
    }

    handleyearselection(event)
    {
        console.log('year ==');
        console.log(event.detail.year);
        const d = new Date();

     //   var oppproductdatatemp = [...this.oppproductdata];
        var oppproductdatatemp = JSON.parse(JSON.stringify(this.oppproductdata));

        for ( var i = 0; i < oppproductdatatemp.length; i++ ) 
        {
            if(oppproductdatatemp[i].Id === event.detail.opplineid && oppproductdatatemp[i].startyearvaluetag === event.detail.columnstate)
            {
                oppproductdatatemp[i].startyearvalue = parseInt(event.detail.year);


                var listofyears = [];
                for(var k = oppproductdatatemp[i].startyearvalue; k <= 2120; k++)
                {
                    listofyears[listofyears.length] = {label: k , value: k, defaultvalue: false } ;
                }

                oppproductdatatemp[i].endyearpicklistOptions = listofyears;
                if(oppproductdatatemp[i].endyearvalue < oppproductdatatemp[i].startyearvalue)
                    oppproductdatatemp[i].endyearvalue = oppproductdatatemp[i].startyearvalue;

                break;
            }
            else if(oppproductdatatemp[i].Id === event.detail.opplineid && oppproductdatatemp[i].endyearvaluetag === event.detail.columnstate)
            {
                oppproductdatatemp[i].endyearvalue = parseInt(event.detail.year);
                break;
            }
        }



       // this.oppproductdata = Object.assign(this.oppproductdata, changedvalues);
        this.oppproductdata = [...oppproductdatatemp];
        event.stopPropagation();


    }

    @api
    downloadaanualforecasting()
    {
        var Opportunityproductheadercheck = Sector_Bulk_Update_Opportunities_Forecasting_Header;
        var headercolumnswithdatatype = Opportunityproductheadercheck.split(",");
        var columnname = '';
        var selectedRows = this.template.querySelector('[data-id="opplistdownload"]').getSelectedRows();
        for (let i = 0; i < headercolumnswithdatatype.length; i = i + 3) 
        {
            columnname += (columnname != '') ? ',' + headercolumnswithdatatype[i] : headercolumnswithdatatype[i] ;                  
        }
        
        console.log('selectedRowswqe');

        console.log('length='+selectedRows.length);
        console.log('selectedRows='+selectedRows);
        for (let i = 0; i < selectedRows.length; i++)
        {
            console.log('start year'+selectedRows[i].startyearvalue);
            console.log(selectedRows[i].startyearvalue);
            console.log('end year'+selectedRows[i].endyearvalue);
            console.log(selectedRows[i].endyearvalue);
            console.log('year diff='+(selectedRows[i].endyearvalue-selectedRows[i].startyearvalue));
            if(selectedRows[i].startyearvalue != null && selectedRows[i].endyearvalue != null && (selectedRows[i].endyearvalue-selectedRows[i].startyearvalue) >= 0)
            {
                for(let kyear = 0; kyear <= (selectedRows[i].endyearvalue-selectedRows[i].startyearvalue) ; kyear++)
                {
                    console.log('kyear');
                    console.log(kyear);
                    columnname += '\n';
                    var eachrow = selectedRows[i];
                    console.log(eachrow);
                    columnname += '"'+eachrow.OpportunityId+'"'+',';   // Opportunity Id
                    columnname += '"'+eachrow.OpportunityName+'"'+',';   // Opportunity Name
                    columnname += '"'+eachrow.Product_Family__c+'"'+',';  // Product family 
                    columnname += '"'+eachrow.Product2Name+'"'+',';  // product name
                    columnname += ''+( parseInt(selectedRows[i].startyearvalue)+kyear)+',';                      // Year
                   // columnname += ''+',';                      // Year
                    columnname += ''+',';						// Annual Volume
                    columnname += ''+',';						// Annual Revenue
                    columnname += ''+',';						// Annual gross margin
                    columnname += ''+',';						// Annual CO2 Emmision
                    columnname += ''+',';						// Annual CO2 Emmision Reduction
                }
            }
        }
       
        var hiddenElement = document.createElement('a');
        hiddenElement.href = 'data:text/csv;charset=utf-8,' + encodeURI(columnname);
        hiddenElement.target = '_self'; //
        hiddenElement.download = 'Bulk_Annual_Forecasting_Template.csv';  
        document.body.appendChild(hiddenElement); 
        hiddenElement.click();  
    }

}