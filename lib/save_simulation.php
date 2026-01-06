<?php
// Enable CORS for Flutter Web
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Methods: POST, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') exit(0);

// Include DB connection
include 'db.php';

// Read JSON input
$input = file_get_contents("php://input");
$data = json_decode($input, true);

if ($data === null) {
    http_response_code(400);
    echo json_encode([
        "status" => "error",
        "message" => "Invalid JSON"
    ]);
    exit;
}

// Prepare statement to avoid SQL injection
$stmt = $conn->prepare(
    "INSERT INTO simulations (height, latitude, longitude, date, time, shadowLength, direction, elevation, azimuth)
     VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)"
);

$stmt->bind_param(
    "dddddssss",
    $data['height'],
    $data['latitude'],
    $data['longitude'],
    $data['date'],
    $data['time'],
    $data['shadowLength'],
    $data['direction'],
    $data['elevation'],
    $data['azimuth']
);

if ($stmt->execute()) {
    echo json_encode(["status" => "success"]);
} else {
    http_response_code(500);
    echo json_encode([
        "status" => "error",
        "message" => $stmt->error
    ]);
}

$stmt->close();
$conn->close();
?>
