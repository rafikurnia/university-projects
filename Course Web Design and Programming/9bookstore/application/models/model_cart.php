<?php
	class Model_cart extends CI_Model {
	
	function retrieve_products(){
		$query = $this->db->query("SELECT * FROM products");
		return $query->result();
	}
	
	function validate_add_cart_item(){
		
		$id = $this->input->post('product_id'); //assign posted product ID to $id
		$cty = $this->input->post('quantity'); //assign product posted quantity to $cty
		
		$this->db->where('id', $id); //select where id matches the posted id
		$query = $this->db->get('books', 1);// select the product
		
		//check if a row has matched our product id
		if($query->num_rows > 0)
		{
            
		//found
			foreach ($query->result() as $row)
			{
				//create array with product info
				$data = array(
						'id' => $id, 
						'qty' => $cty, 
						'price' => $row->price, 
						'name' => $row->name
				);
				
				//
				$this->cart->insert($data);
				
				return TRUE; // 	
			}
		}
		else
		{
		//not found
		return FALSE;
		}
	}
	
	function validate_update_cart(){
	
		//get the total number of items in cart
		$total = count($this->cart->contents());
		
		//retrieve the posted info and update
		$item = $this->input->post('rowid');
		$qty = $this->input->post('qty');
		
		//cycle true all items and update them
		for($i=0; $i<$total; $i++)
		{
			//create ann array with products rowid's and quantities
			$data = array(
				'rowid' => $item[$i],
				'qty' => $qty[$i]
			);
			
			//update the cart with new info
			$this->cart->update($data);
		}
	} 
}