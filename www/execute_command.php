<?php
/**
 * Created by IntelliJ IDEA.
 * User: Christian Everett
 * Date: 1/5/2016
 * Time: 12:31 AM
 */

//==========================================
//	CONNECT TO THE LOCAL DATABASE
//==========================================
$user_name = "root";
$pass_word = "root";
$database = "pidb";
$server = "127.0.0.1";

$connection = mysqli_connect($server, $user_name, $pass_word, $database);

if (!$connection)
    die("Database connection failed: " . mysqli_connect_error());


$command = $_GET['action'];

//if(!isset($_SESSION["role"]) || empty($_SESSION["role"]))
    //checkPermissions($connection);

//check user permissions
//if(strcmp($_SESSION["role"], "l") == 0 && $command > 2)
    //$command = 999;

/*
 * 1 = GET status of all devices
 * 2 = POST new device state
 * 3 =
 */
switch ($command)
{
    case 1:
        $queryResult = mysqli_query($connection, "SELECT * FROM states");

        while ($temp = mysqli_fetch_assoc($queryResult))
        {
            $data[] = $temp;
        }

        echo json_encode($data);
        break;
    case 2;
        mysqli_query($connection, "INSERT INTO actions VALUES('" . $_POST['command'] . "'," . $_POST['state'] . ")");
        break;
    case 3:

        break;

    default:
        http_response_code(400);
}

mysqli_close($connection);

function checkPermissions($connection)
{
    $queryResult = mysqli_query($connection, "SELECT role FROM login WHERE username = " . $_SESSION['username']);

    $array = mysqli_fetch_assoc($queryResult);

    $_SESSION["role"] = strtolower($array["role"]);
}
?>