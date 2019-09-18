/*    ==Parâmetros de Script==

    Versão do Servidor de Origem : SQL Server 2008 R2 (10.50.1600)
    Edição do Mecanismo de Banco de Dados de Origem : Microsoft SQL Server Standard Edition
    Tipo do Mecanismo de Banco de Dados de Origem : SQL Server Autônomo

    Versão do Servidor de Destino : SQL Server 2017
    Edição de Mecanismo de Banco de Dados de Destino : Microsoft SQL Server Standard Edition
    Tipo de Mecanismo de Banco de Dados de Destino : SQL Server Autônomo
*/

USE [Esteira]
GO
/****** Object:  StoredProcedure [dbo].[USP_IMPORTAR_IN_OS_BASE_NOVO]    Script Date: 18/09/2019 17:12:41 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER  PROCEDURE [dbo].[USP_IMPORTAR_IN_OS_BASE_NOVO]                       
              
AS               
              
BEGIN               
     
/*¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨¨
' [PROCEDURE]
'   NAME........: [ATUALIZA_IN_NOVO_TESTE] 
'   DESCRIPTION.: IMPORTA AS VENDAS ATIVADAS 
'   AUTHOR......: Pedro Emidio de Freitas Silva
'   COMMENTARIES:
'      
' [UPDATES]
'   DATE/TIME      AUTHOR               DESCRIPTION
'   ============== ==================== ==========================================================*/


IF ( SELECT NAME FROM TEMPDB.SYS.TABLES WHERE NAME = '##IN_NOVO') IS NOT NULL BEGIN DROP TABLE ##IN_NOVO END                            
CREATE TABLE ##IN_NOVO ( MAILING VARCHAR(150), CONTADOR INT Identity )                          
                    
                      
DECLARE @PASTA VARCHAR(max) SET @PASTA = 'MASTER.SYS.XP_CMDSHELL ''DIR \\server-x\xxxx\xxxx /B'''                      
           
--INSERE OS ARQUIVOS                           
INSERT INTO ##IN_NOVO  EXEC(@PASTA)          

--DELETA OS ARQUIVOS DIFERENTES               
DELETE  FROM ##IN_NOVO WHERE  MAILING NOT LIKE '%IN_NOVO%' AND MAILING NOT LIKE '%CBO_OS_CHIP%'     
DELETE  FROM ##IN_NOVO WHERE  MAILING IS NULL                
--select * from ##IN_NOVO
DELETE   

##IN_NOVO WHERE MAILING COLLATE DATABASE_DEFAULT IN (SELECT MAILING FROM HISTORICO_MAILING_IN_NET)      
 AND ISNUMERIC(LEFT(MAILING,8))=1  
 AND MAILING NOT LIKE '%CBO_OS_CHIP%'
 --SELECT * FROM  ##IN_NOVO
-- VERIFICA SE TEM MAILING NOVO 'IN'                        
DECLARE @MAILING_IN VARCHAR(200); SET @MAILING_IN = ( SELECT TOP 1 MAX(MAILING) FROM  ##IN_NOVO WHERE MAILING LIKE '%IN_NOVO%' AND DATEDIFF(M,CONVERT(VARCHAR(10),CONVERT(DATETIME,LEFT(MAILING,8),112),112),GETDATE()) IN (1,0) AND DATEDIFF(M,CONVERT(VARCHAR
(10),CONVERT(DATETIME,LEFT(MAILING,8),112),112),GETDATE()) in (0,1)) PRINT @MAILING_IN                          
       
-- SE TIVER MAILING DISPONÍVEL IMPORTA!!!
IF (SELECT COUNT(@MAILING_IN) )  = 1                          
                          
BEGIN       
                    
IF OBJECT_ID ('IN_NOVO') IS NOT NULL BEGIN DROP TABLE IN_NOVO END                           
--CRIA A TABELA IN_NOVO                       
CREATE TABLE [dbo].[IN_NOVO](                          
 [CD_OPERADORA] [nvarchar](max) NULL,                          
 [NM_CIDADE] [nvarchar](max) NULL,                          
 [UF] [nvarchar](max) NULL,                          
 [TIPO] [nvarchar](max) NULL,                          
 [DATA_BASE] [nvarchar](max) NULL,                          
 [DD] [nvarchar](max) NULL,                          
 [CD_NET] [nvarchar](max) NULL,                          
 [CPF_CNPJ_ASSINANTE] [nvarchar](max) NULL,                          
 [LOGIN_CADASTRO] [nvarchar](max) NULL,                          
 [FRANQUIA] [nvarchar](max) NULL,                          
 [INDICADOR_DESCR_PADRONIZADO] [nvarchar](max) NULL,                          
 [NM_CANAL_VENDA_SUBGRUPO] [nvarchar](max) NULL,                          
 [NOME_EMPRESA] [nvarchar](max) NULL,                          
 [NOME_VENDEDOR] [nvarchar](300) NULL,                          
 [CPF_CNPJ_VENDEDOR] [nvarchar](max) NULL,                          
 [EQUIPE_VENDA] [nvarchar](max) NULL,                          
 [PERFIL] [nvarchar](max) NULL,                          
 [FORMA_PGTO] [nvarchar](max) NULL,                          
 [SEGPTO] [nvarchar](max) NULL,                          
 [TP_CLASSE_SOCIAL] [nvarchar](max) NULL,                          
 [COMBINACAO] [nvarchar](max) NULL,                          
 [NM_REGIONAL] [nvarchar](max) NULL,                          
 [NM_GRUPO] [nvarchar](max) NULL,                          
 [NM_CLUSTER] [nvarchar](max) NULL,                         
 [NM_SUBCLUSTER] [nvarchar](max) NULL,                          
 [NM_AREA_GEO] [nvarchar](max) NULL,                          
 [NOVO_CANAL_VENDA_GRUPO] [nvarchar](max) NULL,                          
 [PRODUTO_MULTI_NET] [nvarchar](max) NULL,                          
 [DESCRICAO] [nvarchar](max) NULL,                          
 [FG_ATIVACAO_CLARO] [nvarchar](max) NULL,                          
 [DATA_ATIVACAO] [nvarchar](max) NULL,             
 [FLAG_PORTABILIDADE] [nvarchar](max) NULL,                          
 [DH_ENTRADA_CLARO] [nvarchar](max) NULL,                          
 [PRODUTO_MULTI_CLARO] [nvarchar](max) NULL,                          
 [E_CLIENTE_BASE_CLARO] [nvarchar](max) NULL,                          
 [VENDA_APARELHO] [nvarchar](max) NULL,                          
 [TOTAL] [nvarchar](max) NULL,                          
 [TOTAL_MOVEL] [nvarchar](max) NULL,                          
 [TOTAL_VOZ] [nvarchar](max) NULL,                          
 [TOTAL_DADOS] [nvarchar](max) NULL,                          
 [TOTAL_VOZ_DEP] [nvarchar](max) NULL,                          
 [TOTAL_DADOS_DEP] [nvarchar](max) NULL,                          
 [TOTAL_VOZ_TT] [nvarchar](max) NULL,                    
 [TOTAL_DADOS_TT] [nvarchar](max) NULL,     
 [FG_AV_VPL] [nvarchar](max) NULL,   
 [PRODUTO_BACKEND] [nvarchar](max) NULL,   
 [DH_CADASTRO] [nvarchar](max) NULL,   
 [DH_HISTORICO] [nvarchar](max) NULL   
                     
) ON [PRIMARY]                          
    
--===================== SUBIR MAIS DE UM ARQUIV ========================   
             
 DECLARE @I INT,@F INT,@CMD2 VARCHAR(2000)    
 SET @I = (SELECT MIN(CONTADOR) FROM ##IN_NOVO)    
 SET @F = (SELECT MAX(CONTADOR) FROM ##IN_NOVO)    
 WHILE @I <= @F    
 BEGIN      
 SET @CMD2 = '                          
 BULK INSERT DBO.[IN_NOVO] FROM                           
 ''\\server-x\xxxx\xxxx''                          
 WITH( FIRSTROW = 2, CODEPAGE = ''1252'', ROWTERMINATOR = ''\n'',fieldTERMINATOR = ''\t''   )   '      
    
 SET @I = @I + 1     
 EXECUTE(@CMD2)                        
 END    
 
END
