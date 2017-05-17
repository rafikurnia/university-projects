<center><div class="header">
<a href="tugasakhir_client.php"><img style="display: inline;" src="http://www.perthmilitarymodelling.com/images/go-back-button.png" height="40"></a><h1 style="display: inline; margin-left:20px;">Fungsi Transfer</h1>
</div>
<br><br>

<form method="post" action="https://ahlunaza.sisdis.ui.ac.id/transfer_client.php">
URL WSDL : <input type="text" name="url"><br><br>
User : <input type="text" name="user"><br>
Nilai : <input type="text" name="nilai"><br><br>
<input type="submit" name="submit" value="Kirim">
</form>

<?php

if(isset($_POST['submit'])) {
	$url = $_POST['url'];
	$user = $_POST['user'];
	$nilai = $_POST['nilai'];

	try {
		$client = new SoapClient($url, array(
			'soap_version' => SOAP_1_2,
			'trace'=> 1, 
			'exceptions' => 0)
		);

		$con = mysql_connect("localhost","root","");
		mysql_select_db('sistem_terdistribusi');

		if(!$con) {
			die('Could not connect: '.mysql_error());
		}

		$sql = 'SELECT * FROM `bank` WHERE `user_id` = \''.$user.'\';';
		$retval = mysql_query($sql, $con);
		$row = mysql_fetch_array($retval);

		$nama = "";
		$ip = "";
		if($row != false) {
			$nama = $row[1];
			$ip = $row[2];
		}

		if ($row[3] > $nilai) {
			$result = $client->__soapCall("getSaldo", array($user));
			if ($result > -1) {
				$result = $client->__soapCall("transfer", array($user, $nilai));
				if ($result > -1) {
					$nilai_saldo = $row[3]-$nilai;
					$sql = 'UPDATE `bank` SET `saldo` = '.$nilai_saldo.' WHERE `bank`.`user_id` = \''.$user.'\';';
					$retval = mysql_query($sql, $con);
					if($retval == true) {
						echo "Transfer berhasil user ".$user." sejumlah ".$nilai."\n";
					} else {
						echo "Transfer Gagal!1\n";
					}
				} else {
					echo "Transfer Gagal!2\n";
				}
			} else {
				$result = $client->__soapCall("register", array($user, $nama, $ip));
				if ($result == null) {
					$result = $client->__soapCall("getSaldo", array($user));

					if ($result > -1) {

						echo "User ditambahkan!\n";
						$result = $client->__soapCall("transfer", array($user, $nilai));
						if ($result > -1) {
							$nilai_saldo = $row[3]-$nilai;
							$sql = 'UPDATE `bank` SET `saldo` = '.$nilai_saldo.' WHERE `bank`.`user_id` = \''.$user.'\';';
							$retval = mysql_query($sql, $con);
							if($retval == true) {
								echo "Transfer berhasil user ".$user." sejumlah ".$nilai."\n";
							} else {
								echo "Transfer Gagal!3\n";
							}
						} else {
							echo "Transfer Gagal!4\n";
						}
					} else {
						echo "User tidak ada.\n";
					}
				}
			}
		} else {
			echo "Saldo tidak mencukupi!\n";
		}
	} catch (SoapFault $fault) {
		echo "SoapFault. Could not transfer data\n";
	}
}

?>

</center>
