<?php
include "db.php";

$sql = "INSERT INTO shadow_simulations
(height, latitude, longitude, sim_date, sim_time, shadow_length, direction, elevation, azimuth)
VALUES (2.0, 25.2048, 55.2708, '2026-01-06', '12:30', 3.5, 'N', 45, 180)";

if ($conn->query($sql) === TRUE) {
    echo "Test row inserted successfully!";
} else {
    echo "Error: " . $conn->error;
}

$conn->close();
?>
