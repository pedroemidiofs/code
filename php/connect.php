<?php
    $conector = mssql_connect("10.100.0.xx", "login", "password") or die("N�O FOI POSS�VEL A CONEX�O COM O SERVIDOR");
    $conn = mssql_select_db("database", $conector) or die("N�O FOI POSS�VEL SELECIONAR O BANCO DE DADOS");
?>
