#InstallMouseHook
#InstallKeybdHook
#SingleInstance Force
#Persistent
#NoEnv

~n::
    Toggle := !Toggle
     While Toggle{
        Click
        Send, r
        Sleep, 50
        Send, r
    }
return

~k::
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