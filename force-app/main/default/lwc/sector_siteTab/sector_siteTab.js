import { LightningElement } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';

export default class Sector_siteTab extends NavigationMixin(LightningElement) {
    navigateToNewOpportunity() {
    this[NavigationMixin.Navigate]({
        type: 'standard__objectPage',
        attributes: {
            objectApiName: 'Opportunity',
            actionName: 'new'
        }
    });
}
}