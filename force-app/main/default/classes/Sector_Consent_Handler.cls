public class Sector_Consent_Handler 
{
    // Update SFMC Preference Center Key on Contact once teh new contact is created.
    @InvocableMethod(label='Update Contact with SFMC Center Key' description='Update the Contact with SFMC Key when new contact is created' )
    public static void updateSFMCPreferenceCenterKey_Contact(List<Id> ContactId)
    {
        System.debug('ContactId='+ContactId);
        SV2020RecursiveTriggerHandler.isFirstTime = false;
        List<Contact> contactstoupdate = new List<Contact>();
        for(Id eachcontactId : ContactId)
        {
            contactstoupdate.add(new Contact(Id = eachcontactId, SFMC_Preference_Center_Key__c = generateSFMCPreferenceCenterKey(eachcontactId)));
        }
        update contactstoupdate;
    }
    public static String generateSFMCPreferenceCenterKey(String recordId)
    {
        Blob myID = Blob.valueOf(recordId);
        Blob myMD5 = Crypto.generateDigest('MD5', myID);
        String myHashKey = EncodingUtil.convertToHex(myMD5 );
        return myHashKey;
    }
}