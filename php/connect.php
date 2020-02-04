<?php
    try {
        $hostname = "10.100.0.xxx";
        $dbname = "database";
        $username = "login";
        $pw = "password";
        $dbh = new PDO ("dblib:host=$hostname;dbname=$dbname","$username","$pw");
      } catch (PDOException $e) {
        echo "Erro de conexão: " . $e->getMessage() . "\n";
        exit;
      }
?>
