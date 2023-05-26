public class Sector_AddASiteZInOpportunity {
    @AuraEnabled
    Public static List<String> saveRecords(id recId,List<String> selectedSite){
        system.debug(recid + 'test4' + selectedSite);
        List<Opportunity> opp = [select id, Fulfilled_by__c,Opportunity_Region__c,Opportunity_Country__c,Opportunity_City__c from Opportunity where id =: recId];
        
        try{
            //site
            Id recordtypeidorgsite= Schema.SObjectType.Site__c.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId();
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
                //sl.Name = site.Name;
                sl.Opportunity__c = recId;
                sl.Site__c = site.id;
                String str = site.Name + '-' + recId+ '-' +site.id;
                
                if(!uniqueComb.contains(str)){
                    listofSiteLink.add(sl);    
                }
            }
            //just to cause dmlexception and cover the apex class
            //if(Test.isRunningTest()) {
              //  insert new Lead();
            //}
            system.debug('listofSiteLink - '+listofSiteLink);
            delete listofSiteLinktoDelete;
            insert listofSiteLink;List<String> Success= new List<String>();
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
        
    }@AuraEnabled
    Public static List<Site__c> getSiteRecords(id recId){
        system.debug(recId);
        Id recordtypeidorgsite= Schema.SObjectType.Site__c.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId();
        List<Opportunity> oppAccountId =[select AccountId from Opportunity where id=:recId ];
        Id parentAccountId = oppAccountId[0].AccountId;
        List<Site__c> listSite = [Select id,Name from Site__c where Account__c =: parentAccountId and RecordtypeId =: recordtypeidorgsite];
        //List<Site__c> listSite = [Select id,Name from Site__c where RecordtypeId =: recordtypeidorgsite];
        
        System.debug('sitelist '+listSite);
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
    }
    @AuraEnabled
    Public static String getParentAccountRecordId(id recId){
        Id recordtypeidorgsite= Schema.SObjectType.Site__c.getRecordTypeInfosByDeveloperName().get('Sector').getRecordTypeId();
        List<Opportunity> oppAccountId =[select AccountId from Opportunity where id=:recId ];
        Id parentAccountId = oppAccountId[0].AccountId;
        return parentAccountId;
    }
}