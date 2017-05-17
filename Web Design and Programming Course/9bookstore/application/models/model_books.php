<?php
    class Model_books extends CI_Model
    {
        public function cekDB()
        {
            return $this->db->query("SELECT * FROM books");    
        }

        public function getBookName($data)
        {
            $this->db->select('image')->from('books')->where('id',$data);

            $query = $this->db->get();
            
            if ($query->num_rows() > 0) {
                return $query->row()->image;
            }
            return false;    
        }

        public function selectAll()
        {
            $query = $this->db->get("books");
            return $query->result();    
        }

        public function selectSome($id)
        {
            $query = $this->db->get_where("books",array("id" => $id));
            return $query->result();
        }

        public function search($keyword)
        {
            $this->db->like('name', $keyword);
            $this->db->or_like('isbn', $keyword);
            $this->db->or_like('isbn10', $keyword);
            $this->db->or_like('audience', $keyword);
            $this->db->or_like('format', $keyword);
            $this->db->or_like('language', $keyword);
            $this->db->or_like('pages', $keyword);
            $this->db->or_like('published', $keyword);
            $this->db->or_like('dimensions', $keyword);
            $this->db->or_like('weight', $keyword);
            $this->db->or_like('genre', $keyword);
            $this->db->or_like('description', $keyword);
            $this->db->or_like('price', $keyword);
            $query = $this->db->get('books');
            return $query->result();
        }

        public function add($values)
        {
            $this->db->insert("books",$values);
        }

        public function edit($id,$values)
        {
            $this->db->update("books",$values,"id = $id");   
        }

        public function delete($id)
        {
            $query = $this->db->delete("books",array("id" => $id));   
        }
        
        function specific_query() 
        {
            $image = $this->input->post('source');

            $this->db->where('image', $image);
            $query = $this->db->get('books');
                    
            return $query->result();    
        }
    }
?>