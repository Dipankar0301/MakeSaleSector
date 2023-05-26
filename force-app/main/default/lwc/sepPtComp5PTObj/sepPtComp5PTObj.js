import { LightningElement, track } from 'lwc';
import savePTObj from '@salesforce/apex/PTObjlwcController.savePTObj';

export default class sepPtComp5PTObj extends LightningElement {
    name;
    phoneNumber;
    //Name__c;
    @track outputObject;
    @track error;

    addName(event) {
        this.name = event.target.value;
    }
    addPhoneNumber(event) {
        this.phoneNumber = event.target.value;
    }
    addPtObjDetails() {
        savePTObj({
            name: this.name,
            //email: this.email,
            phoneNumber: this.phoneNumber,
            //Name__c: this.Name__c
            //doj: this.doj
        }).then(data => {
            this.outputObject = data;
        }).catch(error => {
            this.error = error.body.message;
        });
    }
}