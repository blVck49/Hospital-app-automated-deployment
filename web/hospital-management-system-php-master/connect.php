<?php
	$con = mysqli_connect("","","","");
	date_default_timezone_set ("Asia/Colombo");
	mysqli_select_db($con,"Hospital_db");
	if(!$con){
			die("Failed to connect");
			}

?>