#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=pomf.ico
#AutoIt3Wrapper_Outfile=.\bin\pomf.exe
#AutoIt3Wrapper_Res_Comment=pomf.se client
#AutoIt3Wrapper_Res_Description=pomf.se client
#AutoIt3Wrapper_Res_Fileversion=2.0.0.0
#AutoIt3Wrapper_Res_Icon_Add=.\2.ico,12
#AutoIt3Wrapper_Res_Icon_Add=.\3.ico,13
#AutoIt3Wrapper_Res_Icon_Add=.\4.ico,14
#AutoIt3Wrapper_Res_Icon_Add=.\5.ico,15
#AutoIt3Wrapper_Res_Icon_Add=.\6.ico,16
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

	AutoIt Version: 3.3.11.0 (Beta)
	Author:    subnet-

	Script Function:
	Open up the program -> Start the pomf client
	Drag multiple files onto program -> Upload multiple files to pomf.se

#ce ----------------------------------------------------------------------------
#include-once
#include <ScreenCapture.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <Memory.au3>
#include <WinHTTP.au3>
#include <GDIPlus.au3>
#include <Misc.au3>
#include <String.au3>

Global $noGUI = False
Global $directSave = False
Global $directUpload = False
Global $screenshot_window = False
Global $no_spastic = False
Global $savesetting = False
Global $GUI
Global $Login = False

#Region Contextmenu
If ($CmdLine[0] <> 0) Then
	#NoTrayIcon
	Local $eMail = RegRead("HKEY_CLASSES_ROOT\*\shell\pomf", "eMail")
	If @error = 0 Then $Login = True
	If ($CmdLine[0] > 3) Then
		If (MsgBox(68, "pomf.se client", "Do you really want to upload " & $CmdLine[0] & " Files?") == 7) Then Exit
	EndIf
	For $i = 1 To $CmdLine[0]
		$filesize = (FileGetSize($CmdLine[$i]) / 1048576)
		If $filesize <= 50 Then pomfload($CmdLine[$i])
		If $filesize > 50 Then MsgBox(16, "ERROR", "ERROR: File too big" & @CRLF & StringRegExpReplace($CmdLine[$i], '.+\\', '') & @CRLF & "Max upload size is: 50MB" & @CRLF & "Your File is: " & Round($filesize, 2) & "MB")
	Next
	Exit
EndIf
#EndRegion

_Singleton(@ScriptName)
HotKeySet("{PRINTSCREEN}", "Screenshot")

#Region TrayIcon
Opt("TrayMenuMode", 3)
Opt("TrayOnEventMode", 1)
$tray_GUI = TrayCreateItem("Show GUI after Screencap")
TrayItemSetOnEvent(-1, "setting_showgui")
TrayItemSetState(-1, 1)
$tray_login = TrayCreateItem("Login")
TrayItemSetOnEvent(-1, "setting_login")
TrayCreateItem("")
Local $tray_screenshot = TrayCreateItem("Screenshot whole Screen")
TrayItemSetOnEvent(-1, "setting_screenshot")
TrayItemSetState(-1, 1)
Local $tray_screenshot_window = TrayCreateItem("Screenshot active Window")
TrayItemSetOnEvent(-1, "setting_screenshot_window")
TrayCreateItem("")
Local $tray_directUpload = TrayCreateItem("Enable Direct Upload")
TrayItemSetOnEvent(-1, "setting_directupload")
Local $tray_directSave = TrayCreateItem("Enable Direct Save")
TrayItemSetOnEvent(-1, "setting_directsave")
TrayCreateItem("")
Local $tray_spasticIcon = TrayCreateItem("Epileptic Icon")
TrayItemSetOnEvent(-1, "setting_icon")
TrayItemSetState(-1, 1)
Local $tray_saveSetting = TrayCreateItem("Save Settings")
TrayItemSetOnEvent(-1, "setting_savesetting")
TrayCreateItem("")
Local $tray_exit = TrayCreateItem("Exit")
TrayItemSetOnEvent(-1, "quit")
TraySetToolTip("pomf client v2.5 by subnet-")
TraySetState()
#EndRegion

#Region SaveSettings
$settings = RegRead("HKEY_CLASSES_ROOT\*\shell\pomf", "Settings")
If @error Then
	$settings = 0
Else;switch case continuecase
	If (Mod($settings, 2) == 1) Then
		setting_screenshot_window()
		$settings -= 1
	EndIf
	If (Mod($settings, 4) == 2) Then
		setting_directupload()
		$settings -= 2
	EndIf
	If (Mod($settings, 8) == 4) Then
		setting_directsave()
		$settings -= 4
	EndIf
	If (Mod($settings, 16) == 8) Then
		setting_icon()
		$settings -= 8
	EndIf
	If ($settings == 16) Then;if more options then Mod($settings, 32) == 16
		setting_savesetting()
		$settings -= 16
	EndIf
EndIf
$mailcheck = RegRead("HKEY_CLASSES_ROOT\*\shell\pomf", "eMail")
If @error = 0 then
	$Login = True
	TrayItemSetState($tray_login, 1)
	TrayItemSetText($tray_login, "Logged in")
EndIf
RegWrite("HKEY_CLASSES_ROOT\*\shell\pomf", "", "REG_SZ", "Upload to pomf.se")
RegWrite("HKEY_CLASSES_ROOT\*\shell\pomf", "Icon", "REG_SZ", @ScriptFullPath)
RegWrite("HKEY_CLASSES_ROOT\*\shell\pomf\command", "", "REG_SZ", @ScriptFullPath & ' "%1"')
#EndRegion

pomfidle()

Func pomfidle()
	$spastic = 45; photoshop said the original value was 30, oh well
	While True
		If $no_spastic Then
			TraySetIcon()
			Sleep($spastic * 20)
		Else
			Sleep($spastic)
			TraySetIcon(@ScriptFullPath, 12)
			Sleep($spastic)
			TraySetIcon(@ScriptFullPath, 13)
			Sleep($spastic)
			TraySetIcon(@ScriptFullPath, 14)
			Sleep($spastic)
			TraySetIcon(@ScriptFullPath, 15)
			Sleep($spastic)
			TraySetIcon(@ScriptFullPath, 16)
			Sleep($spastic)
			TraySetIcon()
		EndIf
	WEnd
EndFunc

Func quit()
	If $screenshot_window Then $settings += 1
	If $directUpload Then $settings += 2
	If $directSave Then $settings += 4
	If $no_spastic Then $settings += 8
	If $savesetting Then $settings += 16
	If $savesetting Then RegWrite("HKEY_CLASSES_ROOT\*\shell\pomf", "Settings", "REG_SZ", $settings)
	If ($savesetting == False) Then RegDelete("HKEY_CLASSES_ROOT\*\shell\pomf")
	Exit
EndFunc   ;==>quit

Func setting_icon()
	If $no_spastic Then
		TrayItemSetState($tray_spasticIcon, 1)
	Else
		TrayItemSetState($tray_spasticIcon, 4)
	EndIf
	$no_spastic = Not $no_spastic
EndFunc   ;==>setting_icon

Func setting_login()
	$lGUI = GUICreate("Login", 197, 120, -1, -1, $WS_SYSMENU, $WS_EX_TOPMOST)
	GUICtrlCreateLabel("Please login", 0, 10, 197, 20, $SS_CENTER)
	Local $upload = GUICtrlCreateButton("Upload", 10, 35, 80, 20)
	Local $save = GUICtrlCreateButton("Save", 100, 35, 80, 20)
	Local $saveup = GUICtrlCreateButton("Save+Upload", 10, 62, 80, 20)
	Local $view = GUICtrlCreateButton("View", 100, 62, 80, 20)
	GUISetState(@SW_SHOW)
	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				GUIDelete($lGUI)
				Opt("TrayOnEventMode", 0)
				Opt("TrayOnEventMode", 1)
;~ 				pomfidle()
			Case $upload
			Case $save
			Case $saveup
			Case $view
		EndSwitch
	WEnd
EndFunc

Func setting_savesetting()
	If $savesetting Then
		TrayItemSetState($tray_saveSetting, 4)
	Else
		TrayItemSetState($tray_saveSetting, 1)
	EndIf
	$savesetting = Not $savesetting
EndFunc   ;==>setting_savesetting

Func Screenshot()
	If $screenshot_window = False Then Local $sFile = Screenshot_png()
	If $screenshot_window = True Then Local $sFile = Screenshot_window_png()
	If $directSave = True Then FileWrite(@UserProfileDir & "\Pictures\" & "pomf " & @YEAR & "." & @MON & "." & @MDAY & " - " & @HOUR & "." & @MIN & "." & @SEC & ".jpg", $sFile)
	If $directUpload = True Then pomfload("", $sFile)
	If $noGUI = False Then pomfGUI($sFile)
EndFunc   ;==>Screenshot

Func setting_screenshot()
	$screenshot_window = False
	TrayItemSetState($tray_screenshot, 1)
	TrayItemSetState($tray_screenshot_window, 4)
EndFunc   ;==>setting_screenshot

Func setting_screenshot_window()
	$screenshot_window = True
	TrayItemSetState($tray_screenshot_window, 1)
	TrayItemSetState($tray_screenshot, 4)
EndFunc   ;==>setting_screenshot_window

Func setting_showgui()
	$noGUI = False
	$directSave = False
	$directUpload = False
	TrayItemSetState($tray_GUI, 1)
	TrayItemSetState($tray_directSave, 4)
	TrayItemSetState($tray_directUpload, 4)
EndFunc   ;==>setting_showgui

Func setting_directupload()
	If (($directSave = False) And ($directUpload = True)) Then Return setting_showgui()
	$noGUI = True
	$directUpload = Not $directUpload
	If $directUpload = True Then
		TrayItemSetState($tray_GUI, 4)
		TrayItemSetState($tray_directUpload, 1)
	Else
		TrayItemSetState($tray_directUpload, 4)
	EndIf
EndFunc   ;==>setting_directupload

Func setting_directsave()
	If (($directSave = True) And ($directUpload = False)) Then Return setting_showgui()
	$noGUI = True
	$directSave = Not $directSave
	If $directSave = True Then
		TrayItemSetState($tray_GUI, 4)
		TrayItemSetState($tray_directSave, 1)
	Else
		TrayItemSetState($tray_directSave, 4)
	EndIf
EndFunc   ;==>setting_directsave

Func pomfGUI($sFile)
	GUIDelete($GUI)
	$GUI = GUICreate("Pomf Client", 197, 120, -1, -1, $WS_SYSMENU, $WS_EX_TOPMOST)
	GUICtrlCreateLabel("Image Saved", 0, 10, 197, 20, $SS_CENTER)
	Local $upload = GUICtrlCreateButton("Upload", 10, 35, 80, 20)
	Local $save = GUICtrlCreateButton("Save", 100, 35, 80, 20)
	Local $saveup = GUICtrlCreateButton("Save+Upload", 10, 62, 80, 20)
	Local $view = GUICtrlCreateButton("View", 100, 62, 80, 20)
	GUISetState(@SW_SHOW)
	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				GUIDelete($GUI)
				$sFile = ""
				pomfidle()
			Case $upload
				pomfload("", $sFile)
			Case $save
				GUIDelete($GUI)
				FileWrite(@UserProfileDir & "\Pictures\" & "pomf " & @YEAR & "." & @MON & "." & @MDAY & " - " & @HOUR & "." & @MIN & "." & @SEC & ".jpg", $sFile)
			Case $saveup
				GUIDelete($GUI)
				FileWrite(@UserProfileDir & "\Pictures\" & "pomf " & @YEAR & "." & @MON & "." & @MDAY & " - " & @HOUR & "." & @MIN & "." & @SEC & ".jpg", $sFile)
				pomfload("", $sFile)
			Case $view
				FileWrite(@TempDir & "\pomf.jpg", $sFile)
				ShellExecute(@TempDir & "\pomf.jpg")
				WinWaitClose("pomf.jpg")
				FileDelete(@TempDir & "\pomf.jpg")
		EndSwitch
	WEnd
EndFunc   ;==>pomfGUI

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

	Local $sUserAgent = 'Mozilla/5.0 (Windows NT 6.1; WOW64; rv:33.0) Gecko/20100101 Firefox/33.0'
	Local $hSession = _WinHttpOpen($sUserAgent)
	Local $hConnect = _WinHttpConnect($hSession, 'pomf.se')

	If $Login = True Then
		$eMail = _StringEncrypt(0,RegRead("HKEY_CLASSES_ROOT\*\shell\pomf", "eMail"),"010101000110111001000111001000000010110100100000011000010110110001101100001000000110010101111010")
		$ePass = _StringEncrypt(0,RegRead("HKEY_CLASSES_ROOT\*\shell\pomf", "pass"),"010101000110111001000111001000000010110100100000011000010110110001101100001000000110010101111010")
		_WinHttpSimpleRequest($hConnect, 'POST', '/user/includes/api.php?do=login', 'pomf.se', 'email='&StringReplace($eMail, "@","%40")&'&pass='&$ePass)
	EndIf

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
	FileWrite(@DesktopDir & "\pomf.html",$sResponse)
	Local $aRegExp = StringRegExp($sResponse, '"url":"(.+?)"', 3)
	If IsArray($aRegExp) Then
		InputBox("Success"," ","http://a.pomf.se/"&$aRegExp[0],"",200,100)
		If (@error = 0) Then ShellExecute("http://a.pomf.se/"&$aRegExp[0])
	EndIf
	_WinHttpCloseHandle($hConnect)
	_WinHttpCloseHandle($hSession)
EndFunc   ;==>upload