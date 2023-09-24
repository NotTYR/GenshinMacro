#InstallMouseHook
#InstallKeybdHook
#SingleInstance Force
#Persistent
#NoEnv

CoordMode Pixel
SetKeyDelay, 0


width := 500
height := 150
margin := 30
Menu, Tray, Icon, %A_ScriptDir%/images/icon.ico
Gui, +AlwaysOnTop +border +ToolWindow -SysMenu +Owner
Gui, Font, s10, Verdana
Gui, Add, Text, x15 y15, Local Speciality
Gui, Add, DropDownList, x15 y40 w100 vLocalSpecialityChoice gO, |Qingxin
Gui, Add, Text, x185 y15 w100, Ores
Gui, Add, DropDownList, x150 y40 w100 vOreChoice , |Amethyst
Gui, Add, Text, x134 y0 w1 h85 0x7
Gui, Add, Text, x270 y0 w1 h85 0x7
Gui, Add, Text, x5 y85 w492 h1 0x7
Gui, Add, Button, x360 y25 default gStart, Start
Gui, Add, Button, y100 x15 default gLaunch, Launch Game
Gui, Add, Button, y100 x175  default gClose, Close
Gui, Show, x0 y0 w%width% h%height%, Genshin Macro
Gui, +LastFound ; make the GUI the Last Found Window
WinGetPos,,, GUIWidth ; find out the width of the gui window
GuiXPos := A_ScreenWidth - GUIWidth ; find out where it should be placed based on window size and current resolution of screen
WinMove,,, %GuiXPos%, 0 ; move the windoweaseas
return

O:
    Gui, Submit, nohide
return

Close:
    ExitApp
    Gui, Submit
return

Start:
    Char(1)
    Loop, 2{
        Send, e
        Send, {a down}
        Send, {s down}
        Sleep, 1750
        Send, {a up}
        Send, {s up}
        Sleep, 4000
    }
    Loop, 2{
        Send, e
        Send, {d down}
        Sleep, 1750
        Send, {d up}
        Sleep, 4000
    }
    Send, e
return

Launch:
    Launch()
return

Speciality(){
    if(%LocalSpecialityChoice% == Qingxin){
        Domain(8)
        Loop, 5{
            ReduceMap()
        }
        Sleep, 500
        Teleport(596, 349)
        ; here
    }
}


Char(char){
    SwitchToGenshin()
    Send, %char%
    Sleep, 1000
}

ZoomMap(){
    Click(32, 300)
}

SwitchToGenshin(){
    Loop, 1 {
        if WinActive("ahk_exe GenshinImpact.exe"){
            break
        }
        if WinExist("ahk_exe GenshinImpact.exe"){
            WinActivate
        }
    }
}

ReduceMap(){
    Click(32, 461)
}

Teleport(x, y){
    Click(x, y)
    Sleep, 1000
    Click(1200, 700)
    Load()
}

StatueOfSeven(){
    Home()
    Send, m
    Sleep, 2000
    Click(1150, 30)
    Sleep, 1000
    Loop, 5{
        ReduceMap()
    }
    Sleep, 500
    Teleport(292, 301)
    Char(1)
    Send, {s down}
    Sleep, 1600
    Send, {s up}
}

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
    Sleep, 500
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
}

GuiClose:
    ExitApp

f9::
    ExitApp

SetCursorPos(x, y){
    DllCall("SetCursorPos", int, x, int, y)
}

Click(x, y){
    SetCursorPos(x, y)
    Click
}