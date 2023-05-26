import { LightningElement,track,api } from 'lwc';
import getCompletionPercentage from '@salesforce/apex/Sector_OpportunityProgressBar.getCompletionPercentage';

export default class Sector_OpportunityProgressBar extends LightningElement {
    @api recordId;
    @track opportunity;
    percentageCompletion =0;
    connectedCallback() {
        console.log('LWC Component Loaded Successfully');
        getCompletionPercentage({recordId: this.recordId})
        .then(data=>{
            console.log('data---->'+data);
            this.percentageCompletion =data;
            //this.opportunity = data[0];
           // this.getCompletionPercentage = this.opportunity.Name;

        })
    }
    /*handleChange(event) {
    
    }
    fieldsCompleted() {
        var numVal = 0;

        if (this.firstName != null && this.firstName != '') {
            numVal = numVal + 1;
        }

        if (this.lastName != null && this.lastName != '') {
            numVal = numVal + 1;
        }

        if (this.birthdate != null && this.birthdate != '') {
            numVal = numVal + 1;
        }

        if (this.emailAddress != null && this.emailAddress !='') {
            numVal = numVal + 1;
        }
        
        if (this.mobile != null && this.mobile !='') {
            numVal = numVal + 1;
        }

        this.progressBar(numVal);
    }*/





}