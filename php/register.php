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
$password = htmlentities($_REQUEST["password"]);
$email = htmlentities($_REQUEST["email"]);
$fullname = htmlentities($_REQUEST["fullname"]);

// if GET or POST are empty
if (empty($username) || empty($password) || empty($email) || empty($fullname)){

    $returnArray["status"] = "400";
    $returnArray["message"] = "Missing required information";
    echo json_encode($returnArray);
    return;
}

// secure password
$salt = openssl_random_pseudo_bytes(20);
$secured_password = sha1($password . $salt);

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
$result = $access->registerUser($username, $secured_password, $salt, $email, $fullname);

if($result){
    $user = $access->selectUser($username);
    $returnArray["status"] = "200";
    $returnArray["message"] = "Successfully registered";
    $returnArray["id"] = $user["id"];
    $returnArray["username"] = $user["username"];
    $returnArray["fullname"] = $user["fullname"];

    // $actual_link = "http://$_SERVER[HTTP_HOST]$_SERVER[REQUEST_URI]"."activate.php?id=" . $current_id;
    // $toEmail = $email;
    // $subject = "User Registration Activation Email";
    // $content = "Click this link to activate your account. <a href='" . $actual_link . "'>" . $actual_link . "</a>";
    // $mailHeaders = "From: Admin\r\n";
    // if(mail($toEmail, $subject, $content, $mailHeaders)) {
    //     $message = "You have registered and the activation mail is sent to your email. Click the activation link to activate you account."; 
    // }
    // unset($_POST);


}else{
    $returnArray["status"] = "400";
    $returnArray["message"] = "Could not register with provided information";
}

// STEP 4. Close Connection
$access->disconnect();

//STEP 5. Json data
echo json_encode($returnArray);

?>