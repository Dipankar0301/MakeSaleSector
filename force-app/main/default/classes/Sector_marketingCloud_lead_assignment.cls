public class Sector_marketingCloud_lead_assignment {
    // Update SFMC Preference Center Key on Lead once the new lead is created.
    @InvocableMethod(label='Update Lead with queue id' description='Update the Lead with Queue Id' )
    public static void updateOwnerIdWithQueues(List<Id> LeadIds)
    {
        List<Group> hotId = [SELECT Id, Type,Name FROM Group WHERE Type = 'Queue' AND Name = 'Hot Lead Queue'];
        List<Group> warmId = [SELECT Id, Type,Name FROM Group WHERE Type = 'Queue' AND Name = 'Warm Lead Queue'];
        List<Group> marketingId = [SELECT Id, Type,Name FROM Group WHERE Type = 'Queue' AND Name = 'Marketing Cloud Nurturing Queue'];
        List<Lead> leadList = [select id,In_RKA__c,Department__c,Job_Role__c,Engagement_Source__c,OwnerId, LeadSource, Company,Sync_with_MC__c,Lead_Rating__c,Lead_Score__c from Lead where id in: LeadIds];
        Map<String, Sector_Marketing_cloud_scoring__mdt> mapEd = Sector_Marketing_cloud_scoring__mdt.getAll();
        Map<String, Sector_RKA_List__mdt> mapRKA = Sector_RKA_List__mdt.getAll();
        
        List<Lead> leadstoupdate = new List<Lead>();
        for(Lead le : leadList){
            if(le.Sync_with_MC__c == true){
            String function = le.Department__c;
            String role= le.Job_Role__c;
            String rkaName = le.Company;
            Decimal score=getScore(function,role,mapEd);
            le.Lead_Score__c = score;//add the score in the lead score field. just to show the testers that value is coming out perfectly.
            
            if(score >= 4){
                if(le.company != null){
                    Boolean check=checkExist(rkaName,mapRKA);
                    if(check == true){
                        if(le.Engagement_Source__c == 'RAQ'||le.Engagement_Source__c == 'Contact Us'|| le.Engagement_Source__c == 'Lets Chat'){
                            System.debug('line 24');
                            le.OwnerId = hotId[0].id;
                            le.Lead_Rating__c = 'Hot';
                            System.debug(hotId[0].id);
                        }
                        else if(le.Engagement_Source__c != null){
                            le.OwnerId = warmId[0].id;
                            le.Lead_Rating__c = 'Warm';
                        }
                    }
                    else{
                        if(le.Engagement_Source__c == 'RAQ'||le.Engagement_Source__c == 'Contact Us'|| le.Engagement_Source__c == 'Lets Chat'){
                            System.debug('line 34');
                            le.OwnerId = warmId[0].id;
                            le.Lead_Rating__c = 'Warm';
                            System.debug(warmId[0].id);
                        }
                        else if(le.Engagement_Source__c != null){
                            le.OwnerId=marketingId[0].id;
                            le.Lead_Rating__c = 'Cold';
                        }
                    }
                    
                }
                else{
                    if(le.Engagement_Source__c != null)
                    {
                        le.OwnerId=marketingId[0].id;
                        le.Lead_Rating__c = 'Cold';
                    }
                    
                }
            }
            else{
                if(le.company != null){
                    if(le.Engagement_Source__c == 'RAQ'||le.Engagement_Source__c == 'Contact Us'|| le.Engagement_Source__c == 'Lets Chat'){
                        System.debug('line 55');
                        le.OwnerId = warmId[0].id;
                        le.Lead_Rating__c = 'Warm';
                        System.debug(warmId[0].id);
                    }
                    else if(le.Engagement_Source__c != null){
                        le.OwnerId=marketingId[0].id;
                        le.Lead_Rating__c = 'Cold';
                    }
                }
                else{
                    if(le.Engagement_Source__c != null){
                        le.OwnerId=marketingId[0].id;
                        le.Lead_Rating__c = 'Cold';
                    }
                }
            }
            
            
            
            leadstoupdate.add(le);
        }
        }
        System.debug(leadstoupdate);
        update leadstoupdate;
    }
    public static Decimal getScore(String function, String role, Map<String, Sector_Marketing_cloud_scoring__mdt> mapEd)
    {
        System.debug('in getScore');
        Decimal score=0;
        for(String nameEmailDomain : mapEd.keySet()){
            if(mapEd.get(nameEmailDomain).Function__c == function  && mapEd.get(nameEmailDomain).Job_Role__c == role){
                score= mapEd.get(nameEmailDomain).Score__c;
            }
        }
        return score;
    }
    public static Boolean checkExist(String rkaName, Map<String, Sector_RKA_List__mdt> mapRKA)
    {
        System.debug('in checkExist');
        Boolean bool = false;
        for(String nameEmailDomain : mapRKA.keySet()){
            System.debug(nameEmailDomain);
            System.debug(mapRKA.get(nameEmailDomain).Value__c);
            if(mapRKA.get(nameEmailDomain).Value__c == rkaName ){
                bool =true;
            }
        }
        return bool;
    }
}