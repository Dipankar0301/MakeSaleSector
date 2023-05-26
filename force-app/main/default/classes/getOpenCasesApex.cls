public with sharing class getOpenCasesApex {
    @AuraEnabled
    public static List<Case> getOpenCases(Integer numRecords){
        
        String [] caseFields = new String[] {'Id', 'Type','Reason','Subject','Status'};
            
        Map<String,Schema.SObjectField> caseMap = Schema.SObjectType.Case.fields.getMap();    
            for(String fieldToCheck : caseFields){
                if(!caseMap.get(fieldToCheck).getDescribe().isAccessible()){
                    throw new System.NoAccessException();
                }
            }
            
        List<Case> caseList =[Select Id,Type,Reason,Subject,Status From
                             Case Where isClosed = false limit : numRecords];
        return caseList;
    }

}