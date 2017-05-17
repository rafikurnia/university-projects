<?php
    class Model_users extends CI_Model
    {
        public function can_log_in()
        {
            $this->db->where('email',$this->input->post('email'));
            $this->db->where('password',md5($this->input->post('password')));

            $query = $this->db->get('login');

            if($query->num_rows() == 1)
            {
                return true;
            }
            else
            {
                return false;
            }
        }

        public function add_temp_user($key)
        {
            $data = array(
                'email' => $this->input->post('email'),
                'password' => md5($this->input->post('password')),
                'key' => $key
            );

            $query = $this->db->insert('temp_login',$data);

            if($query)
            {
                return true;
            }
            else
            {
                return false;
            }

        }

        public function change_pass()
        {
            $data = array(
                'password' => md5($this->input->post('password')),
            );

            $email = $this->session->userdata('email');

            $this->db->where('email', $email);


            $query = $this->db->update('login', $data); 

            if($query)
            {
                return true;
            }
            else
            {
                return false;
            }

        }

        public function is_key_valid($key)
        {
            $this->db->where('key',$key);
            $query = $this->db->get('temp_login');

            if ($query->num_rows()==1)
            {
                return true;
            }
            else
            {
                return false;
            }

        }

        public function add_user($key)
        {
            $this->db->where('key',$key);
            $temp = $this->db->get('temp_login');

            if ($temp)
            {
                $row = $temp->row();
                $data = array(
                    'email' => $row->email,
                    'password' => $row->password                    
                );

                $already_add = $this->db->insert('login',$data);        
            }

            if ($already_add)
            {
                $this->db->where('key',$key);
                $this->db->delete('temp_login');
                return $data['email'];

            }
            else
            {
                return false;
            }
        }
        
        function get_password() 
        {
            $email = $this->session->userdata('email');

            $this->db->select('password')->from('login')->where('email',$email);

            $query = $this->db->get();
            
            if ($query->num_rows() > 0) {
                return $query->row()->password;
            }
            return false;     
        }


}