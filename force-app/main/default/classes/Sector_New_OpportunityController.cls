public class Sector_New_OpportunityController 
{
    public Opportunity opp{get;set;}
    public Sector_New_OpportunityController(ApexPages.StandardSetController stdController) 
    {
      //  this.opp = (Opportunity)stdController.getRecord();
        opp = new Opportunity();
    }
    public PageReference saverecord()
    {
        insert opp;
        PageReference pg = new PageReference('/'+opp.Id);
        pg.setRedirect(true);
        return pg; 
    }
}