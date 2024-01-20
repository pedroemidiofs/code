<?php

    $opcao = $_GET['opcao'];

    // echo $opcao;

    switch($opcao){

        case 'entrar':

            // echo 'entrando';

            $senha = $_GET['senha'];

            $campanha = $_GET['campanha'];

            if($senha != '1234'){
                echo 'Senha incorreta!';
            }
            else{
                include "connect.php";

                $qtdanalista = "select count(distinct login_tratativa) as qtd ".
                " from ".
                " ".$campanha."_tabela ".
                " where status_importacao in ('AGUARDANDO MONITORIA','EM TRATAMENTO')";

                $qtd = $dbh->prepare($qtdanalista); 

                $qtd->execute();

                $valida = $qtd->fetch();

                if($valida[0] == '0'){
                    echo 'Não ha monitorias na fila dos analistas';
                }
                else{

                    $script = utf8_decode(" select distinct b.Nome from  [Qualidade].[dbo].[".$campanha."_tabela] as a join ".
                    " (SELECT  ".
                    " [Nome] ".
                    " ,Usuário ".
                    " FROM [Planejamento].[dbo].[dimensionamento] ".
                    " where nome is not null ".
                    " and Usuário is not null) as b  ".
                    " on a.login_tratativa = b.Usuário ".
                    " where login_tratativa is not  ".
                    " null and status_importacao in ('EM TRATAMENTO','AGUARDANDO MONITORIA')");

                    $sql = $dbh->prepare($script); 

                    $sql->execute();

                    echo '<br>Selecione o login do analista que deseja limpar a fila:<br><br><select id="opcaoAnalista">';

                    while($dados = $sql->fetch()){

                        echo "<option value='",  utf8_encode($dados[0]), "'>",  utf8_encode($dados[0]), "</option>";
                    }

                    echo '</select><br><br><button id="btnLimpaFila">Limpar Fila</button>';

                }

            }

        break;

        case 'limpa':

            $campanha = $_GET['campanha'];

            $analista = $_GET['analista'];

            include "connect.php";

            $script2 = utf8_decode("update a  ".
            " set a.status_importacao = null  ".
            " ,a.inicio_monitoria = null  ".
            " ,a.fim_monitoria = null  ".
            " ,a.login_tratativa = null  ".
            " ,a.obs = null   ".
            " ,a.erro_auditoria_ura = null  ".
            " ,a.obs_auditoria_ura = null  ".
            " ,a.medida = null  ".
            " ,a.operador = null  ".
            " ,a.nota = null  ".
            " ,a.nota_real = null  ".
            " ,a.status_monitoria = null  ".
            " ,a.tipificacao = null  ".
            " ,a.status_monitoria_super = null  ".
            " ,a.obs_feedback = null  ".
            " ,a.num_contest = null  ".
            " ,a.ficha = null  ".
            " ,a.versao = null  ".
            " from  ".
            " ".$campanha."_tabela as a  ".
            " join [Planejamento].[dbo].[dimensionamento] as b  ".
            " on a.login_tratativa = b.Usuário  ".
            " where b.Nome = '".$analista."'  ".
            " and status_importacao in ('AGUARDANDO MONITORIA','EM TRATAMENTO')");

            $sql2 = $dbh->prepare($script2); 
            //$campanha = $_POST['campanha'];

            $sql2->execute();

            echo 'Fila limpa!';

        break;

    }

?>
