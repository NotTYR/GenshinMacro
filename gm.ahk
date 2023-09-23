#InstallMouseHook
#InstallKeybdHook
#SingleInstance Force
#Persistent
#NoEnv
CoordMode Pixel
SetKeyDelay, 0

GuiX := 0
GuiY := 0
Menu, Tray, Icon, %A_ScriptDir%/images/icon.ico
Gui, Font, s10, Verdana  
Gui, Add, Button, default gDomain, Domain
Gui, Add, Button, default gMessage, Message test
Gui, Add, Button, default gParty, Party(Put Nahida as 1, Zhongli as 2)
Gui, Add, Button, default gStart, Start
Gui, Show, x%GuiX% y%GuiY% w500 h285, Genshin Macro
return

Party:
    Party()
return

Domain:
    Domain(2)
return

Message:
    Beg("Cor Lapis")
return

Start:
    Launch()
return

Beg(speciality){
    Home()
    Message("Hi")
    Sleep, 1000
    Message("I would like to take some " speciality " in your world")
    Send, {Esc}
}
Launch(){
    if not WinExist("ahk_exe GenshinImpact.exe"){
        Run, C:\Program Files\Genshin Impact\Genshin Impact game\GenshinImpact.exe
        loggedin := -1
        Loop{
            if WinExist("Genshin Impact Configuration"){
                WinActivate
                Send, {Space}
            }
            if WinExist("ahk_exe GenshinImpact.exe"){
                ; Game Launched
                WinActivate
                break
            }
        }
        ; Wait for game to load
        Loop{
            ; logged in
            ImageSearch, OutputVarX, OutputVarY, 0, 0, 1366, 768, %A_ScriptDir%\images\logout.png
            if (ErrorLevel == 0){
                loggedin := 1
                break
            }
            ; not logged in
            ImageSearch, OutputVarX, OutputVarY, 0, 0, 1366, 768, %A_ScriptDir%\images\login.png
            if (ErrorLevel == 0){
                loggedin := 0
                break
            }
        }
        if (loggedin == 0){
            Click(500, 300)
            FileRead, email, %A_ScriptDir%/username.txt
            Send, %email%
            Click(500, 360)
            FileRead, pw, %A_ScriptDir%/pw.txt
            Send, %pw%
            Click(500, 500)
        }
        Loop{
            ImageSearch, OutputVarX, OutputVarY, 0, 0, 1366, 768, %A_ScriptDir%\images\logout.png
            if (ErrorLevel == 0){
                break
            }
        }
        Loop{
            ImageSearch, OutputVarX, OutputVarY, 0, 0, 1366, 768, %A_ScriptDir%\images\logout.png
            if (ErrorLevel == 0){
                Click(600, 400)
            } else {
                break
            }
        }
        Loop{
            ImageSearch, OutputVarX, OutputVarY, 0, 0, 1366, 768, %A_ScriptDir%\images\logout.png
            if (ErrorLevel == 0){
                Click(600, 400)
                break
            }
        }
        Load()
    }
}
+p::
    MouseGetPos, mx , my
    MsgBox %mx%, %my% 
return

Party(){
    Home()
    Send, l
    Sleep, 4000
    Click(45, 720)
    Sleep, 500
    SetCursorPos(60, 600)
    Send, {WheelDown 100}
    Sleep, 500
    Click
    Click(45, 720)
    Sleep, 500
    Click(1200, 725)
    Send, {Esc}
    Load()
}

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
    if WinExist("ahk_exe GenshinImpact.exe"){
        WinActivate
        Send, {Enter}
        Click(80, 90)
        SetKeyDelay, 0
        DllCall("SetCursorPos", int, 400, int, 710)
        Click
        Send, %msg%
        Send, {Enter}
        Sleep, 500
    }
}

Domain(domain){
    HomeScreen()
    Click(465, 500)
    Sleep, 500
    Click(215, 315)
    Sleep, 1000
    SetCursorPos(1105, 240)
    Loop, %domain% {
        Send, {WheelDown 8}
    }
    Click
    Sleep, 5000
}

Home(){
    HomeScreen()
    Send, {Esc}
    Sleep, 1000
}

HomeScreen(){
    if WinExist("ahk_exe GenshinImpact.exe"){
        WinActivate
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

Click(x, y){
    SetCursorPos(x, y)
    Click
}