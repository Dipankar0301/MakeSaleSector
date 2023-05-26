({
    
    upload: function(component, helper, file) {
        if (!file) return;
        if(! file.type=='text/csv'){
            component.find('notificationsLibrary').showToast({
                "duration":"5000",     
                "mode":"dismissible",  
                "title": "Orders file Upload",
                "message":'Please upload CSV file only' ,
                "variant":"error"
            }); 
        }
        else{
            var files=file[0][0];
            var mesg='';
            reader = new FileReader();
            reader.onerror =function errorHandler(evt) {
                switch(evt.target.error.code) {
                    case evt.target.error.NOT_FOUND_ERR:
                        mesg='File Not Found!';
                        break;
                    case evt.target.error.NOT_READABLE_ERR:
                        mesg='File is not in readable format';
                        break;
                    case evt.target.error.ABORT_ERR:
                        break;
                    default:
                        mesg='An error occurred while reading this file.';
                };
                if(mesg.length!=0){
                    component.find('notificationsLibrary').showToast({
                        "duration":"5000",     
                        "mode":"dismissible",  
                        "title": "Mass file Upload",
                        "message":mesg ,
                        "variant":"error"
                    });  
                }
            }
            reader.onabort = function(e) {
                component.find('notificationsLibrary').showToast({
                    "duration":"5000",     
                    "mode":"dismissible",  
                    "title": "Mass file Upload",
                    "message":'File read cancelled' ,
                    "variant":"error"
                });  
                
            };
            reader.onloadstart = function(e) { 
                var output = '<ui type=\"disc\"><strong>'+files.name +'&nbsp'+'</strong> '+files.size+'bytes,&nbsp last modified: '+files.lastModifiedDate.toLocaleDateString()+'</ui>';
                component.set("v.filename",files.name);
                component.set("v.TargetFileName",output);
            };
            reader.onload = function(e) {
                var data=e.target.result;
                var setData=data.replace(/�/g, ' ').trim();
                component.set("v.fileContentData",setData);
                var setlist=[];
                var allTextLines = data.split(/\r\n|\n/);
                var dataRows=allTextLines.length-1;
                var headers=[];
                headers = allTextLines[0].split(',');
                component.set("v.filecolumns",headers);
                var filecontentdata=[];
                var errormsg='';
                if(headers.length<=1){
                    errormsg='File is Empty!';
                    component.set("v.totalCount",0);
                }
                else{
                    var count=0;
                    var content = "<table  class=\"slds-table slds-table_cell-buffer slds-table_bordered\">";
                    content += "<thead><tr class=\"slds-text-title--caps\">";
                    
                    for(i=0;i<headers.length; i++){
                        content += '<th scope=\"col"\>'+headers[i]+'</th>';
                    }
                    content += "</tr></thead>";
                    for (var i=1; i<allTextLines.length; i++) {
                        
                        filecontentdata = allTextLines[i].split(',');
                        if(filecontentdata[0]!=''){
                            
                            content +="<tr>";
                            count=count+1;
                            for(var j=0;j<filecontentdata.length;j++){
                                
                                content +='<td>'+  filecontentdata[j].replace(/�/g, ' ').trim()+'</td>';
                                
                            }
                            
                            content +="</tr>";
                        }
                    }
                    content += "</table>";
                    if(allTextLines.length<=2){
                        content=[];
                        errormsg='File is empty!';
                        component.set("v.totalCount",0);
                    }
                    else{
                        component.set("v.TableContent",content);
                        component.set("v.disableUploadButton",true);
                        component.set("v.showMain",true);
                        component.set("v.totalCount",count);
                    }
                }
                if(errormsg.length>0){
                    component.find('notificationsLibrary').showToast({
                        "duration":"5000",     
                        "mode":"dismissible",  
                        "title": "Orders file Upload",
                        "message": errormsg ,
                        "variant":"error"
                    }); 
                }
            }
            reader.readAsText(files);
        }
        var reader = new FileReader();
        reader.onloadend = function() {
            
        };
        reader.readAsDataURL(files);
    },
    
})