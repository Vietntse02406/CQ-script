#include <WinAPI.au3>
#include <GUIConstantsEx.au3>
#include <Math.au3>
#include <Misc.au3>
_Singleton("CQConfirmRetry.au3", 0)

Global $Struct = DllStructCreate($tagPoint)
Global $hwnd,$x,$y
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

If $CmdLine[0] > 0 Then
	$hwnd = $CmdLine[1]
	Local $clickCoord[4] = [$CmdLine[2], $CmdLine[3], $CmdLine[4], $CmdLine[5]]
	loopConfirmRetry($clickCoord)
Else
	Sleep(1000)
EndIf


Func loopConfirmRetry($clickCoord)
   While(True)
	  Sleep(3500)
	  pclick($clickCoord[0], $clickCoord[1])
	  Sleep(3500)
	  pclick($clickCoord[2], $clickCoord[3])
   Wend
EndFunc

Func tuclick()
   pclick($x, $y)
EndFunc

Func Pos()
   DllStructSetData($Struct, "x", MouseGetPos(0))
   DllStructSetData($Struct, "y", MouseGetPos(1))
EndFunc   ;==>Pos

Func pclick($x=0,$y=0)
   $lParam = ($y * 65536) + ($x)
   _WinAPI_PostMessage($hwnd, $WM_LBUTTONDOWN, $MK_LBUTTON,$lParam)
   _WinAPI_PostMessage($hwnd, $WM_LBUTTONUP, 0,$lParam)
EndFunc

Func thoat()
   Exit
EndFunc
