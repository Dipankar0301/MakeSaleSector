@isTest
public class Sector_Site_ApiCallingTest {
/*    
    
    @testSetup static void IntialSetup() 
    {
        String orgId = UserInfo.getOrganizationId();  
        String dateString = String.valueof(Datetime.now()).replace(' ','').replace(':','').replace('-','');  
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));  
        String uniqueName = orgId + dateString + randomInt; 
        Profile p = [SELECT Id FROM Profile WHERE Name='MakeSaledSector']; 
        User u = new User(Alias = 'standt', Email = 'sectortestclassuser@sector.shell.com', LastName = 'Testing', 
                          EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', 
                          LocaleSidKey = 'en_US', ProfileId = p.Id, 
                          TimeZoneSidKey = 'Europe/Amsterdam', UserName = uniqueName + '@test' + orgId + '.org');
        insert u;
        
    }
    static testMethod void GetAddressInsertTest(){
        User us = [Select Id from User where email = 'sectortestclassuser@sector.shell.com'];
        System.runAs(us)
        {
            Test.setMock(HttpCalloutMock.class, new MockHttpResponseGenerator());
                //Test.startTest();
            List<Site__c> siteList = New List<Site__c>();
            
            for(Integer i=0;i<24;i++){
                Site__c siteTemp = new Site__c();
                siteTemp.Name ='Site Test '+ i;
                siteTemp.Street__c='CongressPara';
                siteTemp.City__c='Balurghat';
                siteTemp.Zip_Postal_Code__c = '733101';
                siteTemp.Sector_Country__c='India';
                siteList.add(siteTemp);
            }
            insert siteList;
            //List<Site__c> siteListAfterInsert = [select id, name,Geo__Latitude__s,Geo__Longitude__s,City__c,Sector_Country__c from Site__c where id in: siteList];
            siteList[0].Street__c = 'Khadimpur';
            siteList[0].Zip_Postal_Code__c = '733103';
            update sitelist;
        }
    }
    
    */
}