@isTest
public class leadextentionTest{
    
     @isTest private static void testClass() { 
         //Standard controller of leads is just an example 
         //Create a new instance of leads 
         lead acc = new lead(Status = 'new', LastName='leads', Company='shell'); 
         //Insert the object virtually insert acc; 
         //Create a new instance of standard controller 
         ApexPages.StandardController sc = new ApexPages.standardController(acc); 
         leadextention controller = new leadextention(sc); 
    } 
    
    @testSetup static void setup(){
        
        profile p = [select id from profile where name = 'Sales and Platform users'];
        
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com', 
                          EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US', 
                          LocaleSidKey='en_US', ProfileId = p.Id, 
                          TimeZoneSidKey='America/Los_Angeles', UserName='ishu@testorg.com'); 
        insert u;
        
        
        
        PermissionSet ps = [select id , name from permissionset where permissionset.name= 'MC_VF_access'];
        
        PermissionSetAssignment psa = new PermissionSetAssignment(
            AssigneeId = u.id,
            PermissionSetId = ps.Id
        );
        insert psa;
        
        update u;
    } 
    
    static testMethod void testMethod2(){
        
        System.runAs([SELECT Id FROM User WHERE Id = :UserInfo.getUserId()][0]) {
            
            Boolean chkbox= leadextention.getcheckbox();
        } 
        
        System.runAs([SELECT Id FROM User][0]) {
            
            Boolean chkbox= leadextention.getcheckbox();
            
        }    
        
        
    }   
    
    
    
    
}