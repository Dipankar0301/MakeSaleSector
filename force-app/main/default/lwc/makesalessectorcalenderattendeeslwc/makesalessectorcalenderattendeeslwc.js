import { LightningElement,api, wire } from 'lwc';
import { refreshApex } from '@salesforce/apex';
import getattendeesdata from '@salesforce/apex/SectorCalenderAttendeesController.getAttendees';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import saveattendee from '@salesforce/apex/SectorCalenderAttendeesController.saveAttendees';
import deleteAttendees from '@salesforce/apex/SectorCalenderAttendeesController.deleteAttendees';
import shellaccountid from '@salesforce/label/c.Sector_ShellAccountId';
import { getObjectInfo } from 'lightning/uiObjectInfoApi';
import CONTACT_OBJECT from '@salesforce/schema/Contact';
import LASTNAME_FIELD from '@salesforce/schema/Contact.lastname';
import FIRSTNAME_FIELD from '@salesforce/schema/Contact.firstname';
import EMAIL_FIELD from '@salesforce/schema/Contact.Email';
import ACCOUNTID_FIELD from '@salesforce/schema/Contact.accountid';

const internalattendeelabel = 'Internal (Salesforce) Attendees ';

export default class Makesalessectorcalenderattendeeslwc extends LightningElement{
    @api recordId;
    data;
    isShowModal = false;
    attendeeselected = null;
    deleterecordselected = null;
    isShowModaldelete = false;
    isShowModaltable = false;
    numberofattendee = internalattendeelabel+"(0)";
    objectfiltersparent = 'and IsActive=true and Id not in :exludelistids';
    exludelistidsparent = [];
    isownerofevent = false;
    isShowModalAddAttendeeEmail = false;
    shellaccountid = shellaccountid;
    contactObject = CONTACT_OBJECT;
    lastnameField = LASTNAME_FIELD;
    firstnameField = FIRSTNAME_FIELD;
    emailField = EMAIL_FIELD;
    accountidField = ACCOUNTID_FIELD;


    isLoading = false;
    

    actions = [ { label: 'Delete', name: 'delete' } ];

    columns = [
        { label: 'Attendee Name', fieldName: 'AttendeeName' },
        { label: 'Email', fieldName: 'AttendeeEmail' }
    ];



    @wire(getObjectInfo, { objectApiName: CONTACT_OBJECT })
    objectInfo;

    get contactsectorrecordTypeId() 
    {
        // Returns a map of record type Ids 
        const rtis = this.objectInfo.data.recordTypeInfos;
        return Object.keys(rtis).find(rti => rtis[rti].name === 'Sector');
    }


    handlecontactcreated(event)
    {
        console.log('onsuccess event recordEditForm', event.detail.id);
        this.attendeeselected = event.detail.id;
        this.isShowModalAddAttendeeEmail = false;
        this.saveattendee();

    }

    showaddattendeeemail()
    {
        this.isShowModalAddAttendeeEmail = true;
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

    _wiredMarketData;
    @wire(getattendeesdata, {recordId: '$recordId'})
    dataTableAcc(_wiredMarketData){
            this.isLoading = true;
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
                this.isLoading = false;
            }
            else
            {
                const event = new ShowToastEvent({
                    variant : data.responseStatus,
                    message: data.responseMessage,
                });
                this.dispatchEvent(event);
                this.isLoading = false;
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
            this.isLoading = false;
        }
    }


    addattendee(event) {
        this.isShowModal = true;
    }
    hideModalBox()
    {
        this.attendeeselected = null;
        this.isShowModal = false;
    }

    hideModalBoxAttendeeEmail()
    {
        this.isShowModalAddAttendeeEmail = false;
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

    saveattendee()
    {
        this.isLoading = true;
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

                        this.isShowModalAddAttendeeEmail = false;

                        refreshApex(this._wiredMarketData);
                        const functiontorefresh  = Function("$A.get('e.force:refreshView').fire();");  // getRecordNotifyChange does not work properly if we change the child records
                        functiontorefresh();
                        this.isLoading = false;
                    }
                    else
                    {
                        const event = new ShowToastEvent({
                            variant : result.responseStatus,
                            message: result.responseMessage,
                        });
                        this.dispatchEvent(event);
                        this.isLoading = false;
                    }
                    
                })
                .catch((error) => {
                    const event = new ShowToastEvent({
                        variant : 'error',
                        message: JSON.stringify(error),
                    });
                    this.dispatchEvent(event); 
                    this.isLoading = false;
                });
            }
        else
        {
            const event = new ShowToastEvent({
                variant : 'info',
                message: 'Please select Attendee',
            });
            this.dispatchEvent(event);
            this.isLoading = false;
        }
    }


    deleteattendee()
    {
        this.isLoading = true;
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
                        this.isLoaded = false;
                    }
                    else
                    {
                        const event = new ShowToastEvent({
                            variant : result.responseStatus,
                            message: result.responseMessage,
                        });
                        this.dispatchEvent(event);
                        this.isLoading = false;
                    }
                })
                .catch((error) => {
                    const event = new ShowToastEvent({
                        variant : 'error',
                        message: JSON.stringify(error),
                    });
                    this.dispatchEvent(event); 
                    this.isLoading = false;
                });

                
            }
    }



}