public class SiteScheduleUpdate implements Schedulable 
{
    public void execute(SchedulableContext sc) 
    {
        Sector_batchGeoCoding b = new Sector_batchGeoCoding(); 
        database.executebatch(b,50);
    }
}