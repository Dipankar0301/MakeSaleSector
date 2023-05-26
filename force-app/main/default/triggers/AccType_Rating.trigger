trigger AccType_Rating on Account (before insert,before update) {
	List<Account> li=new List<Account>();
    for(Account acc2: Trigger.new)
    {
        //li.add(acc2);
        if(acc2.type=='Prospect')
    	{
            acc2.City__c='Kolkata';
    	}
    }    	
}