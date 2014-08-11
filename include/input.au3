#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.8.0
 Author:	subnet-

 Script Function:
	Shows you the parameters the program was called with

 Installation:
	Replace a binary with this one

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

;Second Example
; Terminate script if no command-line arguments
If $CmdLine[0] = 0 Then Exit

$w = (7*StringLen($CmdLineRaw))
InputBox("Input",$CmdLineRaw,$CmdLineRaw,"",$w,150)