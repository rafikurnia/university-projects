<?php
    class Model extends CI_Model
    {
        public function getAll()
        {
            $query = $this->db->get("status");
            return $query->result();    
        }
		
		public function setAll($id,$connected,$motor,$signals,$battery,$position,$obstacle)
        {
        	$changes = array(
        		'connected' => $connected,
        		'motor' => $motor,
        		'signals' => $signals,
        		'battery' => $battery,
        		'position' => $position,
        		'obstacle' => $obstacle
			);	
					
            $this->db->where('id', $id);
			$this->db->update('status', $changes);
        }
		
		public function set($data,$id,$value)
        {
            $changes = array($data => $value);
			$this->db->where('id', $id);
			$this->db->update('status', $changes); 
        }
    }
?>