<br><br>

<div id="input">
    <?php       

        $this->load->helper("form");

        echo "<div id=\"error\">";
        echo validation_errors();
        echo "</div>";

        echo form_open("main/add");

        echo form_label("Name: ", "name");
        $data = array("name" => "name","id" => "name","value" => "$name");
        echo form_input($data);

        echo form_label("ISBN: ", "isbn");
        $data = array("name" => "isbn","id" => "isbn","value" => "$isbn");
        echo form_input($data);

        echo form_label("ISBN-10: ", "isbn10");
        $data = array("name" => "isbn10","id" => "isbn10","value" => "$isbn10");
        echo form_input($data);

        echo form_label("Audience: ", "audience");
        $data = array("name" => "audience","id" => "audience","value" => "$audience");
        echo form_input($data);

        echo form_label("Format: ", "format");
        $data = array("name" => "format","id" => "format","value" => "$format");
        echo form_input($data);

        echo form_label("Language: ", "language");
        $data = array("name" => "language","id" => "language","value" => "$language");
        echo form_input($data);

        echo form_label("Pages: ", "pages");
        $data = array("name" => "pages","id" => "pages","value" => "$pages");
        echo form_input($data);

        echo form_label("Published: ", "published");
        $data = array("name" => "published","id" => "published","value" => "$published");
        echo form_input($data);

        echo form_label("Dimensions: ", "dimensions");
        $data = array("name" => "dimensions","id" => "dimensions","value" => "$dimensions");
        echo form_input($data);

        echo form_label("Weight: ", "weight");
        $data = array("name" => "weight","id" => "weight","value" => "$weight");
        echo form_input($data);

        echo form_label("Genre: ", "genre");
        $data = array("name" => "genre","id" => "genre","value" => "$genre");
        echo form_input($data);

        echo form_label("Description: ", "description");
        $data = array("name" => "description","id" => "description","value" => "$description",'rows'=>'5','cols'=> '16');
        echo form_textarea($data);

        echo form_label("Price: ", "price");
        $data = array("name" => "price","id" => "price","value" => "$price");
        echo form_input($data);

        $data = array("editing"  => 0);
        echo form_hidden($data);

        echo "<br><br>";        
        echo "<center>".form_submit('submit','Add !')."</center>";

        echo form_close();


    ?>     
</div>
<br><br>   