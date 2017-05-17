<?php
    class Model extends CI_Model
    {
        public function getAll()
        {
            $query = $this->db->get("data");
            return $query->result();    
        }
		
        public function add($values)
        {
			$values['flag'] = 1;
			$this->db->delete("chart",array("flag" => 1));   
			$this->db->insert("chart",$values);
        }
		
		public function batch($values)
		{
			$this->db->insert_batch('data', $values); 
		}
		
		public function get($value)
        {
            $this->db->select($value)->from('chart')->where('flag',1);

            $query = $this->db->get();
            
            if ($query->num_rows() > 0) {
                return $query->row()->$value;
            }
            return false;    
        }
	}	
?>