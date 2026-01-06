<?php
$host = "fdb1032.awardspace.net";
$user = "4718158_shamstrack";
$pass = "janamona2";
$db   = "4718158_shamstrack";
$port = 3306;

$conn = new mysqli($host, $user, $pass, $db, $port);

if ($conn->connect_error) {
    die("DB error: " . $conn->connect_error);
}
?>
