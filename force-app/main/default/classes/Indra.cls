public class Indra {
		public static Void getUsers()
    	{
        //List<User> L = new List<User>();
        //L = [SELECT Id FROM User WHERE ProfileId IN (select Id from Profile where Name = 'System Administrator')];
        List<ObjectPermissions> Obp = new List<ObjectPermissions>();
        Obp = [SELECT Id,sObjectType, PermissionsCreate, PermissionsRead, PermissionsEdit, PermissionsDelete, PermissionsModifyAllRecords, 
               PermissionsViewAllRecords FROM ObjectPermissions 
         	   WHERE sObjectType ='Account' and ParentId IN ( SELECT Id 
               FROM permissionset 
           	   WHERE PermissionSet.Profile.Name = 'System Administrator') and CreatedById in (select CreatedById from Profile where Name = 'System Administrator')];
        System.debug(Obp);
    	}
}