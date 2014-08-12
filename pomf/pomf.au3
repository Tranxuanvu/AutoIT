#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=pomf.ico
#AutoIt3Wrapper_Res_Fileversion=2.0
#AutoIt3Wrapper_Res_Comment=pomf.se client
#AutoIt3Wrapper_Res_Description=pomf.se client
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
#include <Client.au3>
#include <Misc.au3>

If ($CmdLine[0] <> 0) Then
	#NoTrayIcon
	For $i = 1 to $CmdLine[0]
		$filesize = (FileGetSize($CmdLine[$i]) / 1048576)
		If $filesize <= 50 Then pomfload($CmdLine[$i])
		If $filesize > 50 Then MsgBox(16,"ERROR", "ERROR: File too big"&@CRLF&StringRegExpReplace($CmdLine[$i], '.+\\', '')&@CRLF&"Max upload size is: 50MB"&@CRLF&"Your File is: "&Round($filesize,2)&"MB")
	Next
	Exit
EndIf

_singleton(@ScriptName)

HotKeySet("{PRINTSCREEN}","Screenshot")
Opt("TrayMenuMode", 3)
Opt("TrayOnEventMode", 1)
TraySetState()
$tray_GUI = TrayCreateItem("Show GUI after Screencap")
TrayItemSetOnEvent(-1,"setting_showgui")
TrayItemSetState(-1,1)
TrayCreateItem("")
Local $tray_screenshot = TrayCreateItem("Screenshot whole Screen")
TrayItemSetOnEvent(-1,"setting_screenshot")
TrayItemSetState(-1,1)
Local $tray_screenshot_window = TrayCreateItem("Screenshot active Window")
TrayItemSetOnEvent(-1,"setting_screenshot_window")
TrayCreateItem("")
Local $tray_directUpload = TrayCreateItem("Enable Direct Upload")
TrayItemSetOnEvent(-1,"setting_directupload")
Local $tray_directSave = TrayCreateItem("Enable Direct Save")
TrayItemSetOnEvent(-1,"setting_directsave")
TrayCreateItem("")
Local $tray_spasticIcon = TrayCreateItem("Epileptic Icon")
TrayItemSetOnEvent(-1,"setting_icon")
TrayItemSetState(-1,1)
Local $tray_saveSetting = TrayCreateItem("Save Settings")
TrayItemSetOnEvent(-1,"setting_savesetting")
TrayCreateItem("")
Local $tray_exit = TrayCreateItem("Exit")
TrayItemSetOnEvent(-1,"quit")
TraySetToolTip("pomf client v1.0 by subnet-")

Global $noGUI = False
Global $directSave = False
Global $directUpload = False
Global $screenshot_window = False
Global $no_spastic = False
Global $savesetting = False

	;1=window screenshot
	;2=direct upload
	;4=direct save
	;8=icon
	;16=save settings
$settings = RegRead("HKEY_CLASSES_ROOT\*\shell\pomf","Settings")
If @error then
	$settings = 0
Else
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

RegWrite("HKEY_CLASSES_ROOT\*\shell\pomf","","REG_SZ","Upload to pomf.se")
RegWrite("HKEY_CLASSES_ROOT\*\shell\pomf","Icon","REG_SZ", @ScriptFullPath)
RegWrite("HKEY_CLASSES_ROOT\*\shell\pomf\command","","REG_SZ",@ScriptFullPath&' "%1"')

$spastic = 45; photoshop said the original value was 30, oh well
while True
	If $no_spastic Then
		TraySetIcon()
		Sleep($spastic * 10)
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

Func quit()
	If $screenshot_window Then $settings += 1
	If $directUpload Then $settings += 2
	If $directSave Then $settings += 4
	If $no_spastic Then $settings += 8
	If $savesetting Then $settings += 16
	If $savesetting Then RegWrite("HKEY_CLASSES_ROOT\*\shell\pomf","Settings","REG_SZ",$settings)
	If ($savesetting == False) then RegDelete("HKEY_CLASSES_ROOT\*\shell\pomf")
	Exit
EndFunc

Func setting_icon()
	If $no_spastic Then
		TrayItemSetState($tray_spasticIcon,1)
	else
		TrayItemSetState($tray_spasticIcon,4)
	EndIf
	$no_spastic = not $no_spastic
EndFunc

Func setting_savesetting()
	If $savesetting Then
		TrayItemSetState($tray_saveSetting,4)
	Else
		TrayItemSetState($tray_saveSetting,1)
	EndIf
	$savesetting = Not $savesetting
EndFunc

Func Screenshot()
	If $screenshot_window = False then Screenshot_png()
	If $screenshot_window = True then Screenshot_window_png()
	If $directUpload = True Then pomfload(@TempDir & "\pomf.png")
	If $directSave = True Then FileMove(@TempDir & "\pomf.png",@UserProfileDir & "\Pictures\"&"pomf "&@YEAR&"."&@MON&"."&@MDAY&" - "&@HOUR&"."&@MIN&"."&@SEC&".png")
	If $noGUI = False Then pomfGUI()
EndFunc

Func setting_screenshot()
	$screenshot_window = False
	TrayItemSetState($tray_screenshot,1)
	TrayItemSetState($tray_screenshot_window,4)
EndFunc

Func setting_screenshot_window()
	$screenshot_window = True
	TrayItemSetState($tray_screenshot_window,1)
	TrayItemSetState($tray_screenshot,4)
EndFunc

Func setting_showgui()
	$noGUI = False
	$directSave = False
	$directUpload = False
	TrayItemSetState($tray_GUI,1)
	TrayItemSetState($tray_directSave,4)
	TrayItemSetState($tray_directUpload,4)
EndFunc

Func setting_directupload()
	If (($directSave = False) And ($directUpload = True)) Then return setting_showgui()
	$noGUI = True
	$directUpload = not $directUpload
	if $directUpload = True Then
		TrayItemSetState($tray_GUI,4)
		TrayItemSetState($tray_directUpload,1)
	Else
		TrayItemSetState($tray_directUpload,4)
	EndIf
EndFunc

Func setting_directsave()
	If (($directSave = True) And ($directUpload = False)) Then return setting_showgui()
	$noGUI = True
	$directSave = not $directSave
	if $directSave = True Then
		TrayItemSetState($tray_GUI,4)
		TrayItemSetState($tray_directSave,1)
	Else
		TrayItemSetState($tray_directSave,4)
	EndIf
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
				Return 0
			Case $save
				GUIDelete($GUI)
				HotKeySet("{PRINTSCREEN}")
				$path = FileSaveDialog("Save Image","","Picture (*.png)",18,"pomf "&@YEAR&"."&@MON&"."&@MDAY&" - "&@HOUR&"."&@MIN&"."&@SEC&".png")
				If @error Then Return HotKeySet("{PRINTSCREEN}","Screenshot")
				HotKeySet("{PRINTSCREEN}","Screenshot")
				FileMove(@TempDir & "\pomf.png",$path,1)
				Return 0
			Case $saveup
				GUIDelete($GUI)
				HotKeySet("{PRINTSCREEN}")
				$path = FileSaveDialog("Save Image","","Picture (*.png)",18,"pomf "&@YEAR&"."&@MON&"."&@MDAY&" - "&@HOUR&"."&@MIN&"."&@SEC&".png")
				If @error Then Return HotKeySet("{PRINTSCREEN}","Screenshot")
				HotKeySet("{PRINTSCREEN}","Screenshot")
				pomfload(@TempDir & "\pomf.png")
				FileMove(@TempDir & "\pomf.png",$path,1)
				Return 0
			Case $view
				ShellExecute(@TempDir & "\pomf.png")
		EndSwitch
	WEnd
EndFunc