({
    setRecordId : function(component,event,helper) {
        var sPageURL = decodeURIComponent(window.location.search.substring(1)),
            sParameterValue,
            i;
        sParameterValue = sPageURL.split('=')[1];
        component.set("v.recordId", sParameterValue);
    },
    fetchSections : function(component,event,helper) {
        var action = component.get("c.listOfSections");
        action.setParams({
            InterviewId: component.get("v.recordId")
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            var secList =[];
            if(state == 'SUCCESS'){
                
                var rtnValue = response.getReturnValue();                
                for(var i in rtnValue){
                	secList.push(rtnValue[i]);
                }
                component.set("v.sectionList",secList);
            }
        });
        $A.enqueueAction(action);
    },
    fetchQuestions : function(component,event,helper) {
        var action = component.get("c.listOfQuestions");
        action.setParams({
            InterviewId: component.get("v.recordId")
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            //var secList =[];
            var qstList =[];
            //var secVAls =[];
            if(state == 'SUCCESS'){
                
                var rtnValue = response.getReturnValue();                
                for(var i in rtnValue){
                    console.log(rtnValue);
                    /*if(!secList.includes(rtnValue[i].Theme__r.Name)){
                        secVAls[rtnValue[i].Theme__r.Name] = rtnValue[i].Theme__r.Name;
                        secList.push(rtnValue[i].Theme__r.Name);
                    }*/
                    qstList.push(rtnValue[i]);
                    //console.log("==LOOP secList==:"+secList);
                    console.log("==LOOP qstList==:"+qstList);
                    
                }
                console.log("qstList:"+qstList);
                //console.log("secList:"+secList);
                //console.log("secVAls:"+secVAls);
                component.set("v.questionList",qstList);
                //component.set("v.sectionList",secList);
                //component.set("v.sectionValues",secVAls);
            }
        });
        $A.enqueueAction(action);
    },
    saveData : function(component,event,helper){
        console.log(component.get("v.questionList"));
        var qAction = component.get("c.saveQuestions");
        qAction.setParams({
            responses: component.get("v.questionList")
        });
        qAction.setCallback(this,function(response){
            console.log(response.getReturnValue());          
            
        });
        
        console.log(component.get("v.sectionList"));
        var sAction = component.get("c.saveSections");
        sAction.setParams({
            responses: component.get("v.sectionList")
        });
        sAction.setCallback(this,function(response){
            console.log(response.getReturnValue());          
            window.close();
        });
        $A.enqueueAction(qAction);
		$A.enqueueAction(sAction);
		        
    }
    /*setRecordId: function(component,event,helper){
        var recordId = helper.getParamValue('RSC_Assessment', 'projectId');
        debugger;
        component.set('v.recordId', recordId);
    },
    getParamValue : function( tabName, paramName ) {
        debugger;
        var url = window.location.href;
        var allParams = url.substr(url.indexOf(tabName) + tabName.length+1).split('&amp;amp;amp;');
        var paramValue = '';
        for(var i in allParams.length) {
            if(allParams[i].split('=')[0] == paramName)
                paramValue = allParams[i].split('=')[1];
        }
        console.log(paramValue);
        return paramValue;
    }*/
})