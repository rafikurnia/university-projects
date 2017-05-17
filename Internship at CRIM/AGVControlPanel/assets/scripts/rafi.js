function buttonPress()
{
	var p = $(this).attr('id');						
	//if (p=="go")
	//{
	//	window.location = "http://localhost/AGV/control";
	//}
	//else
	//{
		if (p.indexOf("1") >= 0) var agv = 1;
		else if (p.indexOf("2") >= 0) var agv = 2;
		else if (p.indexOf("3") >= 0) var agv = 3;
				
		//$('#'+p).prop("disabled", true);

		if (p.indexOf("n") >= 0)
		{
			//p = p.replace("n","ff");
			//$('#'+p).prop("disabled", false);
			
			$.get("http://192.168.0."+agv+":80/", {cmd:1});
			
		}
		else if (p.indexOf("ff") >= 0)
		{
			//p = p.replace("ff","n");
			//$('#'+p).prop("disabled", false);
			
			$.get("http://192.168.0."+agv+":80/", {cmd:0});
		}	
	//}
}

function disableIt($id)
{
	$('#'+$id).prop("disabled", true);
}

function enableIt($id)
{
	$('#'+$id).prop("disabled", false);
}

function reloadPage()
{
	window.location = location.href;
}

$(document).ready
(
	function()
	{
		setInterval("reloadPage();",3000);
		$("button").click(buttonPress);
	}
);