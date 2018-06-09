<html>
	<head>
		<title>
			My simple query on COUNTRIES
		</title>
	</head>

	<body>

	<?php
		$user = 'root';
		$password = 'root';
		$db = 'test';
		$host = 'localhost';
		$port = 3306;

		$conn = mysqli_init();
		if (!$conn) { 
			die("mysqli_init failed"); 
		}
		if (!$success = mysqli_real_connect( $conn, $host, $user, $password, $db, $port)) { 
			die("&#128544; Connect Error: " . mysqli_connect_error());
		}
		echo "&#128526; Connected to database <b>$db</b> as user <b>$user</b>.";

		$sql = "SELECT * FROM countries";
		$result = $conn->query($sql);
	?>

	<p>
	Here are the countries:
	<table border=1>
	<tr><th>Country code</th><th>Country name</th></tr>

	<?php
		if ($result->num_rows > 0) {
		    // output data of each row
		    while($row = $result->fetch_assoc()) {
			echo "<tr><td>" . $row["Country_Code"]. "</td><td> " . $row["Country_Name"]. "</tr>";
		    }
		} else {
		    echo "(0 results)";
		}
	?>

	</table>

	<?php
		mysqli_close($conn);
	?>

	</body>
</html>
