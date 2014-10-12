On Error Resume Next

Const wbemFlagReturnImmediately = &h10
Const wbemFlagForwardOnly = &h20

arrComputers = Array("127.0.0.1")
For Each strComputer In arrComputers
 

   Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\MicrosoftIISv2")
   Set colItems = objWMIService.ExecQuery("SELECT * FROM IIsApplicationPool", "WQL", _
                                          wbemFlagReturnImmediately + wbemFlagForwardOnly)

   For Each objItem In colItems

      WScript.Echo  objItem.Name

   Next
Next


Function WMIDateStringToDate(dtmDate)
WScript.Echo dtm: 
	WMIDateStringToDate = CDate(Mid(dtmDate, 5, 2) & "/" & _
	Mid(dtmDate, 7, 2) & "/" & Left(dtmDate, 4) _
	& " " & Mid (dtmDate, 9, 2) & ":" & Mid(dtmDate, 11, 2) & ":" & Mid(dtmDate,13, 2))
End Function