public class Sector_Opportunity_AddMap 
{
    @AuraEnabled
    public static responseWrapper getAccountDetails(String OppId)
    {
        responseWrapper response = new responseWrapper();
        try
        {
            response.OppResponse = [SELECT Id, Billing_Street__c, Billing_City__c, Billing_State_Province__c, Billing_Zip_Postal_Code__c, Billing_Country__c 
                                    FROM Opportunity where Id =: OppId];
            response.responseStatus = 'success';
        }
        catch(Exception e)
        {
            response.responseStatus = 'error';
            response.responseMessage = 'Something went wrong. Unable to fetch location. Error: '+
                e.getMessage()+'. Line number: '+e.getLineNumber()+'. StackTrace: '+e.getStackTraceString()+'. Please try again or contact system admin.';
        }
        return response;
    }
    public class responseWrapper 
    {
        @AuraEnabled public String responseStatus;
        @AuraEnabled public String responseMessage;
        @AuraEnabled public Opportunity OppResponse;
    }
}