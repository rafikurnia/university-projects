<center><div class="header">
<a href="tugasakhir_client.php"><img style="display: inline;" src="http://www.perthmilitarymodelling.com/images/go-back-button.png" height="40"></a><h1 style="display: inline; margin-left:20px;">Fungsi Register</h1>
</div>
<br><br>

<form method="post" action="https://ahlunaza.sisdis.ui.ac.id/register_client.php">
URL WSDL : <input type="text" name="url"><br><br>
User : <input type="text" name="user"><br>
Nama : <input type="text" name="nama"><br>
IP : <input type="text" name="ip"><br><br>
<input type="submit" name="submit" value="Kirim">
</form>

<?php

if(isset($_POST['submit'])) {
	$url = $_POST['url'];
	$user = $_POST['user'];
	$nama = $_POST['nama'];
	$ip = $_POST['ip'];

	try {
		$client = new SoapClient($url, array(
			'soap_version' => SOAP_1_2)
		);

		$result = $client->__soapCall("register", array($user, $nama, $ip));
		if ($result == null) {
			$result = $client->__soapCall("getSaldo", array($user));

			if ($result > -1) {
				echo "Enter data successfully\n";
			} else {
				echo "Could not enter data\n";
			}
		}
	} catch (SoapFault $fault) {
		echo "SoapFault. Could not register data\n";
	}
}

?>
</center>
