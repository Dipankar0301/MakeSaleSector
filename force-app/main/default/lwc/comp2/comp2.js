import { LightningElement, track } from 'lwc';

export default class Comp2 extends LightningElement {

    @track
    products = [{
            productId: 1001,
            productName: 'Laptop'
        },
        {
            productId: 1002,
            productName: 'LED Tv'
        },
        {
            productId: 1003,
            productName: 'Mobile Phone'
        },
        {
            productId: 1004,
            productName: 'Washing Machine'
        },

    ];
    proId;
    proName;
    changeid(event) {
        this.proId = event.target.value;
    }
    changename(event) {
        this.proName = event.target.value;
    }
    addProductDeatils() {
        this.products.push({
            productId: this.proId,
            productName: this.proName
        });
        alert(this.proId + '   ' + this.proName);
    }
    index;
    delProduct(event) {

        this.index = event.target.value;
        this.products.splice(this.index, 1)
    }
    ppid;
    @track
    product = [{
        productId: '',
        productName: ''
    }]
    searchppid(event) {
        this.ppid = event.target.value;
    }
    sname;
    sid;
    searchProduct(event) {
        this.product = this.products.find(p => { return p.productId == this.ppid });
        this.sname = this.product.productName;
        this.sid = this.product.productId;
    }
}