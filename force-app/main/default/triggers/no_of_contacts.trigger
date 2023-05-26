trigger no_of_contacts on Account (before insert,before update) {
    Map<id,Account> ma=new Map<id,Account>();
    for(Account acc:Trigger.New){
        ma.put(acc.id,acc);
    }
	List<Contact> li=[select id,AccountId from contact where accountId in: ma.keySet()];
    Integer count=0;
    for(account a: ma.values())
    {
        count=0;
        for(contact c:li)
        {
            if(a.id==c.accountId)
                count++;
        }
        String s=String.valueOf(count);
        a.No_of_contacts__c=s;
    }
}