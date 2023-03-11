#InstallMouseHook
#InstallKeybdHook
#SingleInstance Force
#Persistent
#NoEnv

+p::
    MouseGetPos, x, y
    MsgBox %x%,%y%
return

+q::
    Loop {
        ImageSearch, OutputVarX, OutputVarY, 1200, 400, 1366, 768, %A_ScriptDir%\images\loaded.png
        if (ErrorLevel == 0){
            break
        }
        DllCall("SetCursorPos", int, 1070, int, 575)
        Click
    }
    run, https://www.youtube.com/watch?v=zsB6Iqjf8Qo
    Sleep, 5000
    Send, ^{w}
return

^n::
    Toggle := !Toggle
     While Toggle{
        Click
        Send, r
        Send, r 
    }
return

^k::
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