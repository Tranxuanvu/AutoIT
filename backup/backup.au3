#NoTrayIcon
#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Backup.ico
#AutoIt3Wrapper_Res_Comment=Adds "Create a Backup" to the Explorer-Contextmenu
#AutoIt3Wrapper_Res_Description=Creating Backup, please wait....
#AutoIt3Wrapper_Res_Fileversion=1.0
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.11.0 (Beta)
 Author:	subnet-

 Script Function:
	Adds "Create a Backup" to the Explorer-Contextmenu
	Creates a .bak (Backup) of a file

 Installation:
	Click "enable"

 Uninstallation:
	If you still got this script (or the compiled binary), click "disable"
	If you deleted the binary, open up C:/Windows/BackUp.exe and click "disable"

#ce ----------------------------------------------------------------------------
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>

if $CmdLine[0] > 0 Then
	for $i = 1 to $CmdLine[0] Step 1
		$backup = string($CmdLine[$i])
		$t=""
		If FileExists($backup & ".bak") Then
			$t = 2
			While FileExists($backup & ".bak" & $t)
				$t+=1
			WEnd
		EndIf
		$backup = $backup & ".bak" & $t
		FileCopy($CmdLine[$i],$backup,1)
	Next
Else
	Settings()
EndIf

func Settings()
	$settings = GUICreate("Options",197,100,-1,-1,$WS_SYSMENU,$WS_EX_TOPMOST)
	GUICtrlCreateLabel("Enable/Disable",0,10,197,20,$SS_CENTER)
	$enable = GUICtrlCreateButton("Enable",10,35,80,20)
	$disable = GUICtrlCreateButton("Disable",100,35,80,20)
	RegRead("HKEY_CLASSES_ROOT\*\shell\Backup","")
	if @error then
		GUICtrlSetState($disable,$GUI_DISABLE)
	Else
		GUICtrlSetState($enable,$GUI_DISABLE)
	EndIf
	GUISetState(@SW_SHOW)
	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				Exit
			Case $enable
				GUIDelete($settings)
				if not (FileCopy(@ScriptFullPath,@WindowsDir & "\Backup.exe")) Then
					MsgBox(0,"ERROR","Could not write"&@CRLF & @WindowsDir & "\Backup.exe")
					Exit
				EndIf
				RegWrite("HKEY_CLASSES_ROOT\*\shell\Backup","","REG_SZ","Create a Backup")
				RegWrite("HKEY_CLASSES_ROOT\*\shell\Backup","Icon","REG_SZ",@WindowsDir & "\Backup.exe")
				RegWrite("HKEY_CLASSES_ROOT\*\shell\Backup\command","","REG_SZ",@WindowsDir & '\Backup.exe "%1"')
				MsgBox(0,"Success","The backup.exe can be found at"&@CRLF & @WindowsDir & "\Backup.exe")
				Exit
			case $disable
				GUIDelete($settings)
				if (RegDelete("HKEY_CLASSES_ROOT\*\shell\Backup") <> 1) Then
					MsgBox(0,"Failure",	"Could not delete the registry-key."&@CRLF& _
										"Please delete the following out of your registry:"&@crlf& _
										"HKEY_CLASSES_ROOT\*\shell\Backup")
					Exit
				EndIf
				if (@ScriptFullPath = (@WindowsDir & "\Backup.exe")) Then
					MsgBox(0,"Success","You can now remove this .exe")
				Else
					if not (FileDelete(@WindowsDir & "\Backup.exe")) then
						MsgBox(0,"ERROR","Could not delete file:"&@crlf&@WindowsDir&"\Backup.exe")
					Else
						MsgBox(0,"Success","Backup disabled")
					EndIf
				EndIf
				Exit
		EndSwitch
    WEnd
EndFunc