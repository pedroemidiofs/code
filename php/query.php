<?php 

include "connect.php";

$sql = "SELECT getdate() as now"; 

$res = mssql_query($sql);
$dados = mssql_fetch_array($res);

$frase = $dados['now'];
echo $frase;

?>
