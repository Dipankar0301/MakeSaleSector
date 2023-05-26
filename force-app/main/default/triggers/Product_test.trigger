trigger Product_test on ProductTransfer (after insert,after update) {
    
    List<ProductTransfer> pt1=Trigger.New;
    Id id1=pt1[0].ProductRequestId;
    List<ProductRequest> li2=new List<ProductRequest>();
    li2=[select id, status from ProductRequest where id =: id1];
    Integer flag=0;
    List<ProductRequest> xc=new List<ProductRequest>();
    
    for(ProductTransfer pt : [select id,status from ProductTransfer where ProductRequestId =: id1]){
        if(pt.status !='Completed'){
            flag=1;
            break;
        }
    }
    if(flag==0){
        for(ProductRequest pr: li2){
            pr.status='Received';
            xc.add(pr);
        }
        if(xc.size()>0)
            update xc;
    }  
    
    /* Set<Id> ProductRequestIdSet = new Set<Id>();
Integer flag;
List<ProductRequest> PRUpdateList = new List<ProductRequest>();
for (ProductTransfer pt : Trigger.new) {
if (pt.Status == 'Completed') {
ProductRequestIdSet.add(pt.ProductRequestId);
}
}
if (ProductRequestIdSet.size() > 0) {
List<ProductTransfer> productTransferList = [select Id, status, ProductRequestId from ProductTransfer where ProductRequestId in: ProductRequestIdSet order by ProductRequestId];

for (ProductRequest pr : [select Id, status from ProductRequest where Id in: ProductRequestIdSet]) {
flag = 0;
for (ProductTransfer pt : productTransferList) {
if(pt.ProductRequestId == pr.Id){
system.debug('1');
if ((pt.status != 'Completed')) {
flag = 1;
system.debug('2');
break;
}
}
else{
//flag=1;
system.debug('3');
break;
}    
}
if (flag == 0) {
pr.status = 'Received';
PRUpdateList.add(pr);
}
}
if (PRUpdateList.size() > 0) {
update PRUpdateList;
}
}*/
    
    
}