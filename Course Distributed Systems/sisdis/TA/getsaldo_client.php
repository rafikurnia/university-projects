<center><div class="header">
<a href="tugasakhir_client.php"><img style="display: inline;" src="http://www.perthmilitarymodelling.com/images/go-back-button.png" height="40"></a><h1 style="display: inline; margin-left:20px;">Fungsi Get Saldo</h1>
</div>
<br><br>

<form method="post" action="https://ahlunaza.sisdis.ui.ac.id/getsaldo_client.php">
URL WSDL : <input type="text" name="url"><br><br>
User : <input type="text" name="user"><br><br>
<input type="submit" name="submit" value="Kirim">
</form>

<?php

if(isset($_POST['submit'])) {
	$url = $_POST['url'];
	$user = $_POST['user'];

	try {
		$client = new SoapClient($url, array(
			'soap_version' => SOAP_1_2,
			'trace'=> 1, 
			'exceptions' => 0)
		);

		$result = $client->__soapCall("getSaldo", array($user));

		if ($result > -1) {
			echo "Saldo user ".$user." = ".$result."\n";
		} else {
			$con = mysql_connect("localhost","root","");
			mysql_select_db('sistem_terdistribusi');

			if(!$con) {
				die('Could not connect: '.mysql_error());
			}

			$sql = 'SELECT * FROM `bank` WHERE `user_id` = \''.$user.'\';';
			$retval = mysql_query($sql, $con);
			$row = mysql_fetch_array($retval);

			$nama = "nama";
			$ip = "ip";
			if($row != false) {
				$nama = $row[1];
				$ip = $row[2];
			}

			$client->__soapCall("register", array($user, $nama, $ip));
			$result = $client->__soapCall("getSaldo", array($user));

			if ($result > -1) {
				echo "User ditambahkan!\n";
				echo "Saldo user ".$user." = ".$result."\n";
			} else {
				echo "User tidak ada.\n";
			}
		}
	} catch (SoapFault $fault) {
		echo "SoapFault. Could not get data\n";
	}
}

?>

</center>
