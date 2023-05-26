trigger Location_self_acc on Location (after insert,after update) {
    
    Map<Id,Schema.Location> self_loc =new Map<Id,Schema.Location>();
    for(Schema.Location lo: Trigger.new)
    {
        if(lo.Parent_Location__c!=null)
            self_loc.put(lo.Parent_Location__c, lo);
    }
    if(self_loc.size()>0){
        List<Schema.Location> re_loc1=[select id,Name, Combined_premise__c, Parent_Location__c from Location 
                                       where Parent_Location__c in: self_loc.keyset()];
        List<Schema.Location> re_loc2=[select id,Name, Combined_premise__c, Parent_Location__c from Location 
                                       where id in: self_loc.keyset()];
        List<Schema.Location> nw=new List<Schema.Location>();
        Integer count=0;
        for(Schema.Location lo2: re_loc2)
        {
        	count=0;    
            for(Schema.Location lo1: re_loc1)
            {
                if(lo2.id == lo1.Parent_Location__c){
                    count++;
                }
            }
            if(count>1)
            {
                lo2.Combined_premise__c =true;
                nw.add(lo2);
            }
        }
    }
}