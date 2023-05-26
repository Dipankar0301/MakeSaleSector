public class Sector_Consent_LeadUpdateSFMC 
{
    // Update SFMC Preference Center Key on Lead once the new lead is created.
    @InvocableMethod(label='Update Lead with SFMC Center Key' description='Update the Lead with SFMC Key when new lead is created' )
    public static void updateSFMCPreferenceCenterKey_Lead(List<Id> LeadIds)
    {
        System.debug('LeadIds='+LeadIds);
        List<Lead> leadstoupdate = new List<Lead>();
        for(Id LeadId : LeadIds)
        {
            leadstoupdate.add(new Lead(Id = LeadId, SFMC_Preference_Center_Key__c = Sector_Consent_Handler.generateSFMCPreferenceCenterKey(LeadId)));
        }
        update leadstoupdate;
    }
    
}