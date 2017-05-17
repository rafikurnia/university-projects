<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Rafi extends CI_Controller {

	public function index()	{
		$this->load->model('Db');
		$data['result'] = $this->Db->getAll();
		$this->load->view('rafi',$data);
	}

	public function tugas2($serviceType=" ",$filename=" ") {
		if 		($serviceType == "server") $this->serverService2($filename);
		else if ($serviceType == "client") $this->clientService2($filename);
		else echo "<h1>Maaf, layanan tidak tersedia</h1>";
	}

	private function serverService2($filename=" ") {
		$fullPath = 'c:/xampp/htdocs/sisdis/assets/img/'.$filename;
		header("Content-type:application/json; charset=utf-8");
		if (file_exists($fullPath)) {
			$fileSize = number_format(filesize($fullPath)/1024,2);
			$dataRaw = file_get_contents($fullPath);
			$base64Data = base64_encode($dataRaw);
			$arr = array('isi_berkas' => $base64Data, 'lokasi_berkas' => $fullPath, 'ukuran_berkas' => $fileSize.'KB');
		} else {
			$arr = array('isi_berkas' => 'FILE_NOT_FOUND', 'lokasi_berkas' => 'FILE_NOT_FOUND', 'ukuran_berkas' => 'FILE_NOT_FOUND');
		}
		$data = json_encode($arr);
		echo $data;
	}

	private function clientService2($filename=" ") {
		$data = file_get_contents('http://localhost/sisdis/tugas2/server/'.$filename);
		$retrieved = json_decode($data);
		$extension = pathinfo($retrieved->lokasi_berkas, PATHINFO_EXTENSION);

		/*Maaf pak, jika base64 harus di decode, harus menggunakan bantuan temporary file
		$decoded = base64_decode($retrieved->isi_berkas);
		file_put_contents('c:/xampp/htdocs/sisdis/assets/img/tmp/tmp.'.$extension,$decoded);
		echo '<img src="/sisdis/assets/img/tmp/tmp.',$extension,'" height="240">';
		*/
		
		//tanpa base64_decode maka gambar dapat ditampilkan dengan cara berikut
		echo '<img src="data:image/'.$extension.';base64,'.$retrieved->isi_berkas.'" height="240">';
		echo '<p>Lokasi Pada Server : '.$retrieved->lokasi_berkas;
		echo '<br>Ukuran : '.$retrieved->ukuran_berkas.'</p>';
	}
	
	public function tugas3($serviceType=" ",$input=" ") {
		if ($serviceType == "server") {
			$output = $this->hello($input);
			echo $output;
		}
		else if ($serviceType == "klien") {
			echo "			
			<!DOCTYPE HTML>
			<html>
				<body>
					<form action=\"/sisdis/tugas3/klien\" method=\"post\">
					URL WSDL <input type=\"text\" name=\"url\" value=\"http://localhost/sisdis/tugas3/speksaya.wsdl\"><br>
					String Dikirim <input type=\"text\" name=\"string\"><br>
					<input type=\"submit\" name=\"Kirim\">
					</form><br>";
			if ( !empty($_POST) ) {
				$this->clientService3($_POST["string"],$_POST["url"]);
			}
			echo "		
				</body>
			</html>
			";
		}
		else echo "<h1>Maaf, layanan tidak tersedia</h1>";
	}
	

	public function serverService3(){
		function hello($input) {
			return "Halo, ".$input;
		}
		ini_set("soap.wsdl_cache_enabled", "0"); 
		$server = new SoapServer("http://localhost/sisdis/tugas3/speksaya.wsdl"); 
		$server->addFunction("hello"); 
		$server->handle(); 
	}

	public function clientService3($input=" ",$url="http://localhost/sisdis/tugas3/speksaya.wsdl"){
		$client = new SoapClient($url,array('trace' => 1 ));
		
		echo $client->hello($input);  //Memanggil fungsi dari wsdl
		
		/**
		* Debuging untuk menampilkan XML Request dan Response beserta headernya
		* Lihat page source untuk melihat kode xml
		* Uncomment untuk menampilkannya pada web
		**/
		echo "\n\n\n\n<br><br><b>Request</b><br>\n\n";
		echo $client->__getLastRequestHeaders();		//Header XML Request
		echo $client->__getLastRequest();				//Isi XML Request
		echo "\n\n\n\n<br><br><b>Response</b><br>\n\n";
		echo $client->__getLastResponseHeaders();		//Header XML Response
		echo "\n".$client->__getLastResponse();			//Isi XML Response
	}
	
	public function tugas4($serviceType="server") {
		if ($serviceType == "server") {
			$this->load->model('Db');
			$this->Db->setCount();
			echo "<html>
				  <body>
					IP : 10.10.100.58<br>
					NAMA : Rafi Kurnia Putra<br>
					CNT : ".$this->Db->getCount()."<br>
				  </body>
				  </html>";
		}
		else echo "<h1>Maaf, layanan tidak tersedia</h1>";
	}

	public function Dummy1() {
			echo "<html>
				  <body>
					IP : 10.10.100.58<br>
					NAMA : Rafi Kurnia Putra<br>
					CNT : Dari dummy1<br>
				  </body>
				  </html>";
	}

	public function Dummy2() {
			echo "<html>
				  <body>
					IP : 10.10.100.58<br>
					NAMA : Rafi Kurnia Putra<br>
					CNT : Dari dummy2<br>
				  </body>
				  </html>";
	}
	public function Dummy3() {
			echo "<html>
				  <body>
					IP : 10.10.100.58<br>
					NAMA : Rafi Kurnia Putra<br>
					CNT : Dari dummy3<br>
				  </body>
				  </html>";
	}

	public function Dummy4() {
			echo "<html>
				  <body>
					IP : 10.10.100.58<br>
					NAMA : Rafi Kurnia Putra<br>
					CNT : Dari dummy4<br>
				  </body>
				  </html>";
	}
}