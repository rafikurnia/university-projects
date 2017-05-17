
<style>
    /* Style the elements (nothing interesting here) */

    p{
        font-size: 16px;
        width: 420px;
        margin: 20px auto 0;
        text-align:center;
    }

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
        font-style: italic;
        text-decoration: underline;
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

    .cc{

        /* Set a counter named cnt to 0 */
        counter-reset: cnt;

        position:relative;
        text-align:center;
        padding:20px 0;
        width:420px;
        height: 160px;
        margin: 0 auto;
    }

    /* You can style pseudo elements and give them content,
    as if they were real elements on the page */

    .cc::before{
        display: block;
        font-size:18px;
        font-weight:bold;
        text-align:center;
        padding:50px;
    }

    .cc span{
        display:inline-block;
        padding:8px 13px;
        background-color:#666666;
        color:#186C72;
        border-radius:4px;
        margin:3px;
        cursor:default;
    }

    /* Create a counter with a pseudo element */

    .cc span::after{

        /* Every time this rule is executed, the 
        counter value is increased by 1 */
        counter-increment: cnt;

        /* Add the counter value as part of the content */


        display:inline-block;
        padding:4px;
    }

    /* Pseudo elements can even access attributes of their parent element */

    .cc span::before{
        position:absolute;
        bottom:0;
        left:0;
        width:100%;
        content:attr(data-title);
        color:#666;  
        font-size:16px;

        opacity:0;

        /* Animate the transitions */
        -webkit-transition:opacity 0.4s;
        transition:opacity 0.4s;
    }

    .cc span:hover::before{
        opacity:1;
    }

    .satu
    {
        margin:-40px 0 0 -300px;
    }
    .dua
    {
        margin:-20px 0 0 -1100px;
    }
    .tiga
    {
        margin:-260px 0 0 -700px;
    }
    .empat
    {
        margin:-275px 0 0 385px;
    }
</style>
<div id="wrap">
    <h2><center>9BookStore.com</h2><center><h2>EST 2014</h2></center>
    <div class="cc">  
        <div class="satu">
            <span data-title="claudia.khans@gmail.com"><a href="mailto:claudia.khans@gmail.com"><img src="<?php echo base_url();?>assets/img/style/claud.jpg"  alt="claud" height="155" width="155"></span></a>
        </div>  <div class="dua">
            <span data-title="rafi.kurnia@ui.ac.id"><a href="mailto:rafi.kurnia@ui.ac.id"><img src="<?php echo base_url();?>assets/img/style/rafi.jpg" alt="rafi" height="155" width="155"></span> </a>
        </div>  <div class="tiga">
            <span data-title="joseph.tobing@ui.ac.id"><a href="mailto:joseph.tobing@ui.ac.id"><img src="<?php echo base_url();?>assets/img/style/joseph.jpg" alt="jo" height="155" width="155"></span>  </a>
        </div>  
        <div class="empat">
            <span data-title="Kelompok 9!! 9BookStore Establisher :)"><img src="<?php echo base_url();?>assets/img/style/bareng.jpg" alt="bareng" height="250" width="427"></span>
        </div>  
    </div></div>
<div class="team1">



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
    