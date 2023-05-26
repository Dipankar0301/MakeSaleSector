/*
* Author: Nagarjuna Mutte
* Description: This Class is used for create a test records
*/

@isTest
public class SEUK_TestDataFactory 
{
    public static List<Lead> createLead(Integer numLead, Date DueDate, 
                                        Integer GasMeter, Decimal AnnualHH, Decimal AnnualNHH, 
                                        String recordTypeName) 
    {
        List<Lead> newLeadList = new List<Lead>();
        for(Integer i = 0; i < numLead; i++)
        {
            Lead ld = new Lead();
            ld.recordtypeid = Schema.SObjectType.Lead.getRecordTypeInfosByDeveloperName().get(recordTypeName).getRecordTypeId();
            ld.FirstName = 'test '+i+' first name'+i;
            ld.LastName = 'test '+i+' last name'+i;
            ld.Company = 'test '+i+' company name'+i;
            ld.email = 'abc'+i+'@example'+i+'.com';
            ld.Due_Date__c = DueDate;
            ld.Number_of_Gas_meters__c = GasMeter;
            ld.AnnVol_HH__c = AnnualHH;
            ld.AnnVol_NHH__c = AnnualNHH;
            newLeadList.add(ld);
        }
        return newLeadList;
    }
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
    public static List<Account> createAccount(Integer numAccount,
                                              String recordTypeName) 
    {
        List<Account> Accountlist = new List<Account>();
        for(Integer i = 0; i < numAccount; i++)
        {
            Account acc = new Account();
            acc.Name = 'Test Account '+i;
            acc.recordtypeid = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get(recordTypeName).getRecordTypeId();
            Accountlist.add(acc);
        }
        return Accountlist;
    }
}