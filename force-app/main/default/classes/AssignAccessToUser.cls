public class AssignAccessToUser {
    @future
    public static void userAccess(Map<string,string> usermap){
        List<NEPM_Project__c> neprolist = new List<NEPM_Project__c>();  
        for(NEPM_Project__c pro : [SELECT ID,
                                             NAME,
                                             NEPM_BA_Commercial_Lead_GAL__c,
                                             NEPM_BA_Commercial_Lead_GAL__r.Email__c,
                                             NEPM_BA__c,
                                             NEPM_BA__r.email,
                                             NEPM_BOM_GAL__c,
                                             NEPM_BOM_GAL__r.email__c,
                                             NEPM_BOM__c,
                                             NEPM_BOM__r.Email,
                                             NEPM_GAL_Finance__c,
                                             NEPM_GAL_Finance__r.email__c,
                                             NEPM_Finance__c,
                                             NEPM_Finance__r.email,
                                             NEPM_Commercial_Lead_GAL__c,
                                             NEPM_Commercial_Lead_GAL__r.email__c,
                                             NEPM_CL__c,
                                             NEPM_CL__r.email,
                                             NEPM_Decision_Executive_GAL__c,
                                             NEPM_Decision_Executive_GAL__r.email__c,
                                             NEPM_Decision_Executive__c,
                                             NEPM_Decision_Executive__r.email,
                                             NEPM_Technology_Lead__c,
                                             NEPM_Technology_Lead__r.email,
                                             NEPM_Technology_Lead_GAL__c,
                                             NEPM_Technology_Lead_GAL__r.email__c,
                                             RecordType.Name,
                                             Recordtype.Developername
                                       FROM NEPM_Project__c 
                                       WHERE (((NEPM_BOM_GAL__c != null) AND (NEPM_BOM_GAL__r.Email__c IN:usermap.keySet()) AND (NEPM_BOM__c = null)) 
                                       OR ((NEPM_GAL_Finance__c != null) AND (NEPM_GAL_Finance__r.Email__c IN:usermap.keySet()) AND (NEPM_Finance__c = null))
                                       OR ((NEPM_Technology_Lead_GAL__c != null) AND (NEPM_Technology_Lead_GAL__r.email__c IN:usermap.keySet()) AND (NEPM_Technology_Lead__c = null))
                                       OR ((NEPM_Commercial_Lead_GAL__c != null) AND (NEPM_Commercial_Lead_GAL__r.email__c IN:usermap.keySet()) AND (NEPM_CL__c = null) AND (Recordtype.Developername = 'Onshore_Power'))
                                       OR ((NEPM_BA_Commercial_Lead_GAL__c != null) AND (NEPM_BA_Commercial_Lead_GAL__r.email__c IN:usermap.keyset()) AND (NEPM_BA__c = null) AND (Recordtype.Developername != 'Onshore_Power'))) AND (NEPM_VP_Ship__c != 'DSAD')]){
                                       
                                           NEPM_Project__c p = new NEPM_Project__c();
                                           p.id = pro.id;
                                           p.NEPM_BOM__c = pro.NEPM_BOM_GAL__c != null && usermap.containsKey(pro.NEPM_BOM_GAL__r.Email__c) ? usermap.get(pro.NEPM_BOM_GAL__r.Email__c) : pro.NEPM_BOM__c;
                                           p.NEPM_Finance__c = pro.NEPM_GAL_Finance__c != null && usermap.containsKey(pro.NEPM_GAL_Finance__r.Email__c) ? usermap.get(pro.NEPM_GAL_Finance__r.Email__c) : pro.NEPM_Finance__c;
                                           if(pro.Recordtype.Developername == 'Onshore_Power'){
                                             p.NEPM_CL__c = pro.NEPM_Commercial_Lead_GAL__c != null && usermap.containsKey(pro.NEPM_Commercial_Lead_GAL__r.Email__c) ? usermap.get(pro.NEPM_Commercial_Lead_GAL__r.Email__c) : pro.NEPM_CL__c;
                                             p.NEPM_BA_Commercial_Lead_GAL__c = pro.NEPM_Commercial_Lead_GAL__c;
                                           }
                                           if(pro.Recordtype.Developername != 'Onshore_Power'){
                                             p.NEPM_BA__c = pro.NEPM_BA_Commercial_Lead_GAL__c != null && usermap.containsKey(pro.NEPM_BA_Commercial_Lead_GAL__r.email__c) ? usermap.get(pro.NEPM_BA_Commercial_Lead_GAL__r.Email__c) : pro.NEPM_BA__c;
                                             p.NEPM_Commercial_Lead_GAL__c = pro.NEPM_BA_Commercial_Lead_GAL__c;
                                           }
                                           if(pro.Recordtype.Developername == 'Nature_Based_Solutions'){
                                             p.NEPM_Technology_Lead__c = pro.NEPM_Technology_Lead_GAL__c != null && usermap.containsKey(pro.NEPM_Technology_Lead_GAL__r.email__c) ? usermap.get(pro.NEPM_Technology_Lead_GAL__r.email__c) : pro.NEPM_Technology_Lead__c;
                                           }
                                           neprolist.add(p);
                                   }
        if(neprolist.size()>0){
            
            update neprolist;
        }
    }
 
}