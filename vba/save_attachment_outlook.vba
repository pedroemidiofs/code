Private Sub Application_NewMailEx(ByVal EntryIDCollection As String)

 Dim arr() As String
 Dim item As MailItem
 
 arr = Split(EntryIDCollection, ",")
 If TypeOf Application.Session.GetItemFromID(arr(i)) Is MailItem Then
 Set item = Application.Session.GetItemFromID(arr(i))
 Call SalvarAnexo(item)
 End If


End Sub
Public Sub SalvarAnexo(item As MailItem)
  
  Dim Atmt As Attachment
  Dim FileName As String
  
  'Mude o caminho da pasta destino que os anexos serão salvos aqui.
  'Não se esqueça de colocar a última barra invertida
  Const sPasta As String = "M:\planejamento\MIS\Pedro_Emidio\ESTEIRA_BIN\ANALITICOS\"
  
  'Especifique abaixo a regra sobre o assunto do e-mail para que ele queria salvar anexos:
  If item.Subject Like "*Email com anexo*" Then
    For Each Atmt In item.Attachments
      'Especifique abaixo a regra sobre o nome do anexo para que o mesmo possa ser salvo:
      If Atmt.FileName Like "*anal*" Then
        FileName = sPasta & Format(item.CreationTime, "yyyymmdd_hhnnss_") & Atmt.FileName
        Atmt.SaveAsFile FileName
        MsgBox "Arquivo " & Atmt.FileName & " salvo no diretorio com sucesso!"
      End If
    Next Atmt
  End If
  
End Sub
