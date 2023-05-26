import { api, LightningElement, track } from 'lwc';
//import doj from '@salesforce/schema/PTObj__c.Doj__c';
//import email from '@salesforce/schema/PTObj__c.E_mail__c';
import mobile from '@salesforce/schema/PTObjs__c.Mobile_Number1__c';
import name from '@salesforce/schema/PTObjs__c.Name';
//import ownerId from '@salesforce/schema/PTObj__c.OwnerId';

export default class SepPtComp7dataService extends LightningElement {

    @api recordId;
    @api objectApiName;

    @track fields = [mobile, name];

    connectedCallback() {
        this.objectName = this.objectApiName;
    }

}