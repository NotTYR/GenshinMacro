#InstallMouseHook
#InstallKeybdHook
#SingleInstance Force
#Persistent
#NoEnv

Loop {
    AssistedTp()
    AssistedQuest()
}

AssistedQuest(){
    ImageSearch, OutputVarX, OutputVarY, 0, 0, 100, 100, %A_ScriptDir%\images\quest1.png
    if (ErrorLevel == 0){
        Loop {
            ImageSearch, OutputVarX, OutputVarY, 1200, 400, 1366, 768, %A_ScriptDir%\images\loaded.png
            if (ErrorLevel == 0){
                break
            }
            DllCall("SetCursorPos", int, 1070, int, 575)
            Click
        }
    }
    ImageSearch, OutputVarX, OutputVarY, 0, 0, 100, 100, %A_ScriptDir%\images\quest2.png
    if (ErrorLevel == 0){
        Loop {
            ImageSearch, OutputVarX, OutputVarY, 1200, 400, 1366, 768, %A_ScriptDir%\images\loaded.png
            if (ErrorLevel == 0){
                break
            }
            DllCall("SetCursorPos", int, 1070, int, 575)
            Click
        }
    }
}

AssistedTp(){
    ImageSearch, OutputVarX, OutputVarY, 1150, 670, 1240, 740, %A_ScriptDir%\images\tp.png
    if (ErrorLevel == 0){
        DllCall("SetCursorPos", int, 1170, int, 695)
        Click
    }
}

+p::
    MouseGetPos, x, y
    MsgBox %x%,%y%
return

return

^n::
    Toggle := !Toggle
     While Toggle{
        Send, r
        Click
        Send, r
    }
return

k::
    Toggle := !Toggle
    While Toggle{
	    Suspend
    }
return

Load(){
    Loop {
        ImageSearch, OutputVarX, OutputVarY, 0, 0, 1366, 768, %A_ScriptDir%\images\loaded.png
        if (ErrorLevel == 0){
            break
        }
    }
    MsgBox loaded
}

f9::
ExitApp