public class leadextention {

public leadextention(ApexPages.StandardController controller) {

    }
    
  public static boolean chkbox1 {get;set;}
 

   
 public static boolean getcheckbox(){
  
 
  list<PermissionSetAssignment> pset= [SELECT permissionset.name FROM PermissionSetAssignment where AssigneeId =: userinfo.getuserid()
                               and permissionset.name= 'MC_VF_access' ];
     if (pset.size()>0){
       return chkbox1 = true;
          }                   
    else 
       return chkbox1 = false;
      
       
   }   
    


}