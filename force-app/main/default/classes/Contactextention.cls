public class Contactextention {

 Apexpages.StandardController controller;
 public Contact myCustomObject ;
    
 public Contactextention(ApexPages.StandardController sc) {
     this.controller = sc;
    myCustomObject = (contact) sc.getRecord();
    }
    
      public static boolean chkbox1 {get;set;}
  
 
   
 public static boolean getcheckboxs(){
  
 
  list<PermissionSetAssignment> pset= [SELECT permissionset.name FROM PermissionSetAssignment where AssigneeId =: userinfo.getuserid()
                               and permissionset.name= 'MC_VF_access' ];
     if (pset.size()>0){
       return chkbox1 = true;
          }                   
    else 
       return chkbox1 = false;
      
       
   }
   


}