<?php if ( ! defined('BASEPATH')) exit('No direct script access allowed');

    class Main extends CI_Controller {

        public function index()
        {
            $this->page("home");   
        }

        //untuk meload page, tujuan awalnya agar memanggil view lebih mudah. hehe
        public function page($page)
        {
            if ($page == "home")
            {
                $this->load->model("model_books");
                $data['result'] = $this->model_books->selectALL();
                $data['query'] = $this->model_books->cekDB();
                $data['title'] = "Best Selling";
                $data['error'] = 0;          
            }
            else if ($page == "add")
            {
                $data['name'] = NULL;
                $data['isbn'] = NULL;
                $data['isbn10'] = NULL;
                $data['audience'] = NULL;
                $data['format'] = NULL;
                $data['language'] = NULL;
                $data['pages'] = NULL;
                $data['published'] = NULL;
                $data['dimensions'] = NULL;
                $data['weight'] =NULL;
                $data['genre'] = NULL;
                $data['description'] = NULL;
                $data['price'] = NULL;  
            }

            $this->load->view("view_header");
            $this->load->view("view_navigation");

            if ($page == "home") $this->load->view("view_".$page,$data);
            else if ($page == "add") $this->load->view("view_".$page,$data);
                else $this->load->view("view_".$page);

            $this->load->view("view_footer");    
        }

        //Untuk meload view berdasarkan kebutuhan :D    
            public function login()
            {
                $this->page("login"); 
            }

            public function signup()
            {
                $this->page("signup");
            }

            public function about()
            {
                $this->page("about");
            }

            public function contact()
            {
                $this->page("contact");
            }

        //Untuk pada saat memanggil fungsi edit buku 
        public function editbook($id)
        {
            $this->load->model('model_books');
            $data['result'] = $this->model_books->selectSome($id);
            $data['error'] = 0;
            $data['editing'] = 1;
            $this->load->view('view_header');
            $this->load->view('view_navigation');
            $this->load->view('view_edit',$data);
            $this->load->view('view_footer');
        }

        //Sebenarnya ini untuk fungsi search, tapi dinamakan view agar di url terlihat keren :D 
        public function view($fungsi)
        {

            if ($fungsi == "Search" )
            {   
                $keyword = $this->input->post('cari');
                $hasil['title'] = "Search Result : ".$keyword; 
            }
            else
            {
                $keyword = $fungsi;
                $hasil['title'] = $fungsi;
            }

            $this->load->model('model_books');
            if (!$keyword) redirect('#');

            $hasil['keyword'] = $keyword;
            $hasil['result'] = $this->model_books->search($keyword);      

            if  (!$hasil['result'])  $hasil['error'] = 1;
            else $hasil['error'] = 0;

            $this->load->view("view_header");   
            $this->load->view("view_navigation");
            $this->load->view("view_home",$hasil);
            $this->load->view("view_footer");               
        }

        //Untuk validasi login benar atau tidak
        public function login_validation()
        {
            $this->load->library('form_validation');
            $this->form_validation->set_rules('email','Email','required|trim|xss_clean|valid_email|callback_validate_credentials');
            $this->form_validation->set_rules('password','Password','required|md5|trim');

            if ($this->form_validation->run())
            {
                $data = array(
                    'email' => $this->input->post('email'),
                    'is_logged_in' => 1
                );
                $this->session->set_userdata($data);
                redirect(base_url());
            }
            else
            {
                $this->page("login");
            }
        }

        //Untuk validasi signup benar atau tidak
        public function signup_validation()
        {                                                                 
            $this->load->library('form_validation');
            $this->form_validation->set_rules('email','Email','required|trim|valid_email|is_unique[login.email]');
            $this->form_validation->set_rules('password','Password','required|trim');
            $this->form_validation->set_rules('cpassword','Confirm Password','required|trim|matches[password]');

            $this->form_validation->set_message('is_unique','That email address already exist');

            if ($this->form_validation->run())
            {
                //Ini untuk mengirimkan ke email nilai unique yang kemudian akan dicocokkan dengan database sementara
                $key = md5(uniqid());

                $this->load->library('email');
                $this->load->model('model_users');

                //Email nya menggunakan akun google, menggunakan protocol smtp. 
                //Jadi kalau pakai proxy di UI tidak bisa, karena ini mainnya di localhost
                 
                $this->email->from('9bookstore@gmail.com','9bookstore');  
                $this->email->to($this->input->post('email'));
                $this->email->subject('Confirm Your Account');  

                $message = "<p> Thank you for signing up!</p>";
                $message .= "<p><a href='".base_url()."main/register_user/$key'>click here</a> to confirm your account</p>";

                $this->email->message($message);

                if ($this->model_users->add_temp_user($key))
                { 
                    if ($this->email->send())
                    {
                        $data['page'] = "Success";
                        $this->load->view('view_header');
                        $this->load->view('view_navigation');
                        $this->load->view('view_info',$data);
                        $this->load->view('view_footer');
                    }
                    else
                    {
                        $data['page'] = "Failure";
                        $this->load->view('view_header');
                        $this->load->view('view_navigation');
                        $this->load->view('view_info',$data);
                        $this->load->view('view_footer');
                    }
                }
                else
                {
                    $data['page'] = "ErrorDatabase";
                    $this->load->view('view_header');
                    $this->load->view('view_navigation');
                    $this->load->view('view_info',$data);
                    $this->load->view('view_footer');
                }
            }
            else
            {
                $this->page('signup');
            }

        }

        public function change_password()
        {
            $data['galat'] = 0;
            $this->load->view('view_header');  
            $this->load->view('view_navigation');  
            $this->load->view('view_changepass',$data);  
            $this->load->view('view_footer');              
        }

        //mencocokkan apakah valid untuk ganti password atau tidak
        public function changepass_validation()
        {                                                                 
            $this->load->library('form_validation');
            $this->form_validation->set_rules('opassword','Old Password','required|trim');
            $this->form_validation->set_rules('password','Password','required|trim');
            $this->form_validation->set_rules('cpassword','Confirm Password','required|trim|matches[password]');

            $this->load->model('model_users');
            $oldpass = $this->model_users->get_password();

            if ($this->form_validation->run())
            {               
                if ((md5($this->input->post('opassword'))) ==  $oldpass)
                {                   
                    if ($this->model_users->change_pass())
                    {
                        $data['user'] =  $this->session->userdata('email'); 
                        $data['page'] = "Password Changed";
                        $this->load->view('view_header');
                        $this->load->view('view_navigation');
                        $this->load->view('view_info',$data);
                        $this->load->view('view_footer');    
                    }
                    else
                    { 
                        $data['page'] = "Password Unchanged";
                        $this->load->view('view_header');
                        $this->load->view('view_navigation');
                        $this->load->view('view_info',$data);
                        $this->load->view('view_footer');
                    }
                }
                else
                {
                    $data['galat'] = 1;
                    $this->load->view('view_header');  
                    $this->load->view('view_navigation');  
                    $this->load->view('view_changepass',$data);  
                    $this->load->view('view_footer');  
                }

            }
            else
            {
                $data['galat'] = 0;
                $this->load->view('view_header');  
                $this->load->view('view_navigation');  
                $this->load->view('view_changepass',$data);  
                $this->load->view('view_footer');
            }

        }

        public function validate_credentials()
        {
            $this->load->model('model_users');
            if ($this->model_users->can_log_in())
            {
                return true;   
            }
            else
            {
                $this->form_validation->set_message('validate_credentials','Incorrect email/password');
                return false;            
            }
        }

        //Saat logout, session di hapus begitupun dengan cart
        public function logout()
        {
            $this->session->sess_destroy();
            $this->empty_cart();
        }

        public function register_user($key)
        {
            $this->load->model('model_users');

            if ($this->model_users->is_key_valid($key))
            {
                if($newemail = $this->model_users->add_user($key))
                {
                    $data = array(
                        'email' => $newemail,
                        'is_logged_in' => 1
                    );

                    $this->session->set_userdata($data);
                    redirect(base_url());

                }
                else
                {
                    $data['page'] = "UserAddFailed";
                    $this->load->view('view_header');
                    $this->load->view('view_navigation');
                    $this->load->view('view_info',$data);
                    $this->load->view('view_footer');  
                }
            }        
            else
            {
                $data['page'] = "InvalidKey";
                $this->load->view('view_header');
                $this->load->view('view_navigation');
                $this->load->view('view_info',$data);
                $this->load->view('view_footer');     
            }
        }

        function add_cart_item(){
            $this->load->model("model_cart");
            if($this->model_cart->validate_add_cart_item() == TRUE){

                //mengecek jquery
                if($this->input->post('ajax') != '1'){
                    redirect('main'); // kalau ga dapet feedback 1 dari js, berarti disable, jadi reload 
                }

                else{
                    echo 'true';// kalo dapet 1 berarti js enabled, maka update cart bisa dilakukan
                }
            }
        }

        function show_cart(){

            $data['content'] = 'cart/view-cart.php';    

            $this->load->view('view_header');
            $this->load->view('view_content',$data);
            $this->load->view('view_footer');    
        }

        function update_cart(){
            $this->load->model("model_cart");
            $this->model_cart->validate_update_cart();
            redirect(base_url());
        }

        //menghapus cart
        function empty_cart(){
            $this->cart->destroy();
            redirect(base_url());
        }

        public function add()
        {
            $this->load->library("form_validation");
            $this->form_validation->set_rules("name","Name","required|max_length[255]");
            $this->form_validation->set_rules("isbn","ISBN","required|numeric|exact_length[13]");
            $this->form_validation->set_rules("isbn10","ISBN-10","required|numeric|exact_length[10]");
            $this->form_validation->set_rules("audience","Audience","max_length[255]");
            $this->form_validation->set_rules("format","Format","max_length[255]");
            $this->form_validation->set_rules("language","Language","max_length[255]");
            $this->form_validation->set_rules("pages","Pages","numeric");
            $this->form_validation->set_rules("weight","Weight","numeric");
            $this->form_validation->set_rules("genre","Genre","max_length[255]");
            $this->form_validation->set_rules("price","Price","numeric|required");

            $data['name'] = $this->input->post('name');
            $data['isbn'] = $this->input->post('isbn');
            $data['isbn10'] = $this->input->post('isbn10');
            $data['audience'] = $this->input->post('audience');
            $data['format'] = $this->input->post('format');
            $data['language'] = $this->input->post('language');
            $data['pages'] = $this->input->post('pages');
            $data['published'] = $this->input->post('published');
            $data['dimensions'] = $this->input->post('dimensions');
            $data['weight'] = $this->input->post('weight');
            $data['genre'] = $this->input->post('genre');
            $data['description'] = $this->input->post('description');
            $data['price'] = $this->input->post('price');
            $data['editing'] = 0;

            if ($this->form_validation->run()==FALSE)
            {
                $this->load->view("view_header");   
                $this->load->view("view_navigation");   
                $this->load->view("view_add",$data);
                $this->load->view("view_footer");   
            }
            else
            {
                $data['error'] = "";
                $data['image'] = NULL;
                $data['id'] = NULL;
                $this->load->view("view_header");   
                $this->load->view("view_navigation");   
                $this->load->view("view_upload",$data);
                $this->load->view("view_footer");               
            }
        }

        public function bookedit()
        {
            $this->load->library("form_validation");
            $this->form_validation->set_rules("name","Name","required|max_length[255]");
            $this->form_validation->set_rules("isbn","ISBN","required|numeric|exact_length[13]");
            $this->form_validation->set_rules("isbn10","ISBN-10","required|numeric|exact_length[10]");
            $this->form_validation->set_rules("audience","Audience","max_length[255]");
            $this->form_validation->set_rules("format","Format","max_length[255]");
            $this->form_validation->set_rules("language","Language","max_length[255]");
            $this->form_validation->set_rules("pages","Pages","numeric");
            $this->form_validation->set_rules("weight","Weight","numeric");
            $this->form_validation->set_rules("genre","Genre","max_length[255]");
            $this->form_validation->set_rules("price","Price","numeric|required");

            $data['error'] = 1;

            $data['id'] = $this->input->post('id');
            $data['name'] = $this->input->post('name');
            $data['isbn'] = $this->input->post('isbn');
            $data['isbn10'] = $this->input->post('isbn10');
            $data['audience'] = $this->input->post('audience');
            $data['format'] = $this->input->post('format');
            $data['language'] = $this->input->post('language');
            $data['pages'] = $this->input->post('pages');
            $data['published'] = $this->input->post('published');
            $data['dimensions'] = $this->input->post('dimensions');
            $data['weight'] = $this->input->post('weight');
            $data['genre'] = $this->input->post('genre');
            $data['description'] = $this->input->post('description');
            $data['price'] = $this->input->post('price');
            $data['image'] = $this->input->post('image');
            $data['editing'] = 1;

            if ($this->form_validation->run()==FALSE)
            {
                $this->load->view("view_header");   
                $this->load->view("view_navigation");   
                $this->load->view("view_edit",$data);
                $this->load->view("view_footer");   
            }
            else
            {
                $data['error'] = "";
                $this->load->view("view_header");   
                $this->load->view("view_navigation");   
                $this->load->view("view_upload",$data);
                $this->load->view("view_footer");               
            }
        }

        //kalau edit buku maka cover buku yang lama harus dihapus, dengan memakai unlink
        public function delete($id)
        {
            $this->load->model("model_books");
            $this->model_books->delete($id);
            $file_name = $this->model_books->getBookName($id); 
            $this->load->helper('file');
            unlink("./assets/img/books/".$file_name);
            redirect(base_url());
        }

        function upload_img()
        {
            //form upload untuk gambar buku
            $config['upload_path'] = './assets/img/books/';
            $config['allowed_types'] = 'gif|jpg|png';
            $config['max_size']    = '100000';
            $config['max_width']  = '244';
            $config['max_height']  = '400';

            $this->load->library('upload', $config);

            $data['name'] = $this->input->post('name');
            $data['isbn'] = $this->input->post('isbn');
            $data['isbn10'] = $this->input->post('isbn10');
            $data['audience'] = $this->input->post('audience');
            $data['format'] = $this->input->post('format');
            $data['language'] = $this->input->post('language');
            $data['pages'] = $this->input->post('pages');
            $data['published'] = $this->input->post('published');
            $data['dimensions'] = $this->input->post('dimensions');
            $data['weight'] = $this->input->post('weight');
            $data['genre'] = $this->input->post('genre');
            $data['description'] = $this->input->post('description');
            $data['price'] = $this->input->post('price');
            $data['editing'] = $this->input->post('editing');
            if ($data['editing'] == 1)
            {
                $data['image'] = $this->input->post('image');
                $data['id'] = $this->input->post('id');

            }

            $name = $data['name'];
            $isbn = $data['isbn'];
            $isbn10 = $data['isbn10'];
            $audience = $data['audience'];
            $format = $data['format'];
            $language = $data['language'];
            $pages = $data['pages'];
            $published = $data['published'];
            $dimensions = $data['dimensions'];
            $weight = $data['weight'];
            $genre = $data['genre'];
            $description = $data['description'];
            $price = $data['price'];
            if ($data['editing'] == 1)
            {
                $image = $data['image'];
                $id = $data['id'];
            }

            if ( ! $this->upload->do_upload())
            {
                $data['error'] = $this->upload->display_errors();
                $this->load->view("view_header");   
                $this->load->view("view_navigation");   
                $this->load->view("view_upload",$data);
                $this->load->view("view_footer");
            }
            else
            {
                $info = $this->upload->data();
                $data['upload_data'] = $info; 
                $data['filename'] = $info['file_name'];

                if ($data['editing'] == 1)
                {
                    unlink("./assets/img/books/".$image);      
                }

                $filename = $data['filename'];

                $this->load->model('model_books');

                $values = array("name" => "$name",
                    "isbn" =>  "$isbn",
                    "isbn10" =>  "$isbn10",
                    "audience" =>  "$audience",
                    "format" =>  "$format",
                    "language" =>  "$language",
                    "pages" =>  "$pages",
                    "published" =>  "$published",
                    "dimensions" =>  "$dimensions",
                    "weight" =>  "$weight",
                    "genre" =>  "$genre",
                    "description" =>  "$description",
                    "price" =>  "$price",
                    "image" =>  "$filename"
                );

                if ($data['editing'] == 0)
                {
                    $data['page'] = "Added";
                    $this->model_books->add($values);
                }
                else
                {
                    $data['page'] = "Edited";
                    $this->model_books->edit($id,$values);
                }

                $this->load->view('view_header');
                $this->load->view('view_navigation');
                $this->load->view('view_info',$data);
                $this->load->view('view_footer');
            } 
        }

        public function book_view()
        {
            $this->load->model("model_books");
            $data['info'] = $this->model_books->specific_query();    
            $this->load->view("view_box",$data);
        }

        public function buy()
        {
            if (!($this->session->userdata('is_logged_in')))
            {
                $data['page'] = "login";
                $this->load->view('view_header');
                $this->load->view('view_navigation');
                $this->load->view('view_info',$data);
                $this->load->view('view_footer');
            }
            else
            {
                $total = $this->input->post('total');
                $data['user'] = $this->session->userdata('email');
                $data['page'] = "checkout";
                $data['total'] = $total;

                $this->load->view('view_header');
                $this->load->view('view_navigation');
                $this->load->view('view_info',$data);
                $this->load->view('view_footer');      
            }
        }

}