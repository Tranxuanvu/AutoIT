#Include-once

#Region Global Variables and Constants

; http://msdn.microsoft.com/en-us/library/dd375731(VS.85).aspx

Global Const $VK_LBUTTON = 0x01
Global Const $VK_RBUTTON = 0x02
Global Const $VK_CANCEL = 0x03
Global Const $VK_MBUTTON = 0x04
Global Const $VK_XBUTTON1 = 0x05
Global Const $VK_XBUTTON2 = 0x06
; 0x07 - Undefined
Global Const $VK_BACK = 0x08; backspace
Global Const $VK_TAB = 0x09; tab
Global Const $VK_SHIFT = 0x10; shift
; 0x0A - 0x0B - Reserved
Global Const $VK_CLEAR = 0x0C
Global Const $VK_RETURN = 0x0D; enter
; 0x0E - 0x0F - Undefined
Global Const $VK_CONTROL = 0x11; ctrl
Global Const $VK_MENU = 0x12; alt
Global Const $VK_PAUSE = 0x13; break
Global Const $VK_CAPITAL = 0x14; capslock
; 0x15
; 0x16 - Undefined
; 0x17
; 0x18
; 0x19
; 0x1A - Undefined
Global Const $VK_ESCAPE = 0x1B; esc
; 0x1C
; 0x1D
; 0x1E
; 0x1F
Global Const $VK_SPACE = 0x20; space
Global Const $VK_PRIOR = 0x21; pgup
Global Const $VK_NEXT = 0x22; pgdn
Global Const $VK_END = 0x23; end
Global Const $VK_HOME = 0x24; home
Global Const $VK_LEFT = 0x25; leftarrow
Global Const $VK_UP = 0x26; uparrow
Global Const $VK_RIGHT = 0x27; rightarrow
Global Const $VK_DOWN = 0x28; downarrow
Global Const $VK_SELECT = 0x29
Global Const $VK_PRINT = 0x2A
Global Const $VK_EXECUTE = 0x2B
Global Const $VK_SNAPSHOT = 0x2C; druck
Global Const $VK_INSERT = 0x2D; ins
Global Const $VK_DELETE = 0x2E; del
Global Const $VK_HELP = 0x2F
Global Const $VK_0 = 0x30
Global Const $VK_1 = 0x31
Global Const $VK_2 = 0x32
Global Const $VK_3 = 0x33
Global Const $VK_4 = 0x34
Global Const $VK_5 = 0x35
Global Const $VK_6 = 0x36
Global Const $VK_7 = 0x37
Global Const $VK_8 = 0x38
Global Const $VK_9 = 0x39
; 0x3A - 0x40 - Undefined
Global Const $VK_A = 0x41
Global Const $VK_B = 0x42
Global Const $VK_C = 0x43
Global Const $VK_D = 0x44
Global Const $VK_E = 0x45
Global Const $VK_F = 0x46
Global Const $VK_G = 0x47
Global Const $VK_H = 0x48
Global Const $VK_I = 0x49
Global Const $VK_J = 0x4A
Global Const $VK_K = 0x4B
Global Const $VK_L = 0x4C
Global Const $VK_M = 0x4D
Global Const $VK_N = 0x4E
Global Const $VK_O = 0x4F
Global Const $VK_P = 0x50
Global Const $VK_Q = 0x51
Global Const $VK_R = 0x52
Global Const $VK_S = 0x53
Global Const $VK_T = 0x54
Global Const $VK_U = 0x55
Global Const $VK_V = 0x56
Global Const $VK_W = 0x57
Global Const $VK_X = 0x58
Global Const $VK_Y = 0x59
Global Const $VK_Z = 0x5A
Global Const $VK_LWIN = 0x5B; left gui
Global Const $VK_RWIN = 0x5C; right gui
; 0x5E - Reserved
Global Const $VK_APPS = 0x5D; app
Global Const $VK_SLEEP = 0x5F
Global Const $VK_NUMPAD0 = 0x60; kp_ins
Global Const $VK_NUMPAD1 = 0x61; kp_end
Global Const $VK_NUMPAD2 = 0x62; kp_downarrow
Global Const $VK_NUMPAD3 = 0x63; kp_pgdn
Global Const $VK_NUMPAD4 = 0x64; kp_leftarrow
Global Const $VK_NUMPAD5 = 0x65; kp_5
Global Const $VK_NUMPAD6 = 0x66; kp_rightarrow
Global Const $VK_NUMPAD7 = 0x67; kp_home
Global Const $VK_NUMPAD8 = 0x68; kp_uparrow
Global Const $VK_NUMPAD9 = 0x69; kp_pgup
Global Const $VK_MULTIPLY = 0x6A; kp_multiply
Global Const $VK_ADD = 0x6B; kp_plus
Global Const $VK_SEPARATOR = 0x6C; kp_enter
Global Const $VK_SUBTRACT = 0x6D; kp_minus
Global Const $VK_DECIMAL = 0x6E; kp_del
Global Const $VK_DIVIDE = 0x6F; kp_divide
Global Const $VK_F1 = 0x70
Global Const $VK_F2 = 0x71
Global Const $VK_F3 = 0x72
Global Const $VK_F4 = 0x73
Global Const $VK_F5 = 0x74
Global Const $VK_F6 = 0x75
Global Const $VK_F7 = 0x76
Global Const $VK_F8 = 0x77
Global Const $VK_F9 = 0x78
Global Const $VK_F10 = 0x79
Global Const $VK_F11 = 0x7A
Global Const $VK_F12 = 0x7B
Global Const $VK_F13 = 0x7C
Global Const $VK_F14 = 0x7D
Global Const $VK_F15 = 0x7E
Global Const $VK_F16 = 0x7F
Global Const $VK_F17 = 0x80
Global Const $VK_F18 = 0x81
Global Const $VK_F19 = 0x82
Global Const $VK_F20 = 0x83
Global Const $VK_F21 = 0x84
Global Const $VK_F22 = 0x85
Global Const $VK_F23 = 0x86
Global Const $VK_F24 = 0x87
; 0x88 - 0x8F - Unassigned
Global Const $VK_NUMLOCK = 0x90; num
Global Const $VK_SCROLL = 0x91; scrollock
; 0x92 - 0x96 - OEM specific
; 0x97 - 0x9F - Unassigned
Global Const $VK_LSHIFT = 0xA0; left shift
Global Const $VK_RSHIFT = 0xA1; right shift
Global Const $VK_LCONTROL = 0xA2; left ctrl
Global Const $VK_RCONTROL = 0xA3; right ctrl
Global Const $VK_LMENU = 0xA4; left alt
Global Const $VK_RMENU = 0xA5; left ctrl + right alt
Global Const $VK_BROWSER_BACK = 0xA6
Global Const $VK_BROWSER_FORWARD = 0xA7
Global Const $VK_BROWSER_REFRESH = 0xA8
Global Const $VK_BROWSER_STOP = 0xA9
Global Const $VK_BROWSER_SEARCH = 0xAA
Global Const $VK_BROWSER_FAVORITES = 0xAB
Global Const $VK_BROWSER_HOME = 0xAC
Global Const $VK_VOLUME_MUTE = 0xAD
Global Const $VK_VOLUME_DOWN = 0xAE
Global Const $VK_VOLUME_UP = 0xAF
Global Const $VK_MEDIA_NEXT_TRACK = 0xB0
Global Const $VK_MEDIA_PREV_TRACK = 0xB1
Global Const $VK_MEDIA_STOP = 0xB2
Global Const $VK_MEDIA_PLAY_PAUSE = 0xB3
Global Const $VK_LAUNCH_MAIL = 0xB4
Global Const $VK_LAUNCH_MEDIA_SELECT = 0xB5
Global Const $VK_LAUNCH_APP1 = 0xB6
Global Const $VK_LAUNCH_APP2 = 0xB7
; 0xB8 - 0xB9 - Reserved
Global Const $VK_OEM_1 = 0xBA; ü
Global Const $VK_OEM_PLUS = 0xBB; +
Global Const $VK_OEM_COMMA = 0xBC; ,
Global Const $VK_OEM_MINUS = 0xBD; -
Global Const $VK_OEM_PERIOD = 0xBE; .
Global Const $VK_OEM_2 = 0xBF; #
Global Const $VK_OEM_3 = 0xC0; ö
; 0xC1 - 0xD7 - Reserved
; 0xD8 - 0xDA - Unassigned
Global Const $VK_OEM_4 = 0xDB; ß
Global Const $VK_OEM_5 = 0xDC; ^
Global Const $VK_OEM_6 = 0xDD; ´
Global Const $VK_OEM_7 = 0xDE; ä
Global Const $VK_OEM_8 = 0xDF
; 0xE0 - Reserved
; 0xE1 - OEM specific
Global Const $VK_OEM_102 = 0xE2
; 0xE3 - 0xE4 - OEM specific
; 0xE5
; 0xE6 - OEM specific
; 0xE7
; 0xE8 - Unassigned
; 0xE9 OEM specific
Global Const $VK_MOUSE1 = 0xF0
Global Const $VK_MOUSE2 = 0xF1
Global Const $VK_MOUSE3 = 0xF2
Global Const $VK_MOUSE4 = 0xF3
Global Const $VK_MOUSE5 = 0xF4
; 0xF6 - Unassigned
Global Const $VK_ATTN = 0xF6
Global Const $VK_CRSEL = 0xF7
Global Const $VK_EXSEL = 0xF8
Global Const $VK_EREOF = 0xF9
Global Const $VK_PLAY = 0xFA
Global Const $VK_ZOOM = 0xFB
Global Const $VK_NONAME = 0xFC
Global Const $VK_PA1 = 0xFD
Global Const $VK_OEM_CLEAR = 0xFE
#EndRegion Global Variables and Constants

; 4 Felder:  Feld1 = HexCode Taste, Feld2 = Englische Beschreibung, Feld3 = Deutsche Beschreibung, Feld4 = String wie ihn HotKeySet benötigt

;unvollständig, benötigt überarbeitung
Global $VK_LIST[255][4] = [ _
		["00","","",""]
        ["01","Left mouse button","Linke Maustaste",""], _
        ["02","Right mouse button","Rechte Maustaste = F12",""], _
        ["03","not documented","nicht dokumentiert",""], _
        ["04","Middle mouse button (three-button mouse)","Mittlere Maustaste = F12",""], _
        ["05","Windows 2000/XP: X1 mouse button","X1 Maus-Taste = F12",""], _
        ["06","Windows 2000/XP: X2 mouse button","X2 Maus-Taste = F12",""], _
        ["07","not documented","nicht dokumentiert","",""], _
        ["08","BACKSPACE key","Löschtaste rückwärts","{BACKSPACE}"], _
        ["09","TAB key","Tabulator-Taste","{TAB}"], _
        ["0C","CLEAR key","Entf-Taste","{DEL}"], _
        ["0D","ENTER key","Enter/Return-Taste","{ENTER}"], _
        ["10","SHIFT key","Shift/Umschalt/'Großschreib'-Taste",""], _
        ["11","CTRL key","Ctrl/Strg-Taste",""], _
        ["12","ALT key","Alt-Taste",""], _
        ["13","PAUSE key","Pause-Taste","{PAUSE}"], _
        ["14","CAPS LOCK key","Feststelltaste","{CAPSLOCK toggle}"], _
        ["1B","ESC key","Esc-Taste","{ESC}"], _
        ["20","SPACEBAR","Leertaste","{SPACE}"], _
        ["21","PAGE UP key","Bild-auf Taste","{PGUP}"], _
        ["22","PAGE DOWN key","Bild-ab Taste","{PGDN}"], _
        ["23","END key","Ende-Taste","{END}"], _
        ["24","HOME key","Pos 1-Taste","{HOME}"], _
        ["25","LEFT ARROW key","Pfeiltaste nach links","{LEFT}"], _
        ["26","UP ARROW key","Pfeiltaste nach oben","{UP}"], _
        ["27","RIGHT ARROW key","Pfeiltaste nach rechts","{RIGHT}"], _
        ["28","DOWN ARROW key","Pfeiltaste nach unten","{DOWN}"], _
        ["29","SELECT key","Auswahltaste",""], _
        ["2A","PRINT key","Drucktaste","{PRINTSCREEN}"], _
        ["2B","EXECUTE key","Ausführentaste",""], _
        ["2C","PRINT SCREEN key","Drucktaste","{PRINTSCREEN}"], _
        ["2D","INS key","Einfg-Taste","{INS}"], _
        ["2E","DEL key","Entf-Taste","{DEL}"], _
        ["30","0","0","0"], _
        ["31","1","1","1"], _
        ["32","2","2","2"], _
        ["33","3","3","3"], _
        ["34","4","4","4"], _
        ["35","5","5","5"], _
        ["36","6","6","6"], _
        ["37","7","7","7"], _
        ["38","8","8","8"], _
        ["39","9","9","9"], _
        ["41","A","A","a"], _
        ["42","B","B","b"], _
        ["43","C","C","c"], _
        ["44","D","D","d"], _
        ["45","E","E","e"], _
        ["46","F","F","f"], _
        ["47","G","G","g"], _
        ["48","H","H","h"], _
        ["49","I","I","i"], _
        ["4A","J","J","j"], _
        ["4B","K","K","k"], _
        ["4C","L","L","l"], _
        ["4D","M","M","m"], _
        ["4E","N","N","n"], _
        ["4F","O","O","o"], _
        ["50","P","P","p"], _
        ["51","Q","Q","q"], _
        ["52","R","R","r"], _
        ["53","S","S","s"], _
        ["54","T","T","t"], _
        ["55","U","U","u"], _
        ["56","V","V","v"], _
        ["57","W","W","w"], _
        ["58","X","X","x"], _
        ["59","Y","Y","y"], _
        ["5A","Z","Z","z"], _
        ["5B","Left Windows key","Linke Windows-Taste",""], _
        ["5C","Right Windows key","Rechte Windows-Taste",""], _
        ["60","Numeric keypad 0 key","rechter Nummerblock Taste 0","{NUMPAD0}"], _
        ["61","Numeric keypad 1 key","rechter Nummerblock Taste 1","{NUMPAD1}"], _
        ["62","Numeric keypad 2 key","rechter Nummerblock Taste 2","{NUMPAD2}"], _
        ["63","Numeric keypad 3 key","rechter Nummerblock Taste 3","{NUMPAD3}"], _
        ["64","Numeric keypad 4 key","rechter Nummerblock Taste 4","{NUMPAD4}"], _
        ["65","Numeric keypad 5 key","rechter Nummerblock Taste 5","{NUMPAD5}"], _
        ["66","Numeric keypad 6 key","rechter Nummerblock Taste 6","{NUMPAD6}"], _
        ["67","Numeric keypad 7 key","rechter Nummerblock Taste 7","{NUMPAD7}"], _
        ["68","Numeric keypad 8 key","rechter Nummerblock Taste 8","{NUMPAD8}"], _
        ["69","Numeric keypad 9 key","rechter Nummerblock Taste 9","{NUMPAD9}"], _
        ["6A","Multiply key","rechter Nummerblock Malzeichen","{NUMPADMULT}"], _
        ["6B","Add key","rechter Nummerblock Pluszeichen","{NUMPADADD}"], _
        ["6C","Separator key","rechter Nummernblock Eingabetaste","{NUMPADENTER}"], _
        ["6D","Subtract key","rechter Nummerblock Minuszeichen","{NUMPADSUB}"], _
        ["6E","Decimal key","rechter Nummerblock Kommazeichen","{NUMPADDOT}"], _
        ["6F","Divide key","rechter Nummerblock Geteiltzeichen","{NUMPADDIV}"], _
        ["70","F1","F1","{F1}"], _
        ["71","F2","F2","{F2}"], _
        ["72","F3","F3","{F3}"], _
        ["73","F4","F4","{F4}"], _
        ["74","F5","F5","{F5}"], _
        ["75","F6","F6","{F6}"], _
        ["76","F7","F7","{F7}"], _
        ["77","F8","F8","{F8}"], _
        ["78","F9","F9","{F9}"], _
        ["79","F10","F10","{F10}"], _
        ["7A","F11","F11","{F11}"], _
        ["7B","F12","F12","{F12}"], _
        ["7C","F13","F13","{F13}"], _
        ["7D","F14","F14","{F14}"], _
        ["7E","F15","F15","{F15}"], _
        ["7F","F16","F16","{F16}"], _
        ["90","NUM LOCK key","Num-Taste","{NUMLOCK toggle}"], _
        ["91","SCROLL LOCK key","Rollen-Taste","{SCROLLLOCK toggle}"], _
        ["A0","Left SHIFT key","linke Shift/Umschalt/Feststelltaste",""], _
        ["A1","Right SHIFT key","rechte Shift/Umschalt/Feststelltaste",""], _
        ["A2","Left CONTROL key","linke Ctrl/Strg-Taste",""], _
        ["A3","Right CONTROL key","rechte Ctrl/Strg-Taste",""], _
        ["A4","Left MENU key","(linke) Alt-Taste",""], _
        ["A5","Right MENU key","(rechte) Alt Gr-Taste",""] ]