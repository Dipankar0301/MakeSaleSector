trigger Cris_Case on Case (before insert,before update) {
    Map<id,Case> ca1=new Map<id,Case>();
    Map<id,Case> ca2=new Map<id,Case>();
    for(Case c: Trigger.new)
    {
        ca1.put(c.AccountId, c);
        ca2.put(c.Location__c, c);
    }
    list<Account> acc=[select id, name,CSSIs__c,CRISId__c from account where id in: ca1.keySet()];
    list<Schema.Location> loc=[select id, name, CSSIs__c,CRISId__c from Location where id in: ca2.keySet()];
    if(acc.size()>0)
    {
        for(Account l: acc)
        if(l.CSSIs__c== null){
            if(!((ca1.get(l.id).OrderType__c =='a' && ca1.get(l.id).ReasonCode__c =='p') 
               || (ca1.get(l.id).OrderType__c =='b' && ca1.get(l.id).ReasonCode__c =='s') 
               || (ca1.get(l.id).OrderType__c =='b' && ca1.get(l.id).ReasonCode__c =='t')))
            {
                ca1.get(l.id).addError('Please select correct OrderType and ReasonCode');
            }
        }
        else if(l.CRISId__c== null){
            if(!((ca1.get(l.id).OrderType__c =='b' && ca1.get(l.id).ReasonCode__c =='s') || 
               (ca1.get(l.id).OrderType__c =='c' && ca1.get(l.id).ReasonCode__c =='x') || 
               (ca1.get(l.id).OrderType__c =='c' && ca1.get(l.id).ReasonCode__c =='y')))
            {
                ca1.get(l.id).addError('Please select correct OrderType and ReasonCode');
            }
        }
    }
    else if(loc.size()>0)
    {
        for(Schema.Location l: loc)
        if(l.CSSIs__c== null){
            if(!((ca2.get(l.id).OrderType__c =='a' && ca2.get(l.id).ReasonCode__c =='p') 
               || (ca2.get(l.id).OrderType__c =='a' && ca2.get(l.id).ReasonCode__c =='q') 
               || (ca2.get(l.id).OrderType__c =='c' && ca2.get(l.id).ReasonCode__c =='x')))
            {
                ca2.get(l.id).addError('Please select correct OrderType and ReasonCode');
            }
        }
        else if(l.CRISId__c== null){
            if(!((ca2.get(l.id).OrderType__c =='a' && ca2.get(l.id).ReasonCode__c =='r') || 
               (ca2.get(l.id).OrderType__c =='c' && ca2.get(l.id).ReasonCode__c =='x') || 
               (ca2.get(l.id).OrderType__c =='c' && ca2.get(l.id).ReasonCode__c =='y') || 
               (ca2.get(l.id).OrderType__c =='c' && ca2.get(l.id).ReasonCode__c =='z')))
            {
                ca2.get(l.id).addError('Please select correct OrderType and ReasonCode');
            }
        }
    }


}