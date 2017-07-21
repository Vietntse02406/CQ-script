#include <GUIConstantsEx.au3>
#include <Misc.au3>
#include <WinAPI.au3>
#include <Math.au3>
#include <Array.au3>

Opt("GUIOnEventMode", 1)

; ========== DECLARE VAR SECTION ====================================
Global $Struct = DllStructCreate($tagPoint)
$gui = GUICreate("Coord for click", 300, 33)
Global $hwnd

Global $click1
Global $click2
Global $click3
Global $click4
Global $click5

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
; ========== END VAR SECTION ====================================


; ========== GUI SECTION ====================================
$bt1 = GUICtrlCreateButton("click 1", 1, 1, 60, 30)
$bt2 = GUICtrlCreateButton("click 2", 60, 1, 60, 30)
$bt3 = GUICtrlCreateButton("click 3", 120, 1, 60, 30)
$bt4 = GUICtrlCreateButton("click 4", 180, 1, 60, 30)
$bt5 = GUICtrlCreateButton("click 5", 240, 1, 60, 30)

GUICtrlSetOnEvent($bt1, "clickButtonEvent")
GUICtrlSetOnEvent($bt2, "clickButtonEvent")
GUICtrlSetOnEvent($bt3, "clickButtonEvent")
GUICtrlSetOnEvent($bt4, "clickButtonEvent")
GUICtrlSetOnEvent($bt5, "clickButtonEvent")

GUISetOnEvent($GUI_EVENT_CLOSE, "close")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "mini")

GUISetState(@SW_SHOW, $gui)
; ========== END GUI SECTION ====================================


; ========== HOTKEY SECTION ====================================
HotKeySet("{NUMPADSUB}", "getwin")
HotKeySet("{ESC}", "close")

HotKeySet("{NUMPAD1}", "clicker")
HotKeySet("{NUMPAD2}", "clicker")
HotKeySet("{NUMPAD3}", "clicker")
HotKeySet("{NUMPAD4}", "clicker")
HotKeySet("{NUMPAD5}", "clicker")
; ========== END HOTKEY SECTION ====================================


; ========== Sleep body SECTION ====================================
While True
	Sleep(1000)
WEnd
; ========== End sleep body SECTION ====================================


; ========== FUNCTION SECTION ====================================
Func toast($text = "")
	ToolTip($text, 666, 5)
EndFunc   ;==>toast


Func clickButtonEvent()
	$id = @GUI_CtrlId
	toast("click point to set coord")
	Switch $id
		Case $bt1
			waitForClick()
			$click1 = setCoord()
			dd($click1)
			GUICtrlSetState($bt1, $GUI_DISABLE)
			toast()
		Case $bt2
			waitForClick()
			$click2 = setCoord()
			GUICtrlSetState($bt2, $GUI_DISABLE)
			toast()
		Case $bt3
			waitForClick()
			$click3 = setCoord()
			GUICtrlSetState($bt3, $GUI_DISABLE)
			toast()
		Case $bt4
			waitForClick()
			$click4 = setCoord()
			GUICtrlSetState($bt4, $GUI_DISABLE)
			toast()
		Case $bt5
			waitForClick()
			$click5 = setCoord()
			GUICtrlSetState($bt5, $GUI_DISABLE)
			toast()
	EndSwitch
EndFunc   ;==>clickButtonEvent


Func clicker()
	Local $clickCoord[2]
	Switch @HotKeyPressed
		Case "{NUMPAD1}"
			$clickCoord = $click1
		Case "{NUMPAD2}"
			$clickCoord = $click2
		Case "{NUMPAD3}"
			$clickCoord = $click3
		Case "{NUMPAD4}"
			$clickCoord = $click4
		Case "{NUMPAD5}"
			$clickCoord = $click5
	EndSwitch
	pclickArray($clickCoord)
EndFunc   ;==>clicker


Func waitForClick()
	While Not _IsPressed(01)
		Sleep(100)
	WEnd
EndFunc   ;==>waitForClick


Func getWin()
	;get window
	DllStructSetData($Struct, "x", MouseGetPos(0))
	DllStructSetData($Struct, "y", MouseGetPos(1))
	$hwnd = _WinAPI_WindowFromPoint($Struct)
	dd($hwnd)
	toast("get win ok: " & _WinAPI_GetClassName($hwnd))
	;convert default mouse pos to window mouse pos
	;_WinAPI_ScreenToClient($hwnd, $Struct)
EndFunc   ;==>getWin


Func setCoord()
	DllStructSetData($Struct, "x", MouseGetPos(0))
	DllStructSetData($Struct, "y", MouseGetPos(1))

	_WinAPI_ScreenToClient($hwnd, $Struct)

	$x = DllStructGetData($Struct, "x")
	$y = DllStructGetData($Struct, "y")

	Local $arr[2] = [$x, $y]

	Return $arr
EndFunc   ;==>setCoord

Func dd($data = "nothing here!")
	If IsArray($data) Then
		ConsoleWrite($data[0] & ":" & $data[1] & @CRLF)
	Else
		ConsoleWrite($data & @CRLF)
	EndIf
EndFunc


Func pclick($x = 0, $y = 0)
	$lParam = ($y * 65536) + ($x)
	_WinAPI_PostMessage($hwnd, $WM_LBUTTONDOWN, $MK_LBUTTON, $lParam)
	_WinAPI_PostMessage($hwnd, $WM_LBUTTONUP, 0, $lParam)
EndFunc   ;==>pclick


Func pclickArray($arr)
	$lParam = ($arr[1] * 65536) + ($arr[0])
	_WinAPI_PostMessage($hwnd, $WM_LBUTTONDOWN, $MK_LBUTTON, $lParam)
	_WinAPI_PostMessage($hwnd, $WM_LBUTTONUP, 0, $lParam)
EndFunc   ;==>pclickArray


Func close()
	Exit
EndFunc   ;==>close


Func mini()
	GUISetState(@SW_MINIMIZE)
EndFunc   ;==>mini
; ========== END FUNCTION SECTION ====================================
