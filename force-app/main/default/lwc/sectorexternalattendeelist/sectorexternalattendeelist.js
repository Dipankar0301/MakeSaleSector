import { LightningElement,api, wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import getattendeesdata from '@salesforce/apex/SectorCalenderAttendeesController.getContacts_Attendee';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import saveattendee from '@salesforce/apex/SectorCalenderAttendeesController.saveAttendees_contact';
import deleteAttendees from '@salesforce/apex/SectorCalenderAttendeesController.deleteAttendees_contact';
import shellaccountid from '@salesforce/label/c.Sector_ShellAccountId';
import CONTACT_OBJECT from '@salesforce/schema/Contact';
import { NavigationMixin } from 'lightning/navigation';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
const internalattendeelabel = 'External Attendees ';

export default class sectorexternalattendeelist extends NavigationMixin(LightningElement) {
    @api recordId;
    data;
    isShowModal = false;
    attendeeselected = null;
    deleterecordselected = null;
    isShowModaldelete = false;
    isShowModaltable = false;
    numberofattendee = internalattendeelabel+"(0)";
    shellaccountid = shellaccountid;
    objectfiltersparent = ' and Id not in :exludelistids and AccountId != \''+this.shellaccountid+'\' ';
    exludelistidsparent = [];
    isownerofevent = false;
    objectname = 'contact';
    objecticon = 'standard:contact';
    isShowModalAddAttendeeEmail = false;
    contactObject = CONTACT_OBJECT;

    

    @wire(getObjectInfo, { objectApiName: CONTACT_OBJECT })
    objectInfo;

    get contactsectorrecordTypeId() 
    {
        // Returns a map of record type Ids 
        const rtis = this.objectInfo.data.recordTypeInfos;
        return Object.keys(rtis).find(rti => rtis[rti].name === 'Sector');
    }


    actions = [ { label: 'Delete', name: 'delete' } ];

    columns = [
        { label: 'Attendee Name', fieldName: 'AttendeeName' },
        { label: 'Email', fieldName: 'AttendeeEmail' }
    ];


    hideModalBoxAttendeeEmail()
    {
        this.isShowModalAddAttendeeEmail = false;
    }


    _wiredMarketData;
    @wire(getattendeesdata, {recordId: '$recordId'})
    dataTableAcc(_wiredMarketData){
            this._wiredMarketData = _wiredMarketData;
            const { data, error } = _wiredMarketData;
         if(data){
            if(data.responseStatus == 'success')
            {
                this.isownerofevent = data.isownerofevent;

                if(data.isownerofevent)
                {
                    
                    this.columns = [
                        { label: 'Attendee Name', fieldName: 'AttendeeName' },
                        { label: 'Email', fieldName: 'AttendeeEmail' },  
                        { type: 'action', typeAttributes: { rowActions: this.actions } }
                    ];
                }
                

                this.data = data.Attendees;
                this.exludelistidsparent = data.AttendeesIds;
                if(this.data && this.data.length > 0)
                {
                    this.isShowModaltable = true;
                    this.numberofattendee = internalattendeelabel+"("+this.data.length+")";
                }
                else
                {
                    this.isShowModaltable = false;
                    this.numberofattendee = internalattendeelabel+"(0)";
                }
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
        else if(error){
            var errormsg1 = (error != null && error.body != null && error.body.message != null) ? error.body.message : '';
            var errormsgcatch = 'Something went wrong. '+errormsg1+ ' .Please try again or contact system admin.'
            const event = new ShowToastEvent({
                variant : 'error',
                message: JSON.stringify(errormsgcatch),
            });
            this.dispatchEvent(event); 
        }
    }

    handlecontactcreated(event)
    {
        console.log('onsuccess event recordEditForm', event.detail.id);
        this.attendeeselected = event.detail.id;
        this.isShowModalAddAttendeeEmail = false;
        this.saveattendee();

    }


    handleRowAction(event) {
        const action = event.detail.action;
        const row = event.detail.row;
        switch (action.name) {
            case 'delete':
                {
                    this.deleterecordselected = row.AttendeeId;
                    this.isShowModaldelete = true;
                }
                break;
        }
    }



    addattendee(event) {
        this.objectname = 'contact';
        this.objectfiltersparent = ' and Id not in :exludelistids and AccountId != \''+this.shellaccountid+'\' ';
        this.objecticon = 'standard:contact';
        this.isShowModal = true;
    }
    hideModalBox()
    {
        this.attendeeselected = null;
        this.isShowModal = false;
    }

    hideModalBoxdelete()
    {
        this.deleterecordselected = null;
        this.isShowModaldelete = false;
    }
    lookupRecord(event){
        this.attendeeselected = (event != null && event.detail != null && event.detail.selectedRecord != null && event.detail.selectedRecord.Id != null) ? 
        event.detail.selectedRecord.Id : null;
    }

    addattendee_Lead()
    {
        this.objectname = 'lead';
        this.objectfiltersparent = ' and Id not in :exludelistids ';
        this.objecticon = 'standard:lead';
        this.isShowModal = true;
    }

    showaddattendeeemail()
    {
      //  this.isShowModalAddAttendeeEmail = true;

     /*   this[NavigationMixin.Navigate]({
            type: 'standard__objectPage',
            attributes: {
                objectApiName: 'contact',
                actionName: 'new'
            }
        }); */


        const functiontocreaterecord  = Function('$A.get("e.force:createRecord").setParams({"entityApiName": "contact","recordTypeId" : "'+this.contactsectorrecordTypeId+'" ,"navigationLocation" : "LOOKUP", "panelOnDestroyCallback": function(event) {  $A.get("e.force:showToast").setParams({ "type" : "info", "message": "Once you have created the contact next step is to add attendee." }).fire(); } }).fire();');  // we don't have any alternative in LWC
        functiontocreaterecord();

    }

    saveattendee()
    {
        if(this.attendeeselected)
            {

                saveattendee({ eventId: this.recordId, attendeeId: this.attendeeselected})
                .then((result) => {
                    if(result.responseStatus == 'success')
                    {
                        this.attendeeselected = null;
                        const event = new ShowToastEvent({
                            variant : result.responseStatus,
                            message: result.responseMessage,
                        });
                        this.dispatchEvent(event);
                        this.isShowModal = false;
                        refreshApex(this._wiredMarketData);
                        const functiontorefresh  = Function("$A.get('e.force:refreshView').fire();");  // getRecordNotifyChange does not work properly if we change the child records
                        functiontorefresh();
                    }
                    else
                    {
                        const event = new ShowToastEvent({
                            variant : result.responseStatus,
                            message: result.responseMessage,
                        });
                        this.dispatchEvent(event);
                    }
                })
                .catch((error) => {
                    const event = new ShowToastEvent({
                        variant : 'error',
                        message: JSON.stringify(error),
                    });
                    this.dispatchEvent(event); 
                });
            }
        else
        {
            const event = new ShowToastEvent({
                variant : 'info',
                message: 'Please select Attendee',
            });
            this.dispatchEvent(event);
        }
    }


    deleteattendee()
    {
        if(this.deleterecordselected)
            {

                deleteAttendees({ eventId: this.recordId, attendeeId: this.deleterecordselected})
                .then((result) => {
                    if(result.responseStatus == 'success')
                    {
                        const event = new ShowToastEvent({
                            variant : result.responseStatus,
                            message: result.responseMessage,
                        });
                        this.dispatchEvent(event);
                        this.isShowModaldelete = false;
                        refreshApex(this._wiredMarketData);
                        const functiontorefresh  = Function("$A.get('e.force:refreshView').fire();");  // getRecordNotifyChange does not work properly if we change the child records
                        functiontorefresh();
                    }
                    else
                    {
                        const event = new ShowToastEvent({
                            variant : result.responseStatus,
                            message: result.responseMessage,
                        });
                        this.dispatchEvent(event);
                    }
                })
                .catch((error) => {
                    const event = new ShowToastEvent({
                        variant : 'error',
                        message: JSON.stringify(error),
                    });
                    this.dispatchEvent(event); 
                });

                
            }
    }

}