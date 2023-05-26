@isTest
public class flows2Test {

    public static testMethod void input(){
        //List<Account> li= new List<Account>();
		Account acc=new Account(name='DK1', annualrevenue=2000);
        insert acc;
        Opportunity opp=new opportunity(name='DK1',StageName='new',CloseDate=system.today(),AccountId=acc.id);
        
        insert opp;
        List<Opportunity> li=[Select id,Discount_Percentage__c from Opportunity where Accountid=:acc.id];
        System.assertEquals(li[0].Discount_Percentage__c, 10);
        
        
        Account acc1=new Account(name='DK2', annualrevenue=20);
        insert acc1;
        Opportunity opp1=new opportunity(name='DK2',StageName='new',CloseDate=system.today(),AccountId=acc1.id);
        
        insert opp1;
        List<Opportunity> li1=[Select id,Discount_Percentage__c from Opportunity where Accountid=:acc1.id];
        System.assertEquals(li1[0].Discount_Percentage__c, 0);
        
    }
}