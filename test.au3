HotKeySet("1", "loop")
HotKeySet("2", "test")
HotKeySet("{ESC}", "quit")

Global $count = 0


While 1
	Sleep(1000)
WEnd

Func loop()
	$count += 1
	While True
		ToolTip("looping " & $count, 1000, 1000)
	WEnd
EndFunc

Func test()
	MsgBox(1, "Interrupt", "I'm interrupting")
EndFunc

Func quit()
	Exit
EndFunc