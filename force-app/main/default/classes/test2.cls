public class test2 {
	
    public static void getData(){
        List<Sept__c> list1=[SELECT CreatedById,CreatedDate,End_Date__c,Id,Name,Start_Date__c FROM Sept__c];
        
        for(Sept__c s:list1)
            System.debug(s.name+' '+s.End_Date__c+' '+s.Start_Date__c);
    }
    public static void getData1(String name){
        List<Sept__c> list2=[SELECT CreatedById,CreatedDate,End_Date__c,Id,Name,Start_Date__c FROM Sept__c WHERE Name= :name];
        
        
        for(Sept__c li:list2){
            //System.debug(s.name+' '+s.End_Date__c+' '+s.Start_Date__c);
            datetime d1=li.Start_Date__c;
        	String s1=d1.format('dd MMM, yyyy');
        	datetime d2=li.End_Date__c;
        	String s2=d2.format('dd MMM, yyyy');
            System.debug(s1+'to'+s2);
        }
    }
    public static void updateData(String name,String newEd){
        try{
        	List<Sept__c> list2=[SELECT End_Date__c,Name FROM Sept__c WHERE Name= :name];
            if(list2.size()>0)
            {
                for(Sept__c s1:list2){
            	//System.debug(s.name+' '+s.End_Date__c+' '+s.Start_Date__c);
                    s1.End_Date__c=Date.valueOf(newEd);
                    update s1;
                }
            }
            else
            {
                System.debug('No records found');
            }
        }catch(Exception e)
        {
            System.debug('Exception Occurred'+e);
        }
    }
}