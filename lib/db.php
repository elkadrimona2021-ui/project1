<?php
$host = "localhost";
$user = "4718158_shamstrack";
$pass = "janamona2";
$db   = "4718158_shamstrack";

$conn = new mysqli($host, $user, $pass, $db);

if ($conn->connect_error) {
    http_response_code(500);
    echo "Database connection failed";
    exit;
}
?>
