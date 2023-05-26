import { LightningElement,api,wire } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import fetchLookupData from '@salesforce/apex/SectorCalenderAttendeesController.fetchLookupData';
const DELAY = 300; // dealy apex callout timing in miliseconds

export default class Sectorcustomlookup extends LightningElement {
     // public properties with initial default values 
     @api label = 'custom lookup label';
     @api placeholder = 'search...'; 
     @api iconName = 'standard:account';
     @api sObjectApiName = 'Account';
     @api objectfilters = '';
     @api defaultRecordId = '';
     @api exludelistids = [];
     @api searchshellcontact = false;
     // private properties 
     lstResult = []; // to store list of returned records   
     hasRecords = true; 
     searchKey=''; // to store input field value    
     isSearchLoading = false; // to control loading spinner  
     delayTimeout;
     selectedRecord = {}; // to store selected lookup record in object formate 

     // wire function property to fetch search record based on user input
     @wire(fetchLookupData, { searchKey: '$searchKey' , sObjectApiName : '$sObjectApiName',
      objectfilters : '$objectfilters', exludelistids : '$exludelistids', searchshellcontact : '$searchshellcontact' })
      searchResult(value) {
            const { data, error } = value; // destructure the provisioned value
            this.isSearchLoading = false;
            if (data) {
                if(data.responseStatus == 'success')
                {
                    this.hasRecords = data.returnsearchresult.length == 0 ? false : true; 
                    this.lstResult = JSON.parse(JSON.stringify(data.returnsearchresult)); 
                }
                else
                {
                    const event = new ShowToastEvent({
                        variant : data.responseStatus,
                        message: data.responseMessage,
                    });
                    this.dispatchEvent(event); 
                }
             }
            else if (error) {
                console.log('(error---> ' + JSON.stringify(error));
                var errormsg1 = (error != null && error.body != null && error.body.message != null) ? error.body.message : '';
                var errormsgcatch = 'Something went wrong. '+errormsg1+ ' .Please try again or contact system admin.'
                const event = new ShowToastEvent({
                    variant : 'error',
                    message: JSON.stringify(errormsgcatch),
                });
                this.dispatchEvent(event); 
             }
     };
        
   // update searchKey property on input field change  
     handleKeyChange(event) {
         // Debouncing this method: Do not update the reactive property as long as this function is
         // being called within a delay of DELAY. This is to avoid a very large number of Apex method calls.
         this.isSearchLoading = true;
         window.clearTimeout(this.delayTimeout);
         const searchKey = event.target.value;
         this.delayTimeout = setTimeout(() => {
         this.searchKey = searchKey;
         }, DELAY);
     }
     // method to toggle lookup result section on UI 
     toggleResult(event){
         const lookupInputContainer = this.template.querySelector('.lookupInputContainer');
         const clsList = lookupInputContainer.classList;
         const whichEvent = event.target.getAttribute('data-source');
         switch(whichEvent) {
             case 'searchInputField':
                 clsList.add('slds-is-open');
                break;
             case 'lookupContainer':
                 clsList.remove('slds-is-open');    
             break;                    
            }
     }
    // method to clear selected lookup record  
    handleRemove(){
     this.searchKey = '';    
     this.selectedRecord = {};
     this.lookupUpdatehandler(undefined); // update value on parent component as well from helper function 
     
     // remove selected pill and display input field again 
     const searchBoxWrapper = this.template.querySelector('.searchBoxWrapper');
      searchBoxWrapper.classList.remove('slds-hide');
      searchBoxWrapper.classList.add('slds-show');
      const pillDiv = this.template.querySelector('.pillDiv');
      pillDiv.classList.remove('slds-show');
      pillDiv.classList.add('slds-hide');
   }
   // method to update selected record from search result 
 handelSelectedRecord(event){   
      var objId = event.target.getAttribute('data-recid'); // get selected record Id 
      this.selectedRecord = this.lstResult.find(data => data.Id === objId); // find selected record from list 
      this.lookupUpdatehandler(this.selectedRecord); // update value on parent component as well from helper function 
      this.handelSelectRecordHelper(); // helper function to show/hide lookup result container on UI
 }
 /*COMMON HELPER METHOD STARTED*/
 handelSelectRecordHelper(){
     this.template.querySelector('.lookupInputContainer').classList.remove('slds-is-open');
      const searchBoxWrapper = this.template.querySelector('.searchBoxWrapper');
      searchBoxWrapper.classList.remove('slds-show');
      searchBoxWrapper.classList.add('slds-hide');
      const pillDiv = this.template.querySelector('.pillDiv');
      pillDiv.classList.remove('slds-hide');
      pillDiv.classList.add('slds-show');     
 }
 // send selected lookup record to parent component using custom event
 lookupUpdatehandler(value){    
     const oEvent = new CustomEvent('lookupupdate',
     {
         'detail': {selectedRecord: value}
     }
 );
 this.dispatchEvent(oEvent);
 }
}