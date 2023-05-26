public class makeSales_opportunity_annualisedRevenue {
	@AuraEnabled
	Public static Boolean storeData(id recId, String[] revenueData){
        system.debug(recId);
        System.debug(revenueData);
        Map<Integer,String> revenueDataMap =new Map<Integer, String>();
        Integer currentYear = System.now().year();
        for(integer i=0;i<10;i++){
            revenueDataMap.put(currentYear+i,revenueData[i]);
        }
        
        Map<Integer,String> revenueDataMapPrevious =new Map<Integer, String>();
        revenueDataMapPrevious =retreiveData(recId);
        //System.debug(revenueDataMap);
        
        Integer currentDataSize = revenueDataMap.size();
        System.debug(currentDataSize);
        //Integer lastYear=revenueDataMap.get();
        
        List<Opportunity> recordData = [select id,Revenue_per_year__c from Opportunity where id=: recId];
        
       
        recordData[0].Revenue_per_year__c = String.valueOf(revenueDataMap);
        update recordData;
        return true;
   }
    
    @AuraEnabled
	Public static Map<Integer,String> retreiveData(id recId){
        Map<Integer,String> revenueDataMapPrevious =new Map<Integer, String>();
        List<Opportunity> recordData =[select id,Revenue_per_year__c from Opportunity where id=: recId];
         System.debug(recordData);
        System.debug(recordData[0].Revenue_per_year__c);
        String revperyear2=recordData[0].Revenue_per_year__c;
        system.debug(revperyear2);
        String revperyear4 = revperyear2.replace('{','');
        String revperyear3 = revperyear4.replace('}','');
        String revperyear5 = revperyear3.replace('.','');
        
        String revperyear1 = revperyear5.deleteWhiteSpace();
        String[] revperyear = revperyear1.split(',');
        System.debug('test'+revperyear);
        
        for(integer i=0;i<revperyear.size();i++){
            String[] keyValue = revperyear[i].split('=');
            System.debug(keyValue);
            revenueDataMapPrevious.put(Integer.ValueOf(keyValue[0]),keyValue[1]);
            
        }   
        System.debug(revenueDataMapPrevious);
        return revenueDataMapPrevious;
   }
}