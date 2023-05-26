trigger AccTeamMail on AccountTeamMember (after insert) {
    
    if(TriggerHandler__c.getInstance('AccTeamMail') != null && TriggerHandler__c.getInstance('AccTeamMail').Active__c == false)
        return;
    
    System.debug('AccOppTeamMail.donotsendemail='+AccOppTeamMail.donotsendemail);
    // send mail when a new user is added to team member
    if(AccOppTeamMail.donotsendemail == false)
    {
        if(Trigger.new.size() == 1)
        {
            for(AccountTeamMember atm:Trigger.new)
            {
                Id accid=atm.AccountId;
                Id accuserId=atm.UserId;
                List<Account> AccName =[Select id, Name from Account where id=:accid];
                String AccN=AccName[0].name;
                List<User> us=[select id,email from User where id=:accuserId];
                String mail = us[0].email;
                AccOppTeamMail.sendMail(accid,'Account',mail,AccN);
            }
        }
    }
    //When Account is updated, add new Account Team members to the Opportunity Team.
}