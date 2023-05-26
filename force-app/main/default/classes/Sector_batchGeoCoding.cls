global class Sector_batchGeoCoding implements Database.Batchable<sObject>,Database.AllowsCallouts, Database.Stateful{
        public string csvBody;
        public string headerValue;
        public string csvBodyDML;
        public string headerValueDML;
        //global list<Database.SaveResult> updateResult = new list<Database.SaveResult>();
        global Sector_batchGeoCoding(){
            csvBody = '';
            csvBodyDML = '';
            headerValue = 'Site Id, Status, Error_message,Response \n';
            headerValueDML = 'Site Id, Update Issues, Latitude, Longitude \n';
        }
        
        //Start 
        global Database.QueryLocator start(Database.BatchableContext BC){
            String SectorRecordTypeId = Schema.SObjectType.Site__c.getRecordTypeInfosByName().get('Sector').getRecordTypeId();
            
            return Database.getQueryLocator([SELECT Id, Name,Street__c, Sector_City__c,State__c,Sector_Country__c,Zip_Postal_Code__c,Inserted_Or_Address_Updated__c,RecordTypeId,
                                             Exclude_Geo_me_update__c,Last_Geo_Coord_updated_date__c,Geo__Latitude__s,Geo__Longitude__s
                                             FROM Site__c 
                                             WHERE Exclude_Geo_me_update__c = false and (Inserted_Or_Address_Updated__c = true or
                                                                                         (Last_Geo_Coord_updated_date__c != LAST_N_DAYS:30 and Last_Geo_Coord_updated_date__c != null))
                                             ]);
        }
        
        //Execute
        global void execute(Database.BatchableContext BC,List<Site__c> scope){
            list<Database.SaveResult> updateResult = new list<Database.SaveResult>();
            //Savepoint sp = Database.setSavepoint();
            //Savepoint sp;
            String siteIdtoPassInCatch ='';
            Double latitudeInCatch;
            Double longitudeInCatch;
            List<Site__c> okSites = new List<Site__c>();
            System.debug('size of scope 24 ---'+ scope.size());
            try{
                for(Site__c site : scope){
                    String Address = '';
                    siteIdtoPassInCatch = site.id;
                    Address = sector_SiteHelper.getAddress(site);
                    if(address != null){
                        //address = EncodingUtil.urlEncode(address, 'UTF-8');
                        System.debug('line 50'+address);
                        Sector_GeoCodeResponse ogc = SiteGeoCodeAddress.getGeoCodeAddress(Address);
                        //sp = Database.setSavepoint();
                        System.debug('line 51'+ ogc);
                        System.debug('line 52'+ ogc.status);
                        System.debug('line 53'+ ogc.error_message);
                        //if(site.id == 'a0G3G000004pIY0UAM')
                            //integer i =0/0;// to test exception
                        if(ogc !=null){
                            if(ogc.results != null && ogc.status =='OK'){
                                
                                System.debug('line 25' + site); 
                                site.Geo__Latitude__s = ogc.results[0].geometry.location.lat;
                                latitudeInCatch = ogc.results[0].geometry.location.lat;
                                site.Geo__Longitude__s = ogc.results[0].geometry.location.lng;
                                //ogc.results[0].geometry.location.lng = 'abc';
                                //site.Geo__Longitude__s = ogc.results[0].geometry.location.lng;
                                longitudeInCatch =  ogc.results[0].geometry.location.lng;
                                site.Inserted_Or_Address_Updated__c = false;
                                site.Last_Geo_Coord_updated_date__c =System.today();
                                okSites.add(site);
                                    
                                }
                                 
                                else if(ogc.status !='OK' && ogc.status !='OVER_QUERY_LIMIT'){
                                    
                                                    if(ogc.status == 'ZERO_RESULTS' )
                                                {
                                                    site.Inserted_Or_Address_Updated__c = false;
                                                     okSites.add(site);
                                        }
                                    
                                    csvBody = csvBody + site.id + ',"' + ogc.status + '","' + ogc.error_message + '","' + ogc +'"\n';
                                    System.debug('csvBody '+ csvBody);
                                }
                            }
                        
                    }
                    
                }     
                
                sector_SiteHelper.isBatchCode = true;
                System.debug('size of scope'+ scope.size());
                System.debug(scope);
                updateResult = Database.update(okSites, false);// giving false so remainder records updated successfully and we get error instead of exception
                if( updateResult != null && !updateResult.isEmpty()){
                    
                    for(Integer index = 0 ; index < updateResult.size() ; index ++){
                        if(!updateResult[index].isSuccess() ){
                            csvBodyDML += scope.get(index).Id + ',';
                            
                            string errorMsg = '';
                            for(Database.Error error : updateResult[index].getErrors()){
                                errorMsg += error.getMessage() + ',';
                                System.debug('error msg' +errorMsg);
                            }
                            errorMsg = errorMsg.removeEnd(',');
                            csvBodyDML += '"'+errorMsg + '"' + ',' + scope.get(index).Geo__Latitude__s + ','+ scope.get(index).Geo__Longitude__s + '\n';
    
                        }
                    }
                }
            }catch(exception e){
                //adding the exception
                /*headerValueDML =headerValueDML+ ' , '+' StackTrace';
                if(csvBodyDML != null && csvBodyDML != ''){
                    csvBodyDML += '"'+e.getStackTraceString() + '"' ; 
                csvBodyDML += '\n';
                }
                else{ 
                    csvBodyDML +=  siteIdtoPassInCatch + ','+ 'Exception ' + ',' + '"'+e.getStackTraceString() + '"'; 
                    csvBodyDML += '\n';
                //}*/
                headerValueDML = headerValueDML + siteIdtoPassInCatch + ',"Exception message: '+e.getMessage()+'\nStack Trace: '+e.getStackTraceString()+'",,\n';
                
            }       
        }
        
        //Finish
        global void finish(Database.BatchableContext BC){
            
            String finalCsv = '';
            String finalCsvDML = '';
            headerValueDML =headerValueDML+ ' \n';
            if(csvBody != null && csvBody != ''){
                finalCsv = headerValue + csvBody;
            }
            if(csvBodyDML != null && csvBodyDML != ''){
                finalCsvDML = headerValueDML + csvBodyDML;
            }
            if( (finalCsv != null && finalCsv != '') || (finalCsvDML != null && finalCsvDML != '') || Test.isRunningTest()){
                String csvname= 'Site_API_Errors.csv';
                String csvnameDML= 'Site_Update_Errors.csv';
                Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
                csvAttc.setFileName(csvname);
                if(Test.isRunningTest()){
                    finalCsv ='a';
                    csvAttc.setBody(Blob.valueOf(finalCsv));
                }
                else
                    csvAttc.setBody(Blob.valueOf(finalCsv));
                Messaging.EmailFileAttachment csvAttcDML = new Messaging.EmailFileAttachment();
                csvAttcDML.setFileName(csvnameDML);
                if(Test.isRunningTest()){
                    finalCsvDML ='a';
                    csvAttcDML.setBody(Blob.valueOf(finalCsvDML));
                }
                else
                    csvAttcDML.setBody(Blob.valueOf(finalCsvDML));
                Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
                String toAddresses= System.Label.Sector_Email_addresess;
                List<String> lstAlpha = toAddresses.split(',');
                String subject = 'Site Geolocation API call Error';
                String sourceUrl=URL.getSalesforceBaseUrl().toExternalForm();
                String mailBody = 'Please find the attached file to see the details of API call error and Site record update error\n\n If API call contain "ZERO_RESULTS" please update the site with proper address. Geo.me could not able to find coordinates for this address. ';
                email.setToAddresses(lstAlpha);
                email.setSubject(subject);
                email.setHtmlBody(mailBody);
                if((finalCsv != null && finalCsv != '') && (finalCsvDML != null && finalCsvDML != ''))
                    email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc,csvAttcDML}); 
                else if(finalCsvDML != null && finalCsvDML != '')                
                    email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttcDML});
                else
                    email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});                 
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});
            }
            
        }
        
    }