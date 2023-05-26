@isTest
public class Product_delete_Test {
    public static testmethod void ins_ERT(){
        ProductRequest pr=new ProductRequest(Status='Draft');
        insert pr;
        ProductRequest prX=new ProductRequest(Status='Draft');
        insert prX;
        Product2 pd=new Product2(Name='Solar Panel System 6000');
        insert pd;
        ProductRequestLineItem prli=new ProductRequestLineItem(Product2Id=pd.id, QuantityRequested=100,ParentId=pr.id);
        insert prli;
        ProductTransfer pt1=new ProductTransfer(Product2Id=pd.id, QuantitySent=50,ProductRequestLineItemId=prli.id);
        insert pt1;
        ProductTransfer pt2=new ProductTransfer(Product2Id=pd.id, QuantitySent=40,ProductRequestLineItemId=prli.id);
        insert pt2;
        delete pr;
        //delete prX;
    }

}