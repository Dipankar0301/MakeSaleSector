@isTest
public class ContactextentionTest{

Public String message = System.currentPagereference().getParameters().get('msg');
public static testmethod void SampleclassTest()
{
System.currentPagereference().getParameters().put('msg','success');
}

 @isTest private static void testClass() {
 
      //create a dummy account 
      account a = new Account();
      a.Name = 'test account';
      insert a;
      
     //Standard controller of contact is just an example 
     //Create a new instance of contact
     contact acc = new contact(LastName='contact', Account= a); 
     //Insert the object virtually insert acc; 
     //Create a new instance of standard controller 
     ApexPages.StandardController sc = new ApexPages.standardController(acc); 
     Contactextention controller = new Contactextention (sc); 
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
        
        Boolean chkbox= Contactextention.getcheckboxs();
    } 
    
    System.runAs([SELECT Id FROM User][0]) {
        
        Boolean chkbox= Contactextention.getcheckboxs();
        
    }    
    
    
}   




}