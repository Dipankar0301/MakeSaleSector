import { LightningElement,api, wire } from 'lwc';
import getoppproducts from '@salesforce/apex/OpportunityProductList.getoppproducts';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import TotalsFields from '@salesforce/label/c.Sector_TotalsFields';

export default class Sector_RelatedListTotalsProducts extends LightningElement {
    @api recordId;
    columns = [];
    tabledata = [];
    listoffields = '';
    data;


    connectedCallback()
    {
        var arraylist = TotalsFields.split(",");
        var fieldlist = '';
        for(var indexeach = 0; indexeach < arraylist.length;  indexeach = indexeach+4)
        {
            fieldlist += ((fieldlist === '') ? arraylist[indexeach] : ','+arraylist[indexeach]);
            this.columns.push({ label: arraylist[indexeach+2], fieldName: arraylist[indexeach+1], type: arraylist[indexeach+3] });
        }
        console.log('fieldlistfieldlist==');
        console.log(fieldlist);
        this.listoffields = fieldlist;
        refreshApex(this._wiredMarketData);


    }

    _wiredMarketData;
    @wire(getoppproducts, { OppId: '$recordId',listoffields: '$listoffields'})
    wiredContacts({ _wiredMarketData }) {
        this._wiredMarketData = _wiredMarketData;
        const { data, error } = _wiredMarketData;
        if (data) {
            
            if( data.responseStatus === 'success')
            {
                var oppproductdatatemp = JSON.parse(JSON.stringify(data.OppLine));
                for ( var i = 0; i < oppproductdatatemp.length; i++ ) 
                {
                    oppproductdatatemp[i].Product2Name = oppproductdatatemp[i].Product2.Name;
                    oppproductdatatemp[i].Product2Family = oppproductdatatemp[i].Product2.Family;
                    oppproductdatatemp[i].QuantityUnit = oppproductdatatemp[i].Product2.QuantityUnitOfMeasure;
                }
                this.tabledata = oppproductdatatemp;
            }
            else
            {
                this.dispatchEvent(
                    new ShowToastEvent({
                        message: data.responseMessage,
                        variant: data.responseStatus
                    })
                );
            }
        } else if (error) {
            this.dispatchEvent(
                new ShowToastEvent({
                    message: error.body.message,
                    variant: "error"
                })
            );
            
        }
    }

}