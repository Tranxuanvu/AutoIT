#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.11.0 (Beta)
 Author:         myName

 Script Function:
	Login Function

#ce ----------------------------------------------------------------------------
#include <WinHTTP.au3>

$sUserAgent = 'User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Firefox/31.0'
$hSession = _WinHttpOpen($sUserAgent)
$hConnect = _WinHttpConnect($hSession, 'pomf.se')

$sSend = 'email='&StringReplace($eMail, "@","%40")&'&pass='&$ePass
$result = _WinHttpSimpleRequest($hConnect, 'POST', '/user/includes/api.php?do=login', '', $sSend)
$result = StringInStr($result,"<title>Moe Panel</title>")
If $result <> 0 Then bla