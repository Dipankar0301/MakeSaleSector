@isTest
public class Practice1Test {
    
    @testSetup
    static void createData(){
        Test.startTest();
        //GenerateData.init();
        List<account> li =new List<account>();
        
        for(Integer i=0;i<10;i++)
        {
            Account acc=new Account(name='name'+i);
            li.add(acc);
            //insert acc;
            //system.debug(acc.Id);
        }
        insert li;
        //
        Contract c = new Contract();
            c.AccountId = li[0].id;
            c.StartDate = date.today();
            c.ContractTerm = 12;
            insert c;
        Test.stopTest(); 
        
    }
    @isTest
    static void testGetAccounts0()
    {
        List<Account> accountList = Practice1.getAccounts();
        //accountList = [select Id, Name from Account order by Name limit 5];
        system.assertEquals('name0', accountList[0].name);
    }
    @isTest
    static void testGetAccounts1()
    {
        List<Account> accountList = Practice1.getAccounts();
        //accountList = [select Id, Name from Account order by Name limit 5];
        system.assertNotEquals('name11', accountList[2].name);
    }
    @isTest
    static void testGetAccounts2()
    {
        List<Account> accountList = Practice1.getAccounts();
        //accountList = [select Id, Name from Account order by Name limit 5];
        system.assertEquals('name2', accountList[2].name);
    }
    @isTest
    static void testGetAccounts3()
    {
        List<Account> accountList = Practice1.getAccounts();
        //accountList = [select Id, Name from Account order by Name limit 5];
        system.assertNotEquals('name31', accountList[3].name);
    }
    @isTest
    static void testGetAccounts4()
    {
        List<Account> accountList = Practice1.getAccounts();
        //accountList = [select Id, Name from Account order by Name limit 5];
        system.assertEquals('name4', accountList[4].name);
    }
    
    
    
    
    @isTest
    static void testGetContracts7()
    {
        Account accID= [select id from account where name='name0'];
        id acc=accID.Id;
        Contract con = Practice1.getContract(acc);
        //system.debug(acc +' '+ con.AccountId +'' +con.ContractNumber);
        //accountList = [select Id, Name from Account order by Name limit 5];
        system.assertEquals(acc, con.AccountId);
    }
    @isTest
    static void testGetContracts8()
    {
        Account accID= [select id from account where name='name0'];
        id acc=accID.Id;
        Contract con = Practice1.getContract(acc);
        //accountList = [select Id, Name from Account order by Name limit 5];
        system.assertNotEquals('123456789987654321', con.AccountId);    
    }
    @isTest
    static void testGetContracts9()
    {
        Account accID= [select id from account where name='name1'];
        id acc=accID.Id;
        Contract con = Practice1.getContract(acc);
        //accountList = [select Id, Name from Account order by Name limit 5];
        system.assertEquals(acc, con.AccountId);
    }
}