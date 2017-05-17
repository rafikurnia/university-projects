<?php
defined('BASEPATH') OR exit('No direct script access allowed');

class Main extends CI_Controller {

	public function index()
	{
		$this->load->view('header');
		$this->load->view('banner');
	}

	public function control()
	{
		$data['result'] = $this->model->getAll();
		
		$this->load->view('header');
		$this->load->view('contents',$data);
	}
	
	public function set($data, $id, $value)
	{
		$this->model->set($data,$id,$value);
		echo "<script> window.location = \"http://localhost/AGV/control\"; </script>";
		
	}
	
	public function setAll($id,$connected,$motor,$signals,$battery,$position,$obstacle)
    {
    	$this->model->setAll($id,$connected,$motor,$signals,$battery,$position,$obstacle);
	}
}
