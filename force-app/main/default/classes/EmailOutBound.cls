public class EmailOutBound {
    public static void sendEmail(String Subject){
        Messaging.SingleEmailMessage mail=new messaging.SingleEmailMessage();
        case case1=getCaseIdFromNumber('00001002');
        String plainTextBody ='Your Case: ' +case1.Id+' has been created.';
        String htmlBody ='your case:<b>' +case1.Id+ '</b>has been created.<p>'+'To view your case <a href=https://yourInstance.salesforce.com/'+case.Id+'>click here.</a>';
        String[] toAddresses =new String[]{'dipankar.karmakar0301@gmail.com','dipankar.karmakar.sfdc1@gmail.com'};
        String[] ccAddresses =new String[]{'mistusehwag123@gmail.com'};
        mail.setToAddresses(toAddresses);
	    mail.setCcAddresses(ccAddresses);  
        mail.setSubject(Subject);
        mail.setReplyTo('dk.sfdc1@gmail.com');
        mail.setSenderDisplayName('Dipankar Karmakar');
        mail.setBccSender(false);
        mail.setUseSignature(false);
        mail.setPlainTextBody(plainTextBody);
        mail.setHtmlBody(htmlBody);
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
    }
    public static Case getCaseIdFromNumber(String caseNumber){
        Case c=[select Id from Case where CaseNumber=:caseNumber];
        return c;
    }
}