;===============================================================================
;
; Function Name:    _ProcessGetHWnd
; Description:      Returns the HWND(s) owned by the specified process (PID only !).
;
; Parameter(s):     $iPid		- the owner-PID.
;					$iOption	- Optional : return/search methods :
;						0 - returns the HWND for the first non-titleless window.
;						1 - returns the HWND for the first found window (default).
;						2 - returns all HWNDs for all matches.
;
;                   $sTitle		- Optional : the title to match (see notes).
;					$iTimeout	- Optional : timeout in msec (see notes)
;
; Return Value(s):  On Success - returns the HWND (see below for method 2).
;						$array[0][0] - number of HWNDs
;						$array[x][0] - title
;						$array[x][1] - HWND
;
;                   On Failure	- returns 0 and sets @error to 1.
;
; Note(s):			When a title is specified it will then only return the HWND to the titles
;					matching that specific string. If no title is specified it will return as
;					described by the option used.
;
;					When using a timeout it's possible to use WinWaitDelay (Opt) to specify how
;					often it should wait before attempting another time to get the HWND.
;
;
; Author(s):        Helge
;
;===============================================================================
Func _ProcessGetHWnd($iPid, $iOption = 1, $sTitle = "", $iTimeout = 2000)
	Local $aReturn[1][1] = [[0]], $aWin, $hTimer = TimerInit()

	While 1

		; Get list of windows
		$aWin = WinList($sTitle)

		; Searches thru all windows
		For $i = 1 To $aWin[0][0]

			; Found a window owned by the given PID
			If $iPid = WinGetProcess($aWin[$i][1]) Then

				; Option 0 or 1 used
				If $iOption = 1 OR ($iOption = 0 And $aWin[$i][0] <> "") Then
					Return $aWin[$i][1]

				; Option 2 is used
				ElseIf $iOption = 2 Then
					ReDim $aReturn[UBound($aReturn) + 1][2]
					$aReturn[0][0] += 1
					$aReturn[$aReturn[0][0]][0] = $aWin[$i][0]
					$aReturn[$aReturn[0][0]][1] = $aWin[$i][1]
				EndIf
			EndIf
		Next

		; If option 2 is used and there was matches then the list is returned
		If $iOption = 2 And $aReturn[0][0] > 0 Then Return $aReturn

		; If timed out then give up
		If TimerDiff($hTimer) > $iTimeout Then ExitLoop

		; Waits before new attempt
		Sleep(Opt("WinWaitDelay"))
	WEnd


	; No matches
	SetError(1)
	Return 0
EndFunc   ;==>_ProcessGetHWnd