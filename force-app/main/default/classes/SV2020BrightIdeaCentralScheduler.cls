/***
Class Name: SV2020BrightIdeaCentralScheduler 
Created Date: 'Nov 05, 2020'
Description: SV2020BrightIdeaCentralScheduler is the Schedulable class created to schedule "SV2020BICAccountAndOppBatchClass" 
batch class daily which inturn fetches the ideas from SVX(BIC system) daily and process those ideas(Synced with SV2020 Accounts). 
if idea name matches with SV2020 account name(matche 70% -fuzzy logic), then it will update matched account's chatter feed. Otherwise it will create new 
account and opportunity in Salesforce(SV2020 app).
***/
global class SV2020BrightIdeaCentralScheduler implements Schedulable{
    global void execute(SchedulableContext context){
        //Get the BIC Token.
        //SV2020BrightIdeaCentralHttpRequest.fetchAndProcessBICIdeas(); 
        integer SV2020CreatedDate = null;
        if(system.label.SV2020CreatedDate != 'null'){
            SV2020CreatedDate = integer.valueof(system.label.SV2020CreatedDate);
        }
        integer SV2020BatchSize= integer.valueof(system.label.SV2020BatchSize);
        String date_created = null;
        if(SV2020CreatedDate != null){
            Datetime Yesterday= Date.today().addDays(SV2020CreatedDate);           
            date_created = Yesterday.format('MM/dd/YYYY');
        }
        Database.executeBatch(new SV2020BICAccountAndOppBatchClass(date_created), SV2020BatchSize); 
    }   
}