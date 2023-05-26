({
	StatusPath : function(component, event, helper) {
        var selectStatus=component.get("v.onclickStatus");
		if(selectStatus == 'Scheduled')
        {
           // component.set("v.showCard", true);
            component.set("v.showFields", 'Scheduled');
         
        }
        else if(selectStatus == 'Planned')
        {
          //  component.set("v.showCard", 'true');
            component.set("v.showFields", 'Planned');
        }
        else if(selectStatus == 'Minutes Recorded')
        {
          //  component.set("v.showCard", 'true');
            component.set("v.showFields", 'Minutes Recorded');
        }
        else if(selectStatus == 'Cancelled')
        {
          //  component.set("v.showCard", 'true');
            component.set("v.showFields", 'Cancelled');
        }
	}
})