		<script src="<?php echo base_url();?>assets/scripts/rafi.js"></script>
		
		
	</head>
	<body class="landing" >	
		<section id="one" class="wrapper style2 align-center" style="height: 665px;">
			<div class="container">
				<br>
				<br>
				<div class="row 200%">
					<?php
						$no = 1;
						
						function changeTo($data) {
						    if ($data) return "YES";
							else return "NO";
						} 
						
						foreach ($result as $row) {
							echo "
							<section class=\"4u 12u$(small)\">
								<center><h9>AGV</h9><h10>".$no."</h10></center><br>
								<table>
									<tr>
										<th>Connected</th>
										<td>:</td>
										<td>".changeTo($row->connected)."</td>
									</tr>
									<tr>
										<th>Signal Strength</th>
										<td>:</td>
										<td>".$row->signals."dBm</td>
									</tr>
									<tr>
										<th>Battery</th>
										<td>:</td>
										<td>".$row->battery."%</td>
									</tr>
									<tr>
										<th>Position</th>
										<td>:</td>
										<td>Checkpoint ".$row->position."</td>
									</tr>
									<tr>
										<th>Obstacle</th>
										<td>:</td>
										<td>".changeTo($row->obstacle)."</td>
									</tr>
								</table>
								<button id=\"on".$no."\" class=\"button control big on\">turn ON</button>
								<button id=\"off".$no."\" class=\"button control big off\">turn OFF</button>
							</section> ";
							
							if ($row->motor)
							{
								echo "<script>
								disableIt(\"on".$no."\");
								enableIt(\"off".$no."\");
								</script>";
							}
							else
							{
								echo "<script>
								disableIt(\"off".$no."\");
								enableIt(\"on".$no."\");
								</script>";
							}
							
							$no++;
						}
					?>
				</div>
			</div>
		</section>
	</body>
</html>