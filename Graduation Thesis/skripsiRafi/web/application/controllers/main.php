<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Main extends CI_Controller {
	
	public function index()
	{
		$this->load->view('view');
	}
	
	public function post()
    {
		
		for ($q = 0; $q < 10; $q++) 
		{
			$ecg[$q] = $this->input->post('a'.$q);
			$pulse[$q] = $this->input->post('b'.$q);
			$breath[$q] = $this->input->post('c'.$q);
			$temp[$q] = $this->input->post('d'.$q);
			$blood[$q] = $this->input->post('e'.$q);
			$rawEcg[$q] = $this->input->post('f'.$q);
			$rawPulse[$q] = $this->input->post('g'.$q);
			$rawBreath[$q] = $this->input->post('h'.$q);
			$cek[$q] = $this->input->post('i'.$q);
			$cpu[$q] = $this->input->post('k'.$q);
		}
		
		$sendingtime = $this->input->post('j');
		$time = gmdate("H:i:s", time() + 3600*(7+date("I")));
		
		for ($q = 0; $q < 10; $q++) 
		{			
			$values[$q] = array
			(
				"ecg" =>  "$ecg[$q]",
				"pulse" =>  "$pulse[$q]",
				"breath" =>  "$breath[$q]",
				"temp" =>  "$temp[$q]",
				"blood" =>  "$blood[$q]",
				"rawEcg" =>  "$rawEcg[$q]",
				"rawPulse" =>  "$rawPulse[$q]",
				"rawBreath" =>  "$rawBreath[$q]",
				"time" =>  "$time",
				"cek" => "$cek[$q]",
				"sendingtime" => "$sendingtime",
				"cpu" => "$cpu[$q]"
			);
		}
			
		$data = array(
				$values[0],$values[1],$values[2],$values[3],$values[4],$values[5],$values[6],$values[7],$values[8],$values[9]
			);	
			
		$this->model->add($values[9]);
			
		$this->model->batch($data);

	}
				
	public function get($param)
	{
		$data = $this->model->get($param);
		$time = $this->model->get('time');
		
		$result = array($data,$time);
		
		header("Content-type: text/json");
		
		echo json_encode($result);
	}
}
