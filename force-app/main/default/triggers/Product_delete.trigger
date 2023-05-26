trigger Product_delete on ProductRequest (after delete) {
	Set<id> pr = new Set<id>();
    for(ProductRequest pr1: Trigger.old)
    {
        pr.add(pr1.id);
    }
    List<ProductTransfer> pt=[select id, ProductRequestId from ProductTransfer where ProductRequestId in: pr];
    if(pt.size()>0){
    	delete pt;
    }
    else{
        system.debug('No product transfer found');
    }
}