#include <WinAPI.au3>
#include <GUIConstantsEx.au3>
#include <Math.au3>
#include <Array.au3>

Global $Struct = DllStructCreate($tagPoint)
Global $hwnd,$hien=True,$chay=False,$button,$x,$y
Global $pid;
Const $WM_MOUSEMOVE= 0x200
Const $WM_LBUTTONDOWN   = 0x201
Const $WM_LBUTTONUP    = 0x202
Const $WM_MBUTTONDOWN  = 0x207
Const $WM_MBUTTONUP    = 0x208
Const $WM_RBUTTONDOWN  = 0x204
Const $WM_RBUTTONUP    = 0x205
Const $WM_NCLBUTTONDOWN  = 0xA1
Const $WM_LBUTTONDBLCLK  = 0x203
Const $WM_MBUTTONDBLCLK  = 0x209
Const $WM_RBUTTONDBLCLK  = 0x206
Const $MK_LBUTTON = 0x1
Const $MK_MBUTTON = 0x10
Const $MK_RBUTTON = 0x2

HotKeySet("^0","thoat")
HotKeySet("{NUMPADSUB}","getwin")
HotKeySet("{NUMPADMULT}", "pressRetry")
HotKeySet("{NUMPADDIV}", "pressConfirm")
huongdan("Numpad - to Start/Pause, Ctrl 0 to quit!")

While 1
	Sleep(1000)
WEnd

Func batdau()
	  ToolTip("")
	  ;run confirm and retry script
	  $command = '" /AutoIt3ExecuteScript "CQConfirmRetry.au3" ' & $hwnd
	  $pid = Run('"' & @AutoItExe & $command, "", @SW_HIDE)

	  While(True)
		 ;auto click
		 pclick(531, 430);spam block
		 Sleep(1000)
	  Wend
;~    Else
;~ 	  huongdan("Paused, F9 to resume")
;~ 	  killOther()
;~ 	  While(True)
;~ 		 Sleep(1000)
;~ 	  WEnd
;~    EndIf
EndFunc

Func huongdan($string)
   ToolTip($string,666,5)
EndFunc

Func tuclick()
   pclick($x,$y)
EndFunc

Func setClickPos()

EndFunc

;get default mouse pos -> save to struct
Func Pos()
   DllStructSetData($Struct, "x", MouseGetPos(0))
   DllStructSetData($Struct, "y", MouseGetPos(1))
EndFunc

Func getwin()
   Pos()
   ;get window
   $hwnd = _WinAPI_WindowFromPoint($Struct)
   ;convert default mouse pos to window mouse pos
   _WinAPI_ScreenToClient($hwnd,$Struct)
   ;get x, y from struct, set to global var
   $x=DllStructGetData($Struct,"x")
   $y=DllStructGetData($Struct,"y")
   ;GUICtrlSetData($tdx,$x)
   ;GUICtrlSetData($tdy,$y)
   ;$cls=_WinAPI_GetClassName($hwnd)
   $chay = Not $chay
   batdau()
EndFunc

;click
Func pclick($x=0,$y=0)
   $lParam = ($y * 65536) + ($x)
   _WinAPI_PostMessage($hwnd, $WM_LBUTTONDOWN, $MK_LBUTTON,$lParam)
   _WinAPI_PostMessage($hwnd, $WM_LBUTTONUP, 0,$lParam)
EndFunc

;kill confirm and retry script
Func killOther()
	ProcessClose($pid)
EndFunc

Func pressRetry()
   pclick(333, 389)
EndFunc

Func pressConfirm()
   pclick(408, 358)
EndFunc

Func thoat()
   killOther()
   Exit
EndFunc
