import { LightningElement, track, wire,api } from 'lwc';
import { getPicklistValues, getObjectInfo } from 'lightning/uiObjectInfoApi';
import OPPORTUNITY_OBJECT from '@salesforce/schema/Opportunity';
import { getRecord,getFieldValue, updateRecord   } from 'lightning/uiRecordApi';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

import Opportunity_Id from "@salesforce/schema/Opportunity.Id";

export default class SeachableMultiSelectPicklist extends LightningElement {

    @api recordId;
    @api fieldlabel = 'ISO';
    //Boolean tracked variable to indicate if modal is open or not default value is false as modal is closed when page is loaded 
    @api isModalOpen = false;
    @api oppfieldapiname = 'ISO__c';


    @track
    options = []
    @track
    allOptions = [];
    @track
    selected
    @track isLoading = true;

    @track Opportunitycountryretr = '';


    @track
    fields = [ 'Opportunity.RecordTypeId','Opportunity.Id'];

    renderedCallback(){
        window.console.log('called renderedCallback');
        this.fields.push('Opportunity.'+this.oppfieldapiname);
        this.isLoading = false;
        this.Opportunitycountryretr = 'Opportunity.'+this.oppfieldapiname;
        window.console.log('called this.oppfieldapiname='+this.oppfieldapiname);
   }   


    @wire(getRecord, { recordId: '$recordId', fields: '$fields'})
    getCountryPicklistvalue({error, data}){
        if(data) {
            window.console.log('called selected values=');
            window.console.log(data);

            if(getFieldValue(data, 'Opportunity.'+this.oppfieldapiname) != null)
            {
                    window.console.log('Opportunity country value 54');
                window.console.log(getFieldValue(data, 'Opportunity.'+this.oppfieldapiname));
                this.selected = getFieldValue(data, 'Opportunity.'+this.oppfieldapiname).split(';')
            }
        }
        else if(error) {
            window.console.log('error =====> '+JSON.stringify(error));
            this.dispatchEvent(
                new ShowToastEvent({
                    message: error.body.message,
                    variant: "error"
                })
            );
        }
    }
   
    


 

    @wire(getObjectInfo, { objectApiName: OPPORTUNITY_OBJECT })
    objectInfo;

    @wire(getRecord, { recordId: '$recordId',  fields: '$fields' })
    opportunityrecorddata


    @wire(getPicklistValues, { fieldApiName: '$Opportunitycountryretr', recordTypeId: '$opportunityrecorddata.data.recordTypeId' }) 
    IndustryPicklist({error, data}) {
        if(data) {
            this.allOptions = data.values; 
           window.console.log(data.values)
           if(data.values != null && data.values.length > 0)
            this.filter();
           
           
        }
        else if(error) {
            this.dispatchEvent(
                new ShowToastEvent({
                    message: error.body.message,
                    variant: "error"
                })
            );
        }
    }

    getselectedvalues() {

    }


    connectedCallback() {
     // this.filter()
    }
    filter(event) {
      let filter = event? 
        new RegExp(this.template.querySelector('lightning-input').value, 'ig'):
        { test: function() { return true }}
      const selected = new Set(this.selected)
      this.options = this.allOptions.filter(option => (filter.test(option.value) || selected.has(option.value)))
    }
    handleChange(event) {
      this.selected = [...event.target.value]
      this.filter(true)
    }

   
    
    openModal() {
        // to open modal set isModalOpen tarck value as true
        this.isModalOpen = true;
    }
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
    }
    submitDetails() {
        // to close modal set isModalOpen tarck value as false
        //Add your code to call apex method or do some processing
        this.isLoading = true;
        this.updateCase();
        this.isLoading = false;
    }

   
    // Update record
    updateCase(){
        const fields = {};
        fields[Opportunity_Id.fieldApiName] = this.recordId;
        let fselectedvalu = '';
        for(let eachselect in this.selected)
        {
            fselectedvalu += this.selected[eachselect] + ';';
        }


        fields[this.oppfieldapiname] = fselectedvalu;
        window.console.log('fselectedvalu valuewefs=');
        window.console.log(fselectedvalu);
        window.console.log('fields');
        window.console.log(fields);
        const recordInput = { fields };
        updateRecord(recordInput)
        .then(() => {
            this.isModalOpen = false;
            this.dispatchEvent(
                new ShowToastEvent({
                    message: 'Opportunity is Saved.',
                    variant: 'success'
                })
            );
        })
        .catch(error => {
                        

                        // Error Handling
            var errors = error.body.output.errors;
            var fieldErrors = error.body.output.fieldErrors;

            console.log('Errors: ');
            console.log(errors);
            console.log('Field Errors: ');
            console.log(fieldErrors);
            console.log('Generic Errors: ' + error.body.message);

            if (error.body.output.errors != null) {
                console.log('Displaying Errors')
                // Loop & Display Errors
                for (let index = 0; index < error.body.output.errors.length; index++) {
                    console.log('Displaying Errors');
                    this.dispatchEvent(
                        new ShowToastEvent({
                            message: error.body.output.errors[index].errorCode + '- ' + error.body.output.errors[index].message,
                            variant: "error"
                        })
                    );
                }
            }
            if (error.body.output.fieldErrors != null) {
                console.log('Displaying Field Errors');
                for (var prop in fieldErrors) {
                    console.log(Object.keys(fieldErrors));
                    var val = Object.values(fieldErrors);
                    console.log(val[0][0]["message"]);
                    this.dispatchEvent(
                        new ShowToastEvent({
                            message: val[0][0]["message"],
                            variant: 'error'
                        })
                    );
                }
            } else {
                console.log('Displaying Generic Errors')
                this.dispatchEvent(
                    new ShowToastEvent({
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            }
            console.error('Error Updating Information');
            console.error(error);





        });
    }

 

}