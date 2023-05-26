public class MassUploaderController {
    @AuraEnabled
    public static Integer insertWorkOrders(String fileData,String sobjectName,List<String> fields,Integer rowsize) {
        Map<String,String> fieldLabel=new Map<String,String>();
        Map<String,String> fieldTypemap=new Map<String,String>();
        //Create SObject reference
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(sobjectName);
        DescribeSObjectResult descrb = targetType.getDescribe();
        //Get SObject Fields API Name and Label Name Map
        Map<String, Schema.SObjectField> fieldMap = targetType.getDescribe().fields.getMap();
        String typeofField='';
        Integer LSTSIZE=0;
        
        //put field label and API Name in fieldLabel Map
        for (String fieldApiName: fieldMap.keySet()) {
            String fieldLabelName=fieldMap.get(fieldApiName).getDescribe().getLabel();//It provides to get the object fields label.
            typeofField=String.valueof(descrb.fields.getMap().get(fieldApiName).getDescribe().getType());
            fieldTypemap.put(fieldApiName,typeofField.toLowerCase());
            fieldLabel.put(fieldLabelName.toLowerCase(),fieldApiName);
        }
        
        try{
            List<sobject> myList = new List<sobject>();
            if(fileData!=null){ 
                String[] fileLines = new String[]{};
                    fileLines = fileData.split('[\n\r]');
                for (Integer i = 0; i < fileLines.size(); i++) {
                    if (fileLines.get(i).equals('') || fileLines.get(i).contains(',,,,') ) {
                        fileLines.remove(i);
                        i--; //Decrement counter since we removed an empty item from the list
                    }
                }
                
                //iterate row and columns to get data and store in respective fields of SObject
                for (Integer i=1,j=rowsize+1;i<j;i++){
                    sObject obj1 = targetType.newSObject();
                    String[] inputvalues = new String[]{};
                        inputvalues = fileLines[i].split(',');
                    integer rows=inputvalues.size();
                    for(integer k=0;k<rows;k++){
                        if(fieldLabel.get(fields[k].toLowerCase())!=null){
                            if(String.isNotBlank(inputvalues[k]) )
                            {
                                String value= inputvalues[k].length()>255 ? inputvalues[k].substring(0,254) : inputvalues[k];
                                value=value.trim();
                                obj1.put(fieldLabel.get(fields[k].toLowerCase()),value);
                                if(fieldTypemap.get(fieldLabel.get(fields[k].toLowerCase()))!='Double' && !(fields[k].toLowerCase()=='start date') && !(fields[k].toLowerCase()=='end date') && !fields[k].toLowerCase().contains('time')){
                                    obj1.put(fieldLabel.get(fields[k].toLowerCase()),value);
                                }
                                if(fieldTypemap.get(fieldLabel.get(fields[k].toLowerCase()))=='Double'){
                                    obj1.put(fieldLabel.get(fields[k].toLowerCase()),Integer.valueof(value)); 
                                }
                            }
                        } 
                    }
                    myList.add(obj1);
                    LSTSIZE=myList.size();
                }
                //insert bulk data into SObject
                Update myList;
            }
        }
        catch(Exception ex){
            throw new AuraHandledException(ex.getMessage() + ex.getLineNumber());   
        }
        //return List Size of inserted data
        return LSTSIZE;
    }
}