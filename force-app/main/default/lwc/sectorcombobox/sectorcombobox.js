import { LightningElement, api } from 'lwc';

export default class Sectorcombobox extends LightningElement {

    @api label;
    @api value;
    @api options;
    @api opplineid;
    @api columnstate;

    handleChange(event)
    {
        this.value = event.target.value;
       // this.value = event.detail.value;
        console.log('this.value==');
        console.log(this.value);
        const selectedEvent = new CustomEvent('yearselected', { detail: {year:this.value, opplineid: this.opplineid, columnstate: this.columnstate  }, 
                                                                bubbles: true, composed: true });
        // Dispatches the event.
        this.dispatchEvent(selectedEvent);
    }

}