$(document).ready(function() {

    var link = "http://localhost/9bookstore/"

    $("a.buy").click(function() {
        
        
        var id = $(this).attr("id"); //mengambil dari class buy, tapi mendapat id buku secara spesifik 
        var qty = 1; 

       $.post(link + "main/add_cart_item", { product_id: id, quantity: qty, ajax: '1'},
            function(data){

                if(data == 'true'){
                    
                    alert("Item(s) added!");

                    $.get(link + "main/show_cart", function(cart){ 
                        $("#cart_content").html(cart);
                    });
                    location.reload();
                }
                else{
                    alert("Product does not exist");
                }

            });

        return false; // browser berhenti buka form
    });

    //view 
    $("a.preview").click(function(){

        var src = $(this).parent().prev().attr("src");

        $("#box img").attr("src", src);

        strEnd = src.length;
        strStart = 45;

        source = src.slice(strStart,strEnd); //untuk memotong dari url agar mendapat nama file gambarnya saja
        
        $.post(link + "main/book_view", { source: source }, //request info dari database, direturn dalam string
            function(data){

            page = $.parseHTML(data); //string dibuat html

            $("ul.books").html(page); //tambah ke page

        });


        $("#overlay").fadeIn();
        $("#box").fadeIn();

    });

    $("#overlay").click(function(){
        $("#overlay").fadeOut();
        $("#box").fadeOut();
    });

});