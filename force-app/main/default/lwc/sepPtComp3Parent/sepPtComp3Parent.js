import { LightningElement, track } from 'lwc';

export default class SepPtComp3Parent extends LightningElement {

    //fromParentToChild() {
    // var childCompo = this.template.querySelector('c-sep-pt-comp4-child');
    //  var parm = { 'Dog': 'bow bow', 'Cat': 'meow meow' };
    //  childCompo.myChildMethod(parm);
    //}>
    @track ch = 'abc';
    @track di = '';
    parentMethodCall(event) {
        alert('hi from parentMethodCall ' + event.detail);
        this.ch = event.detail;

    }
}