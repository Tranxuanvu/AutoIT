#include-once
#include <ScreenCapture.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <WinHTTP.au3>
#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.11.0 (Beta)
 Author:	subnet-

 Script Function:
	pomf client functions

#ce ----------------------------------------------------------------------------

Func Screenshot_png()
    Local $hBmp = _ScreenCapture_Capture("",0,0,-1,-1,False)
    _ScreenCapture_SaveImage(@TempDir & "\pomf.png", $hBmp)
	_WinAPI_DeleteObject($hBmp)
EndFunc


Func Screenshot_window_png()
	If (WinGetState("[ACTIVE]","[ACTIVE]") == 47) then Return Screenshot_png()
    Local $hBmp = _ScreenCapture_CaptureWnd("",WinGetHandle("[ACTIVE]","[ACTIVE]"),0,0,-1,-1,False)
    _ScreenCapture_SaveImage(@TempDir & "\pomf.png", $hBmp)
	_WinAPI_DeleteObject($hBmp)
EndFunc

Func pomfGUI()
	Local $GUI = GUICreate("Pomf Client",197,120,-1,-1,$WS_SYSMENU,$WS_EX_TOPMOST)
	GUICtrlCreateLabel("Image Saved",0,10,197,20,$SS_CENTER)
	Local $upload = GUICtrlCreateButton("Upload",10,35,80,20)
	Local $save = GUICtrlCreateButton("Save",100,35,80,20)
	Local $saveup = GUICtrlCreateButton("Save+Upload",10,62,80,20)
	Local $view = GUICtrlCreateButton("View",100,62,80,20)
	GUISetState(@SW_SHOW)

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				GUIDelete($GUI)
				FileDelete(@TempDir & "\pomf.png")
				Return 0
			Case $upload
				GUIDelete($GUI)
				pomfload(@TempDir & "\pomf.png")
				FileDelete(@TempDir & "\pomf.png")
				Return 1
			Case $save
				$path = FileSaveDialog("Save Image","","Picture (*.png)",18,@YEAR&"."&@MON&"."&@MDAY&" - "&@HOUR&"."&@MIN&"."&@SEC&".png",$GUI)
				If @error Then Return
				GUIDelete($GUI)
				FileMove(@TempDir & "\pomf.png",$path,1)
				Return 2
			Case $saveup
				$path = FileSaveDialog("Save Image","","Picture (*.png)",18,@YEAR&"."&@MON&"."&@MDAY&" - "&@HOUR&"."&@MIN&"."&@SEC&".png",$GUI)
				If @error Then Return
				GUIDelete($GUI)
				pomfload(@TempDir & "\pomf.png")
				FileMove(@TempDir & "\pomf.png",$path,1)
				Return 3
			Case $view
				ShellExecute(@TempDir & "\pomf.png")
		EndSwitch
	WEnd
EndFunc

Func pomfload($sImagePath)
	Local $sUserAgent = 'User-Agent: AutoIT-pomfloader (v. 0.1 alpha) p-please dont ban'
	Local $hSession = _WinHttpOpen($sUserAgent)
	Local $hConnect = _WinHttpConnect($hSession, 'pomf.se')

	Local $iBoundary = Random(13,37)
	Local $bFileContent = FileRead($sImagePath)
	Local $sHeaders = 'Content-Type: multipart/form-data; boundary=---------------------------' & $iBoundary

	Local $sSend = @CRLF
	$sSend &= '-----------------------------' & $iBoundary & @CRLF
	$sSend &= 'Content-Disposition: form-data; name="files[]"; filename="' & StringRegExpReplace($sImagePath, '.+\\', '') & '"' & @CRLF
	$sSend &= 'Content-Type: application/octet-stream' & @CRLF
	$sSend &= @CRLF
	$sSend &= $bFileContent & @CRLF
	$sSend &= '-----------------------------' & $iBoundary & '--' ;& @CRLF

	ToolTip(@lf,(@DesktopWidth-162),(@DesktopHeight-51),"Uploading to pomf.se...",1)
	Local $sResponse = _WinHttpSimpleRequest($hConnect, 'POST', '/upload.php', '', $sSend, $sHeaders)
	ToolTip("")
	Local $aRegExp = StringRegExp($sResponse, '"url":"(.+?)"', 3)
	If IsArray($aRegExp) Then
		InputBox("Success"," ","http://a.pomf.se/"&$aRegExp[0],"",200,100)
		If (@error = 0) Then ShellExecute("http://a.pomf.se/"&$aRegExp[0])
	EndIf
	_WinHttpCloseHandle($hConnect)
	_WinHttpCloseHandle($hSession)
EndFunc   ;==>upload