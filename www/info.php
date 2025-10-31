<?php
echo "<h1>Hola desde PHP</h1>";
echo "<hr>";
echo "<h3>Datos empleados PostgreSQL</h3>";

$host = "192.168.56.11"; // IP de la máquina db
$dbname = "exampledb";
$user = "vagrant";
$password = "vagrant";

$conn = pg_connect("host=$host dbname=$dbname user=$user password=$password");

if (!$conn) {
  die("<p style='color:red;'> Error al conectar a la base de datos.</p>");
}

echo "<p style='color:green;'>Conexión exitosa a PostgreSQL</p>";

// Intentar consultar datos
$query = "SELECT * FROM empleados";
$result = pg_query($conn, $query);

if (!$result) {
  die("<p style='color:red;'> Error en la consulta: " . pg_last_error($conn) . "</p>");
}

echo "<table border='1' cellpadding='5' cellspacing='0'>";
echo "<tr><th>ID</th><th>Nombre</th><th>Cargo</th></tr>";

while ($row = pg_fetch_assoc($result)) {
  echo "<tr>";
  echo "<td>" . htmlspecialchars($row['id']) . "</td>";
  echo "<td>" . htmlspecialchars($row['nombre']) . "</td>";
  echo "<td>" . htmlspecialchars($row['cargo']) . "</td>";
  echo "</tr>";
}

echo "</table>";

pg_close($conn);
?>
