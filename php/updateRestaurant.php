<?php
/**
 * Created by PhpStorm.
 * User: apple
 * Date: 2017/5/31
 * Time: 下午10:42
 */

// STEP 1. Declare params of user info
// Secruing info and storing var

$resName = htmlentities($_REQUEST["name"]);
$attributeName = htmlentities($_REQUEST["attributeName"]);
$attributeValue = htmlentities($_REQUEST["attributeValue"]);

// if GET or POST are empty
if (empty($resName) || empty($attributeName) || empty($attributeValue)){

    $returnArray["status"] = "400";
    $returnArray["message"] = "Missing required information";
    echo json_encode($returnArray);
    return;
}

// secure password
if(strcmp($attributeName, "password") == 0){
    $salt = openssl_random_pseudo_bytes(20);
    $secured_password = sha1($attributeValue . $salt);
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
    $result = $access->updateRestaurant($resName, $attributeName, $attributeValue);

    if($result){
        $res = $access->selectRestaurant($resName);
        $returnArray["status"] = "200";
        $returnArray["message"] = "Successfully updated";
        $returnArray["id"] = $res["id"];
        $returnArray["name"] = $res["name"];
        $returnArray[$attributeName] = $res[$attributeName];
    }else{
        $returnArray["status"] = "400";
        $returnArray["message"] = "Could not update with provided information";
    }
// STEP 4. Close Connection
$access->disconnect();

//STEP 5. Json data
echo json_encode($returnArray);

?>
