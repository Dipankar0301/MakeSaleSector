public class MakeSaleSector_NewenergiesAppcheckCon 
{
    Public String Appdevname { get; set; }
    public MakeSaleSector_NewenergiesAppcheckCon()
    {
        UserAppInfo userAppInfo = [SELECT Id, AppDefinitionId FROM UserAppInfo WHERE UserId = :UserInfo.getUserId() LIMIT 1];
        AppDefinition appDefinition = [SELECT DurableId, Label, DeveloperName  FROM AppDefinition Where DurableId = :userAppInfo.AppDefinitionId LIMIT 1];
    	Appdevname = appDefinition.DeveloperName;
    }
    
}