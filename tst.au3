;Sleep(5000)

;ConsoleWrite (Hex(PixelGetColor(979, 707)))

Global $ARR[2] = [1, 1]

Global $ARR2[2] = [2, 2]

$ARR2 = $ARR

$ARR[1] = 3

MsgBox(0, "", $ARR2[1] & "  " & $ARR[1])
    