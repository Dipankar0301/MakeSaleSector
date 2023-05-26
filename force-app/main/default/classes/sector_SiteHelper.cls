public class sector_SiteHelper {
    public static Boolean isBatchCode = false;
    public static String getAddress(Site__c site){
        String Address='';
        if (site.Street__c != null) {
            address +=  site.Street__c + ' ';
        }
        if (site.Sector_City__c != null) {
            address += site.Sector_City__c+ ' ';
        }
        if (site.State__c != null) {
            address += site.State__c+ ' ';
        }
        if (site.Zip_Postal_Code__c != null) {
            address += site.Zip_Postal_Code__c+ ' ';
        }
        if (site.Sector_Country__c != null) {
            address += site.Sector_Country__c;
        }
        
        return Address;
    }
    public static void UpdateFieldForInsert(List<Site__c> newList, Map<Id, Site__c> newMap){
        String SectorRecordTypeId = Schema.SObjectType.Site__c.getRecordTypeInfosByName().get('Sector').getRecordTypeId();
        List<Site__c> SiteRecords = New List<Site__c>();
        for(Site__c site:newList){
            if(site.RecordTypeId == SectorRecordTypeId){
                String address = getAddress(site);
                if(address != ''){
                    site.Inserted_Or_Address_Updated__c = true;
                    //site.Last_Geo_Coord_updated_date__c = system.today();
                }
            }
            System.debug(newList);
            System.debug(newList[0].Inserted_Or_Address_Updated__c);
        }
    }
    
    public static void UpdateFieldForUpdate(List<Site__c> oldList, List<Site__c> newList, Map<Id, Site__c> oldMap, Map<Id, Site__c> newMap){
        
        String SectorRecordTypeId = Schema.SObjectType.Site__c.getRecordTypeInfosByName().get('Sector').getRecordTypeId();
        String addressNew;
        String addressOld;
        for(Site__c site:newList){
            if(site.RecordTypeId == SectorRecordTypeId){
                addressNew =getAddress(site);
                Site__c siteold= oldMap.get(site.id); 
                System.debug('line 67');
                System.debug(siteold);
                addressOld =getAddress(siteold);
                System.debug(addressOld +'---'+ addressNew);
                if(addressOld != addressNew && addressOld != '' && addressNew != ''){
                    site.Inserted_Or_Address_Updated__c =true;
                }
            }
            
            
        }
        
    }
}