#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=HotKey.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include "hotkey.au3"
#include "vkConstants.au3"
global $firstrun, $listenkey = ""
hotkey(1)
while $listenkey = ""
	Sleep(100)
WEnd
InputBox("Button Received","The following Button was received:"&@crlf&$VK_LIST[$listenkey][1],$listenkey,"",220,130,Default,Default,120);vkConstants updaten!

func hotkey($firstrun=0)
	While 1
		if $firstrun = 1 Then
			SplashTextOn("Press a Button", "Please press a button", 180, 30, -1, -1, 32, "",12)
			$firstrun = 0
			global $listenkey=""
			for $i = 2 to 254 step 1
				_HotKey_Assign($i,"hotkey",$HK_FLAG_EXTENDEDCALL)
			Next
			Return
		ElseIf $firstrun = 0 Then
			Return
		Else
			global $listenkey = $firstrun
			SplashOff()
			Return
		EndIf
	WEnd
EndFunc   ;==>_SB_hotkey