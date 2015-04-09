$( document ).ready(function() {
	// function below is from http://stackoverflow.com/questions/2177548/load-json-into-variable
	// var json = (function () {
	//     var json = null;
	//     $.ajax({
	//         'async': false,
	//         'global': false,
	//         'url': 'all-courses-enhanced-11-03-2014.json',
	//         'dataType': "json",
	//         'success': function (data) {
	//             json = data;
	//         }
	//     });
	//     return json;
	// })(); 
	// console.log(json);



    $('#searchform').on('submit', function(ev){
    	$('#results')
    	ev.preventDefault();
    	// console.log($('#query').val());
    	var regex = new RegExp($('#query').val());
    	$('#results').text("")
    	
    	var output = "";

    	$.getJSON('all-courses-enhanced-11-03-2014.json', function(data){
    		$.each(data, function(key, val){
    			var in_vid_ids = false;
    			for (var i = val.vid_ids.length - 1; i >= 0; i--) {
    				if (val.vid_ids[i].search(regex) != -1){
    					in_vid_ids = true;
    					break;
    				}
    			};
                var in_vid_subtitles = false;
                for (var i = val.subtitles.length - 1; i >= 0; i--) {
                    if (val.subtitles[i].search(regex) != -1){
                        in_vid_subtitles = true;
                        break;
                    }
                };
    			if ((val.code.search(regex) != -1) || (val.l.search(regex) != -1) || (val.url.search(regex) != -1) || in_vid_ids || in_vid_subtitles){
    				output += "<h1>"+val.l+"</h1>";
    				for (var i = val.vid_ids.length - 1; i >= 0; i--) {
    				 	output += "<p><a href='https://www.youtube.com/watch?v="+val.vid_ids[i]+"'>ID-"+val.vid_ids[i]+"</a></p>";
    				};
    			}
				// console.log(val.code);
				// console.log(val.l);
				// console.log(val.url);

			});
			$('#results').prepend(output);
		});
    	// console.log(output);

		
    });
});