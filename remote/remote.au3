#cs ----------------------------------------------------------------------------

	AutoIt Version: 3.3.11.0 (Beta)
	Author:	subnet-

	Script Function:
	AutoIT Interface for HIDMacros.exe

#ce ----------------------------------------------------------------------------
#NoTrayIcon
#include "MailSlot.au3"
#include <Misc.au3>
Global Const $mMailSlotName = "\\.\mailslot\USB-Remote"
AutoItSetOption("WinTitleMatchMode",2)

If ($CmdLine[0] == 0) Then
	_Singleton(@ScriptName)
	Global $mMailSlot = _MailSlotCreate($mMailSlotName)
	If @error Then
		MsgBox(48 + 262144, "MailSlot", "Failed to create new account!" & @CRLF & "Probably one using that 'address' already exists.")
		Exit
	EndIf
	Local $iIni = StringTrimRight(@ScriptFullPath,3)&"ini"
	Local $iCount = IniRead($iIni, "config", "count", "0")
	Global $iWindow[$iCount+1]
	$iWindow[0] = $iCount
	For $i = 1 to $iCount
		$iWindow[$i] = WinGetHandle(IniRead($iIni, "config", "window_"&$i, "0"))
	Next
	$mTimer = TimerInit()
	While 1
		Local $mSize = _MailSlotCheckForNextMessage($mMailSlot)
		If $mSize Then
			For $m = 1 to $iWindow[0]
				$mHandle = WinGetHandle("[ACTIVE]")
				If ($mHandle == $iWindow[$m]) Then SendKey(_MailSlotRead($mMailSlot, $mSize, 1),$mHandle,$m)
			Next
			_MailSlotRead($mMailSlot, $mSize, 1)
		Else
			Sleep(10)
			if (TimerDiff($mTimer) >= 2000) Then
				ReadIni()
				$mTimer = TimerInit()
				If (ProcessExists("HIDMacros.exe") == 0) Then Exit
			EndIf
		EndIf
	WEnd
Else
	_SendMail($mMailSlotName)
	Exit
EndIf

Func ReadIni()
	Local $iIni = StringTrimRight(@ScriptFullPath,3)&"ini"
	Local $iCount = IniRead($iIni, "config", "count", "0")
	Global $iWindow[$iCount+1]
	$iWindow[0] = $iCount
	For $i = 1 to $iCount
		$iWindow[$i] = WinGetHandle(IniRead($iIni, "config", "window_"&$i, "0"))
	Next
EndFunc

Func SendKey($sKey,$sHandle,$sCount)
	Switch $sKey
		Case 1
			ControlSend($sHandle,"","",IniRead($iIni, "window_"&$sCount, "case1", ""))
		Case 2
			ControlSend($sHandle,"","",IniRead($iIni, "window_"&$sCount, "case2", ""))
		Case 3
			ControlSend($sHandle,"","",IniRead($iIni, "window_"&$sCount, "case3", ""))
		Case 4
			ControlSend($sHandle,"","",IniRead($iIni, "window_"&$sCount, "case4", ""))
		Case 5
			ControlSend($sHandle,"","",IniRead($iIni, "window_"&$sCount, "case5", ""))
		Case 6
			ControlSend($sHandle,"","",IniRead($iIni, "window_"&$sCount, "case6", ""))
	EndSwitch
EndFunc   ;==>bind

Func _SendMail($mMailSlotName)
	_MailSlotWrite($mMailSlotName, $CmdLine[1]);, 1)
	Switch @error
		Case 1
			Run(@ScriptFullPath)
			Sleep(10)
			_SendMail($mMailSlotName)
		Case 2
			MsgBox(48, "MailSlot demo error", "Message is blocked!")
		Case 3
			MsgBox(48, "MailSlot demo error", "Message is send but there is an open handle left." & @CRLF & "That could lead to possible errors in future")
		Case 4
			MsgBox(48, "MailSlot demo error", "All is fucked up!" & @CRLF & "Try debugging MailSlot.au3 functions. Thanks.")
		Case Else
			Exit
	EndSwitch
EndFunc   ;==>_SendMail
