import { api, LightningElement, track } from 'lwc';

export default class SeptPtChildComp4 extends LightningElement {

    @api mydata = 'Hello Dipankar123';
    @track value = 'dummy value';
    @api myChildMethod(parm) {
        this.value = 'this is from parent to child method output! Dog : ' + parm.Dog + '   Cat:' + parm.Cat;
    }

    genEveMethod() {
        var parantMethodCall = new CustomEvent('generateda_event_in_child', {
            ching: 'chong',
            ding: 'dong'
        });
        this.dispatchEvent(parantMethodCall);
    }
}