<?php
	class Db extends CI_Model
	{
		public function getAll()
		{
			$query = $this->db->get("tugas1");
			return $query->result();
		}
		
		public function getCount()
        {
            $this->db->select('count')->from('tugas4')->where('id',1);

            $query = $this->db->get();
            
            if ($query->num_rows() > 0) {
                return $query->row()->count;
            }
            return false;    
        }

		public function setCount()
        {
			$value = $this->getCount();
			$value = $value + 1;
			
            $changes = array('count' => $value);
			$this->db->where('id', 1);
			$this->db->update('tugas4', $changes); 
        }

	}
?>