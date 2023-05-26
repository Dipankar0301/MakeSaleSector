@isTest
Private class NEPM_ProjectLastModifiedDateTriggerTest{
    
   @testSetup static void setup(){
       List<NEPM_Project__c> prolist = new List<NEPM_Project__c>();
       
            
            Id devRecordTypeId = Schema.SObjectType.NEPM_Project__c.getRecordTypeInfosByDeveloperName().get('Global_Customer_Solutions').getRecordTypeId();
            NEPM_Project__c p = new NEPM_Project__c();
            p.Name = 'TestGlobal_Customer_Solutions';
            p.RecordTypeId = devRecordTypeId;
            p.NEPM_Stage__c ='Screening';
            insert p;
            
            Id devRecordTypeId1 = Schema.SObjectType.NEPM_Project__c.getRecordTypeInfosByDeveloperName().get('New_Fuels_RNG').getRecordTypeId();
            NEPM_Project__c p1 = new NEPM_Project__c();
            p1.Name = 'TestNew_Fuels_RNG';
            p1.RecordTypeId = devRecordTypeId1;
            p1.NEPM_Stage__c ='Screening';
            insert p1;
            Id devRecordTypeId2 = Schema.SObjectType.NEPM_Project__c.getRecordTypeInfosByDeveloperName().get('Onshore_Power').getRecordTypeId();
            NEPM_Project__c p2 = new NEPM_Project__c();
            p2.Name = 'TestOnshore_Power';
            p2.RecordTypeId = devRecordTypeId2;
            p2.NEPM_Stage__c ='Screening';
            insert p2;
    }
    @isTest static void testMethod1(){
    
        /****Getting the Energy Solution Record Type****/
        NEPM_Project__c  pro = [SELECT Id,Name FROM NEPM_Project__c WHERE Name ='TestGlobal_Customer_Solutions' LIMIT 1];
        Id devRecordTypeId = Schema.SObjectType.Financial__c.getRecordTypeInfosByDeveloperName().get('UpStreamFinancial').getRecordTypeId();
        
        /*****Financial****/
        Financial__c f  = new Financial__c();
        f.Project__c    = pro.Id;
        f.RecordTypeId  = devRecordTypeId;
        f.NE_CAPEX__c   = 20;
        f.FEASEX_M__c   = 25;
        f.Non_NE_CAPEX_M__c = 30;
        f.Year__c = 2015;
        insert f;
        
        
        Financial__c fs = [Select id,name,Project__c,NE_CAPEX__c,FEASEX_M__c,Non_NE_CAPEX_M__c,Year__c from Financial__c Where Project__c =:pro.id LIMIT 1];
        fs.Year__c = 2020;
        update fs;
        
        Financial__c fsDelete= [Select id,name,Project__c,NE_CAPEX__c,FEASEX_M__c,Non_NE_CAPEX_M__c,Year__c from Financial__c Where Project__c =:pro.id LIMIT 1];
        delete fsDelete;

        GAL__c g      = new GAL__c();
        g.Email__c    = 'TestGAL@gmail.com';
        g.Position__c = 'Developer';
        insert g;
        
        /*****SupportRole****/
        Id RecordTypeId = Schema.SObjectType.NEPM_Support_Role__c.getRecordTypeInfosByDeveloperName().get('UpStreamSupportRole').getRecordTypeId();
        NEPM_Support_Role__c sp = new NEPM_Support_Role__c();
        sp.NEPM_Project__c      =  pro.id;
        sp.GAL__c               =  g.id;
        sp.RecordTypeId         =  RecordTypeId;
        sp.NEPM_Support_Type__c = 'HSSE';
        insert sp;
        
        NEPM_Support_Role__c sup = [Select id,NEPM_Support_Type__c from NEPM_Support_Role__c Where NEPM_Project__c =:pro.id LIMIT 1];
        sup.NEPM_Support_Type__c = 'Strategy';
        update sup;
        
        NEPM_Support_Role__c supDelete= [Select id,NEPM_Support_Type__c from NEPM_Support_Role__c Where NEPM_Project__c =:pro.id LIMIT 1];
        delete supDelete; 
        
        Legal_name__c le = new Legal_name__c();
        le.Name          = 'TestLegalName';
        insert le;
        
        Legal_name__c le1 = new Legal_name__c();
        le1.Name          = 'TestLegalName1';
        insert le1;
        
        /*****Partner****/
        Partner__c p    = new Partner__c();
        p.Project__c    = pro.Id;
        p.Legal_Name__c = le.id;
        insert p;
        
        Partner__c par = [Select id,Legal_Name__c from Partner__c Where Project__c =:pro.id LIMIT 1];
        par.Legal_Name__c = le1.id;
        update par;
        
        Partner__c parDelete= [Select id,Legal_Name__c from Partner__c Where Project__c =:pro.id LIMIT 1];
        delete parDelete;
        
        
        NEPM_Counter_Party__c custparty        = new NEPM_Counter_Party__c();
        custparty.NEPM_Contact_Person_Email__c = 'TestCustomer@gmail.com';
        //custparty.Project__c                   = pro.id;
        custparty.Counter_Party_Type__c        = 'Campus';
        //custparty.Parent_Counter_Party__c      = cusoff1.id;
        insert custparty;
        
        
        NEPM_Counter_Party__c custparty1        = new NEPM_Counter_Party__c();
        custparty.NEPM_Contact_Person_Email__c = 'TestCustomer@gmail.com';
        //custparty.Project__c                   = pro.id;
        custparty.Counter_Party_Type__c        = 'Campus';
        //custparty.Parent_Counter_Party__c      = cusoff1.id;
        insert custparty1;
 
        
        Customer_Offtaker__c cusoff = new Customer_Offtaker__c();
        cusoff.Project__c           = pro.id;
        cusoff.Customer_Offtaker__c = custparty.id;
        insert cusoff;
        
        Customer_Offtaker__c custormeroff = [Select id,Customer_Offtaker__c from Customer_Offtaker__c Where Project__c =:pro.id LIMIT 1];
        custormeroff.Customer_Offtaker__c = custparty1.id;
        update custormeroff;
        
        Customer_Offtaker__c custormeroffDelete= [Select id,Customer_Offtaker__c from Customer_Offtaker__c Where Project__c =:pro.id LIMIT 1];
        delete custormeroffDelete;
        
    }
    @isTest static void testMethod2(){
    
        /****Getting the Energy Solution Record Type****/
        NEPM_Project__c  pro = [SELECT Id,Name FROM NEPM_Project__c WHERE Name ='TestNew_Fuels_RNG' LIMIT 1];
        Id devRecordTypeId = Schema.SObjectType.Financial__c.getRecordTypeInfosByDeveloperName().get('UpStreamFinancial').getRecordTypeId();
        
        /*****Feedstock****/
        Feedstock__c fee               = new Feedstock__c();
        fee.Project__c                 = pro.id;
        fee.Percentage_of_feedstock__c = 10;
        fee.Feedstock_category__c      = 'Lipids - Veg oils';
        insert fee;
        
        Feedstock__c par = [Select id,Percentage_of_feedstock__c from Feedstock__c Where Project__c =:pro.id LIMIT 1];
        par.Percentage_of_feedstock__c = 11;
        update par;
        
        Feedstock__c parDelete= [Select id,Percentage_of_feedstock__c from Feedstock__c Where Project__c =:pro.id LIMIT 1];
        delete parDelete;
        
        /*****Product****/
        Product__c  prod         = new Product__c();
        prod.Project__c          = pro.id;
        prod.Percentage__c       = 10;
        prod.Product_category__c = 'FAME';
        insert prod;
        
        Product__c product = [Select id,Percentage__c from Product__c Where Project__c =:pro.id LIMIT 1];
        product.Percentage__c = 11;
        update product;
        
        Product__c productDelete= [Select id,Percentage__c from Product__c Where Project__c =:pro.id LIMIT 1];
        delete productDelete;
        
        
    } 
     @isTest static void testMethod3(){
    
        /****Getting the Energy Solution Record Type****/
        NEPM_Project__c  pro = [SELECT Id,Name FROM NEPM_Project__c WHERE Name ='TestOnshore_Power' LIMIT 1];
        
        External_Contacts__c  externalContact = new External_Contacts__c();
        externalContact.Email__c              = 'TestExContact@gmail.com';
        externalContact.Phone__c              = '89789789789789';
        insert externalContact;
        
        External_Contacts__c  externalContact1 = new External_Contacts__c();
        externalContact1.Email__c              = 'TestExContact1@gmail.com';
        externalContact1.Phone__c              = '897897897839789';
        insert externalContact1;
        
        External_Contacts_Junction__c externaljun = new External_Contacts_Junction__c();
        externaljun.Project__c                    = pro.id;
        externaljun.External_Contacts__c          = externalContact.id;
        insert externaljun;
        
        External_Contacts_Junction__c exter = [Select id,External_Contacts__c from External_Contacts_Junction__c Where Project__c =:pro.id LIMIT 1];
        exter.External_Contacts__c = externalContact1.id;
        update exter;
        
        External_Contacts_Junction__c exterDelete= [Select id,External_Contacts__c from External_Contacts_Junction__c Where Project__c =:pro.id LIMIT 1];
        delete exterDelete;
        
        String yourFilesContent = 'TheBlogReaders.com File upload content';
 
        ContentVersion conVer = new ContentVersion();
        conVer.ContentLocation = 'S'; // to use S specify this document is in Salesforce, to use E for external files
        conVer.PathOnClient = 'testing.txt'; // The files name, extension is very important here which will help the file in preview.
        conVer.Title = 'Testing Files'; // Display name of the files
        conVer.VersionData = blob.valueof(yourFilesContent); // converting your binary string to Blog
        insert conVer;    //Insert ContentVersion
        
        
        // First get the Content Document Id from ContentVersion Object
        Id conDoc = [SELECT ContentDocumentId FROM ContentVersion WHERE Id =:conVer.Id].ContentDocumentId;
        //create ContentDocumentLink  record 
        ContentDocumentLink conDocLink = New ContentDocumentLink();
        conDocLink.LinkedEntityId = pro.id; // Specify RECORD ID here i.e Any Object ID (Standard Object/Custom Object)
        conDocLink.ContentDocumentId = conDoc;  //ContentDocumentId Id from ContentVersion
        conDocLink.shareType = 'V';
        insert conDocLink;
        
        ContentDocument doc = [SELECT Id,Title, LatestPublishedVersionId FROM ContentDocument where id =:conDoc];
        Delete doc;
        
        
    }  
       
    
}