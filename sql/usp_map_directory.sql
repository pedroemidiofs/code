/*    ==Parâmetros de Script==

    Versão do Servidor de Origem : SQL Server 2008 R2 (10.50.1600)
    Edição do Mecanismo de Banco de Dados de Origem : Microsoft SQL Server Standard Edition
    Tipo do Mecanismo de Banco de Dados de Origem : SQL Server Autônomo

    Versão do Servidor de Destino : SQL Server 2017
    Edição de Mecanismo de Banco de Dados de Destino : Microsoft SQL Server Standard Edition
    Tipo de Mecanismo de Banco de Dados de Destino : SQL Server Autônomo
*/

USE [Qualidade]
GO
/****** Object:  StoredProcedure [dbo].[usp_paytv_diretorio_audio]    Script Date: 16/09/2019 16:11:42 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Pedro Emidio de Freitas Silva
-- Create date: 28/08/2019
-- Description:	Importa o mapeamento dos diretorio de audio na tabela [Qualidade].dbo.paytv_audio
-- =============================================
ALTER PROCEDURE [dbo].[usp_paytv_diretorio_audio]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
SET NOCOUNT ON;

   -- Insert statements for procedure here

IF ( SELECT NAME FROM TEMPDB.SYS.TABLES WHERE NAME = '##paytv_audio') IS NOT NULL BEGIN DROP TABLE ##paytv_audio END                            
CREATE TABLE ##paytv_audio (caminho varchar(300))                          
                    
DECLARE 
@DATA VARCHAR(10)
, @MES VARCHAR(2)
, @DIA VARCHAR(2)
, @ANO VARCHAR(4) 
SET @DATA =  CONVERT(VARCHAR(10),GETDATE()-1,103)
SET @MES = SUBSTRING(@DATA,4,2)
SET @DIA = SUBSTRING(@DATA,1,2)
SET @ANO = SUBSTRING(@DATA,7,4)

DECLARE @PASTA VARCHAR(max) SET @PASTA = 'MASTER.SYS.XP_CMDSHELL ''dir \\10.100.0.xxx\xxxx\xxxx\xx\x\'+@ANO+'\'+@MES+'\'+@ANO+@MES+@DIA+' /b /s /B'''                      
           
INSERT INTO ##paytv_audio EXEC(@PASTA)

 insert into [Qualidade].dbo.paytv_audio
(caminho
,id_indice)
  select
   caminho
  ,substring(caminho,Char6+1,Char7-Char6-1)
  from (  select caminho
 ,CharIndex('_',caminho,CharIndex('_',caminho,CharIndex('_',caminho,CharIndex('\',caminho,CharIndex('\',caminho,58)+1)+1)+1)+1) as Char6
 ,CharIndex('_',caminho,CharIndex('_',caminho,CharIndex('_',caminho,CharIndex('_',caminho,CharIndex('\',caminho,CharIndex('\',caminho,58)+1)+1)+1)+1)+1) as Char7
 from
 ##paytv_audio
 where caminho like '%rent_paytv%'
 and caminho not like '%TELEFONIA-OPERADOR%'
 and caminho not like '%NAO-TABULADO%') as a
  where char6 > 0
 and char7> 0

END
