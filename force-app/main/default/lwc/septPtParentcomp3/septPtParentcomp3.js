import { LightningElement, track } from 'lwc';

export default class SeptPtParentcomp3 extends LightningElement {

    fromParentToChild() {

        var childcomp = this.template.querySelector('c-sept-pt-child-comp4');
        var parm = { 'Dog': 'bow bow', 'Cat': 'meow meow' };
        childcomp.myChildMethod(parm);

    }
    @track ch = '';
    @track di = '';
    parentMethodCall(event) {
        alert('hi from parentMethodCall ' + event.ching + '  ' + event.ding);
        this.ch = event.ching.value;
        this.di = event.ding.value;
    }

}