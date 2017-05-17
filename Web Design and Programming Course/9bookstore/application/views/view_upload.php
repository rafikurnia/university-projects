<br><br>
<div id="input">
    <?php echo $error;?>

    <?php echo form_open_multipart('main/upload_img');?>

    <input type="file" name="userfile" size="90" />

    <br /><br />

    <input type="hidden" name="name" value="<?php echo $name?>" />
    <input type="hidden" name="isbn" value="<?php echo $isbn?>" />
    <input type="hidden" name="isbn10" value="<?php echo $isbn10?>" />
    <input type="hidden" name="audience" value="<?php echo $audience?>" />
    <input type="hidden" name="format" value="<?php echo $format?>" />
    <input type="hidden" name="language" value="<?php echo $language?>" />
    <input type="hidden" name="pages" value="<?php echo $pages?>" />
    <input type="hidden" name="published" value="<?php echo $published?>" />
    <input type="hidden" name="dimensions" value="<?php echo $dimensions?>" />
    <input type="hidden" name="weight" value="<?php echo $weight?>" />
    <input type="hidden" name="genre" value="<?php echo $genre?>" />
    <input type="hidden" name="description" value="<?php echo $description?>" />
    <input type="hidden" name="price" value="<?php echo $price?>" />
    <input type="hidden" name="editing" value="<?php echo $editing?>" />
    <input type="hidden" name="image" value="<?php echo $image?>" />
    <input type="hidden" name="id" value="<?php echo $id?>" />
    <input type="submit" value="upload" />

    </form>
</div>
<br><br>