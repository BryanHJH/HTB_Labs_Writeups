<?php

$api_key = "UTM1NjM0MmRzJ2dmcTIzND0wMXJnZXdmc2RmCg";

try {
	$conn = pg_connect("host=localhost port=5432 dbname=users user=postgres password=iUer^vd(e1Pl9");
}

catch ( exception $e ) {
 	echo $e->getMessage();
}

?>
