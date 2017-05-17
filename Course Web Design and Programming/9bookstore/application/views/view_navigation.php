<body>

<div id="overlay"></div>
<div id="box">
 <ul class="books">
    </ul> 
   &nbsp&nbsp&nbsp&nbsp<img src=""  />

</div>
 

<div id="wrap">

<div class="header">

    <div id="menu">
        <ul>                                                                                            
            <li><a href="<?php echo base_url();?>main/page/about">About us</a></li>
            <li><a href="<?php echo base_url();?>main/page/contact">Contact</a></li>
            <?php
                if (!($this->session->userdata('is_logged_in')))    
                {
                    echo "<li><a href=".base_url()."main/page/signup>Sign Up</a></li>
                    <li><a href=".base_url()."main/page/login>Log In</a></li>";
                }
                else
                {
                    echo "<li><a href=".base_url()."main/change_password>Change Password</a></li><li><a href=".base_url()."main/logout>Log Out ".$this->session->userdata('email')."</a></li>";

                }
            ?>            
        </ul>
    </div>     


</div> 

<!--Dropdown menu dan search--> 
<div class="dropdown">
    <ul class="nav">
        <li>
            <a href="<?php echo base_url();?>">Home</a>
        </li>

        <?php

            if ($this->session->userdata('is_logged_in'))
            {    
                if ($this->session->userdata('email') == "admin@9bookstore.com") echo "<li><a href=".base_url()."main/page/add>Add Book</a></li>";
            }
        ?>

        <li><a href="#">All Categories</a>
            <!-------------->
            <div>
                <!--MENU 2-->
                <div class="nav-column">
                    <h3><a href="<?php echo base_url();?>main/view/Fiction">Fiction</a></h3>
                    <h3><a href="<?php echo base_url();?>main/view/Romance">Romance</a></h3>
                    <h3><a href="<?php echo base_url();?>main/view/Fantasy">Fantasy</a></h3>
                    <h3><a href="<?php echo base_url();?>main/view/Children">Children</a></h3>
                    <h3><a href="<?php echo base_url();?>main/view/Lifestyle">Lifestyle</a></h3>                  
                </div>
            </div>
            <!--------------->
        </li>
        <li>
            <a href="#">My Cart</a>
            <div>
                <!--------------------------->
                <?php
                    $data['content'] = 'cart/view-cart.php';    
                    $this->load->view('view_content',$data);
                ?>
            </div>
        </li><li class="nav-search">       
            <form action="<?php echo base_url();?>main/view/Search" method="post">
                <input type="text" name="cari" placeholder="What books are you looking for?">
                <input type="submit" value="">
            </form>
        </li>
    </ul>
       </div>
       <!--END OF Dropdown menu dan search--> 
