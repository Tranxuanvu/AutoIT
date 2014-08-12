#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=pomf.ico
#AutoIt3Wrapper_Res_Comment=pomf.se uploader
#AutoIt3Wrapper_Res_Description=uploading to pomf.se...
#AutoIt3Wrapper_Res_Fileversion=0.1
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.11.0 (Beta)
 Author:    subnet-

 Script Function:
	Open up the program -> Upload a single file to pomf.se
	Drag multiple files onto program -> Upload multiple files to pomf.se

#ce ----------------------------------------------------------------------------
#include <Client.au3> ; http://code.google.com/p/autoit-winhttp/downloads/list

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
Local $tray_exit = TrayCreateItem("Exit")
TrayItemSetOnEvent(-1,"quit")
TraySetToolTip("pomf client v0.1 by subnet-")

Global $noGUI = False
Global $directSave = False
Global $directUpload = False
Global $screenshot_window = False

while True
	Sleep(60000)
WEnd

Func quit()
	Exit
EndFunc

Func Screenshot()
	If $screenshot_window = False then Screenshot_png()
	If $screenshot_window = True then Screenshot_window_png()
	If $directUpload = True Then pomfload(@TempDir & "\pomf.png")
	If $directSave = True Then FileMove(@TempDir & "\pomf.png",@UserProfileDir & "\Pictures\"&@YEAR&"."&@MON&"."&@MDAY&" - "&@HOUR&"."&@MIN&"."&@SEC&".png")
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
				$path = FileSaveDialog("Save Image","","Picture (*.png)",18,@YEAR&"."&@MON&"."&@MDAY&" - "&@HOUR&"."&@MIN&"."&@SEC&".png")
				If @error Then Return HotKeySet("{PRINTSCREEN}","Screenshot")
				HotKeySet("{PRINTSCREEN}","Screenshot")
				FileMove(@TempDir & "\pomf.png",$path,1)
				Return 0
			Case $saveup
				GUIDelete($GUI)
				HotKeySet("{PRINTSCREEN}")
				$path = FileSaveDialog("Save Image","","Picture (*.png)",18,@YEAR&"."&@MON&"."&@MDAY&" - "&@HOUR&"."&@MIN&"."&@SEC&".png")
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