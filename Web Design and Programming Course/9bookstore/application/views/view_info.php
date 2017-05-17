<div id="container">
    <?php
        if ($page == "Success") echo "<br><br><br><br><br><br><br><br><br><br><br><br><center><h2>Confirmation Email Has Been Sent to your Email, Please Check your Email to Activate 9bookstore Account</h2></center><br><br><br><br><br><br><br><br><br><br><br>";
        else if ($page == "Failure") echo "<br><br><br><br><br><br><br><br><br><br><br><br><center><h2>Confirmation Email Sending Failed</h2></center><br><br><br><br><br><br><br><br><br><br><br>";
            else if ($page == "Added") echo "<br><br><br><br><br><br><br><br><br><br><br><br><center><h2>The Book Was Successfully Added to The Database</h2></center><br><br><br><br><br><br><br><br><br><br><br>";
                else if ($page == "Edited") echo "<br><br><br><br><br><br><br><br><br><br><br><br><center><h2>The Book Was Successfully Edited</h2></center><br><br><br><br><br><br><br><br><br><br><br>";
                    else if ($page == "ErrorDatabase") echo "<br><br><br><br><br><br><br><br><br><br><br><br><center><h2>There Was a Problem when Adding to The Database</h2></center><br><br><br><br><br><br><br><br><br><br><br>";
                        else if ($page == "UserAddFailed") echo "<br><br><br><br><br><br><br><br><br><br><br><br><center><h2>Failed to Add User, Please Try Again</h2></center><br><br><br><br><br><br><br><br><br><br><br>";
                            else if ($page == "InvalidKey") echo "<br><br><br><br><br><br><br><br><br><br><br><br><center><h2>Sorry, That's an Invalid Key</h2></center><br><br><br><br><br><br><br><br><br><br><br>";
                                else if ($page == "Password Unchanged") echo "<br><br><br><br><br><br><br><br><br><br><br><br><center><h2>Password Has Failed to Change, Please Try Again</h2></center><br><br><br><br><br><br><br><br><br><br><br>";
                                    else if ($page == "Password Changed") 
                                    {
                                        echo "<br><br><br><br><br><br><br><br><br><br><br><br><center><h2>Password for ".$user." Has Been Updated Successfully<br>Please Log In Again to Continue</h2></center><br><br><br><br><br><br><br><br><br><br><br>";
                                        $this->session->sess_destroy();
                                    }   
                                    else if ($page == "login") echo "<br><br><br><br><br><br><br><br><br><br><br><br><center><h2>Sorry, Please Log In First Before Check Out your Cart</h2></center><br><br><br><br><br><br><br><br><br><br><br>";
                                        else if ($page == "checkout") 
                                        {
                                            $this->cart->destroy();
                                            echo "<br><br><br><br><br><br><br><br><br><br><br><br><center><h2>Thank You ".$user.", Rp.".$total." is Already Paid from Your Credit Card</h2></center><br><br><br><br><br><br><br><br><br><br><br>";                                   
                                        }
    ?>
</div>

