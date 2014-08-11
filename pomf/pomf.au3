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

#include <WinHTTP.au3> ; http://code.google.com/p/autoit-winhttp/downloads/list

$sUserAgent = 'User-Agent: AutoIT-pomfloader (v. 0.1 alpha) p-please dont ban'
$hSession = _WinHttpOpen($sUserAgent)
$hConnect = _WinHttpConnect($hSession, 'pomf.se')

if ($cmdline[0] == 0) Then
	$file = FileOpenDialog('Select File to upload', "" , '(*.*)',3)
	if @error = 1 Then Exit
	_pomf($file)
Else
	For $i=1 to $cmdline[0]
		_pomf($cmdline[$i])
	Next
EndIf

_WinHttpCloseHandle($hConnect)
_WinHttpCloseHandle($hSession)

Func _pomf($sImagePath);Credits to Achat
	Local $iBoundary = Random(13,37)
	Local $bFileContent = FileRead($sImagePath)
	Local $sHeaders = 'Content-Type: multipart/form-data; boundary=---------------------------' & $iBoundary
	Local $sSend = @CRLF & '-----------------------------' & $iBoundary & @CRLF & _
			'Content-Disposition: form-data; name="files[]"; filename="' & StringRegExpReplace($sImagePath, '.+\\', '') & '"' & @CRLF & _
			'Content-Type: application/octet-stream' & @CRLF & @CRLF & _
			$bFileContent & @CRLF & _
			'-----------------------------' & $iBoundary & '--' ;& @CRLF
	Local $sResponse = _InetReadWinHttp('POST', 'pomf.se', '/upload.php', '', $sSend, $sHeaders)
	Local $aRegExp = StringRegExp($sResponse, '"url":"(.+?)"', 3)
	If IsArray($aRegExp) Then InputBox("Files Successfully uploaded"," ","http://a.pomf.se/"$aRegExp[0],"",200,100)
EndFunc   ;==>_EpvpImg

;~ {"success":true,"error":null,"files":[{"hash":"9b7%d20a522d22afbe5f1b63725bfabb62f09979d","name":"Unbenannt-1.jpg","url":"kkkngd.jpg","size":"93539"}]}

Func _InetReadWinHttp($sType, $sServerName, $sPath = Default, $sReferrer = Default, $sData = Default, $sHeader = Default, $fGetHeaders = Default, $iMode = Default)
	Return _WinHttpSimpleRequest($hConnect, $sType, $sPath, $sReferrer, $sData, $sHeader, $fGetHeaders, $iMode)
EndFunc   ;==>_InetReadWinHttp