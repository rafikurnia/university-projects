<style type="text/css">

  .isiv{
   background-color: 
  }

 .gisir{
 position:absolute;
 float:right; 
 width:0px;
 margin-left:225px;
 min-width:320px;
    }

.tg{
    font-weight: bold;
}

</style>

  <div class="isiv">
<?php foreach($info as $row): ?></div>
    <div class="gisir">
    <ul class="books">
      
        <li><div class="tg">Book Title :</div>
            <?php echo $row->name; ?>
        </li>
        <li><div class="tg">ISBN :</div>
            <?php echo $row->isbn; ?>
        </li>
        <li><div class="tg">Genre :</div>
            <?php echo $row->genre; ?>
        </li>
        <li><div class="tg">Audience :</div>
            <?php echo $row->audience; ?>
        </li>
        <li><div class="tg">Published :</div>
            <?php echo $row->published; ?>
        </li>
        <li><div class="tg">PRICE : Rp
            <?php echo $row->price; ?></div>
        </li>
        <li><div class="tg">Format :</div>
            <?php echo $row->format; ?>
        </li>
        <li><div class="tg">Synopsis :</div>
            <?php echo $row->description; ?>
        </li>
        <?php endforeach;?>
		</ul>
        </div>
