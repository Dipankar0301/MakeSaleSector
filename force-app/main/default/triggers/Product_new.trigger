trigger Product_new on ProductTransfer (before insert,before update) {
    /*List<ProductTransfer> pt=new List<ProductTransfer>();
    for(ProductTransfer pt1 : Trigger.new)
    {
        pt.add(pt1);
    }*/
    List<Schema.Location> loca=[select id, Name,DestinationPlant__c,DestinationStorageLocation__c, 
                                SourcePlant__c, SourceStorageLocation__c from location];
    List<ProductTransfer> pt2=new List<ProductTransfer>();

    for(ProductTransfer pt1: Trigger.new){
        for(Schema.Location lo : loca)
        {
			if(pt1.SourcePlant__c == lo.SourcePlant__c && lo.SourceStorageLocation__c == pt1.SourceStorageLocation__c)
            {
				pt1.SourceLocationId=lo.id;  
                pt2.add(pt1);
            }
        }
    }
    update pt2;
    
    
    Map<String,ProductTransfer> pt8=new Map<String, ProductTransfer>();
    //Map<String,ProductTransfer> pt9=new Map<String, ProductTransfer>();
    String s='';
    for(ProductTransfer pt4 : Trigger.new)
    {
        s=pt4.DestinationStorageLocation__c +'.'+ pt4.DestinationPlant__c ;
        pt8.put(s, pt4);
    }
    for(Schema.Location pt4 : [select id,DestinationPlant__c, DestinationStorageLocation__c from Location])
    {
        s=pt4.DestinationStorageLocation__c + '.' + pt4.DestinationPlant__c;
        if(pt8.containsKey(s))
        {
            pt8.get(s).DestinationLocationId=pt4.id;
        }
    }
    
    
}