trigger Con_Acc on Contact (before insert, before update,after insert, after update) {
    /*if(Trigger.isbefore){
	Map<id,Contact> m1=new Map<id,Contact>();
    for(Contact con: Trigger.new){
        m1.put(con.accountid, con);
    }
    List<Account> li=[select id,Name from Account where Id in: m1.keySet()];
    for(Account acc: li)
    {
        if(acc.Id == m1.get(acc.id).accountid)
        {
            system.debug(acc.name);
            m1.get(acc.id).Account_name__c=acc.name;
        }
    }
    }
    else if(Trigger.isAfter){
        Map<id,Contact> m1=new Map<id,Contact>();
        Map<id,Contact> m2=new Map<id,Contact>();
    	for(Contact con: Trigger.new){
            if( con.AccountId != Trigger.oldMap.get(con.id).AccountId){
                if(con.accountId!= null)
                {
                    m1.put(con.accountid, con);
                }
                else if(Trigger.oldMap.get(con.id).AccountId!= null)
                {
                    m2.put(Trigger.oldMap.get(con.id).AccountId, con);
                }
            }
    	}
        Account acc1=[select id,Name from account where id=:m1.keyset()];
        Account acc2=[select id,Name from account where id=:m2.keyset()];
        if(m1.size()==m2.size()){
        Integer a =integer.valueof(acc1.No_of_contacts__c);
        a++;
        String s=String.valueOf(a);
        acc1.No_of_contacts__c=s;
        Integer a1 =integer.valueof(acc1.No_of_contacts__c);
        a1--;
        String s1=String.valueOf(a1);
        acc1.No_of_contacts__c=s1;
        }
        else if(m1.size()==1){
            Integer a =integer.valueof(acc1.No_of_contacts__c);
        	a++;
        	String s=String.valueOf(a);
        	acc1.No_of_contacts__c=s;
        }
        else{}
    }*/
}