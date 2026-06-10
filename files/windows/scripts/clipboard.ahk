#Requires AutoHotkey v2.0
Persistent

; Configuration
SyncDir := "C:\Sync\Clipboard"
PcFile := SyncDir "\pc_clip.txt"
AndroidFile := SyncDir "\android_clip.txt"
global LastAndroidMod := 0

; ==============================================================================
; PC to Android (Push -> Ctrl + Alt + C)
; ==============================================================================
^!c:: {
    if (A_Clipboard != "") {
        try {
            if FileExist(PcFile)
                FileDelete(PcFile)
            FileAppend(A_Clipboard, PcFile, "UTF-8")
            ToolTip "Sent to Android!"
            SetTimer () => ToolTip(), -1500
        }
    } else {
        ToolTip "Clipboard is empty or not text!"
        SetTimer () => ToolTip(), -1500
    }
}

; ==============================================================================
; Android to PC (Pull)
; ==============================================================================
SetTimer CheckAndroidClip, 1000

CheckAndroidClip() {
    global LastAndroidMod
    if FileExist(AndroidFile) {
        currentMod := FileGetTime(AndroidFile, "M")
        if (currentMod != LastAndroidMod) {
            LastAndroidMod := currentMod
            try {
                newClip := FileRead(AndroidFile, "UTF-8")
                A_Clipboard := newClip
                ToolTip "Received from Android!"
                SetTimer () => ToolTip(), -1500
            }
        }
    }
}
