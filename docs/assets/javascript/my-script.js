
//var csv is the CSV file with headers
function csvJSON(csv,dataName){
    console.log(csv);

    // splitting the data on lines. 
    var lines=csv.split("\r\n");
    var result = [];
  
    //reading hades.
    var headers=lines[0].split(",");

    //reading rest of the data
    for(var i=1;i<lines.length;i++){
  
        var obj = {};
        var currentline=lines[i].split(",");
  
        for(var j=0;j<headers.length;j++){
            obj[headers[j]] = currentline[j];
        }
  
        result.push(obj);
  
    }
    console.log(result)

    var obj2={};
    obj2["elements"]=result;
    return obj2;
  
  }

var STUDENT_METHOD ={

        handlerData:function(resJSON){

            var templateSource   = $("#template").html(),

                template = Handlebars.compile(templateSource),

                studentHTML = template(resJSON);

           $('#my-container').html(studentHTML);
        //    console.log($("#template").html())
        },
        loadStudentData : function(){

            $.ajax({
                url:"https://docs.google.com/spreadsheets/d/e/2PACX-1vRESLHsK654EodzamuJO0blWoEf4VXKfejH8GcylSGuRD7N6lpnD5kuv90aC0xyir6NGcc0-DzRmapJ/pub?output=csv",
                dataFilter:csvJSON, 
                method:'get',
                success:this.handlerData

            })
        }
};

$(document).ready(function(){

    STUDENT_METHOD.loadStudentData();
});