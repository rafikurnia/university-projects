<?php

$con = mysql_connect("localhost","root","");

mysql_select_db('sistem_terdistribusi');

if(!$con) {
    die('Could not connect: '.mysql_error());
}

function quorum() {
	$status = 0;	

	$url[0] = 'https://made.sisdis.ui.ac.id/tugasakhir/spek.wsdl';
	$url[1] = 'https://putra.sisdis.ui.ac.id/tugasAkhir/speksaya.wsdl';
	$url[2] = 'https://winata.sisdis.ui.ac.id/tugasakhir/spesifikasi.wsdl';
	$url[3] = 'https://ahlunaza.sisdis.ui.ac.id/tugasakhir.wsdl';
	$url[4] = 'https://pramana.sisdis.ui.ac.id/bank/bank.wsdl';
	$url[5] = 'https://nabilati.sisdis.ui.ac.id/ta/wsdl';
	$url[6] = 'https://rahmat.sisdis.ui.ac.id/ta/service.wsdl';
	$url[7] = 'https://priambodo.sisdis.ui.ac.id/bank/wsdl';

	for ($i = 0; $i <= 7; $i++) {
		try {
			$client = new SoapClient($url[$i], array(
				'soap_version' => SOAP_1_2)
			);

			$result = $client->__soapCall("ping", array());
			$status++;
		} catch (SoapFault $fault) {
			echo "URL $i -th is inactive";
		}
	}

	return $status;

}

function ping() {
    $pong = 1;
    return $pong;
}

function register($user_id, $nama, $ip_domisili) {
	/*if (quorum() < 5) {
		return null;
	}*/

    $sql = 'INSERT INTO `bank` (`user_id`, `nama`, `ip_domisili`, `saldo`) VALUES (\''.$user_id.'\', \''.$nama.'\', \''.$ip_domisili.'\', 0)';
    $retval = mysql_query($sql, $GLOBALS['con']);
}

function getSaldo($user_id) {
	/*if (quorum() < 5) {
		return -1;
	}*/

    $sql = 'SELECT * FROM `bank` WHERE `user_id` = \''.$user_id.'\';';
    $retval = mysql_query($sql, $GLOBALS['con']);
    $row = mysql_fetch_array($retval);

    if($row != false) {
    	return $row[3];
    } else {
		return -1;
    }
}

function transfer($user_id, $nilai) {
	/*if (quorum() < 5) {
		return -1;
	}*/

	if (getSaldo($user_id) > -1) {
		$nilai_saldo = getSaldo($user_id)+$nilai;
		$sql = 'UPDATE `bank` SET `saldo` = \''.$nilai_saldo.'\' WHERE `bank`.`user_id` = \''.$user_id.'\';';
    	$retval = mysql_query($sql, $GLOBALS['con']);
		if(!$retval) {
			return -1;
		} else {
			return 0;
		}
	} else {
    	return -2;
	}
}

ini_set("soap.wsdl_cache_enabled", "0");

$server = new SoapServer("https://ahlunaza.sisdis.ui.ac.id/tugasakhir.wsdl", array('soap_version' => SOAP_1_2));
$server->addFunction("ping");
$server->addFunction("register");
$server->addFunction("getSaldo");
$server->addFunction("transfer");
$server->handle();

?>
