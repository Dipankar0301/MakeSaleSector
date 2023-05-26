@isTest
public class DataFirstInterviewController_TestClass {
    @isTest static void testController() {
        
        Focal_Point__c fp = new Focal_Point__c();
        fp.Name = 'Focal Point';
        insert fp;
        Organisation__c org = new Organisation__c();
        org.Name = 'Test Org';
        org.Focal_Point__c = fp.id;
        insert org;
        Assessment__c assess = new Assessment__c();
        assess.Name = 'Test Assessment';
        assess.End_Date__c = Date.today();
        assess.Start_Date__c = Date.today();
        assess.Organisation__c = org.id;
        Interview__c interview = new Interview__c();
        insert assess;
        interview.Assessment__c = assess.Id;
        insert interview;
        
        Id interviewid = interview.Id;
        Interview__c interview2 = new Interview__c();
        interview2.Assessment__c = assess.Id;
        insert interview2;
        
        Interview__c interview3 = new Interview__c();
        interview3.Assessment__c = assess.Id;
        insert interview3;
        
        List<Theme__c> tl1 = new List<Theme__c>();
        List<Theme__c> tl2 = new List<Theme__c>();
        List<Theme__c> tl3 = new List<Theme__c>();
        
        String[] themes = new String[]{'Goals', 'People', 'Processes and Methods', 'Data Lifecycle', 'Data Architecture', 'Applications', 'Performance', 'Results', 'Continuous Improvement'};
        for(Integer i=0;i<9;i++){
            Theme__c t1 = new Theme__c();
            t1.Name = themes[i];
            t1.Interview__c = interview.Id;
            tl1.add(t1);
            
            Theme__c t2 = new Theme__c();
            t2.Name = themes[i];
            t2.Interview__c = interview2.Id;
            tl2.add(t2);
            
            Theme__c t3 = new Theme__c();
            t3.Name = themes[i];
            t3.Interview__c = interview3.Id;
            tl3.add(t3);
        }
        insert tl1;
        insert tl2;
        insert tl3;
        
        Integer j=0;
        Double order = 1.1;
        List<Interview_Response__c> irl1 = new List<Interview_Response__c>();
        List<Interview_Response__c> irl2 = new List<Interview_Response__c>();
        List<Interview_Response__c> irl3 = new List<Interview_Response__c>();
        List<Need_for_Action__c> nfal = new List<Need_for_Action__c>();
        
        for(Integer i=0;i<35;i++){
            if(i==6){
                j++;
                order = 2.1;
            }
            if(i==11){
                j++;
                order = 3.1;
            }
            if(i==14){
                j++;
                order = 4.1;
            }
            if(i==17){
                j++;
                order = 5.1;
            }
            if(i==22){
                j++;
                order = 6.1;
            }
            if(i==25){
                j++;
                order = 7.1;
            }
            if(i==29){
                j++;
                order = 8.1;
            }
            if(i==33){
                j++;
                order = 9.1;
            }
            Need_for_Action__c nfa = new Need_for_Action__c();
            nfa.Assessment__c = assess.Id;
            nfa.Average_Maturity_Level__c = 0.00;
            nfa.Average_Urgency_for_Improvements__c = 0.00;
            nfa.Question__c = 'Test' + String.valueOf(order);
            nfa.Order__c = order;
            nfa.Need_for_Action__c = 0.00;
            
            nfal.add(nfa);
            
            Interview_Response__c ir1 = new Interview_Response__c();
            ir1.Question__c = 'Test' + String.valueOf(order);
            ir1.Assessment__c = assess.Id;
            ir1.Interview__c = interview.Id;
            ir1.Maturity_Level__c = 'NA';
            ir1.Urgency_for_Improvements__c = 'NA';
           	ir1.Order__c = order;
            ir1.Theme__c = tl1[j].Id;
            irl1.add(ir1);
            
            Interview_Response__c ir2 = new Interview_Response__c();
            ir2.Question__c = 'Test';
            ir2.Assessment__c = assess.Id;
            ir2.Interview__c = interview2.Id;
            ir2.Maturity_Level__c = 'NA';
            ir2.Urgency_for_Improvements__c = 'NA';
            ir2.Order__c = order;
            ir2.Theme__c = tl2[j].Id;
            irl2.add(ir2);
            
            Interview_Response__c ir3 = new Interview_Response__c();
            ir3.Question__c = 'Test';
            ir3.Assessment__c = assess.Id;
            ir3.Interview__c = interview3.Id;
            ir3.Maturity_Level__c = 'NA';
            ir3.Urgency_for_Improvements__c = 'NA';
            ir3.Order__c = order;
            ir3.Theme__c = tl3[j].Id;
            irl3.add(ir3);
            order += 0.1;
        }
		insert nfal;
        insert irl1;
        insert irl2;
        insert irl3;
        System.Debug(DataFirstInterviewViewQuestionsCtr.listOfQuestions(interview.Id));
		Test.startTest();
        String url = '/cmp/InterviewViewQuestions?recordId=' + interviewid;
        PageReference page = new PageReference(url);
        
        Test.setCurrentPage(page);
        Id checkId = DataFirstInterviewViewQuestionsCtr.fetchRecordId();
        List<Interview_Response__c> questions = DataFirstInterviewViewQuestionsCtr.listOfQuestions(interviewid);
        List<Interview_Response__c> questions_2 = DataFirstInterviewViewQuestionsCtr.listOfQuestions(interview2.Id);
        List<Theme__c> mthemes = DataFirstInterviewViewQuestionsCtr.listOfSections(interviewid);
  
        for(Interview_Response__c i : questions){
            i.Maturity_Level__c = '2';
            i.Urgency_for_Improvements__c = '3';
        }
        
        for(Interview_Response__c i : questions_2){
            i.Maturity_Level__c = '2';
            i.Urgency_for_Improvements__c = '3';
        }
        
        for(Theme__c t : mthemes){
            t.Key_Areas_of_Improvement__c = 'Lorem Ipsum';
        }
        
        boolean result1 = DataFirstInterviewViewQuestionsCtr.saveQuestions(questions);
        boolean result2 = DataFirstInterviewViewQuestionsCtr.saveSections(mthemes);
        
        boolean result3 = DataFirstInterviewViewQuestionsCtr.saveQuestions(questions_2);

		delete questions[0];
		delete interview;
        delete interview2;
        Test.stopTest();
        
        System.assertEquals(checkId, interview.id);
        System.assertEquals(35, questions.size());
        System.assertEquals(9, themes.size());
        System.assertEquals(true, result1);
        System.assertEquals(true, result2);
    }
}