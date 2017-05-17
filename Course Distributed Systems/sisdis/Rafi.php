<?php
defined('BASEPATH') OR exit('No direct script access allowed');
 
class Rafi extends CI_Controller {
 
    public function index() {
        $this->load->model('Db');
        $data['result'] = $this->Db->getAll();
        $this->load->view('rafi',$data);
    }
 
    private function serverService($filename=" ") {
        $fullPath = '/opt/lampp/htdocs/assets/img/'.$filename;
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
 
    private function clientService($filename=" ") {
        $data = file_get_contents('http://10.10.100.58/tugas2/server/'.$filename);
        $retrieved = json_decode($data);
        $extension = pathinfo($retrieved->lokasi_berkas, PATHINFO_EXTENSION);
 
        ///*Maaf pak, jika base64 harus di decode, harus menggunakan bantuan temporary file
        $decoded = base64_decode($retrieved->isi_berkas);
        file_put_contents('/opt/lampp/htdocs/assets/img/tmp/tmp.'.$extension,$decoded);
        echo '<img src="/assets/img/tmp/tmp.',$extension,'" height="240">';
        //*/
         
        //tanpa base64_decode maka gambar dapat ditampilkan dengan cara berikut
        //echo '<img src="data:image/'.$extension.';base64,'.$retrieved->isi_berkas.'" height="240">';
        echo '<p>Lokasi Pada Server : '.$retrieved->lokasi_berkas;
        echo '<br>Ukuran : '.$retrieved->ukuran_berkas.'</p>';
    }
 
    public function tugas2($serviceType=" ",$filename=" ") {
        if      ($serviceType == "server") $this->serverService($filename);
        else if ($serviceType == "client") $this->clientService($filename);
        else echo "<h1>Maaf, layanan tidak tersedia</h1>";
    }
}