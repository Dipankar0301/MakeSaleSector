/***
Class Name: SV2020BrightIdeaCentralDuplicate 
Created Date: 'Nov 05, 2020'
Last Modified: 'Nov 05, 2020'
Description: SV2020BrightIdeaCentralDuplicate is created to process the ideas(Sync the ideas with SV2020 Accounts). 
If idea name matches with SV2020 account name(matche 70% -fuzzy logic), then it will update matched account's chatter feed. Otherwise it will create new 
account and opportunity in Salesforce(SV2020 app).
***/
Global class SV2020BrightIdeaCentralDuplicate {


    Global static  Map<String, String> CreateAccount(String companyname, String website, String description){
        
        Double MaxRatio = 0.00;
        Account bestAccountMatched = null; 
        //validate input params
        if(companyname == null || companyname.equals('')){
            return SV2020BrightIdeaCentralWrapper.getResult('failed', SV2020BrightIdeaCentralWrapper.ERROR_MESSAGE_VALID_COMPANY_NAME, 'failed', null, null, 0.00);
            //return null;
        }
        
        if(website != null && SV2020BrightIdeaCentralWrapper.isValidUrl(website) == false){
            return SV2020BrightIdeaCentralWrapper.getResult('failed',SV2020BrightIdeaCentralWrapper.ERROR_MESSAGE_VALID_WEBSITE,'failed',null,null,0.00);
            //return null;
        }
        
        //check for Levenshtein Distance
        //Parameter - Company Name        
        Id RecordTypeid = Schema.SObjectType.Account.getRecordTypeInfosByName().get('SV2020 - Account Creation Layout').getRecordTypeId();        
        Account acc = new Account();        
        acc.Name = companyname;
        //acc.Website = Website;
        acc.IC__c = 'SVX';
        acc.Description = description;
        if(RecordTypeid != null){
            acc.RecordTypeId =  RecordTypeid;
        }
        acc.Company_Status__c = 'Active';
        acc.CreatedById = SV2020BrightIdeaCentralWrapper.UserId;
        acc.OwnerID= SV2020BrightIdeaCentralWrapper.UserId;      
        
        
        List<Account> acctList = new List<Account>();
        acctList.add(acc);         

        Datacloud.FindDuplicatesResult[] results = Datacloud.FindDuplicates.findDuplicates(acctList);
        
        //System.debug(String.valueOf(results));

        // results -> exact 100%
        //         -> fuzzy
        for (Datacloud.FindDuplicatesResult findDupeResult : results) {
            for (Datacloud.DuplicateResult dupeResult : findDupeResult.getDuplicateResults()) {                        
                for (Datacloud.MatchResult matchResult : dupeResult.getMatchResults()) {                            
                    for (Datacloud.MatchRecord matchRecord : matchResult.getMatchRecords()) {
                        bestAccountMatched = (Account)matchRecord.getRecord();
                        MaxRatio = matchRecord.getMatchConfidence();
                        if(MaxRatio >=100){
                            break;
                        }
                        // max ratio >= 100 
                        // come out of the loop
                        // else update the max ratio
                    }
                }                   
            }
        }
        
        if(bestAccountMatched !=null){
            //calling postOnFeed method to insert chatter post on matched Account and associated Opportunity
            SV2020BrightIdeaCentralWrapper.postOnFeed(bestAccountMatched, companyname, website, description);
            return SV2020BrightIdeaCentralWrapper.getResult('Updated Successfully', null,SV2020BrightIdeaCentralWrapper.getMessage(companyname, bestAccountMatched, MaxRatio),bestAccountMatched.Id,null, MaxRatio);
            //return null;
        }
        else{
            
            Opportunity__c opp = new Opportunity__c();
            try{
                insert acc;
                if(acc.id != null){                    
                    if(companyname.length()>80){
                        companyname = companyname.substring(0,70);
                    }
                    opp.Name = companyname + ' - '+ system.label.SV2020BICOppNameRound;
                    opp.Account__c = acc.id;
                    opp.Round__c = system.label.SV2020BICOppNameRound;
                    opp.RecordTypeId =  Schema.SObjectType.Opportunity__c.getRecordTypeInfosByName().get('Invest').getRecordTypeId();
                    opp.Type_of_Investment__c = 'Warrants';
                    opp.Stage__c = 'Unreviewed';
                    opp.IC__c = 'SVX';
                    opp.Fund__c = 'Business Funded';
                    opp.Description__c = description;
                    opp.Business_Grouping_1__c = 'Cross Business (all lines of business)';
                    opp.Business_Grouping_2__c = 'PTX';
                    opp.BOM__c = SV2020BrightIdeaCentralWrapper.userId;
                    opp.CreatedById = SV2020BrightIdeaCentralWrapper.UserId;
                    opp.OwnerID= SV2020BrightIdeaCentralWrapper.UserId;
                    insert opp;   
                    //calling postOnFeed method to insert chatter post on matched Account and associated Opportunity
                    SV2020BrightIdeaCentralWrapper.postOnFeed(acc, companyname, website, description);                 
                }
            }catch(Exception exp){
                system.debug('Error occured in SV2020BrightIdeaCentralDuplicate class'+ exp);                
            }
            return SV2020BrightIdeaCentralWrapper.getResult('Inserted Successfully',null,'Inserted Successfully',acc.Id,opp.id, MaxRatio);
        }
    }
   
}