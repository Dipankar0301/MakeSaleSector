public class AttachEmailService implements Messaging.InboundEmailHandler 
{
    public Messaging.InboundEmailResult handleInboundEmail(Messaging.inboundEmail email, 
                                                           Messaging.InboundEnvelope env)
    {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
        
        if(email.subject != null && email.subject.contains('Ref: '))
        {
            Id recordid;
            try
            {
                System.debug('substringAfter='+email.subject.substringAfter('Ref: '));
                System.debug('substringAfter 0 to 15='+email.subject.substringAfter('Ref: ').mid(0, 15));
                recordid = Id.valueOf(email.subject.substringAfter('Ref: ').mid(0, 15)); 
                /*
                Task tk = new Task();
                tk.WhatId = recordid;
                tk.Status = 'Completed';
                tk.Subject = 'Email: '+email.subject;
                tk.TaskSubtype = 'Email';
                tk.ActivityDate = Date.today();
                
                tk.Description = 'From Adress: '+email.fromAddress+'\nCC: '+(email.ccAddresses != null && email.ccAddresses.size() > 0 ? email.ccAddresses+'' : '')
                    +' \n\nSubject: '+email.Subject+'\nBody: \n'+email.plainTextBody;
                insert tk;
                
                */
                
                String Toaddressall = '';
                if(email.toAddresses != null && email.toAddresses.size() > 0)
                {
                    for(String toaddress : email.toAddresses)
                    {
                        Toaddressall += toaddress+';';
                    }
                }
                
                String CCaddressall = '';
                if(email.ccAddresses != null && email.ccAddresses.size() > 0)
                {
                    for(String ccaddress : email.ccAddresses)
                    {
                        CCaddressall += ccaddress+';';
                    }
                }
                
                EmailMessage emailMessage = new EmailMessage();
                emailMessage.status = '3';
                emailMessage.Incoming = true;
                // emailMessage.relatedToId = recordid; 
                emailMessage.ToIds = new String[]{recordid};
                    emailMessage.fromAddress = email.fromAddress;
                emailMessage.CcAddress = CCaddressall;
                //  emailMessage.ValidatedFromAddress = email.fromAddress;
                emailMessage.fromName = email.fromName; 
                emailMessage.ToAddress = Toaddressall;
                emailMessage.Subject = email.subject;
                emailMessage.HtmlBody = email.htmlBody;
                insert emailMessage;
                
                EmailMessageRelation emr = new EmailMessageRelation();
                emr.emailMessageId = emailMessage.id;
                emr.relationId = userinfo.getUserId(); // user id of the sender
                emr.RelationAddress = email.fromName;
                emr.relationType = 'FromAddress';
                insert emr;
                
                EmailMessageRelation emr1 = new EmailMessageRelation();
                emr1.emailMessageId = emailMessage.id;
                emr1.relationId = recordid; // user id of the sender
                emr1.RelationAddress = email.fromName;
                emr1.relationType = 'ToAddress';
                insert emr1;
                
                
                List<Attachment> attachmentlist = new List<Attachment>();
                if(email.binaryAttachments != null && email.binaryAttachments.size() > 0)
                {
                    for(Messaging.InboundEmail.BinaryAttachment binaryattachment : email.binaryAttachments)
                    {
                        attachmentlist.add(new Attachment(Body = binaryattachment.body, Name = binaryattachment.fileName, parentId = emailMessage.Id));
                    } 
                }
                if(email.textAttachments != null && email.textAttachments.size() > 0)
                {
                    for(Messaging.InboundEmail.TextAttachment textattachment : email.textAttachments)
                    {
                        attachmentlist.add(new Attachment(Body = Blob.valueOf(textattachment.body), Name = textattachment.fileName, parentId = emailMessage.Id));
                    } 
                }

                if(attachmentlist.size() > 0)
                    insert attachmentlist;
            }
            catch(Exception e)
            {
                result.success = false;
                result.message = 'This email is not recorded in Salesforce because it may not have right Ref in subject or may be due to technical issue. Error: '+e.getMessage();               
            }
        }
        else
        {
            Lead ld = new Lead();
            ld.Company = email.fromAddress;
            ld.FirstName = email.fromAddress;
            ld.LastName = email.fromAddress;
            ld.recordtypeid = Schema.SObjectType.Lead.getRecordTypeInfosByName().get('SEUK B2B Leads').getRecordTypeId();
            ld.Status = 'New'; 
            ld.Email = email.fromAddress;
            ld.Description = 'Subject: '+email.subject+'\n\n'+'Body: '+email.htmlBody;
            insert ld;
            
            Id recordid = ld.Id;
            
            String Toaddressall = '';
            if(email.toAddresses != null && email.toAddresses.size() > 0)
            {
                for(String toaddress : email.toAddresses)
                {
                    Toaddressall += toaddress+';';
                }
            }

            String CCaddressall = '';
            if(email.ccAddresses != null && email.ccAddresses.size() > 0)
            {
                for(String ccaddress : email.ccAddresses)
                {
                    CCaddressall += ccaddress+';';
                }
            }
            
            EmailMessage emailMessage = new EmailMessage();
            emailMessage.status = '3';
            emailMessage.Incoming = true;
           // emailMessage.relatedToId = recordid; 
            emailMessage.ToIds = new String[]{recordid};
            emailMessage.fromAddress = email.fromAddress;
            emailMessage.CcAddress = CCaddressall;
            //  emailMessage.ValidatedFromAddress = email.fromAddress;
            emailMessage.fromName = email.fromName; 
            emailMessage.ToAddress = Toaddressall;
            emailMessage.Subject = email.subject+' [Ref: '+recordid+']';
            emailMessage.HtmlBody = email.htmlBody;
            insert emailMessage;
            
            EmailMessageRelation emr = new EmailMessageRelation();
            emr.emailMessageId = emailMessage.id;
            emr.relationId = userinfo.getUserId(); // user id of the sender
            emr.RelationAddress = email.fromName;
            emr.relationType = 'FromAddress';
            insert emr;
            
            EmailMessageRelation emr1 = new EmailMessageRelation();
            emr1.emailMessageId = emailMessage.id;
            emr1.relationId = recordid; // user id of the sender
            emr1.RelationAddress = email.fromName;
            emr1.relationType = 'ToAddress';
            insert emr1;
            
            
            List<Attachment> attachmentlist = new List<Attachment>();
            if(email.binaryAttachments != null && email.binaryAttachments.size() > 0)
            {
                for(Messaging.InboundEmail.BinaryAttachment binaryattachment : email.binaryAttachments)
                {
                    attachmentlist.add(new Attachment(Body = binaryattachment.body, Name = binaryattachment.fileName, parentId = emailMessage.Id));
                } 
            }
            if(email.textAttachments != null && email.textAttachments.size() > 0)
            {
                for(Messaging.InboundEmail.TextAttachment textattachment : email.textAttachments)
                {
                    attachmentlist.add(new Attachment(Body = Blob.valueOf(textattachment.body), Name = textattachment.fileName, parentId = emailMessage.Id));
                } 
            }
            
            if(attachmentlist.size() > 0)
                insert attachmentlist;
            
            
            
        }
        return result;
    }
}