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

Func pomfload($sImagePath)
	Local $sUserAgent = 'User-Agent: AutoIT-pomfloader (v1.0 Stable) p-please dont ban'
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