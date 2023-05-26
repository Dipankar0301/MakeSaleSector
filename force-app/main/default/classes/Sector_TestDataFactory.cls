@isTest
public class Sector_TestDataFactory 
{
    public static List<Opportunity> createOpportunity(Integer numOpportunity,Id AccountId, Date Closeddate, 
                                                      String StageName, 
                                                      String recordTypeName) 
    {
        List<Opportunity> opplist = new List<Opportunity>();
        for(Integer i = 0; i < numOpportunity; i++)
        {
            Opportunity opp = new Opportunity();
            opp.Name = 'Test opp '+i;
            opp.AccountId = AccountId;
            opp.StageName = StageName;
            opp.recordtypeid = Schema.SObjectType.Opportunity.getRecordTypeInfosByDeveloperName().get(recordTypeName).getRecordTypeId();
            opp.CloseDate = Closeddate;
            opplist.add(opp);
        }
        return opplist;
    }
    public static List<Contact> createContact(Integer numContact,Id AccountId, String recordTypeName) 
    {
        List<Contact> connist = new List<Contact>();
        for(Integer i = 0; i < numContact; i++)
        {
            Contact conn = new Contact();
            conn.firstname = Integer.valueOf(math.rint(math.random()*1000000))+'firstname'+Integer.valueOf(math.rint(math.random()*1000000));
            conn.lastname = Integer.valueOf(math.rint(math.random()*1000000))+'lastname'+Integer.valueOf(math.rint(math.random()*1000000));
            conn.AccountId = AccountId;
            conn.recordtypeid = Schema.SObjectType.Contact.getRecordTypeInfosByDeveloperName().get(recordTypeName).getRecordTypeId();
            connist.add(conn);
        }
        return connist;
    } 
    public static List<Account> createAccount(Integer numAccount, String recordTypeName) 
    {
        List<Account> acclist = new List<Account>();
        for(Integer i = 0; i < numAccount; i++)
        {
            Account acc = new Account();
            acc.Name = Integer.valueOf(math.rint(math.random()*1000000))+'companyname'+Integer.valueOf(math.rint(math.random()*1000000));
            acc.recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(recordTypeName).getRecordTypeId();
            acclist.add(acc);
        }
        return acclist;
    }
    public static List<Lead> createLead(Integer numLead, String recordTypeName) 
    {
        List<Lead> leadList = new List<Lead>();
        for(Integer i = 0; i < numLead; i++)
        {
            Lead leadrecord = new Lead();
            leadrecord.firstname = Integer.valueOf(math.rint(math.random()*1000000))+'firstname'+Integer.valueOf(math.rint(math.random()*1000000));
            leadrecord.lastname = Integer.valueOf(math.rint(math.random()*1000000))+'lastname'+Integer.valueOf(math.rint(math.random()*1000000));
            leadrecord.Company = Integer.valueOf(math.rint(math.random()*1000000))+'lastname'+Integer.valueOf(math.rint(math.random()*1000000));
            leadrecord.recordtypeid = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get(recordTypeName).getRecordTypeId();
            leadList.add(leadrecord);
        }
        return leadList;
    } 
}