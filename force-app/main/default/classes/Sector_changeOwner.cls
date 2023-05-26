public  with sharing class Sector_changeOwner {
    
    
    public List<Account> acc{get;set;}
    public Sector_changeOwner(ApexPages.StandardSetController controller1) 
    {
        controller1.setPageSize(10);
        acc = new List<Account>();
        acc =  [Select Id,Name,Ownerid,(Select Id,name From contacts) From Account];
    }
    
    
    public PageReference save(){
        update acc;
        return null;
    }   
}