#include <WinAPI.au3>
#include <GUIConstantsEx.au3>
#include <Math.au3>
#include <Array.au3>
#include <Misc.au3>

Global $Struct = DllStructCreate($tagPoint)
Global $hwnd, $stop = False, $x, $y
Global $pid
Global $index = 0
;						spam     - retry   - confirm
Global $clickCoord[6] = [531, 430, 408, 358, 333, 389]
Const $WM_MOUSEMOVE = 0x200
Const $WM_LBUTTONDOWN = 0x201
Const $WM_LBUTTONUP = 0x202
Const $WM_MBUTTONDOWN = 0x207
Const $WM_MBUTTONUP = 0x208
Const $WM_RBUTTONDOWN = 0x204
Const $WM_RBUTTONUP = 0x205
Const $WM_NCLBUTTONDOWN = 0xA1
Const $WM_LBUTTONDBLCLK = 0x203
Const $WM_MBUTTONDBLCLK = 0x209
Const $WM_RBUTTONDBLCLK = 0x206
Const $MK_LBUTTON = 0x1
Const $MK_MBUTTON = 0x10
Const $MK_RBUTTON = 0x2

HotKeySet("^0", "thoat")
;HotKeySet("{NUMPADSUB}", "batdau")
;HotKeySet("{NUMPADMULT}", "pause")
HotKeySet("^-", "batdau")
HotKeySet("^=", "pause")
HotKeySet("{F9}", "setCoord")
huongdan("Numpad - to Start/Pause, Ctrl 0 to quit!")



While 1
	Sleep(1000)
WEnd

Func batdau()
	ToolTip("")
	Pos()
	$hwnd = _WinAPI_WindowFromPoint($Struct)
	_WinAPI_ScreenToClient($hwnd, $Struct)
	;run confirm and retry script
	$command = '" /AutoIt3ExecuteScript "CQConfirmRetry.au3" ' & $hwnd & " " & $clickCoord[2] & " " & $clickCoord[3] & " " & $clickCoord[4] & " " & $clickCoord[5]
	$pid = Run('"' & @AutoItExe & $command, "", @SW_HIDE)
	$stop = False
	$cls=_WinAPI_GetClassName($hwnd)

	While (True)
		;spam block
		pclick($clickCoord[0], $clickCoord[1])
		Sleep(1000)
		If ($stop) Then
			ExitLoop
		EndIf
	WEnd
;~    Else
;~ 	  huongdan("Paused, F9 to resume")
;~ 	  killOther()
;~ 	  While(True)
;~ 		 Sleep(1000)
;~ 	  WEnd
;~    EndIf
EndFunc   ;==>batdau


Func huongdan($string)
	ToolTip($string, 666, 5)
EndFunc   ;==>huongdan

Func tuclick()
	pclick($x, $y)
EndFunc   ;==>tuclick

;get default mouse pos -> save to struct
Func Pos()
	DllStructSetData($Struct, "x", MouseGetPos(0))
	DllStructSetData($Struct, "y", MouseGetPos(1))
EndFunc   ;==>Pos

Func setCoord()
	Pos()
	;get window
	$hwnd = _WinAPI_WindowFromPoint($Struct)
	;convert default mouse pos to window mouse pos
	_WinAPI_ScreenToClient($hwnd, $Struct)
	;get x, y from struct, set to global var
	$x = DllStructGetData($Struct, "x")
	$y = DllStructGetData($Struct, "y")
	ConsoleWrite(@CRLF)
	ConsoleWrite($x & " | " & $y)
	If $index < 5 Then
		$clickCoord[$index] = $x
		$index += 1
		$clickCoord[$index] = $y
		$index += 1
		If $index == 6 Then
			MsgBox(1, "OK", "Finish setting coord" & @CRLF & "Spam Coord: " & $clickCoord[0] & "-" & $clickCoord[1] & @CRLF & "Confirm Coord: "  & $clickCoord[4] & "-" & $clickCoord[5] & @CRLF & "Retry Coord: " & $clickCoord[2] & "-" & $clickCoord[3])
		EndIf
	Else
		MsgBox(1, "OK", "Finish setting coord" & @CRLF & "Spam Coord: " & $clickCoord[0] & "-" & $clickCoord[1] & @CRLF & "Confirm Coord: "  & $clickCoord[4] & "-" & $clickCoord[5] & @CRLF & "Retry Coord: " & $clickCoord[2] & "-" & $clickCoord[3])
	EndIf
	;GUICtrlSetData($tdx,$x)
	;GUICtrlSetData($tdy,$y)
	;$cls=_WinAPI_GetClassName($hwnd)
EndFunc   ;==>getwin

;click
Func pclick($x = 0, $y = 0)
	$lParam = ($y * 65536) + ($x)
	_WinAPI_PostMessage($hwnd, $WM_LBUTTONDOWN, $MK_LBUTTON, $lParam)
	_WinAPI_PostMessage($hwnd, $WM_LBUTTONUP, 0, $lParam)
EndFunc   ;==>pclick

;kill confirm and retry script
Func killOther()
	ProcessClose($pid)
EndFunc   ;==>killOther

Func pause()
	$stop = True
	killOther()
EndFunc ;==>pressConfirm

Func thoat()
	killOther()
	Exit
EndFunc   ;==>thoat
