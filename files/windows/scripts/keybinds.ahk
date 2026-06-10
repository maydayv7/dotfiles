#Requires AutoHotkey v2.0

; ==============================================================================
; Keybinds
; ==============================================================================

; Win + Shift + Q: Force quit
#+q::
{
    activePID := WinGetPID("A")
    ProcessClose(activePID)
}

; ==============================================================================
; Horizontal Scrolling (Shift + Scroll)
; ==============================================================================
; Shift + Scroll Up: Scroll Left
+WheelUp::
{
    Send "{WheelLeft}"
}

; Shift + Scroll Down: Scroll Right
+WheelDown::
{
    Send "{WheelRight}"
}

; ==============================================================================
; Window Transparency Control (Ctrl + Shift + Scroll)
; ==============================================================================
^+WheelUp:: {
    MouseGetPos(, , &win)

    try {
        Trans := WinGetTransparent(win)
    } catch {
        return
    }

    if (Trans = "")
        Trans := 255

    newTrans := Trans + 15

    if (newTrans > 255)
        newTrans := 255

    WinSetTransparent(newTrans, win)
}

^+WheelDown:: {
    MouseGetPos(, , &win)

    try {
        Trans := WinGetTransparent(win)
    } catch {
        return
    }

    if (Trans = "")
        Trans := 255

    newTrans := Trans - 15

    if (newTrans < 75)
        newTrans := 75

    WinSetTransparent(newTrans, win)
}

; ==============================================================================
; App Window Switcher (Alt + Grave)
; ==============================================================================
!`:: {
    active_pid := WinGetPID("A")
    active_exe := WinGetProcessName("A")
    win_list := WinGetList("ahk_exe " active_exe)

    if (win_list.Length < 2)
        return

    for i, hwnd in win_list {
        if (hwnd = WinGetID("A")) {
            next_index := (i = win_list.Length) ? 1 : i + 1
            WinActivate(win_list[next_index])
            break
        }
    }
}
