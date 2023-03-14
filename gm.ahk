#InstallMouseHook
#InstallKeybdHook
#SingleInstance Force
#Persistent
#NoEnv

Launch()
Loop {
    AssistedQuest()
}

Message(msg){
    SetKeyDelay, 0
    DllCall("SetCursorPos", int, 400, int, 710)
    Click
    Send, % msg
    Send, {Enter}
}

Online(){
    ImageSearch, OutputVarX, OutputVarY, 270, 130, 340, 160, %A_ScriptDir%\images\online.png
    if (ErrorLevel == 0){
        DllCall("SetCursorPos", int, 1225, int, 125)
        Click
        Sleep, 500
        Message("hello")
    }
}

HomeScreen(){
    Loop {
        Sleep, 1000
        ImageSearch, OutputVarX, OutputVarY, 0, 0, 500, 500, %A_ScriptDir%\images\homescreen.png
        if (ErrorLevel == 0){
            break
        }
        Send, {Esc} 
    }
}

Launch(){
    if not WinExist("ahk_exe GenshinImpact.exe"){
        Send,{LWin down}
        Send,s
        Send,{LWin up}
        Sleep, 500
        Send, Genshin
        Sleep, 500
        Send, {Enter}
        Loop {
            ImageSearch, OutputVarX, OutputVarY, 0, 0, 1366, 768, %A_ScriptDir%\images\launch.png
            if (ErrorLevel == 0){
                DllCall("SetCursorPos", int, OutputVarX, int, OutputVarY)
                Click
                break
            }
        }
        Loop {
            ImageSearch, OutputVarX, OutputVarY, 0, 0, 1366, 768, %A_ScriptDir%\images\configuration.png
            if (ErrorLevel == 0){
                Send, {Enter}
            }
            ImageSearch, OutputVarX, OutputVarY, 0, 0, 1366, 768, %A_ScriptDir%\images\logout.png
            if (ErrorLevel == 0){
                DllCall("SetCursorPos", int, 300, int, 300)
                Click
                break
            }
        }
        Sleep, 1000
        Loop {
            ImageSearch, OutputVarX, OutputVarY, 0, 0, 1366, 768, %A_ScriptDir%\images\wrench.png
            if (ErrorLevel == 0){
                DllCall("SetCursorPos", int, 300, int, 300)
                Click
                break
            }
        }
    }
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

+p::
    MouseGetPos, x, y
    MsgBox %x%,%y%
return

return

^n::
    SetKeyDelay, 50
    Toggle := !Toggle
     While Toggle{
        Click
        Send, rrrr
    }
return

k::
    Toggle := !Toggle
    While Toggle{
	    Suspend
    }
return

+h::
    Online()
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