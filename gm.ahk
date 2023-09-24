#InstallMouseHook
#InstallKeybdHook
#SingleInstance Force
#Persistent
#NoEnv

CoordMode Pixel
SetKeyDelay, 0

Global InCoop := -1

IniRead, LocalSpeciality, %A_ScriptDir%/settings.ini, Collect, LocalSpeciality

width := 500
height := 150
margin := 30
Menu, Tray, Icon, %A_ScriptDir%/images/icon.ico
Gui, Font, s10, Verdana
Gui, Add, Text, x15 y15, Local Speciality
Gui, Add, DropDownList, x15 y40 w100 vLocalSpecialityChoice gO, |Qingxin
GuiControl, Choose, LocalSpecialityChoice, |%LocalSpeciality% ; select the second item
Gui, Add, Text, x185 y15 w100, Ores
Gui, Add, DropDownList, x150 y40 w100 vOreChoice gO, |Amethyst
Gui, Add, Text, x134 y0 w1 h85 0x7
Gui, Add, Text, x270 y0 w1 h150 0x7
Gui, Add, Text, x5 y85 w492 h1 0x7
Gui, Add, Text, x280 y105 w110 vCoopCheck, Coop Check: -1
Gui, Add, Button, x400 y90 default gJoinCoop, Join Coop
Gui, Add, Button, x395 y120 default gLeaveCoop, Leave Coop
Gui, Add, Button, x350 y25 default gStart, Start(F6)
Gui, Add, Button, y100 x15 default gLaunch, Launch Game
Gui, Add, Button, y100 x175  default gClose, Close
Gui, Show, x800 y450 w%width% h%height%, Genshin Macro
CoopCheck()
return

O:
    Gui, Submit, nohide
    IniWrite, %LocalSpecialityChoice%, %A_ScriptDir%/settings.ini, Collect,LocalSpeciality
return

Close:
    ExitApp
    Gui, Submit
return

return
f6::
    Start()
return 

Start:
    Start()
return

LeaveCoop:
    LeaveCoop()
return

Launch:
    Launch()
return

Start(){
    Loop {
        StatueOfSeven()
        Party()
        Char(1)
        JoinCoop()
        Speciality()
        LeaveCoop()
    }
}

CoopSend(send) {
    SwitchToGenshin()
    if (InCoop != 2){
        Send, %send%
        return 1
    } else {
        return 0
    }
}

CoopFunc(funcName, param1:="", param2:="", param3:="")
{
    SwitchToGenshin()
    if (InCoop != 2){
        if IsFunc(funcName)
            if (param3 == ""){
                if(param2 == ""){
                    if(param1 ==""){
                        %funcName%()
                    } else{
                        %funcName%(param1)
                    }
                } else {
                    %funcName%(param1, param2)
                }
            } else {
                %funcName%(param1, param2, param3)
            }
        ; coop check
        return 1
    } else {
        return 0
    }
}

CoopCheck(){
    Loop{
        Sleep, 1000
        ImageSearch, OutputVarX, OutputVarY, 0, 0, 100, 100, %A_ScriptDir%\images\loaded.png
        if (ErrorLevel == 0){
            Sleep, 1000
            ImageSearch, OutputVarX, OutputVarY, 230, 30, 300, 70, %A_ScriptDir%\images\2p.png
            if (ErrorLevel == 0){
                GuiControl, Text, CoopCheck, Coop Check: 1
                InCoop = 1
            } else {
                GuiControl, Text, CoopCheck, Coop Check: 0
                InCoop = 0
            }
        } else {
            Sleep, 1000
            ImageSearch, OutputVarX, OutputVarY, 0, 0, 1366, 768, %A_ScriptDir%\images\kicked.png
            if (ErrorLevel == 0){
                GuiControl, Text, CoopCheck, Coop Check: 2
                InCoop = 2
            }
        }
    }
}

LeaveCoop(){
    HomeScreen()
    SetCursorPos(365, 590)
    Click
    Sleep, 1000
    Click(1145, 733)
}

Load(){
    Loop {
        ImageSearch, OutputVarX, OutputVarY, 0, 0, 100, 100, %A_ScriptDir%\images\loaded.png
        if (ErrorLevel == 0){
            break
        }
    }
}


Speciality(){
    IniRead, LocalSpeciality, %A_ScriptDir%/settings.ini, Collect, LocalSpeciality
    Loop, 1{
        Beg(LocalSpeciality)
        if(%LocalSpeciality% == Qingxin){
            Domain(8)
            Loop, 5{
                c := CoopFunc(ReduceMap())
                if (c == 0){
                    break
                }
            }
            Sleep, 500
            t := Teleport(596, 349)
            if (t == 1){
                Char(1)
                Loop, 1{
                    c := CoopSend("{a down}")
                    if (c == 0){
                        Send, {a up}
                        break
                    }
                    c := CoopSend("{s down}")
                    if (c == 0){
                        Send, {s up}
                        break
                    }
                    Sleep, 2000
                    Send, {a up}
                    Send, {s up}
                    c := CoopSend("e")
                    if (c == 0){
                        break
                    }
                    c := CoopSend("{d down}")
                    if (c == 0){
                        Send, {d up}
                        break
                    }
                    Sleep, 4000
                    Send, {d up}
                    Sleep, 1500
                    Send, e
                }
                return
            } else {
                ; no tp waypoint
                return 0
            }
        }
    }
}

CheckIfKicked(){
    ImageSearch, OutputVarX, OutputVarY, 0, 0, 1366, 768, %A_ScriptDir%\images\kicked.png
    if (ErrorLevel == 0){
        return 1
    } 
}


Char(char){
    SwitchToGenshin()
    Send, %char%
    Sleep, 1000
}

ZoomMap(){
    SwitchToGenshin()
    Click(32, 300)
}

SwitchToGenshin(){
    if WinExist("ahk_exe GenshinImpact.exe"){
        WinActivate
    }
}

ReduceMap(){
    SwitchToGenshin()
    Click(32, 461)
}

Teleport(x, y){
    tp := -1
    Loop {
        Click(x, y)
        Sleep, 2000
        ImageSearch, OutputVarX, OutputVarY, 1000, 650, 1100, 768, %A_ScriptDir%\images\discoveredtp.png
        if (ErrorLevel == 0){
            tp = 1
            break
        } 
        else {
            ImageSearch, OutputVarX, OutputVarY, 1000, 650, 1100, 768, %A_ScriptDir%\images\undiscoveredtp.png
            if (ErrorLevel == 0){
                tp = 0
                break
            }
        }
        Send, {Esc}
        ; error, next loop
    } ; check if tp waypoint is unlocked
    if (tp == 1){
        Click(1200, 700)
        Load()
        return 1
    } else {
        Home()
        return 0
    }
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
    } else {
        if WinExist("ahk_exe GenshinImpact.exe"){
            WinActivate
        }
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
    joined := 0
    Loop{
        HomeScreen()
        SetCursorPos(365, 590)
        Click
        Loop, 15{
            SetCursorPos(1145, 175)
            Click
            send {WheelDown 7}
            Sleep, 500
            ImageSearch, OutputVarX, OutputVarY, 0, 0, 500, 500, %A_ScriptDir%\images\cooploading1.png
            if (ErrorLevel == 0){
                joined = 1
                break
            }
            ImageSearch, OutputVarX, OutputVarY, 0, 0, 500, 500, %A_ScriptDir%\images\cooploading2.png
            if (ErrorLevel == 0){
                joined = 1
                break
            }
            if (InCoop == 1){
                joined = 1
                break
            }
        }
        if (joined == 1){
            break
        }
    }
}

Message(msg){
    if WinExist("ahk_exe GenshinImpact.exe"){
        WinActivate
        Send, {Enter}
        Sleep, 1000
        Click(80, 90)
        SetKeyDelay, 0
        DllCall("SetCursorPos", int, 400, int, 710)
        Click
        Send, %msg%
        Send, {Enter}
        Sleep, 1000
    }
}

Domain(domain){
    Loop, 1 {
        HomeScreen()
        c := CoopFunc(Click(465, 500))
        if (c == 0){
            break
        }
        Sleep, 2000
        c := CoopFunc(Click(215, 315))
        if (c == 0){
            break
        }
        Sleep, 2000
        c := CoopFunc(SetCursorPos(1105, 240))
        if (c == 0){
            break
        }
        Loop, %domain% {
            Send, {WheelDown 8}
        }
        Sleep, 500
        Click
        Sleep, 5000
    }
}

Home(){
    if WinExist("ahk_exe GenshinImpact.exe"){
        WinActivate
        Loop {
            Sleep, 1000
            CoordMode Pixel
            ImageSearch, OutputVarX, OutputVarY, 0, 0, 100, 100, %A_ScriptDir%\images\loaded.png
            if (ErrorLevel == 0){
                break
            }
            Send, {Esc}
            if(InCoop == 2){
                return -1
                break
            } 
        }
    }
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
            if(InCoop == 2){
                return -1
                break
            } 
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