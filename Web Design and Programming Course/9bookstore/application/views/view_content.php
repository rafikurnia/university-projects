<div id="wrap">

    <h3>Your shopping cart</h3>
    <?php if(!$this->cart->contents()):
            echo "<h1>";
            echo '---Your cart is still empty---';
            echo "</h1>";
            else:
        ?>

        <?php echo form_open('main/update_cart'); ?>
        <table width="100%" cellpadding="0" cellspacing="0" align="right">
            <thead>
                <tr>
                    <td>Qty</td>
                    <td>Item Description</td>
                    <td>Item Price</td>
                    <td>Sub-Total</td>
                </tr>
            </thead>
            <tbody>
                <?php $i = 1; ?>
                <?php foreach($this->cart->contents() as $items): ?>
                    <?php echo form_hidden('rowid[]', $items['rowid']); ?>
                    <tr <?php if($i&1){ echo 'class="alt"'; }?> >    
                    <td>
                        <?php echo form_input(
                            array(
                                'name' => 'qty[]', 
                                'value' => $items['qty'],
                                'maxlength' => '3',
                                'size' => '5')); ?>
                    </td>
                    <td><?php echo $items['name']; ?></td>
                    <td>Rp. <?php echo $this->cart->format_number($items['price']); ?>,-</td>
                    <td>Rp. <?php echo $this->cart->format_number($items['subtotal']); ?>,-</td>
                </tr>

                <?php $i++; //Add 1 to $i ?>
                <?php endforeach; // End the foreach ?>
            <?php $total = $this->cart->format_number($this->cart->total()); // End the foreach ?>

            <tr>
                <td></td>
                <td></td>
                <td><strong>Total</strong></td>
                <td>Rp. <?php echo $this->cart->format_number($this->cart->total())?>,-</td>
            </tr>
        </tbody>
    </table>

    <?php 
        echo "<br>&nbsp;&nbsp;&nbsp;";
        echo form_submit('','Update Cart');
        echo form_close();
    ?>    
    <?php 
        echo "<br>";
        echo form_open('main/empty_cart');
        echo "&nbsp;&nbsp;&nbsp;"; 
        echo form_submit('','Empty Cart');
        echo form_close();
    ?>
    <?php 
        echo "<br>";
        echo form_open('main/buy');
            
        $data = array("total"  => "$total");
        echo form_hidden($data);
        echo "&nbsp;&nbsp;&nbsp;"; 
        echo form_submit('','CheckOut Cart');
        echo form_close();
    ?>





    <p><small>If the quantity is set to zero, the item will be removed from the cart.</small></p>

    <?php
        echo form_close();
        endif;
    ?>

</div>
 
</body>
</html>