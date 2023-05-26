trigger DataFirstUtilNeedforActionInterview on Interview__c (after delete) {
    Id AssessmentId = null;
    
    if(Trigger.isDelete){
        AssessmentId = Trigger.Old[0].Assessment__c;    
        
        
        List<Interview_Response__c> responses = [SELECT Order__c, Question__c, Need_for_Action__c, Maturity_Level__c, Urgency_for_Improvements__c FROM Interview_Response__c WHERE Assessment__c =: AssessmentId ORDER BY Order__c ASC];
        Integer n = 35;
        
        Integer num_interviews = responses.size()/n;
        
        Map<Integer, List<Double>> nfa = new Map<Integer, List<Double>>();
        Map<Integer, List<Double>> maturity = new Map<Integer, List<Double>>();
        Map<Integer, List<Double>> improvements = new Map<Integer, List<Double>>();
        
        Integer k = 0;
        for(Integer i=0; i<n; ++i){
            nfa.put(i, new List<Double>());
            maturity.put(i, new List<Double>());
            improvements.put(i, new List<Double>());
            
            for(Integer j=k; j<num_interviews+k; j++){
                
                Interview_Response__c r = responses[j];
                if(!r.Maturity_Level__c.equals('NA') && !r.Urgency_for_Improvements__c.equals('NA')) {
                    nfa.get(i).add(Double.valueof(r.Need_for_Action__c));
                    maturity.get(i).add(Double.valueof(r.Maturity_Level__c));
                    improvements.get(i).add(Double.valueof(r.Urgency_for_Improvements__c));
                }
            }
            
            k += num_interviews;
        }
        List<Need_for_Action__c> mList = [SELECT Need_for_Action__c, Average_Maturity_Level__c, Average_Urgency_for_Improvements__c FROM Need_for_Action__c WHERE Assessment__c =: AssessmentId ORDER BY Order__c ASC];
        
        for(Integer i=0; i<n ;i++){
            Double sNfa = 0.00;
            Double sMat = 0.00;
            Double sImp = 0.00;
            
            for(Double x : nfa.get(i)){
                sNfa += x;
            }
            for(Double x : maturity.get(i)){
                sMat += x;
            }
            for(Double x : improvements.get(i)){
                sImp += x;
            }
            
            if(nfa.get(i).size()>0){
                mList[i].Need_for_Action__c = Double.valueOf(sNfa)/Double.valueOf(nfa.get(i).size());
            }
            else{
                mList[i].Need_for_Action__c = 0.00;
            }
            
            if(maturity.get(i).size()>0){
                mList[i].Average_Maturity_Level__c = Double.valueOf(sMat)/Double.valueOf(maturity.get(i).size());
            }
            else{
                mList[i].Average_Maturity_Level__c = 0.00;
            }
            
            if(improvements.get(i).size()>0){
                mList[i].Average_Urgency_for_Improvements__c = Double.valueOf(sImp)/Double.valueOf(improvements.get(i).size());
            }
            else{
                mList[i].Average_Urgency_for_Improvements__c = 0.00;
            }
        }
        
        update mList;
    }
}