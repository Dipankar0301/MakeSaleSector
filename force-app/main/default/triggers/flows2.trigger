trigger flows2 on Opportunity (before insert, before update) {
	Map<id,Opportunity> m1=new Map<id,Opportunity>();
    for(Opportunity opp: Trigger.new){
        m1.put(opp.accountid, opp);
    }
    List<Account> li=[select id,AnnualRevenue from Account where Id in: m1.keySet()];
    for(Account acc: li)
    {
        if(acc.AnnualRevenue>200){
            m1.get(acc.id).Discount_Percentage__c=10;
        }
        else if(acc.AnnualRevenue<200 && acc.AnnualRevenue>100){
            m1.get(acc.id).Discount_Percentage__c=5;
        }
        else{
            m1.get(acc.id).Discount_Percentage__c=0;
        }
    }
}