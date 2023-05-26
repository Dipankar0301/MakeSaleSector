import { api, LightningElement, track } from 'lwc';

export default class SepPtComp4Child extends LightningElement {

    @api myData = 'Hello Ajay';
    @track value = 'dummy value';

    //@api myChildMethod(parm) {
    //  this.value = 'this is from parent to child method output! Dog : ' + parm.Dog + '     Cat :' + parm.Cat + ' !';
    //}

    genEveMethod(event) {
        var calling = new CustomEvent('generated_event_in_child', {
            detail: "bow bow"
        });
        this.dispatchEvent(calling);
    }

}