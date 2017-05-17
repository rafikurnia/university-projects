<?php
function hello_func($method_name, $params, $app_data)
{
	$name = $params[0];
	return "Hello $name.";
}

$xmlrpc_server=xmlrpc_server_create();
$registered=xmlrpc_server_register_method($xmlrpc_server, "hello", "hello_func" );

$request_xml = <<< END
<?xml version="1.0"?>
<methodCall>
    <methodName>hello</methodName>
      <params>
        <param>
          <value>
            <string>Deepak</string>
          </value>
        </param>
      </params>
</methodCall>
END;
$response=xmlrpc_server_call_method( $xmlrpc_server, $request_xml, '', array(output_type => "xml"));
print $response;
?>