public with sharing class Practice1 {
   
    @Auraenabled(cacheable=true)
    public static List<Account> getAccounts()
    {
        List<Account> accountList = new List<Account>();
        accountList = [select Id, Name from Account order by Name limit 5];
        return accountList;
    }
 
    @Auraenabled
    public static Contract getContract(Id accId)
    {
        try {
            Contract con = [select Id, ContractNumber,AccountId from Contract where AccountId=:accId
        order by ContractNumber limit 1];
        return con;
        } 
        catch (Exception e) {
            Contract c = new Contract();
            c.AccountId = accId;
            c.StartDate = date.today()-1;
            c.ContractTerm = 12;
            insert c;
            return c;
        }   
    }
}