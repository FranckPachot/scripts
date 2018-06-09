&lt;?php
	$str_browser_language = !empty($_SERVER['HTTP_ACCEPT_LANGUAGE']) ? strtok(strip_tags($_SERVER['HTTP_ACCEPT_LANGUAGE']), ',') : '';
	$str_browser_language = !empty($_GET['language']) ? $_GET['language'] : $str_browser_language;
	switch (substr($str_browser_language, 0,2))
	{
		case 'de':
			$str_language = 'de';
			break;
		case 'en':
			$str_language = 'en';
			break;
		default:
			$str_language = 'en';
	}
    
	$arr_available_languages = array();
	$arr_available_languages[] = array('str_name' => 'English', 'str_token' => 'en');
	$arr_available_languages[] = array('str_name' => 'Deutsch', 'str_token' => 'de');
    
	$str_available_languages = (string) '';
	foreach ($arr_available_languages as $arr_language)
	{
		if ($arr_language['str_token'] !== $str_language)
		{
			$str_available_languages .= '&lt;a href="'.strip_tags($_SERVER['PHP_SELF']).'?language='.$arr_language['str_token'].'" lang="'.$arr_language['str_token'].'" xml:lang="'.$arr_language['str_token'].'" hreflang="'.$arr_language['str_token'].'">'.$arr_language['str_name'].'&lt;/a> | ';
		}
	}
	$str_available_languages = substr($str_available_languages, 0, -3);
?>

&lt;!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN"
"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
&lt;html xmlns="http://www.w3.org/1999/xhtml">
&lt;head lang="&lt;?php echo $str_language; ?>" xml:lang="&lt;?php echo $str_language; ?>">
&lt;meta http-equiv="content-type" content="text/html; charset=utf-8" />
&lt;title>MAMP PRO&lt;/title>
&lt;style type="text/css">
    body {
        font-family: Arial, Helvetica, sans-serif;
        font-size: .9em;
        color: #000000;
        background-color: #FFFFFF;
        margin: 0;
        padding: 10px 20px 20px 20px;
    }

    samp {
        font-size: 1.3em;
    }

    a {
        color: #000000;
        background-color: #FFFFFF;
    }

    sup a {
        text-decoration: none;
    }

    hr {
        margin-left: 90px;
        height: 1px;
        color: #000000;
        background-color: #000000;
        border: none;
    }

    #logo {
        margin-bottom: 10px;
        margin-left: 28px;
    }

    .text {
        width: 80%;
        margin-left: 90px;
        line-height: 140%;
    }
&lt;/style>
&lt;/head>

&lt;body>
    &lt;p>&lt;img src="MAMP-PRO-Logo.png" id="logo" alt="MAMP PRO Logo" width="250" height="49" />&lt;/p>

&lt;?php if ($str_language == 'de'): ?>

    &lt;p class="text">&lt;strong>Der virtuelle &lt;span lang="en" xml:lang="en">Host&lt;/span> wurde erfolgreich eingerichtet.&lt;/strong>&lt;/p>
    &lt;p class="text">Wenn Sie diese Seite sehen, dann bedeutet dies, dass der neue virtuelle &lt;span lang="en" xml:lang="en">Host&lt;/span> erfolgreich eingerichtet wurde. Sie können jetzt Ihren &lt;span lang="en" xml:lang="en">Web&lt;/span>-Inhalt hinzufügen, diese Platzhalter-Seite&lt;sup>&lt;a href="#footnote_1">1&lt;/a>&lt;/sup> sollten Sie ersetzen &lt;abbr title="beziehungsweise">bzw.&lt;/abbr> löschen.&lt;/p>
    &lt;p class="text">
        Server-Name: &lt;samp>&lt;?php echo $_SERVER['SERVER_NAME']; ?>&lt;/samp>&lt;br />
        Document-Root: &lt;samp>&lt;?php echo $_SERVER['DOCUMENT_ROOT']; ?>&lt;/samp>
    &lt;/p>
    &lt;p class="text" id="footnote_1">&lt;small>&lt;sup>1&lt;/sup> Dateien: &lt;samp>index.php&lt;/samp> und &lt;samp>MAMP-PRO-Logo.png&lt;/samp>&lt;/small>&lt;/p>
    &lt;hr />
    &lt;p class="text">This page in: &lt;?php echo $str_available_languages; ?>&lt;/p>

&lt;?php elseif ($str_language == 'en'): ?>

    &lt;p class="text">&lt;strong>The virtual host was set up successfully.&lt;/strong>&lt;/p>
    &lt;p class="text">If you can see this page, your new virtual host was set up successfully. Now, web content can be added and this placeholder page&lt;sup>&lt;a href="#footnote_1">1&lt;/a>&lt;/sup> should be replaced or deleted.&lt;/p>
    &lt;p class="text">
        Server name: &lt;samp>&lt;?php echo $_SERVER['SERVER_NAME']; ?>&lt;/samp>&lt;br />
        Document root: &lt;samp>&lt;?php echo $_SERVER['DOCUMENT_ROOT']; ?>&lt;/samp>
    &lt;/p>
    &lt;p class="text" id="footnote_1">&lt;small>&lt;sup>1&lt;/sup> Files: &lt;samp>index.php&lt;/samp> and &lt;samp>MAMP-PRO-Logo.png&lt;/samp>&lt;/small>&lt;/p>
    &lt;hr />
    &lt;p class="text">Diese Seite auf: &lt;?php echo $str_available_languages; ?>&lt;/p>

&lt;?php endif; ?>

&lt;?php
$user = 'openflights'; $password = '';
$db   = 'flightdb2';   $host = 'localhost'; $port = 3306;

$conn = mysqli_init();
if (!$conn) { 
	die("mysqli_init failed"); 
}
if (!$success = mysqli_real_connect( $conn, $host, $user, $password, $db, $port)) { 
	die("&#128544; Connection Error: " . mysqli_connect_error());
}
echo "&#128526; Connected to database &lt;b>$db&lt;/b> as user &lt;b>$user&lt;/b>.";
?>

&lt;p>
Here are the Airports:
 &lt;table border=1>
 &lt;tr>&lt;th>IATA&lt;/th>&lt;th>Name&lt;/th>&lt;/tr>

&lt;?php
$result = $conn->query("select iata,name from airports where country='Greenland' order by 2");
if ($result->num_rows > 0) {
    // output data of each row
    while($row = $result->fetch_assoc()) {
        echo "&lt;tr>&lt;td>" . $row["iata"]. "&lt;/td>&lt;td> " . $row["name"]. "&lt;/tr>";
    }
} else {
    echo "0 results";
}
mysqli_close($conn);
?>

 &lt;/table>






&lt;?php


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
echo "&#128526; Connected to database &lt;b>$db&lt;/b> as user &lt;b>$user&lt;/b>.";

$sql = "SELECT * FROM countries";
$result = $conn->query($sql);

?>
&lt;p>
Here are the countries:
 &lt;table border=1>
 &lt;tr>&lt;th>Country code&lt;/th>&lt;th>Country name&lt;/th>&lt;/tr>
&lt;?php

if ($result->num_rows > 0) {
    // output data of each row
    while($row = $result->fetch_assoc()) {
        echo "&lt;tr>&lt;td>" . $row["Country_Code"]. "&lt;/td>&lt;td> " . $row["Country_Name"]. "&lt;/tr>";
    }
} else {
    echo "0 results";
}

?>
 &lt;/table>
&lt;?php

mysqli_close($conn);


?>







&lt;/body>
&lt;/html>
