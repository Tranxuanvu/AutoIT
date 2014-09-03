#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=favicon-ws.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

	AutoIt Version: 3.3.11.0 (Beta)
	Author:		subnet-

	Script Function:
	Shows visible text for easy copy/paste

#ce ----------------------------------------------------------------------------
#NoTrayIcon
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>



$windowarray = ListAllWindows()
$gui = GUICreate("Window Info", 6 * GetLongestString($windowarray), 34 * $windowarray[0][0], -1, -1, -1, $WS_EX_TOOLWINDOW + $WS_EX_TOPMOST)
Dim $button[$windowarray[0][0]]
For $i = 0 To $windowarray[0][0] - 1
	$button[$i] = GUICtrlCreateButton($windowarray[$i + 1][0], 10, 10 + (30 * $i))
Next
GUIRegisterMsg($WM_COMMAND, "input")
GUISetState()

Func input($hWnd, $Msg, $wParam, $lParam)
	If $lParam = 0 Then Exit
	If $hWnd == $gui Then
		GUIDelete($gui)
		$text = WinGetText($windowarray[Floor($wParam) - 2][1])
		$text = StringReplace($text, @LF, @CRLF)
		$split = StringSplit($text, @CRLF)
		$w = 9 * GetLongestString2($split)
		$h = $split[0] * 9
		If $w < 100 Then $w = 300
		If $h < 60 Then $h = 60
		If $w > (@DesktopWidth / 2) Then $w = (@DesktopWidth / 2)
		If $h > (@DesktopHeight / 2) Then $h = (@DesktopHeight / 2)
		$gui2 = GUICreate(WinGetTitle($windowarray[Floor($wParam) - 2][1]), $w, $h, -1, -1, -1, $WS_EX_TOOLWINDOW + $WS_EX_TOPMOST)
		GUICtrlCreateEdit($text, -1, -1, $w + 2, $h + 2, $ES_READONLY + $WS_HSCROLL + $WS_VSCROLL + $ES_AUTOHSCROLL)
		GUISetState()
	EndIf
EndFunc   ;==>input


While 1
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
			Exit
	EndSwitch
WEnd

Func GetLongestString($array)
	Local $longest = 1
	For $i = 1 To $array[0][0]
		If StringLen($array[$i][0]) > $longest Then
			$longest = StringLen($array[$i][0])
		EndIf
	Next
	Return $longest
EndFunc   ;==>GetLongestString

Func GetLongestString2($array)
	Local $longest = 1
	For $i = 1 To $array[0]
		If StringLen($array[$i]) > $longest Then
			$longest = StringLen($array[$i])
		EndIf
	Next
	Return $longest
EndFunc   ;==>GetLongestString2

Func ListAllWindows()
	; Retrieve a list of window handles.
	Local $aList = WinList()
	; Loop through the array displaying only visable windows with a title.
	Local $values
	Dim $values[1][2]
	$values[0][0] = 0
	$j = 1
	For $i = 1 To $aList[0][0]
		If $aList[$i][0] <> "" And BitAND(WinGetState($aList[$i][1]), 2) Then
			If (($aList[$i][0] <> "Start") And ($aList[$i][0] <> "Program Manager")) Then
				$values[0][0] += 1
				ReDim $values[$values[0][0] + 1][2]
				$values[$j][0] = $aList[$i][0]
				$values[$j][1] = $aList[$i][1]
				$j += 1
			EndIf
		EndIf
	Next
	Return $values
EndFunc   ;==>ListAllWindows
