<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="utf-8">
        <title>Login Page</title> 
    </head>
    <style>
        body{
            background:#b4b4b4;
        }

        .tulisan
        {
            font-size:15px;
            font-family:Arial;
        }
        #registration-form {
            font-family:'Open Sans Condensed', sans-serif;
            width: 400px;
            min-width:250px;
            margin: 20px auto;
            position: relative;
        }

        #registration-form .fieldset {
            background-color:#CCCECC ;
            border-radius: 3px; 
        }

        #registration-form legend {
            text-align: center;
            background: #000000 ;
            width: 100%;
            padding: 30px 0;
            border-radius: 3px 3px 0 0;
            color: white;
            font-size:2em;
        }

        .fieldset form{
            border:1px solid #CCCECC;
            margin:0 auto;
            display:block;
            width:100%;
            padding:30px 20px;
            box-sizing:border-box;
            border-radius:0 0 3px 3px;
        }
        .placeholder #registration-form label {
            display: none;
        }
        .no-placeholder #registration-form label{
            margin-left:5px;
            position:relative;
            display:block;
            color:grey;
            text-shadow:0 1px white;
            font-weight:bold;
        }
        /* all */


        .no-placeholder #registration-form input[type=text] {
            padding: 10px 20px;
        }

        #registration-form input[type=text]:active, .placeholder #registration-form input[type=text]:focus {
            outline: none;
            border-color: silver;
            background-color:white;
        }

        #registration-form input[type=submit] {
            font-family:'Open Sans Condensed', sans-serif;
            text-transform:uppercase;
            outline:none;
            -webkit-box-sizing: border-box;
            -moz-box-sizing: border-box;
            -ms-box-sizing: border-box;
            box-sizing: border-box;
            width: 100%;
            background-color: #505150;
            padding: 10px;
            color: white;
            border: 1px solid #3498db;
            border-radius: 3px;
            font-size: 1.5em;
            font-weight: bold;
            margin-top: 5px;
            cursor: pointer;
            position:relative;
            top:0;     
        }

        #registration-form input[type=submit]:hover {
            background-color: #404140;
        }

        #registration-form input[type=submit]:active {
            background:#8C8D8C;
        }


        .parsley-error-list{
            background-color:#C34343;
            padding: 5px 11px;
            margin: 0;
            list-style: none;
            border-radius: 0 0 3px 3px;
            margin-top:-5px;
            margin-bottom:5px;
            color:white;
            border:1px solid #870d0d;
            border-top:none;
            -webkit-box-sizing: border-box;
            -moz-box-sizing: border-box;
            box-sizing: border-box;
            position:relative;
            top:-1px;
            text-shadow:0px 1px 1px #460909;
            font-weight:700;
            font-size:12px;
        }
        .parsley-error{
            border-color:#870d0d!important;
            border-bottom:none;
        }
        #registration-form select{
            width:100%;
            padding:5px;
        }
        ::-moz-focus-inner {
            border: 0;
        }
        /*======================================================*/
        .container{
            width: 420px;
            margin:50px auto 0;
            overflow: hidden;
            padding:5px;
        }

        .elem{
            width:30px;
            height:30px;
            margin:4px;
            background-color:#A0DFAC;
            float:left;
        }

        .elem span{
            position:absolute;
            top:5px;
            left:5px;
            right:5px;
            bottom:5px;
            border:2px solid #fff;
        }

        /* Selectors for matching the first letter and line: */

        p::first-letter{
            background-color: #666;
            color: #FFF;
            font-size: 24px;
            font-style:normal;
            display: inline-block;
            padding: 0 5px;
            border-radius: 3px;
            margin-right: 2px;
            font-family: serif;
        }

        p::first-line{
            font-size: 18px;
            text-transform: smallcaps;
            font-style: bold;
            text-decoration: underline;
            font-family: Arial;
        }


        /* Make the first and last elements purple */

        .elem:first-child,
        .elem:last-child{
            background-color:#948bd8;
        }

        /* Make every other element rounded */

        .elem:nth-child(odd){
            border-radius:50%;
        }

        /* Make the sixth element red */

        .elem:nth-child(6){
            background-color:#cb6364;
        }

        /* Style the element which contains the span */

        .elem:not(:empty){
            background-color:#444;
            position:relative;

            -webkit-transform:rotate(25deg);
            transform:rotate(25deg);

        }

        /* Target elements by attribute */

        .elem[data-foo=bar1]{
            background-color:#aaa;
        }

        .elem[data-foo=bar2]{
            background-color:#d7cb89;
        }

        /* The attribute value should start with bar. This matches both
        of the above elements */

        .elem[data-foo^=bar]{
            width: 16px;
            height: 16px;
            margin: 11px;
        }

        /* The element that follows after the one with data-foo="bar2" attribute */

        .elem[data-foo=bar2] + .elem{
            background-color:#78ccd2;
        }
        .tengahin{
            margin:0 0px 0px 100px;
        }
        .error{
            color:red;
            position:absolute;
            right:430px;
            top:120px;
            width:300px;
            font-size: 18px;
            text-transform: smallcaps;
            font-style: bold;
            text-decoration: underline;
            font-family: Arial;
        }
    </style>
    <script>
        function placeholderIsSupported() {
            test = document.createElement('input');
            return ('placeholder' in test);
        }

        $(document).ready(function(){
            placeholderSupport = placeholderIsSupported() ? 'placeholder' : 'no-placeholder';
            $('html').addClass(placeholderSupport);  
        });
    </script>
    <body>

        <div id="registration-form">
            <div class="fieldset">    
                <legend>Log In</legend>

                <?php

                    echo form_open('main/login_validation'); 

                    echo"<div class=\"error\">";
                    echo validation_errors();
                    echo"</div>";
                    echo"<center>";

                    $data = array(
                        'value'       => '',
                        'maxlength'   => '100',
                        'size'        => '50',
                        'style'       => 'width:100%','height:50%',
                    );
                    echo"<div class='tengahin'>";
                    echo "<p>Email<br>";
                    echo form_input('email',$this->input->post('email'));
                    echo "</p>";     

                    echo "<p>Password<br>";
                    echo form_password('password'); 
                    echo "</p>";          
                    echo"</div>"; 
                    echo "<p><br><br>";
                    echo form_submit('login_submit','Login');
                    echo "</p>";

                    echo form_close();

                ?>

                <div class="tulisan"><a href='<?php echo base_url()."main/signup";?>'>You don't have an account yet? Register here</a> </div>





            </div>	
        </div>
        <div class="container">
            <div class="elem"></div>
            <div class="elem"></div>
            <div class="elem"></div>
            <div class="elem"></div>
            <div class="elem"></div>
            <div class="elem"></div>
            <div class="elem"></div>
            <div class="elem"></div>
            <div class="elem"></div>
            <div class="elem"></div>
            <div class="elem"></div>
            <div class="elem"></div>
            <div class="elem"></div>
            <div class="elem"><span></span></div>
            <div class="elem"></div>
            <div class="elem"></div>
            <div class="elem"></div>
            <div class="elem" data-foo="bar1"></div>
            <div class="elem" data-foo="bar2"></div>
            <div class="elem"></div>
            <div class="elem"></div>
            <div class="elem"></div>

        </div>
    </body>
</html>