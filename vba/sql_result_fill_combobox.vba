Public Sub PegaAudio()

Dim audios As Variant
Dim cn_excel As ADODB.Connection
Set cn_excel = New ADODB.Connection
Dim strConn As String
Dim txt, audio As String
Dim r, c As Integer

cn_excel.CommandTimeout = 1500
cn_excel.ConnectionTimeout = 1500

strConn = "PROVIDER=SQLOLEDB;"
strConn = strConn & "Provider=SQLOLEDB.1;Password=password;Persist Security Info=True;User ID=login;Initial Catalog=database;Data Source=10.100.0.xxx"
cn_excel.Open strConn

Dim rsPubs As ADODB.Recordset
Set rsPubs = New ADODB.Recordset
Dim extrator, extrator2, extrator3 As String

audio = formulario.TextBox1.Value
extrator = "select caminho from [database].[dbo].[table] where id_indice = '" & audio & "' order by 1"

extrator3 = " update tb1 set tb1.status_importacao = 'SEM AUDIO',tb1.inicio_monitoria = getdate()" & _
"from [database].[dbo].[table2] as tb1 where id_indice = '" & audio & "'"

With rsPubs
.ActiveConnection = cn_excel
.Open extrator

If rsPubs.EOF Then
MsgBox ("Audio não localizado!")
.Close
.Open extrator3
'.Close
formulario.ComboBox1.Clear
Application.Run "Módulo3.LimparFicha"
Application.Run "Módulo1.Pendente"
Application.Run "Módulo2.Monitorar"

Else

audios = rsPubs.GetRows
.Close
For r = LBound(audios, 2) To UBound(audios, 2)
    For c = LBound(audios, 1) To UBound(audios, 1)
        txt = "" & audios(c, r)
         formulario.ComboBox1.AddItem txt
    Next c
Next r

End If

End With
