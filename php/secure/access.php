<?php
/**
 * Created by PhpStorm.
 * User: apple
 * Date: 2017/5/31
 * Time: 下午10:18
 */
// Declare class to access to this php file
class access {

    // connection global variables
    var $host = null;
    var $user = null;
    var $pass = null;
    var $name = null;
    var $conn = null;
    var $result = null;

    // constructing class
    function __construct($dbhost, $dbuser, $dbpass, $dbname){

        $this->host = $dbhost;
        $this->user = $dbuser;
        $this->pass = $dbpass;
        $this->name = $dbname;

    }

    // connection function
    public function connect(){

        // establish connection and store it in $conn
        $this->conn = new mysqli($this->host, $this->user, $this->pass, $this->name);

        if(mysqli_connect_errno()) {
            die("Could not connect to database");
        }

        // support all languages
        $this->conn->set_charset("utf8");

    }

    // disconnection function
    public function disconnect(){

        if($this->conn != null){
            $this->conn->close();
        }

    }

    // Insert user
    public function registerUser($username, $password, $salt, $email, $fullname){
        // sql command
        $sql = "INSERT INTO users (username, password, salt, email, fullname) VALUES (?, ?, ?, ?, ?)";

        // store query result in $statement
        $statement = $this->conn->prepare($sql);

        // if error
        if(!$statement){
            throw new Exception($statement->error);
        }

        // bind 5 param of type string to be placed in $sql command
        $statement->bind_param("sssss", $username, $password, $salt, $email, $fullname);

        $returnValue = $statement->execute();
        $statement->close();
        return $returnValue;
    }

    public function selectUser($username){
        $returnArray = null;
        // sql command
        $sql = "SELECT * FROM users WHERE username='".$username."'";

        // assign result we got from $sql to $result var
        $result = $this->conn->query($sql);
        if($result != null && (mysqli_num_rows($result) >= 1)){
            echo "into";
            // assign results we got to $row as associative array
            $row = $result->fetch_array(MYSQLI_ASSOC);
            echo "row" . $row["id"];
            if(!empty($row)){
                $returnArray = $row;
            }
        }
        return $returnArray;
    }
}

?>