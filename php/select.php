<?php
/**
 * Created by PhpStorm.
 * User: apple
 * Date: 2017/5/31
 * Time: 下午10:42
 */

// STEP 1. Declare params of user info
// Secruing info and storing var

$username = htmlentities($_REQUEST["username"]);
$attributeName = htmlentities($_REQUEST["attributeName"]);

// if GET or POST are empty
if (empty($username) || empty($attributeName)){

    $returnArray["status"] = "400";
    $returnArray["message"] = "Missing username";
    echo json_encode($returnArray);
    return;
}

// STEP 2. Build connection
// Secure way to build conn
$file = parse_ini_file("./ini_file/minor_dianping.ini");

// store in php var inf from ini var
$host = trim($file["dbhost"]);
$user = trim($file["dbuser"]);
$pass = trim($file["dbpass"]);
$name = trim($file["dbname"]);

// include access.php to call func from access.php file
require("secure/access.php");
$access = new access($host, $user, $pass, $name);
$access->connect();

// STEP 3. Register user information
$result = $access->selectUserSpecificAttribute($username, $attributeName);

if($result){
    $user = $access->selectUser($username);
    $returnArray["status"] = "200";
    $returnArray["message"] = "Successfully selected";
    $returnArray["id"] = $user["id"];
    $returnArray["username"] = $user["username"];
    $returnArray[$attributeName] = $user[$attributeName];

}else{
    $returnArray["status"] = "400";
    $returnArray["message"] = "Could not find " . $username;
}

// STEP 4. Close Connection
$access->disconnect();

//STEP 5. Json data
echo json_encode($returnArray);
return json_decode($returnArray);

?>