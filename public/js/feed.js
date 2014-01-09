$(document).ready(function(){
	$(".aprobar").click(function(e){
		alert("test");
		e.preventDefault();
		//$.ajaxSetup({async: false});
		//$.getScript("/aprobar/" + $(this).closest("tr").attr("id"));
		//$.ajaxSetup({async: true});
		$.ajax({
			url: "/aprobar/" + $(this).closest("tr").attr("id"),
			dataType: "script",
			cache: true
		})
	});
});