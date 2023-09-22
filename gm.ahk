#InstallMouseHook
#InstallKeybdHook
#SingleInstance Force
#Persistent
#NoEnv
CoordMode Pixel


+c::
    JoinCoop()
return

+p::
    MouseGetPos, mx , my
    MsgBox %mx%, %my% 
return



JoinCoop(){
    HomeScreen()
    SetCursorPos(365, 590)
    Click
    Loop, 40{
        SetCursorPos(1145, 165)
        Click
        send {WheelDown 7}
        Sleep, 500
        ImageSearch, OutputVarX, OutputVarY, 0, 0, 500, 500, %A_ScriptDir%\images\cooploading1.png
        if (ErrorLevel == 0){
            break
        }
        ImageSearch, OutputVarX, OutputVarY, 0, 0, 500, 500, %A_ScriptDir%\images\cooploading2.png
        if (ErrorLevel == 0){
            break
        }
    }
}

Message(msg){
    SetKeyDelay, 0
    DllCall("SetCursorPos", int, 400, int, 710)
    Click
    Send, %msg%
    Send, {Enter}
}


HomeScreen(){
    Loop {
        Sleep, 1000
        CoordMode Pixel
        ImageSearch, OutputVarX, OutputVarY, 0, 0, A_ScreenWidth, A_ScreenHeight, %A_ScriptDir%\images\homescreen.png
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

SetCursorPos(x, y){
    DllCall("SetCursorPos", int, x, int, y)
}