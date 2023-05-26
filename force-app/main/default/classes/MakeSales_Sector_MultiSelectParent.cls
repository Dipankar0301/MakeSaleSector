public class MakeSales_Sector_MultiSelectParent {
    @AuraEnabled
    Public static Map<String,List<String>> getRecord(id recId){
        system.debug(recId);
        List<Opportunity> listopp = [Select id,Fulfilled_by__c,Opportunity_Region__c,Opportunity_Country__c, Opportunity_City__c from opportunity where id =: recId];
        List<String> picklistValues;
        List<String> picklistValues1;
        List<String> picklistValues2;
        List<String> picklistValues3;
        
        if(listopp[0].Fulfilled_by__c != null)
            picklistValues = listopp[0].Fulfilled_by__c.split(';');
        if(listopp[0].Opportunity_Region__c != null)
            picklistValues1 = listopp[0].Opportunity_Region__c.split(';');
        if(listopp[0].Opportunity_Country__c != null)
            picklistValues2 = listopp[0].Opportunity_Country__c.split(';');
        if(listopp[0].Opportunity_City__c != null)
            picklistValues3 = listopp[0].Opportunity_City__c.split(';');
        Map<String, List<String>> picklistvaluesMap= New Map<String,List<String>>();
        picklistvaluesMap.put('Fulfilled', picklistValues);
        picklistvaluesMap.put('Region', picklistValues1);
        picklistvaluesMap.put('Country', picklistValues2);
        picklistvaluesMap.put('City', picklistValues3);
        system.debug(picklistValues);
        system.debug(picklistvaluesMap);
        system.debug(listopp);
        
        return picklistvaluesMap;
    }
    @AuraEnabled
    Public static Map<String,List<String>> getPicklistValues(id recId){
        system.debug(recId);
        Map<String, List<String>> picklistvaluesMap= New Map<String,List<String>>();
        List<String> pickListValuesList1= new List<String>();
        Schema.DescribeFieldResult fieldResult1 = Opportunity.Fulfilled_by__c.getDescribe();
        List<Schema.PicklistEntry> ple1 = fieldResult1.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple1){
            pickListValuesList1.add(pickListVal.getLabel());
        }
        
        List<String> pickListValuesList2= new List<String>();
        Schema.DescribeFieldResult fieldResult2 = Opportunity.Opportunity_Region__c.getDescribe();
        List<Schema.PicklistEntry> ple2 = fieldResult2.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple2){
            pickListValuesList2.add(pickListVal.getLabel());
        }
        List<String> pickListValuesList3= new List<String>();
        Schema.DescribeFieldResult fieldResult3 = Opportunity.Opportunity_Country__c.getDescribe();
        List<Schema.PicklistEntry> ple3 = fieldResult3.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple3){
            pickListValuesList3.add(pickListVal.getLabel());
        }
        List<String> pickListValuesList4= new List<String>();
        Schema.DescribeFieldResult fieldResult4 = Opportunity.Opportunity_City__c.getDescribe();
        List<Schema.PicklistEntry> ple4 = fieldResult4.getPicklistValues();
        for( Schema.PicklistEntry pickListVal : ple4){
            pickListValuesList4.add(pickListVal.getLabel());
        }
        picklistvaluesMap.put('Fulfilled', pickListValuesList1);
        picklistvaluesMap.put('Region', pickListValuesList2);
        picklistvaluesMap.put('Country', pickListValuesList3);
        picklistvaluesMap.put('City', pickListValuesList4);
        
        
        
        
        //return pickListValuesList;
        
        
        
        return picklistvaluesMap;
    }
    
    @AuraEnabled
    Public static List<String> saveRecords(id recId, List<String> selectedValueFulfill,List<String> selectedValueRegion,List<String> selectedValueCountry,List<String> selectedValueCity){
        
        system.debug(recid + 'test' + selectedValueFulfill);
        system.debug(recid + 'test1' + selectedValueRegion);
        system.debug(recid + 'test2' + selectedValueCountry);
        system.debug(recid + 'test3' + selectedValueCity);
        //system.debug(recid + 'test4' + selectedSite);
        List<Opportunity> opp = [select id, Fulfilled_by__c,Opportunity_Region__c,Opportunity_Country__c,Opportunity_City__c from Opportunity where id =: recId];
        String temp= '';
        String temp1= '';
        String temp2= '';
        String temp3= '';
        try{
            for(String s : selectedValueFulfill){
                temp = temp + ';' +s;
            }
            for(String s : selectedValueRegion){
                temp1 = temp1 + ';' +s;
            }
            for(String s : selectedValueCountry){
                temp2 = temp2 + ';' +s;
            }
            for(String s : selectedValueCity){
                temp3 = temp3 + ';' +s;
            }
            opp[0].Fulfilled_by__c = temp;
            opp[0].Opportunity_Region__c = temp1;
            opp[0].Opportunity_Country__c = temp2;
            opp[0].Opportunity_City__c = temp3;
            update opp[0];
            
            //site
           /* Id recordtypeidorgsite= Schema.SObjectType.Site__c.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId();
            List<Site__c> listofSite = [Select id, name from Site__c where id in:selectedSite and RecordtypeId =: recordtypeidorgsite];
            List<Site_Link__c> listofExistingSiteLink = [select id,name, Opportunity__c, Site__c from Site_Link__c where Opportunity__c =: recId];
            Set<String> uniqueComb= new Set<String>();
            Set<String> uniqueComb1= new Set<String>();
            List<Site_Link__c> listofSiteLinktoDelete = new List<Site_Link__c>();
            
            for(Site__c site: listofSite){
                
                String str = site.Name + '-' + recId+ '-' +site.id;
                uniqueComb1.add(str);
                System.debug(str);
            }
            System.debug('119');
            System.debug(listofExistingSiteLink);
             for(Site_Link__c sl: listofExistingSiteLink){
                System.debug('122');
                String str = sl.Name + '-' + sl.Opportunity__c+ '-' +sl.Site__c;
                
                 System.debug(uniqueComb1 + '-123-' +str);
                if(!uniqueComb1.contains(str)){
                	listofSiteLinktoDelete.add(sl);    
                }
                
            }
            
            
            for(Site_Link__c sl: listofExistingSiteLink) {
                String str= sl.name + '-' + sl.Opportunity__c+ '-' +sl.Site__c;
                uniqueComb.add(str);
            }
            List<Site_Link__c> listofSiteLink = new List<Site_Link__c>();
            for(Site__c site: listofSite){
                System.debug(site.id + '---' +site.Name+ '---'+ recId);
                Site_Link__c sl = new Site_Link__c();
                sl.Name = site.Name;
                sl.Opportunity__c = recId;
                sl.Site__c = site.id;
                String str = site.Name + '-' + recId+ '-' +site.id;
                
                if(!uniqueComb.contains(str)){
                	listofSiteLink.add(sl);    
                }
                
            }
            system.debug('listofSiteLink - '+listofSiteLink);
            delete listofSiteLinktoDelete;
            insert listofSiteLink;
			*/
            //
            
            
            List<String> Success= new List<String>();
            Success.add('true');
            return Success;
        }
        catch(DmlException e){
            //system.debug('The following exception has occurred: ' + e.getDmlMessage(0));
            Integer numErrors = e.getNumDml();
            System.debug('getNumDml=' + numErrors);
            List<String> error= new List<String>();
            for(Integer i=0;i<numErrors;i++) {
                error.add(e.getDmlMessage(i));
            }
            system.debug('The following exception has occurred: ' + error);
            return error;
        }
        catch(Exception e){
            system.debug('The following exception has occurred: ' + e.getMessage());
            List<String> error= new List<String>();
            error.add(e.getMessage());
            return error;
        }
        
    }
   /* @AuraEnabled
    Public static List<Site__c> getSiteRecords(id recId){
        system.debug(recId);
        Id recordtypeidorgsite= Schema.SObjectType.Site__c.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId();
        
        
        List<Opportunity> oppAccountId =[select AccountId from Opportunity where id=:recId ];
        Id parentAccountId = oppAccountId[0].AccountId;
        List<Site__c> listSite = [Select id,Name from Site__c where Account__c =: parentAccountId and RecordtypeId =: recordtypeidorgsite];
        
        return listSite;
    }
    @AuraEnabled
    Public static List<Site__c> getSelectedSiteRecords(id recId){
        List<Site_Link__c> listofExistingSiteLink = [select id,name, Opportunity__c, Site__c from Site_Link__c where Opportunity__c=:recId];
        Set<Id> siteLinkSiteId = new Set<Id>();
        for(Site_Link__c sl:listofExistingSiteLink){
            siteLinkSiteId.add(sl.Site__c);
        }
        List<Site__c> listSite = [Select Name from Site__c where id in: siteLinkSiteId];
        System.debug('list of site'+listSite);
        return listSite;
    }*/
    
}