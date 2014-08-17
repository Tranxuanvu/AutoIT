#include-once
#include <ScreenCapture.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <Memory.au3>
#include <WinHTTP.au3>
#include <GDIPlus.au3>
#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.11.0 (Beta)
 Author:	subnet-

 Script Function:
	pomf client functions

#ce ----------------------------------------------------------------------------

Func Screenshot_png()
	_GDIPlus_Startup()

	Local $hBmp = _ScreenCapture_Capture("",0,0,-1,-1,False)
	Local $hBitmap = _GDIPlus_BitmapCreateFromHBITMAP($hBmp)
	_WinAPI_DeleteObject($hBmp)

	Local $sEncoderCLSID = _GDIPlus_EncodersGetCLSID("jpg")
	Local $tEncoderCLSID = _WinAPI_GUIDFromString($sEncoderCLSID)
	Local $pEncoderCLSID = DllStructGetPtr($tEncoderCLSID)
	Local $pStream = _WinAPI_CreateStreamOnHGlobal(0)
	_GDIPlus_ImageSaveToStream($hBitmap, $pStream, $pEncoderCLSID)
	_GDIPlus_BitmapDispose($hBitmap)

	Local $hMem = _WinAPI_GetHGlobalFromStream($pStream)
	Local $iSize = _MemGlobalSize($hMem)
	Local $pMem = _MemGlobalLock($hMem)
	Local $tData = DllStructCreate("byte[" & $iSize & "]", $pMem)
	Local $xData = DllStructGetData($tData, 1) ;JPG file in binary format

	_MemGlobalFree($hMem)
	Return BinaryToString($xData)
EndFunc


Func Screenshot_window_png()
	If (WinGetState("[ACTIVE]","[ACTIVE]") == 47) then Return Screenshot_png()
   _GDIPlus_Startup()

	Local $hBmp = _ScreenCapture_CaptureWnD("",WinGetHandle("[ACTIVE]","[ACTIVE]"),0,0,-1,-1,False)
	Local $hBitmap = _GDIPlus_BitmapCreateFromHBITMAP($hBmp)
	_WinAPI_DeleteObject($hBmp)

	Local $sEncoderCLSID = _GDIPlus_EncodersGetCLSID("jpg")
	Local $tEncoderCLSID = _WinAPI_GUIDFromString($sEncoderCLSID)
	Local $pEncoderCLSID = DllStructGetPtr($tEncoderCLSID)
	Local $pStream = _WinAPI_CreateStreamOnHGlobal(0)
	_GDIPlus_ImageSaveToStream($hBitmap, $pStream, $pEncoderCLSID)
	_GDIPlus_BitmapDispose($hBitmap)

	Local $hMem = _WinAPI_GetHGlobalFromStream($pStream)
	Local $iSize = _MemGlobalSize($hMem)
	Local $pMem = _MemGlobalLock($hMem)
	Local $tData = DllStructCreate("byte[" & $iSize & "]", $pMem)
	Local $xData = DllStructGetData($tData, 1) ;JPG file in binary format

	_MemGlobalFree($hMem)
	Return BinaryToString($xData)
EndFunc

Func pomfload($sImagePath,$sBinary = "")
	Local $sUserAgent = 'User-Agent: AutoIT-pomfloader (v1.0 Stable) p-please dont ban'
	Local $hSession = _WinHttpOpen($sUserAgent)
	Local $hConnect = _WinHttpConnect($hSession, 'pomf.se')

	Local $iBoundary = Random(13,37)
	If ($sImagePath <> "") Then
		Local $bFileContent = FileRead($sImagePath)
	Else
		Local $bFileContent = $sBinary
		$sImagePath = "pomf " & @YEAR & "." & @MON & "." & @MDAY & " - " & @HOUR & "." & @MIN & "." & @SEC & ".jpg"
	EndIf
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