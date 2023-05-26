trigger OppTeamMail on OpportunityTeamMember (after insert,after update) {
    
    if(TriggerHandler__c.getInstance('OppTeamMail') != null && TriggerHandler__c.getInstance('OppTeamMail').Active__c == false)
        return;
    
    //Set<Id> opporid=new Set<Id>();
    // send mail when a new user is added to team member
    If(Trigger.isInsert && Trigger.isAfter){
        if(AccOppTeamMail.donotsendemail == false)
        {
            if(Trigger.new.size() == 1)
            {
                for(OpportunityTeamMember otm:Trigger.new)
                {
                    
                    Id oppid=otm.OpportunityId;
                    Id oppuserId=otm.UserId;
                    //opporid.add(oppid);
                    List<Opportunity> OppName =[Select id, Name from Opportunity where id=:oppid];
                    String OppN=OppName[0].name;
                    List<User> us=[select id,email from User where id=:oppuserId];
                    String mail = us[0].email;
                    AccOppTeamMail.sendMail(oppid, 'Opportunity',mail, OppN);
                }
            }
        }
    }
    
    /*--It is another function not related to the last one.--*/
    // When Opportunity is created, all Account Team members should be added to Opportunity Team.
    If((Trigger.isInsert && Trigger.isAfter)||(Trigger.isUpdate && Trigger.isAfter)){
        List<Id> otmList =new List<Id>();
        List<Id> accuserList = new List<Id>();
        List<Id> accOppId = new List<Id>();
        Map<Id,String> atmAccess = new Map<Id,String>();
        List<Id> oppAccId = new List<Id>();
        List<OpportunityShare> oppShareRecordslist = new List<OpportunityShare>();
        for(OpportunityTeamMember otm:Trigger.new)
        {
            otmList.add(otm.OpportunityId);
            accuserList.add(otm.userId);
            accOppId.add(otm.OpportunityId);
        }
        List<OpportunityShare> oppShareRecords = [select Id, OpportunityAccessLevel, RowCause,OpportunityId,UserOrGroupId from OpportunityShare where OpportunityId in: otmList and rowCause =: 'Team'];
        List<Opportunity> opplist = [select Id,AccountId from Opportunity where id in: otmList];
        for(Opportunity opp:opplist)
        {
            oppAccId.add(opp.AccountId);
        }
        List<AccountTeamMember> atmList =[select id, OpportunityAccessLevel,userId from AccountTeamMember where AccountId in: oppAccId];
        for(AccountTeamMember atm:atmList)
        {
            atmAccess.put(atm.userId,atm.OpportunityAccessLevel);        
        }
        // set all team members access to read/write
        for (OpportunityShare OppShare : oppShareRecords){
            System.debug(atmAccess.get(OppShare.UserOrGroupId));
            if(atmAccess.get(OppShare.UserOrGroupId) != null && atmAccess.get(OppShare.UserOrGroupId) != 'None'){
                System.debug(atmAccess.get(OppShare.UserOrGroupId));
                OppShare.OpportunityAccessLevel = atmAccess.get(OppShare.UserOrGroupId);
                oppShareRecordslist.add(OppShare);
            }
            
            
        }
        
        update oppShareRecordslist;
    }
}