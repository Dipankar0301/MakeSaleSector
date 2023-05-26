public class SMT_OverviewCls {
public void getSMTOverview() {
        List<SMT_System_Overview__c> soverviews =[select id,name,User_Object_Usage__c,Apex_Code_Used_Chars__c,Total_Object_Usage__c,Meta_data_usage__c,Metada_Used_Char__c,Data_Storage_Usage__c,Business_Rules__c,Trigger_Usage__c,Apex_Classes__c,Custom_Apps__c,Active_Salesforce_SItes__c,Active_Flows__c,Custom_Tabs__c,Visualforce_Pages__c from SMT_System_Overview__c where name='System Overview'];
        System.debug('@@@@'+soverviews);
    
        /*********************************************************************************************************/
       	final String SYSTEM_OVERVIEW_URL = '/setup/systemOverview.apexp';//?isdtp=vw&setupid=SystemOverview
        PageReference pr = new PageReference(SYSTEM_OVERVIEW_URL);
        pr.setRedirect(false);
        string str='';
        Decimal storageMax=null;
    	Decimal dStorage=null; 
        string dStorageMax='';
        string ds='';
    	string maxStorage='';
        if (!Test.isRunningTest()) {
            
        	str = pr.getContent().toString().stripHtmlTags();
            system.debug('+++'+str);
            //Datastorage in GB
            dStorageMax=str.substringAfter('(Approx.)').left(40).trim();
			Boolean result = dStorageMax.contains('GB');
			system.debug('==='+result);
            if(result==true){maxStorage=dStorageMax.substringAfter('maximum').left(6).trim();storageMax = decimal.valueOf(maxStorage);
            }else{dStorageMax=str.substringBefore('TB').right(4).left(3).trim();storageMax = decimal.valueOf(dStorageMax)*1024;}
            //string dsUsageResult = str.substringBefore('(Approx.)').right(10).trim();
            Boolean dsUsageResult = str.contains('MB');
            if(dsUsageResult==true){ds=str.substringAfter('bytes used. ').left(3);dStorage =decimal.valueOf(ds);dStorage = (dStorage/1024);
            }else{ds=str.substringAfter('bytes used. ').left(3);dStorage =decimal.valueOf(ds);}
            
		}
    	
        string cObjT=str.substringBefore('(maximum 3,000)').right(7).left(3).trim();
        //string apiUsage=str.substringAfter('API Usage API Requests, Last 24 Hours ').left(5).trim().replace(',','');
        string businesRules=str.substringAfter('Business Logic Rules ').left(3).trim();
        string apexTrg=str.substringAfter('Apex Triggers ').left(4).trim();
        //Remove special characters
        string apexclass=str.substringAfter('Apex Classes ').left(5).trim().replace(',','');
        string apexCharsusage=str.substringBefore(' of 6,000,000 characters)').trim().right(7).replace(',','');
        string cApps=str.substringAfter('Custom Apps ').left(2).trim();
        //string activesites=str.substringAfter('Salesforce Site ').left(3).trim();
        //system.debug('*****'+activesites);
    	Boolean siteresult = str.contains('Salesforce Site ');
    
        string SalesforceActiveSites='';
        if(siteresult==true){
            SalesforceActiveSites=str.substringAfter('Salesforce Site ').left(2).trim();
        }else{
            SalesforceActiveSites=str.substringAfter('Salesforce Sites ').left(2).trim();
        }
        string activeFlows=str.substringAfter('Active Flows ').left(3).trim();
        string cTabs=str.substringAfter('Custom Tabs ').left(3).trim();
        string vfPages=str.substringAfter('Visualforce Pages ').left(4).trim();
        
        //system.debug('cbject:'+cObj);
        system.debug('cObjT:'+cObjT);
        //system.debug('cMetadata:'+cMetadata);
        //system.debug('cMetadataLimits:'+cMetadataChars);
        system.debug('dataStorag:'+dStorage);
        system.debug('maxstorage:'+storageMax);
        //system.debug('apiLimit:'+apiUsage);
        system.debug('businesRules:'+businesRules);
        system.debug('apexTrg:'+apexTrg);
        system.debug('apexTrg:'+apexclass);
        system.debug('apexCharsusage:'+apexCharsusage);
        system.debug('cApps:'+cApps);
        system.debug('SalesforceActiveSites:'+SalesforceActiveSites);
        system.debug('activeFlows:'+activeFlows);
        system.debug('cTabs:'+cTabs);
        system.debug('Visualforce Pages :'+vfPages);
/*****************************************Calculate test code coverage*********************************/
string overAllCodeCoveragePercentage;

    HttpRequest req = new HttpRequest();
req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
req.setHeader('Content-Type', 'application/json');
String domainUrl=URL.getSalesforceBaseUrl().toExternalForm();
system.debug('********domainUrl:'+domainUrl);
req.setEndpoint(domainUrl+'/services/data/v48.0/tooling/query/?q=SELECT+PercentCovered+FROM+ApexOrgWideCoverage');
req.settimeout(12000);
req.setMethod('GET');

Http h = new Http();
     
if (!Test.isRunningTest()) {
HttpResponse res = h.send(req);string resBody = res.getBody();JSONParser  parser = JSON.createParser(resBody);
while (parser.nextToken() != null) {String fieldName = parser.getText();
	
	if(fieldName == 'PercentCovered') {parser.nextToken();overAllCodeCoveragePercentage = parser.getText().left(2);break;}
  }
}
system.debug('*******overall Code Coverage:'+overAllCodeCoveragePercentage);

/*******************************************End of code coverage***********************************************************/    
    
		/*****************************************************************************************************/
        
        List<SMT_System_Overview__c> updateSysOverview=new List<SMT_System_Overview__c>();
    	List<SMT_System_Overview__c> insertSysOverview=new List<SMT_System_Overview__c>();
        if(soverviews.size()>0){
            for(SMT_System_Overview__c sst:soverviews){
               
               if (!Test.isRunningTest()) {
               	sst.Total_Object_Usage__c=integer.valueOf(cObjT);sst.Data_Storage_Usage__c=dStorage.setScale(2);sst.Maximum_Storage__c=storageMax;sst.Business_Rules__c=integer.valueOf(businesRules);sst.Trigger_Usage__c=integer.valueOf(apexTrg);sst.Apex_Classes__c=integer.valueOf(apexclass);sst.Apex_Code_Used_Chars__c=integer.valueOf(apexCharsusage);sst.Custom_Apps__c=integer.valueOf(cApps);
               	sst.Active_Salesforce_SItes__c=integer.valueOf(SalesforceActiveSites);sst.Active_Flows__c=integer.valueOf(activeFlows);sst.Custom_Tabs__c=integer.valueOf(cTabs);sst.Visualforce_Pages__c=integer.valueOf(vfPages);sst.Apex_Code_coverage__c=double.valueOf(overAllCodeCoveragePercentage);
                 
               }
                updateSysOverview.add(sst);
                
            }
            
            if(updateSysOverview.size()>0){
                update updateSysOverview;
            	system.debug('Update System Overview'+updateSysOverview);
            }
		   }
           else{
               SMT_System_Overview__c sst=new SMT_System_Overview__c();
               sst.name='System Overview';
               
               sst.Max_Total_Objects__c=3000;
               sst.Maximum_Storage__c=storageMax;
               sst.Maximum_Business_Rules__c=2000;
               sst.Maximum_Custom_Apps__c=9999;
               sst.Maximum_Custom_Tabs__c=9999;
               sst.Maximum_Salesforce_Sites__c=25;
               sst.Maximum_Flows__c=2000;
               sst.Apex_Code_Used_max_chars__c=6000000;
               if (!Test.isRunningTest()) {
               
			    sst.Data_Storage_Usage__c=dStorage.setScale(2);sst.Total_Object_Usage__c=integer.valueOf(cObjT);sst.Business_Rules__c=integer.valueOf(businesRules);sst.Trigger_Usage__c=integer.valueOf(apexTrg);
                sst.Apex_Classes__c=integer.valueOf(apexclass);sst.Apex_Code_Used_Chars__c=integer.valueOf(apexCharsusage);sst.Custom_Apps__c=integer.valueOf(cApps);sst.Active_Salesforce_SItes__c=integer.valueOf(SalesforceActiveSites);sst.Active_Flows__c=integer.valueOf(activeFlows);sst.Custom_Tabs__c=integer.valueOf(cTabs);sst.Visualforce_Pages__c=integer.valueOf(vfPages);sst.Apex_Code_coverage__c=double.valueOf(overAllCodeCoveragePercentage);
                  
               }
               insertSysOverview.add(sst);
                insert insertSysOverview;
               system.debug('insert System Overview'+insertSysOverview);
            }
            
        
    }
}