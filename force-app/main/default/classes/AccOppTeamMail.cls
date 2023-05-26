public class AccOppTeamMail {
    Public static void sendMail(Id recId, String sObjectN, String useremail,String OppN){
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        //String userID = UserInfo.getUserEmail();
        String[] toAddresses = new String[]{useremail};
            String subject = sObjectN +'Team';
        String sourceUrl=URL.getSalesforceBaseUrl().toExternalForm();
        String mailBody = 'Dear User,<p> you have been added to the '+sObjectN+' Team of the following '+sObjectN+' in the RES CRM: <p>'+OppN+ '<p> <a href='+sourceUrl+'/lightning/r/'+sObjectN+'/'+recId+'/view>Click here to view.</a> <p> For any issues related to access, please contact the person who added you to the '+sObjectN+'.';
        email.setToAddresses(toAddresses);
        email.setSubject(subject);
        email.setHtmlBody(mailBody);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
    }
    
    public static Boolean donotsendemail = false;
    @InvocableMethod(label='MakeSaleSector - Do not send email to owner team member' description='If this method is called no email will be send while creating new account/opportunity' )
    public static void donotsendemailtoowner(List<ID> ids) 
    {
        AccOppTeamMail.donotsendemail = true;
    }


}