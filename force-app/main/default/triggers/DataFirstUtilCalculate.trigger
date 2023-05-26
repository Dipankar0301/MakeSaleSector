trigger DataFirstUtilCalculate on Interview_Response__c (after insert, after update, after delete) {

    Id InterviewId = null;
    Id AssessmentId = null;
    
    String[] themes = new String[]{'Goals', 'People', 'Processes and Methods', 'Data Lifecycle', 'Data Architecture', 'Applications', 'Performance', 'Results', 'Continuous Improvement'};
    
    if(Trigger.isDelete){
    	InterviewId = Trigger.Old[0].Interview__c;
        AssessmentId = Trigger.Old[0].Assessment__c;   
    }
    else{
    	InterviewId = Trigger.New[0].Interview__c;
        AssessmentId = Trigger.New[0].Assessment__c; 
    }
    
    List<Interview_Response__c> responses = [SELECT Maturity_Level__c, Urgency_for_Improvements__c, Theme__r.Name FROM Interview_Response__c WHERE Interview__c =: InterviewId];
    
    Map<String, List<Double> > maturity = new Map<String, List<Double>>();
    Map<String, List<Double> > improvements = new Map<String, List<Double>>();
    
    for(Interview_Response__c r : responses){
        if(!maturity.containsKey(r.Theme__r.Name)){
        	maturity.put(r.Theme__r.Name, new List<Double>());    
        }
        if(!r.Maturity_Level__c.equals('NA')){
            maturity.get(r.Theme__r.Name).add(Double.valueOf(r.Maturity_Level__c));
        }
        if(!improvements.containsKey(r.Theme__r.Name)){
        	improvements.put(r.Theme__r.Name, new List<Double>());    
        }
        if(!r.Urgency_for_Improvements__c.equals('NA')){
            improvements.get(r.Theme__r.Name).add(Double.valueOf(r.Urgency_for_Improvements__c));
        }
    }
    
    Map<String, Double> AvgMat = new Map<String, Double>();
    for(String str : maturity.keySet()){
        Double Sum = 0.0;
        for(Double x : maturity.get(str)){
            Sum += x;
        }
        if(maturity.get(str).size() > 0){
             AvgMat.put(str, Sum/(maturity.get(str).size()));
        }
        else{
            AvgMat.put(str, 0.00);
        }
    }
    
    Map<String, Double> AvgImp = new Map<String, Double>();
    for(String str : improvements.keySet()){
        Double Sum = 0.0;
        for(Double x : improvements.get(str)){
            Sum += x;
        }
        if(improvements.get(str).size() > 0){
             AvgImp.put(str, Sum/(improvements.get(str).size()));
        }
        else{
            AvgImp.put(str, 0.00);
        }
       
    }
    
    Interview__c interview = [SELECT Goals__c, People__c, Processes_and_Methods__c, Data_Lifecycle__c, Data_Architecture__c, Applications__c, Performance__c, Results__c, Continuous_Improvement__c, uGoals__c, uPeople__c, uProcesses_and_Methods__c, uData_Lifecycle__c, uData_Architecture__c, uApplications__c, uPerformance__c, uResults__c, uContinuous_Improvement__c from Interview__c where Id =: InterviewId][0];
    
    for(Integer i = 0; i<themes.size(); ++i){
        String str = themes[i];
        if(str == 'Goals'){
            interview.Goals__c = AvgMat.get(str);
            interview.uGoals__c = AvgImp.get(str);
        }
        else if(str == 'People'){
            interview.People__c = AvgMat.get(str);
            interview.uPeople__c = AvgImp.get(str);
        }
        else if(str == 'Processes and Methods'){
            interview.Processes_and_Methods__c = AvgMat.get(str);
            interview.uProcesses_and_Methods__c = AvgImp.get(str);
        }
        else if(str == 'Data Lifecycle'){
            interview.Data_Lifecycle__c = AvgMat.get(str);
            interview.uData_Lifecycle__c = AvgImp.get(str);
        }
        else if(str == 'Data Architecture'){
            interview.Data_Architecture__c = AvgMat.get(str);
            interview.uData_Architecture__c = AvgImp.get(str);
        }
        else if(str == 'Applications'){
            interview.Applications__c = AvgMat.get(str);
            interview.uApplications__c = AvgImp.get(str);
        }
        else if(str == 'Performance'){
            interview.Performance__c = AvgMat.get(str);
            interview.uPerformance__c = AvgImp.get(str);
        }
        else if(str == 'Results'){
            interview.Results__c = AvgMat.get(str);
            interview.uResults__c = AvgImp.get(str);
        }
        else if(str == 'Continuous Improvement'){
            interview.Continuous_Improvement__c = AvgMat.get(str);
            interview.uContinuous_Improvement__c = AvgImp.get(str);
        }
        else{
            // can be added later
        }
        
        
    }
    update interview;
    
    AggregateResult agg = [SELECT AVG(Goals__c)mg, AVG(People__c)mpe, AVG(Processes_and_Methods__c)mpm, AVG(Data_Lifecycle__c)mdl, AVG(Data_Architecture__c)mda, AVG(Applications__c)mapp, AVG(Performance__c)mper, AVG(Results__c)mre, AVG(Continuous_Improvement__c)mci, AVG(uGoals__c)ug, AVG(uPeople__c)upe, AVG(uProcesses_and_Methods__c)upm, AVG(uData_Lifecycle__c)udl, AVG(uData_Architecture__c)uda, AVG(uApplications__c)uapp, AVG(uPerformance__c)uper, AVG(uResults__c)ure, AVG(uContinuous_Improvement__c)uci from Interview__c where (Assessment__c =: AssessmentId AND (Goals__c > 0.00 OR People__c > 0.00 OR Processes_and_Methods__c > 0.00 OR Data_Lifecycle__c > 0.00 OR Data_Architecture__c > 0.00 OR Applications__c > 0.00 OR Performance__c > 0.00 OR Results__c > 0.00 OR Continuous_Improvement__c > 0.00))][0];
    Assessment__c assess = [SELECT mGoals__c, mPeople__c, mProcesses_and_Methods__c, mData_Lifecycle__c, mData_Architecture__c, mApplications__c, mPerformance__c, mResults__c, mContinuous_Improvement__c, uGoals__c, uPeople__c, uProcesses_and_Methods__c, uData_Lifecycle__c, uData_Architecture__c, uApplications__c, uPerformance__c, uResults__c, uContinuous_Improvement__c FROM Assessment__c WHERE Id =: AssessmentId][0];
    
    //List<Interview__c> interviews = [SELECT Goals__c, People__c, Processes_and_Methods__c, Data_Lifecycle__c, Data_Architecture__c, Applications__c, Performance__c, Results__c, Continuous_Improvement__c, uGoals__c, uPeople__c, uProcesses_and_Methods__c, uData_Lifecycle__c, uData_Architecture__c, uApplications__c, uPerformance__c, uResults__c, uContinuous_Improvement__c FROM Interview__c WHERE Assessment__c =: AssessmentId AND (Goals__c > 0.00 OR People__c > 0.00 OR Processes_and_Methods__c > 0.00 OR Data_Lifecycle__c > 0.00 OR Data_Architecture__c > 0.00 OR Applications__c > 0.00 OR Performance__c > 0.00 OR Results__c > 0.00 OR Continuous_Improvement__c > 0.00)];
	//System.debug('-<><><><><><><><><>><><>><>><><>><><><><>><><>');
	//System.debug(interviews);
    
    
    
    assess.mGoals__c = Double.valueOf(agg.get('mg'));
    assess.mPeople__c = Double.valueOf(agg.get('mpe'));
    assess.mProcesses_and_Methods__c = Double.valueOf(agg.get('mpm'));
    assess.mData_Lifecycle__c = Double.valueOf(agg.get('mdl'));
    assess.mData_Architecture__c = Double.valueOf(agg.get('mda'));
    assess.mApplications__c = Double.valueOf(agg.get('mapp'));
    assess.mPerformance__c = Double.valueOf(agg.get('mper'));
    assess.mResults__c = Double.valueOf(agg.get('mre'));
    assess.mContinuous_Improvement__c = Double.valueOf(agg.get('mci'));
	
    assess.uGoals__c = Double.valueOf(agg.get('ug'));
    assess.uPeople__c = Double.valueOf(agg.get('upe'));
    assess.uProcesses_and_Methods__c = Double.valueOf(agg.get('upm'));
    assess.uData_Lifecycle__c = Double.valueOf(agg.get('udl'));
    assess.uData_Architecture__c = Double.valueOf(agg.get('uda'));
    assess.uApplications__c = Double.valueOf(agg.get('uapp'));
    assess.uPerformance__c = Double.valueOf(agg.get('uper'));
    assess.uResults__c = Double.valueOf(agg.get('ure'));
    assess.uContinuous_Improvement__c = Double.valueOf(agg.get('uci'));

    update assess;
}