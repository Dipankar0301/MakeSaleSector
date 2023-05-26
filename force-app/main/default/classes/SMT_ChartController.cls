public class SMT_ChartController {
    public SMT_System_Overview__c systemSMT{get;set;}
    public static final String ICON_ERROR   = '⛔';
    public static final String ICON_WARNING = '️⚠️';
    public static final String ICON_OK      = '✅';

    public static final String MESSAGE_UNDER_10 = 'Under the 10%';
    public static final String MESSAGE_UNDER_75 = 'Under the 75%';
    public static final String MESSAGE_ABOVE_75 = 'Above the 75%';
    
    public SMT_ChartController(){
        systemSMT=[select id,Total_Object_Usage__c,Apex_Code_coverage__c,Data_Storage_Limit__c,Max_Total_Objects__c,Data_Storage_Usage__c,Maximum_Storage__c,Business_Rules__c,Maximum_Business_Rules__c,Trigger_Usage__c,Apex_usage__c,Apex_Code_Used_Chars__c,Custom_Apps__c,Maximum_Custom_Apps__c,Active_Salesforce_SItes__c,Maximum_Salesforce_Sites__c,Active_Flows__c,Maximum_Flows__c,Custom_Tabs__c,Maximum_Custom_Tabs__c,Visualforce_Pages__c,Apex_Classes__c,Apex_Code_Used_max_chars__c from SMT_System_Overview__c where name='System Overview'];
        system.debug('==='+systemSMT.Total_Object_Usage__c);
        system.debug('@@@'+systemSMT.Max_Total_Objects__c);
    }
    
    public List<ChartData> getMyData() {
        List<ChartData> Sampledata = new List<ChartData>();
        integer val=integer.valueOf(systemSMT.Total_Object_Usage__c);
        integer val2=integer.valueOf(systemSMT.Max_Total_Objects__c);
        //integer value1=integer.valueOf(val);
        Sampledata.add(new ChartData('Max',val2,'',0.00,'',0,'',0,'',0,'',0,'',0,'',0,'',0,'',0));
        Sampledata.add(new ChartData('Remaining',val2-val,'',0.00,'',0,'',0,'',0,'',0,'',0,'',0,'',0,'',0));
        Sampledata.add(new ChartData('Usage',val,'',0.00,'',0,'',0,'',0,'',0,'',0,'',0,'',0,'',0));
        
        
        return Sampledata;
    }
    
    public List<ChartData> getDataStorage() {
        List<ChartData> Sampledata = new List<ChartData>();
       // SMT_System_Overview__c systemSMT=[select id,Total_Object_Usage__c,Max_Total_Objects__c,Data_Storage_Limit__c,Data_Storage_Usage__c,Maximum_Storage__c,Business_Rules__c,Trigger_Usage__c,Apex_usage__c,Apex_Code_Used_Chars__c,Custom_Apps__c,Active_Salesforce_SItes__c,Active_Flows__c,Custom_Tabs__c,Visualforce_Pages__c from SMT_System_Overview__c where name='System Overview'];
        
        decimal storageval=double.valueOf(systemSMT.Data_Storage_Usage__c);
        system.debug('@@@'+storageval);
        integer storageval2=integer.valueOf(systemSMT.Maximum_Storage__c);
        Sampledata.add(new ChartData('',0,'Max',storageval2,'',0,'',0,'',0,'',0,'',0,'',0,'',0,'',0));
        Sampledata.add(new ChartData('',0,'Remaining',storageval2-storageval,'',0,'',0,'',0,'',0,'',0,'',0,'',0,'',0));
        Sampledata.add(new ChartData('',0,'Usage',storageval,'',0,'',0,'',0,'',0,'',0,'',0,'',0,'',0));
        
        return Sampledata;
    }
    
   
    public List<ChartData> getBusinessrules() {
        List<ChartData> Sampledata = new List<ChartData>();
       // SMT_System_Overview__c systemSMT=[select id,Total_Object_Usage__c,Max_Total_Objects__c,Data_Storage_Limit__c,Data_Storage_Usage__c,Maximum_Storage__c,Business_Rules__c,Trigger_Usage__c,Apex_usage__c,Apex_Code_Used_Chars__c,Custom_Apps__c,Active_Salesforce_SItes__c,Active_Flows__c,Custom_Tabs__c,Visualforce_Pages__c from SMT_System_Overview__c where name='System Overview'];
        
        integer ruleval=integer.valueOf(systemSMT.Business_Rules__c);
        system.debug('@@@'+ruleval);
        integer ruleval2=integer.valueOf(systemSMT.Maximum_Business_Rules__c);
        Sampledata.add(new ChartData('',0,'',0,'Max',ruleval2,'',0,'',0,'',0,'',0,'',0,'',0,'',0));
        Sampledata.add(new ChartData('',0,'',0,'Remaining',ruleval2-ruleval,'',0,'',0,'',0,'',0,'',0,'',0,'',0));
        Sampledata.add(new ChartData('',0,'',0,'Usage',ruleval,'',0,'',0,'',0,'',0,'',0,'',0,'',0));
        
        return Sampledata;
    }
    
     public List<ChartData> getCustomApps() {
        List<ChartData> Sampledata = new List<ChartData>();
        integer cApp=integer.valueOf(systemSMT.Custom_Apps__c);
         system.debug('--app:'+cApp);
        integer cApp2=integer.valueOf(systemSMT.Maximum_Custom_Apps__c);
        //integer value1=integer.valueOf(val);
        Sampledata.add(new ChartData('',0,'',0,'',0,'Max',cApp2,'',0,'',0,'',0,'',0,'',0,'',0));
        Sampledata.add(new ChartData('',0,'',0,'',0,'Remaining',cApp2-cApp,'',0,'',0,'',0,'',0,'',0,'',0));
        Sampledata.add(new ChartData('',0,'',0,'',0,'Usage',cApp,'',0,'',0,'',0,'',0,'',0,'',0));
        return Sampledata;
    }
    //Salesforce Active Sites
    public List<ChartData> getActiveSites() {
        List<ChartData> Sampledata = new List<ChartData>();
        integer activeSites=integer.valueOf(systemSMT.Active_Salesforce_SItes__c);
        integer activeSites2=integer.valueOf(systemSMT.Maximum_Salesforce_Sites__c);
        //integer value1=integer.valueOf(val);
        Sampledata.add(new ChartData('',0,'',0,'',0,'',0,'Max',activeSites2,'',0,'',0,'',0,'',0,'',0));
        Sampledata.add(new ChartData('',0,'',0,'',0,'',0,'Remaining',activeSites2-activeSites,'',0,'',0,'',0,'',0,'',0));
        Sampledata.add(new ChartData('',0,'',0,'',0,'',0,'Usage',activeSites,'',0,'',0,'',0,'',0,'',0));
        return Sampledata;
    }
    //Saesforce Active Flows
    public List<ChartData> getActiveFlows() {
        List<ChartData> Sampledata = new List<ChartData>();
        integer activeFlows=integer.valueOf(systemSMT.Active_Flows__c);
        integer activeFlows2=integer.valueOf(systemSMT.Maximum_Flows__c);
        //integer value1=integer.valueOf(val);
        Sampledata.add(new ChartData('',0,'',0,'',0,'',0,'',0,'Max',activeFlows2,'',0,'',0,'',0,'',0));
        Sampledata.add(new ChartData('',0,'',0,'',0,'',0,'',0,'Remaining',activeFlows2-activeFlows,'',0,'',0,'',0,'',0));
        Sampledata.add(new ChartData('',0,'',0,'',0,'',0,'',0,'Usage',activeFlows,'',0,'',0,'',0,'',0));
        return Sampledata;
    }
    //Saesforce Custom Tabs
    public List<ChartData> getCustomTabs() {
        List<ChartData> Sampledata = new List<ChartData>();
        integer ctabs=integer.valueOf(systemSMT.Custom_Tabs__c);
        integer ctabs2=integer.valueOf(systemSMT.Maximum_Custom_Tabs__c);
        //integer value1=integer.valueOf(val);
        Sampledata.add(new ChartData('',0,'',0,'',0,'',0,'',0,'',0,'Max',ctabs2,'',0,'',0,'',0));
        Sampledata.add(new ChartData('',0,'',0,'',0,'',0,'',0,'',0,'Remaining',ctabs2-ctabs,'',0,'',0,'',0));
        Sampledata.add(new ChartData('',0,'',0,'',0,'',0,'',0,'',0,'Usage',ctabs,'',0,'',0,'',0));
        return Sampledata;
    }
    
     //Saesforce Custom Tabs
    public List<ChartData> getVFPages() {
        List<ChartData> Sampledata = new List<ChartData>();
        integer vfpages=integer.valueOf(systemSMT.Visualforce_Pages__c);
        integer ApexTriggers=integer.valueOf(systemSMT.Trigger_Usage__c);
        integer apexCls=integer.valueOf(systemSMT.Apex_Classes__c);
        
        Sampledata.add(new ChartData('',0,'',0,'',0,'',0,'',0,'',0,'',0,'Visualforce',vfpages,'',0,'',0));
        Sampledata.add(new ChartData('',0,'',0,'',0,'',0,'',0,'',0,'',0,'Classes',apexCls,'',0,'',0));
        Sampledata.add(new ChartData('',0,'',0,'',0,'',0,'',0,'',0,'',0,'Triggers',ApexTriggers,'',0,'',0));
       
        return Sampledata;
    }
    
    //Saesforce Custom Tabs
    public List<ChartData> getCodeUsage() {
        List<ChartData> Sampledata = new List<ChartData>();
        decimal cUsed=double.valueOf(systemSMT.Apex_Code_Used_Chars__c);
        decimal cUsed2=double.valueOf(systemSMT.Apex_Code_Used_max_chars__c);
        //integer value1=integer.valueOf(val);
        Sampledata.add(new ChartData('',0,'',0,'',0,'',0,'',0,'',0,'',0,'',0,'Max',cUsed2,'',0));
        Sampledata.add(new ChartData('',0,'',0,'',0,'',0,'',0,'',0,'',0,'',0,'Remaining',cUsed2-cUsed,'',0));
        Sampledata.add(new ChartData('',0,'',0,'',0,'',0,'',0,'',0,'',0,'',0,'Usage',cUsed,'',0));
        return Sampledata;
    }
    
    public List<ChartData> getPieData() {
         
         List<ChartData> Sampledata = new List<ChartData>();
		 decimal codeCoverage=double.valueOf(systemSMT.Apex_Code_coverage__c);
         //decimal codeCoverage2=double.valueOf(systemSMT.Apex_Code_Used_max_chars__c);
         decimal yesVal=(codeCoverage/100)*100;
         decimal noVal=(double.valueOf(100-yesVal)/100)*100;
         Sampledata.add(new ChartData('',0,'',0,'',0,'',0,'',0,'',0,'',0,'',0,'',0,'% uncovered',noVal.setScale(2)));
         //Sampledata.add(new ChartData('',0,'',0,'',0,'',0,'',0,'',0,'',0,'',0,'Remaining',cUsed2-cUsed));
         Sampledata.add(new ChartData('',0,'',0,'',0,'',0,'',0,'',0,'',0,'',0,'',0,'% Covered',yesVal.setScale(2)));
         //data.add(new PieWedgeData('% of StopSurvey Yes', yesVal));
         //data.add(new PieWedgeData('% of StopSurvey No', noVal));

        return Sampledata;
    }
    

    /************************************************************/
    public class ChartData {
        public String Attribute {get;set;}
        public integer CustomObjectLimit {get;set;} 
        public string storage {get;set;}
        public decimal storageLimit {get;set;} 
        public string rule {get;set;}
        public integer RulesLimit {get;set;}
        public string apps {get;set;}
        public integer AppLimit {get;set;}
        public string sites {get;set;}
        public integer SiteLimit {get;set;}
        
        public string flows {get;set;}
        public integer FlowsLimit {get;set;}
        public string tabs {get;set;}
        public integer TabsLimit {get;set;}
        //Visualforce pages
        public string vfs {get;set;}
        public integer VisualforceClassTrigger {get;set;}
        public integer apexusd {get;set;}
        public string codeusage {get;set;} 
        public decimal CodeLimit {get;set;} 
        //public SMT_System_Overview__c systemSMT{get;set;}
        public String codecoverage { get; set; }
        public decimal CodeCoverageLimit { get; set; }
        public ChartData(string att, integer amt, string stg, decimal stlimit, string rul, integer ruleLimit,string customap, integer customapLimit,string sit, integer siteLimit,string flw, integer flowLimit,string customTB, integer tabLimit,string vf, integer vfLimit, string codUsed, decimal codLimit, String name, decimal data) {
            this.Attribute = att ;
            this.CustomObjectLimit = amt ;
            this.storage=stg;
            this.storageLimit=stlimit;
            this.rule=rul;
            this.RulesLimit=ruleLimit;
       		this.apps=customap;
            
            this.AppLimit=customapLimit;
            this.sites=sit;
            this.SiteLimit=siteLimit;
            this.flows=flw;
            this.FlowsLimit=flowLimit;
            this.tabs=customTB;
            this.TabsLimit=tabLimit;
            this.VisualforceClassTrigger=vfLimit;
            this.vfs=vf;
            this.codeLimit=codLimit;
            this.codeusage=codUsed;
            this.codecoverage = name;
            this.CodeCoverageLimit = data;
        }
    }   
       
}