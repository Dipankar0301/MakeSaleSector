global class ScheduleEmailsToVPs implements Database.Batchable<sObject> {
global Map<String,List<NEPM_Project__c>> MapOfProject = new Map<String,List<NEPM_Project__c>>();
global Map<String,List<NEPM_Project__c>> MapNewFuels = new Map<string,List<NEPM_Project__c>>();
global set<id> recordTypeSet = new set<id>();
global Map<String,List<string>> Vpmails = new Map<String,List<string>>();
global Map<string,List<string>> ccmails = new Map<string,List<string>>();
global MAP<String,List<string>> mapvpApiFields = new Map<String,List<string>>();
global Map<String,List<string>> mapvpColumnFields = new Map<string,List<string>>();
global Map<List<string>,string> mapGMships = new Map<List<string>,string>();
global set<string> setofGMhipNames = new set<string>();
global set<string> setofRecordTypeNames = new set<string>();
global string Orgurl = system.URL.getSalesforceBaseUrl().toExternalForm()+'/';
global Decimal Headline = 0.0;
global string fromEmail;

    global Database.QueryLocator start(Database.BatchableContext bc) {
        
        /*Getting RecordType id Based on RecordTypeName from CustomMetaData*/
        for(NewEngergiesRecrodTypeNames__mdt recodtypenames : [SELECT RecordTypeName__c FROM NewEngergiesRecrodTypeNames__mdt]){
            string st = recodtypenames.RecordTypeName__c;
            Id devRecordTypeId = Schema.SObjectType.NEPM_Project__c.getRecordTypeInfosByName().get(st).getRecordTypeId();
            recordTypeset.add(devRecordTypeId);
        }
        
         /*Getting query from CustomMetaData*/
         VP_Emails_Dynamic_Query__mdt Dynamicquery = [SELECT id,Query__c FROM VP_Emails_Dynamic_Query__mdt limit 1];
         string querystring = string.valueOf(Dynamicquery.Query__c);
         VPEmails_Schedule_Date__c datevalue = [SELECT id,Schedule_Date__c,Number_of_Days_to_Add__c FROM VPEmails_Schedule_Date__c WHERE name = 'Next Batch Schedule Date' limit 1];
         System.debug('******datevalue*****'+datevalue);
         if(!Test.isRunningTest()){
             if(datevalue.Schedule_Date__c == null || datevalue.Schedule_Date__c == System.today()){
                VPEmails_Schedule_Date__c t = VPEmails_Schedule_Date__c.getInstance('Next Batch Schedule Date');
                t.Schedule_Date__c = System.today()+integer.ValueOf(datevalue.Number_of_Days_to_Add__c);
                System.debug('*****t.Schedule_Date__c*******'+t.Schedule_Date__c);
                update t;
                System.debug('*****querystring******'+querystring);
                return Database.getQueryLocator(querystring);
             }
             else{
                 
                  return Database.getQueryLocator('SELECT Id FROM NEPM_Project__c limit 0');
             }
        }
        else{
            
              return Database.getQueryLocator('SELECT id,Name,NEPM_Project_Description__c,NEPM_Stage__c,NEPM_Status__c,NEPM_Country__c,NEPM_BOM__r.name,NEPM_BOMName__c,LastModifiedBy.name,LastModifiedByName__c,NEPM_Headline_Size_M_USD__c,LastModifiedDate,NEPM_VP_Ship__c,RecordType.Name,NEPM_GM_Ship__c FROM NEPM_Project__c where Last_Updated_Child_Records_Date__c = Today AND RecordTypeId IN : recordTypeset Order by Last_Updated_Child_Records_Date__c DESC');
        }
    
    }
    global void execute(Database.BatchableContext bc, List<NEPM_Project__c>scope)
    {
        List<Messaging.SingleEmailMessage> allmails = new List<Messaging.SingleEmailMessage>();
        if(!scope.isEmpty())
        {
            
            Set<NEPM_Project__c> proSet = new Set<NEPM_Project__c>();
            proSet.addAll(scope);
            System.debug('*********'+scope.size());
            
            /*Getting the from address from OrwideEmailAddress*/
            
            string orgwideVpEmail = label.OrgwideEmail_for_VP_Emails;
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address =:orgwideVpEmail];
            if ( owea.size() > 0 ) {
                
                  fromEmail = owea.get(0).Id;
            }
            
            
            /*Collecting GMShip Names individually inthe list of String*/
            
            for(RecordTypeGMShipName__mdt GMShip : [SELECT Field_Api_Names__c,Field_Column_Names__c,CCEmailList__c,EmailList__c,GMshipName__c,RecordTypeName__c,RecordTypeName__r.NewEnergiesRecordTypeNames__c FROM RecordTypeGMShipName__mdt WHERE RecordTypeName__r.NewEnergiesRecordTypeNames__c = 'New Fuels']){
            
                string filename = string.Valueof(GMShip.GMshipName__c);
                List<String> Namelist = filename.split('&');
                 
                if(!mapGMships.containsKey(Namelist)) {
                        
                        mapGMships.put(Namelist,filename);
                }
            }
            
            /*Collecting the records in Map Based on the Recordtype & GM Ship*/
            
            for(NEPM_Project__c pro : proSet)
            {
                if(pro.NEPM_VP_Ship__c != 'New Fuels'){
                    if(MapOfProject.containsKey(pro.NEPM_VP_Ship__c)) {
                        MapOfProject.get(pro.NEPM_VP_Ship__c).add(pro);
                        System.debug('I Entered into add Values for Existing Map of RecordType');
                        System.debug('the vpship name is '+pro.NEPM_VP_Ship__c);
                    } 
                    else {
                        MapOfProject.put(pro.NEPM_VP_Ship__c, new List<NEPM_Project__c> { pro });
                        System.debug('I Entered into Create Map for new RecordType');
                        System.debug('the vpship name is '+pro.NEPM_VP_Ship__c);
                    }
                }
                else if(pro.NEPM_VP_Ship__c == 'New Fuels'){
                    
                    for(List<string> sp : mapGMships.keyset()){
     
                        if(sp.contains(string.valueOf(pro.NEPM_GM_Ship__c))){
                            
                            if(MapNewFuels.containsKey(mapGMships.get(sp))){
                                
                                MapNewFuels.get(mapGMships.get(sp)).add(pro);
                                System.debug('*****I Entered into the New fules map*******');
                                System.debug('****GM Ship *****'+mapGMships.get(sp));
                                
                            }
                            else{
                                MapNewFuels.put(mapGMships.get(sp),new List<NEPM_Project__c> { pro });
                                System.debug('I Entered into create new map for GM Ship');
                                System.debug('****GM Ship ******'+mapGMships.get(sp));
                                
                            }
                        }
                    }
                 }
            }
            System.debug('******'+MapNewFuels.keyset());
            System.debug('******'+MapOfProject.keyset());
            System.debug('***The values of DSAD ********'+MapOfProject.get('DSAD'));
            
            /*Collecting all the Columns,ApiNames,Emails,Recordtypname*/
            for(RecordTypeGMShipName__mdt GMShipNewFules : [SELECT Field_Api_Names__c,Field_Column_Names__c,CCEmailList__c,EmailList__c,GMshipName__c,RecordTypeName__c,RecordTypeName__r.NewEnergiesRecordTypeNames__c FROM RecordTypeGMShipName__mdt WHERE RecordTypeName__r.NewEnergiesRecordTypeNames__c = 'New Fuels']){
                
                string emailsspltibyComma = GMShipNewFules.EmailList__c;
                List<string> vpemailist = emailsspltibyComma.split(',');
                
                string apinamesplitbyComma = GMShipNewFules.Field_Api_Names__c;
                List<string> vpApiFieldslist = apinamesplitbyComma.split(',');
                
                string columnsplitbyComma = GMShipNewFules.Field_Column_Names__c;
                List<string> vpColumnlist = columnsplitbyComma.split(',');
                
                string ccemailssplitbycomma = GMShipNewFules.CCEmailList__c;
                List<string> cceamilslist   = ccemailssplitbycomma.split(',');
                
                System.debug('****vpemailist*********'+vpemailist);
                
                 
                
                if(!Vpmails.containsKey(GMShipNewFules.GMshipName__c)){
                    
                    Vpmails.put(GMShipNewFules.GMshipName__c,vpemailist);
                    
                }
                
                if(!ccmails.containsKey(GMShipNewFules.GMshipName__c)){
                    
                    ccmails.put(GMShipNewFules.GMshipName__c,cceamilslist);
                }
                
                if(!mapvpApiFields.containskey(GMShipNewFules.GMshipName__c)){
                    
                    mapvpApiFields.put(GMShipNewFules.GMshipName__c,vpApiFieldslist);
                
                }
                
                if(!mapvpColumnFields.containskey(GMShipNewFules.GMshipName__c)){
                    
                    mapvpColumnFields.put(GMShipNewFules.GMshipName__c,vpColumnlist);
                }
                
                if(!MapNewFuels.containskey(GMShipNewFules.GMshipName__c)){
                    
                    setofGMhipNames.add(string.Valueof(GMShipNewFules.GMshipName__c));
                }
            }
            
            System.debug('*******setofGMhipNames*****'+setofGMhipNames);
            
            /*Collecting RecordTypeNames,Columns,Fields,Email,CCEmails*/
            for(RecordTypeNamesVPs__mdt recodtypenames : [SELECT NewEnergiesRecordTypeNames__c,CCEmailList__c,Emails__c,Field_Api_Names__c,Field_Column_Names__c FROM RecordTypeNamesVPs__mdt WHERE NewEnergiesRecordTypeNames__c != 'NEW Fuels']){
    
                string emailsspltibyComma = recodtypenames.Emails__c;
                List<String> vpemailist = emailsspltibyComma.split(',');
                
                string apinamesplitbyComma = recodtypenames.Field_Api_Names__c;
                List<string> vpApiFieldslist = apinamesplitbyComma.split(',');
                
                string columnsplitbyComma = recodtypenames.Field_Column_Names__c;
                List<string> vpColumnlist = columnsplitbyComma.split(',');
                
                string ccemailssplitbycomma = recodtypenames.CCEmailList__c;
                List<string> cceamilslist   = ccemailssplitbycomma.split(',');
                
                System.debug('****vpemailist*********'+vpemailist);
                
                if(!Vpmails.containsKey(recodtypenames.NewEnergiesRecordTypeNames__c)){
                    
                    Vpmails.put(recodtypenames.NewEnergiesRecordTypeNames__c,vpemailist);
                    
                }
                if(!mapvpApiFields.containskey(recodtypenames.NewEnergiesRecordTypeNames__c)){
                    
                    mapvpApiFields.put(recodtypenames.NewEnergiesRecordTypeNames__c,vpApiFieldslist);
                
                }
                if(!mapvpColumnFields.containskey(recodtypenames.NewEnergiesRecordTypeNames__c)){
                    
                    mapvpColumnFields.put(recodtypenames.NewEnergiesRecordTypeNames__c,vpColumnlist);
                    
                }
                if(!ccmails.containsKey(recodtypenames.NewEnergiesRecordTypeNames__c)){
                    
                    ccmails.put(recodtypenames.NewEnergiesRecordTypeNames__c,cceamilslist);
                }
                if(!MapOfProject.containsKey(recodtypenames.NewEnergiesRecordTypeNames__c)){
                    
                    setofRecordTypeNames.add(recodtypenames.NewEnergiesRecordTypeNames__c);
                }                
            }
            
            /*Sending Emails to all recodtypes*/
            for(string projectkeys : MapOfProject.keyset()){
                                    
                    
                    messaging.singleEmailMessage mail = new messaging.singleEmailMessage();
                    mail.ToAddresses = Vpmails.get(projectkeys) != null ? Vpmails.get(projectkeys) : new string[]{'test@shell.com'};
                    mail.ccAddresses = ccmails.get(projectkeys) != null ? ccmails.get(projectkeys) : new string[]{'test@shell.com'};
                    mail.setSubject('Updated NEPM Projects');
                    mail.setOrgWideEmailAddressId(fromEmail);
                    string htmlBody = '';
                    htmlBody += '<html>';
                    htmlBody += '<head>';
                    htmlBody += '<style>';
                    htmlBody += 'table {font-family: arial, sans-serif; width: 100%;}';
                    htmlBody += 'td,th {border:1px solid #000000; text-align: left; padding: 8px;}';
                    htmlBody += 'tr:hover {background-color:#E0FFFF;}';
                    htmlBody += '</style>';
                    htmlBody += '</head>';
                    htmlBody += '<body>';
                    htmlBody += '<p>Dear '+'<b>NEPM</b>'+ ' user,'+'<br>'+Label.VPEmail_Heading_Line+'</p>';
                    htmlBody += '<table>';
                    htmlBody += '<tr bgcolor="#ECF0F1">';
                  
                    for(string column : mapvpColumnFields.get(projectkeys)){
                        
                         htmlBody += '<th>'+column+'</th>';
                        
                    }
                    htmlBody += '</tr>';
                    for(NEPM_Project__c provalus : MapOfProject.get(projectkeys)){
                          Map<String, Object> fieldsToValue = provalus.getPopulatedFieldsAsMap();
                          htmlBody += '<tr>';
                          for(string apifields : mapvpApiFields.get(projectkeys)){
                              
                                 if(provalus.get(apifields) != null && provalus.get(apifields) != '' && apifields != 'Name'){
                                     
                                        htmlBody += '<td>'+ provalus.get(apifields) +'</td>';
                                 }
                                 else if((provalus.get(apifields) != null || provalus.get(apifields) != '') && apifields == 'Name'){
                                
                                    htmlBody += '<td><a href="'+Orgurl+provalus.id+'">'+provalus.get(apifields)+'</a></td>';
        
                                 }
                                  else if((provalus.get(apifields) == null || provalus.get(apifields) == '') && apifields == 'NEPM_Headline_Size_M_USD__c'){
                                      
                                      htmlBody += '<td>'+Headline+'</td>';
                                      
                                 }
                                 else if((provalus.get(apifields) == null || provalus.get(apifields) == '') && apifields != 'NEPM_Headline_Size_M_USD__c'){
                                         
                                      htmlBody += '<td>No Value</td>';
                                 }
                          }
                          htmlBody += '</tr>';
                    }
                    htmlBody += '</table>';
                    htmlBody += '<p>Please click on the project name in the table to go to the project in Salesforce – or click <a href="'+Orgurl+'">here</a> to go to the Salesforce main page.</p>';
                    htmlBody += '<p>Please click <a href="'+Label.Link_for_NEPM_User_Manual+'">here</a> for more information on NEPM and how to use Salesforce click <a href="'+Label.Link_for_How_to_use_Salesforce+'">here</a>.</p>';
                    htmlBody += '</body>';
                    htmlBody += '</html>';
                
                    mail.setHtmlBody(htmlBody);
                    //List<Messaging.SingleEmailMessage> mails1 = new List<Messaging.SingleEmailMessage>();
                    allmails.add(mail);
                    
                    
          }
           
           /*Sending Email Related to NewFules VPship*/ 
          for(string newfulesProjectKeys : MapNewFuels.keyset()){
              
                    messaging.singleEmailMessage mail = new messaging.singleEmailMessage();
                    mail.ToAddresses = Vpmails.get(newfulesProjectKeys) != null ? Vpmails.get(newfulesProjectKeys) : new string[]{'test@shell.com'};
                    mail.ccAddresses = ccmails.get(newfulesProjectKeys) != null ? ccmails.get(newfulesProjectKeys) : new string[]{'test@shell.com'};
                    mail.setSubject('Updated NEPM Projects');
                    mail.setOrgWideEmailAddressId(fromEmail);
                    string htmlBody = '';
                    htmlBody += '<html>';
                    htmlBody += '<head>';
                    htmlBody += '<style>';
                    htmlBody += 'table {font-family: arial, sans-serif; width: 100%;}';
                    htmlBody += 'td,th {border:1px solid #000000; text-align: left; padding: 8px;}';
                    htmlBody += 'tr:hover {background-color:#E0FFFF;}';
                    htmlBody += '</style>';
                    htmlBody += '</head>';
                    htmlBody += '<body>';
                    htmlBody += '<p>Dear '+'<b>NEPM</b>'+ ' user,'+'<br>'+Label.VPEmail_Heading_Line+'</p>';
                    htmlBody += '<table>';
                    htmlBody += '<tr bgcolor="#ECF0F1">';
                  
                    for(string column : mapvpColumnFields.get(newfulesProjectKeys)){
                        
                         htmlBody += '<th>'+column+'</th>';   
                    }
                    htmlBody += '</tr>';
                    for(NEPM_Project__c provalus : MapNewFuels.get(newfulesProjectKeys)){
                          
                          htmlBody += '<tr>';
                          for(string apifields : mapvpApiFields.get(newfulesProjectKeys)){
                              
                                     if(provalus.get(apifields) != null && provalus.get(apifields) != '' && apifields != 'Name'){
                                         
                                            htmlBody += '<td>'+ provalus.get(apifields) +'</td>';
                                     }
                                     else if((provalus.get(apifields) != null || provalus.get(apifields) != '') && apifields == 'Name'){
                                    
                                        htmlBody += '<td><a href="'+Orgurl+provalus.id+'">'+provalus.get(apifields)+'</a></td>';
            
                                     }
                                      else if((provalus.get(apifields) == null || provalus.get(apifields) == '') && apifields == 'NEPM_Headline_Size_M_USD__c'){
                                          
                                          htmlBody += '<td>'+Headline+'</td>';
                                          
                                     }
                                     else if((provalus.get(apifields) == null || provalus.get(apifields) == '') && apifields != 'NEPM_Headline_Size_M_USD__c'){
                                             
                                          htmlBody += '<td>No Value</td>';
                                     }
                          }
                          htmlBody += '</tr>';
                    }
                    htmlBody += '</table>';
                    htmlBody += '<p>Please click on the project name in the table to go to the project in Salesforce – or click <a href="'+Orgurl+'">here</a> to go to the Salesforce main page.</p>';
                    htmlBody += '<p>Please click <a href="'+Label.Link_for_NEPM_User_Manual+'">here</a> for more information on NEPM and how to use Salesforce click <a href="'+Label.Link_for_How_to_use_Salesforce+'">here</a>.</p>';
                    htmlBody += '</body>';
                    htmlBody += '</html>';
                    mail.setHtmlBody(htmlBody);
                    //List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
                    allmails.add(mail);
                    
                    
                    
          }
          
          for(string RecTypename :setofRecordTypeNames){
              
                    messaging.singleEmailMessage mail = new messaging.singleEmailMessage();
                    mail.ToAddresses = Vpmails.get(RecTypename) != null ? Vpmails.get(RecTypename) : new string[]{'test@shell.com'};
                    mail.ccAddresses = ccmails.get(RecTypename) != null ? ccmails.get(RecTypename) : new string[]{'test@shell.com'};
                    mail.setSubject('Updated NEPM Projects');
                    mail.setOrgWideEmailAddressId(fromEmail);
                    string htmlBody = '';
                    htmlBody += '<html>';
                    htmlBody += '<head>';
                    htmlBody += '<style>';
                    htmlBody += 'table {font-family: arial, sans-serif; width: 100%;}';
                    htmlBody += 'td,th {border:1px solid #000000; text-align: left; padding: 8px;}';
                    htmlBody += 'tr:hover {background-color:#E0FFFF;}';
                    htmlBody += '</style>';
                    htmlBody += '</head>';
                    htmlBody += '<body>';
                    htmlBody += '<p>Dear '+'<b>NEPM</b>'+ ' user,'+'<br>'+Label.VPEmail_Heading_Line+'</p>';
                    htmlBody += '<table>';
                    htmlBody += '<tr bgcolor="#ECF0F1">';
                    
                    for(string column : mapvpColumnFields.get(RecTypename)){
                        
                         htmlBody += '<th>'+column+'</th>';
                    }
                    htmlBody +='</tr>';
                    htmlbody += '</tr>';
                    for(string column : mapvpColumnFields.get(RecTypename)){
                    
                         htmlbody += '<td>'+'No updates in '+RecTypename+'</td>';
                    }
                    htmlBody += '</table>';
                    htmlBody += '<p>Please click on the project name in the table to go to the project in Salesforce – or click <a href="'+Orgurl+'">here</a> to go to the Salesforce main page.</p>';
                    htmlBody += '<p>Please click <a href="'+Label.Link_for_NEPM_User_Manual+'">here</a> for more information on NEPM and how to use Salesforce click <a href="'+Label.Link_for_How_to_use_Salesforce+'">here</a>.</p>';
                    htmlBody += '</body>';
                    htmlBody += '</html>';
                    mail.setHtmlBody(htmlBody);
                    //List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
                    allmails.add(mail);
                    
                    
           }
           
           for(string GMShipName :setofGMhipNames ){
                
                    messaging.singleEmailMessage mail = new messaging.singleEmailMessage();
                    mail.ToAddresses = Vpmails.get(GMShipName) != null ? Vpmails.get(GMShipName) : new string[]{'test@shell.com'};
                    mail.ccAddresses = ccmails.get(GMShipName) != null ? ccmails.get(GMShipName) : new string[]{'test@shell.com'};
                    mail.setSubject('Updated NEPM Projects');
                    mail.setOrgWideEmailAddressId(fromEmail);
                    string htmlBody = '';
                    htmlBody += '<html>';
                    htmlBody += '<head>';
                    htmlBody += '<style>';
                    htmlBody += 'table {font-family: arial, sans-serif; width: 100%;}';
                    htmlBody += 'td,th {border:1px solid #000000; text-align: left; padding: 8px;}';
                    htmlBody += 'tr:hover {background-color:#E0FFFF;}';
                    htmlBody += '</style>';
                    htmlBody += '</head>';
                    htmlBody += '<body>';
                    htmlBody += '<p>Dear '+'<b>NEPM</b>'+ ' user,'+'<br>'+Label.VPEmail_Heading_Line+'</p>';
                    htmlBody += '<table>';
                    htmlBody += '<tr bgcolor="#ECF0F1">';
                    
                    for(string column : mapvpColumnFields.get(GMShipName)){
                        
                         htmlBody += '<th>'+column+'</th>';
                    }
                    htmlBody +='</tr>';
                    htmlbody += '<tr>';
                    for(string column : mapvpColumnFields.get(GMShipName)){
                         
                         string s = GMShipName;
                         string GMShipsNames = s.contains('&') ? s.replace('&',','):s;
                         htmlbody += '<td>'+'No updates in '+GMShipsNames+'</td>';
                    }
                    htmlBody +='</tr>';
                    htmlBody += '</table>';
                    htmlBody += '<p>Please click on the project name in the table to go to the project in Salesforce – or click <a href="'+Orgurl+'">here</a> to go to the Salesforce main page.</p>';
                    htmlBody += '<p>Please click <a href="'+Label.Link_for_NEPM_User_Manual+'">here</a> for more information on NEPM and how to use Salesforce click <a href="'+Label.Link_for_How_to_use_Salesforce+'">here</a>.</p>';
                    htmlBody += '</body>';
                    htmlBody += '</html>';
                    mail.setHtmlBody(htmlBody);
                    //List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
                    allmails.add(mail);
                
                
            }
            
      }
      Messaging.sendEmail(allmails);
    }
    global void finish(Database.BatchableContext bc){
    
        //Query the AsyncApexJob object to retrieve the current job's information.
        AsyncApexJob apexJob = [SELECT Id, Status, NumberOfErrors, JobItemsProcessed, TotalJobItems, CreatedBy.Email
                                FROM AsyncApexJob WHERE Id =: BC.getJobId()];
        
        //Send an email to the Apex job's submitter notifying of job completion.
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddress = new String[] {apexJob.CreatedBy.Email};
        system.debug('apexJob.CreatedBy.Email : '+apexJob.CreatedBy.Email);
        mail.setToAddresses(toAddress);
        mail.setSubject('Apex Job status is ' + apexJob.Status);
        mail.setPlainTextBody('The batch Apex job processed ' + apexJob.TotalJobItems + ' batches with '+ apexJob.NumberOfErrors + ' failures.');
        Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 
               
    }    
}