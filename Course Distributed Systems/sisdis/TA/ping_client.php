<center><div class="header">
<a href="tugasakhir_client.php"><img style="display: inline;" src="http://www.perthmilitarymodelling.com/images/go-back-button.png" height="40"></a><h1 style="display: inline; margin-left:20px;">Fungsi Ping</h1>
</div>
<br><br>

<form method="post" action="https://ahlunaza.sisdis.ui.ac.id/ping_client.php">
URL WSDL : <input type="text" name="url"><br><br>
<input type="submit" name="submit" value="Kirim">
</form>

<?php

if(isset($_POST['submit'])) {
	$url = $_POST['url'];

	try {
		$client = new SoapClient($url, array(
			'soap_version' => SOAP_1_2,
			'trace'=> 1)
		);

		$result = $client->__soapCall("ping", array());
		if ($result == 1) {
			echo "Ping Berhasil! ".parse_url($url)['host']." aktif.\n";
		}
	} catch (SoapFault $fault) {
		echo "Ping Gagal! ".parse_url($url)['host']." tidak aktif.\n";
	}
}
?>

</center>
