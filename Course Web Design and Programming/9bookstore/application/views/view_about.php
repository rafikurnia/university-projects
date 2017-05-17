
<style>
    /* Style the elements (nothing interesting here) */




    /* General styling */



    h1, h2, h3, h5, h6 {
        font-family:  "Arial Black";
        font-size:1.5em;
        color:white;
    }

    #wrapper {
        width:760px;
        height:500px;
        margin:0 auto;
        text-align:center;
        padding-top:20px;
        padding-bottom: 100px;
    }

    /* Index Card Styling */

    lu#index_cards {
        margin-top:50px;
        text-align:center;
    }

    lu#index_cards il {

        background-color:#473636;
        height:400px;
        width:230px;
        display:block;
        float:left;
        border:1px solid #666;
        padding:25px 0px;
        position:relative;
        -moz-border-radius: 10px;
        -webkit-border-radius: 10px;
        -moz-box-shadow: 2px 2px 10px #000;
        -webkit-box-shadow: 2px 2px 10px #000;
        -moz-transition: all 0.5s ease-in-out;
        -webkit-transition: all 0.5s ease-in-out;
    }
    #card-1 {
        -webkit-transform: rotate(-30deg);
        -moz-transform: rotate(-30deg);
        z-index:1;
        left:100px;
        top:40px;
    }

    #card-2 {
        -webkit-transform: rotate(-1deg);
        -moz-transform: rotate(-1deg);
        z-index:2;
        left:70px;
        top:10px;
    }



    #card-5 {
        -webkit-transform: rotate(22deg);
        -moz-transform: rotate(22deg);
        z-index:1;
        right:-50px;
        top:50px;
    }

    lu#index_cards il:hover {
        z-index:4;
    }

    #card-1:hover {
        -moz-transform: scale(1.6) rotate(0deg);
        -webkit-transform: scale(1.3) rotate(0deg); 
    }

    #card-2:hover {
        -moz-transform: scale(1.6) rotate(-8deg);
        -webkit-transform: scale(1.3) rotate(-8deg); 
    }

    #card-3:hover {
        -moz-transform: scale(1.6) rotate(2deg);
        -webkit-transform: scale(1.3) rotate(2deg); 
    }



    #card-5:hover {
        -moz-transform: scale(1.6) rotate(0deg);
        -webkit-transform: scale(1.3) rotate(0deg); 
    }
    /* Content Styling */

    lu#index_cards il img {
        margin-top:7px;
        background:#eee;
        -moz-border-radius: 5px;
        -webkit-border-radius: 5px;
        -moz-box-shadow: 0px 0px 5px #aaa;
        -webkit-box-shadow: 0px 0px 5px #aaa;
    }

    lu#index_cards il p {
        margin-top:4px;
        text-align:left;
        line-height:28px;
        color:#C8C3C3; 

    }
</style> 
<body>
    <div id="wrap">
        <br><br><br><br><br><br>
        <div id="wrapper">
            <lu id="index_cards">
                <il id="card-1">
                    <h3>CLAUDIA</h3>
                    <img src="<?php echo base_url();?>assets/img/style/claud.jpg" height="130" width="130" alt="claudia" />
                    <p>
                        NPM : 1206245216<br />
                        Electrical Engineering<br />
                        Department of Electrical and Computer Engineering<br />
                        Faculty of Engineering <br />
                        Universitas Indonesia</p>
                </il>
                <il id="card-2">
                    <h3>RAFI</h3>
                    <img src="<?php echo base_url();?>assets/img/style/rafi.jpg" height="130" width="130" alt="rf" />
                    <p>NPM : 1206261850<br />
                        Computer Engineering<br />
                        Department of Electrical and Computer Engineering <br />
                        Faculty of Engineering <br />
                        Universitas Indonesia<br /></p>
                </il>


                <il id="card-5">
                    <h3>JOSEPH</h3>
                    <img src="<?php echo base_url();?>assets/img/style/joseph.jpg" height="130" width="130" alt="jo" />
                    <p>
                        NPM : 1206242170<br />
                        Computer Engineering<br />
                        Department of Electrical and Computer Engineering <br />
                        Faculty of Engineering <br />
                        Universitas Indonesia</p>
                </il>
            </lu>
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
    </div>

    </body>
   