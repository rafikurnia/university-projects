<div class="center_content">
    <div class="left_content">


        <div class="titleku">
            <?php          
                if ($title == "Best Selling") echo "<img src=\"".base_url()."assets/img/style/best-seller.gif\" width=\"80px\" height=\"80px\">".$title;      
                else echo "<img src=\"".base_url()."assets/img/style/blank.gif\" width=\"40px\" height=\"80px\">".$title;
            ?>       
            <div class="title"></div>
        </div>    
        <!---------------------------------------------------->
        <?php
            if ($error) echo "<center><h2>Sorry, no books from your search</h2></center>";

            $no = 0;
            $horizontal = -250;
            $vertical = 0;
            $geser = -100;
            $enable = 0;
            foreach($result as $row)
            {  
                $no++;

                if ($title == "Best Selling")
                {
                    if ($no>5) break;
                } 


                if($no==1)
                {
                    $vertical = 0;
                    $horizontal = 50;
                    $bawah=0;
                }
                if($no%5>=0&&$no!=1)
                {    
                    $vertical = -100;
                    $horizontal += 250;
                    $bawah =0;
                }  


                if($no%5==1&&$no!=1)
                {
                    $vertical = 500;
                    $horizontal = 50;
                    $bawah=0;
                }

                if (strlen($row->description)>100)
                {  
                    $desc=substr($row->description,0,100).'<br><br><i>Click View for More Detail</i>';
                }
                else
                {
                    $desc= $row->description;
                }
                echo 
                "
                <div style=\"margin: ".$vertical."px 50px ".$bawah."px ".$horizontal."px; padding:0px 0px 0px 0px;\">
                <div class=\"block\">
                <div class=\"product\">
                <img src=".base_url()."assets/img/books/".$row->image." width=\"50px\" height=\"180px\">
                <div class=\"buttons\">
                <a class=\"buy\"  id=".$row->id."  href=\"\">Add cart</a>
                <a class=\"preview\" href=\"#\">View</a>";
            ?>

            <?php

                if ($this->session->userdata('is_logged_in'))    
                {
                    if ($this->session->userdata('email') == "admin@9bookstore.com") echo "<a class=\"delete\"  id=".$row->id."  href=".base_url()."main/delete/".$row->id.">Delete</a>";
                }

                echo "

                </div>
                </div>

                <div class=\"info\">
                <h4>".$row->name."</h4>
                <span class=\"description\">
                ".$desc."
                </span>
                <span class=\"price\">Rp. ".$row->price."</span>                
                </div>";

                if ($this->session->userdata('is_logged_in'))    
                {
                    if ($this->session->userdata('email') == "admin@9bookstore.com") echo "<br><center><a class=\"lingedit\" href=".base_url()."main/editbook/".$row->id.">Edit</a></center>";
                }

                echo " <div class=\"details\">
                <ul class=\"rating\">
                <li class=\"rated\"></li>
                <li class=\"rated\"></li>
                <li class=\"rated\"></li>
                <li></li>
                <li></li>
                </ul>
                </div>
                </div>
                </div>
                ";
            }
        ?>
        <!----------------------->




        <div class="clear"></div>
    </div><!--end of left content-->






    <div class="clear"></div>
       </div><!--end of center content-->
       
              
