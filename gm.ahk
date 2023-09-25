#InstallMouseHook
#InstallKeybdHook
#SingleInstance Force
#Persistent
#NoEnv

CoordMode Pixel
SetKeyDelay, 0

Global InCoop := -1

IniRead, LocalSpeciality, %A_ScriptDir%/settings.ini, Collect, LocalSpeciality
IniRead, Ore, %A_ScriptDir%/settings.ini, Collect, Ore
IniRead, DoubleTp, %A_ScriptDir%/settings.ini, Settings, DoubleTp

width := 500
height := 150
margin := 30
Menu, Tray, Icon, %A_ScriptDir%/images/icon.ico
Gui, Font, s10, Verdana
Gui, Add, Text, x15 y15, Local Speciality
Gui, Add, DropDownList, x15 y40 w100 vLocalSpecialityChoice gLS, |Qingxin
GuiControl, Choose, LocalSpecialityChoice, |%LocalSpeciality%
Gui, Add, Text, x185 y15 w100, Ores
Gui, Add, DropDownList, x150 y40 w100 vOreChoice gO, |Cor Lapis
GuiControl, Choose, OreChoice, |%Ore%
Gui, Add, Text, x134 y0 w1 h85 0x7
Gui, Add, Text, x270 y0 w1 h150 0x7
Gui, Add, Text, x5 y85 w492 h1 0x7
Gui, Add, Button, x280 y95 default gWebhook, Webhook Settings
Gui, Add, Text, x280 y125, Double Teleport
Gui, Add, CheckBox, x390 y125 gDoubleTp vDoubleTp, 
GuiControl,, DoubleTp, %DoubleTp%
Gui, Add, Button, x350 y25 default gStart, Start(F6)
Gui, Add, Button, y100 x15 default gLaunch, Launch Game
Gui, Add, Button, y100 x175  default gClose, Close
Gui, Show, x800 y450 w%width% h%height%, Genshin Macro
CoopCheck()
return

O:
    Gui, Submit, nohide
    IniWrite, %OreChoice%, %A_ScriptDir%/settings.ini, Collect, Ore
LS:
    Gui, Submit, nohide
    IniWrite, %LocalSpecialityChoice%, %A_ScriptDir%/settings.ini, Collect, LocalSpeciality
return

DoubleTp:
    Gui, Submit, nohide
    IniWrite, %DoubleTp%, %A_ScriptDir%/settings.ini, Settings, DoubleTp
return

Close:
    ExitApp
    Gui, Submit
return


f7::
return

f6::
    Start()
return 

Start:
    Start()
return

Webhook:
    Run, %A_ScriptDir%/webhook.ahk
return

Launch:
    Launch()
return

Ore(){
    IniRead, Ore, %A_ScriptDir%/settings.ini, Collect, Ore
    Loop, 1 {
        Beg(Ore)
        Webhook("Collecting " Ore)
        if(Ore == "Cor Lapis"){
            Domain(15)
            Loop, 5{
                ZoomMap()
            }
            t := Teleport(512, 723)
            if (t == 0){
                break
            }
            Send, {a down}
            Sleep, 2300
            Send, {a up}
            Send, {w down}
            Sleep, 2250
            Send, {w up}
            Send, {e down}
            Sleep, 2000
            Send, {e up}
            Send, f
        }
    }
}

Start(){
    IniRead, LocalSpeciality, %A_ScriptDir%/settings.ini, Collect, LocalSpeciality
    IniRead, Ore, %A_ScriptDir%/settings.ini, Collect, Ore
    Party()
    Loop {
        Loop, 1 {
            if(LocalSpeciality == ""){
                break
            }
            StatueOfSeven()
            Char(1)
            JoinCoop()
            Speciality()
            LeaveCoop()
        }
        Loop, 1 {
            if(Ore == ""){
                break
            }
            StatueOfSeven()
            Char(2)
            JoinCoop()
            Ore()
            LeaveCoop()
        }
    }
}

Webhook(msg){
    IniRead, url, %A_ScriptDir%/settings.ini, Links, WebhookUrl
    Send_Msg_to_Discord(msg, url)
}

Send_Msg_to_Discord(msg,Url="webhookurl"){
   ;Default parmaeter is url of general Of my Server

   EncodedMsg := JsonReady(msg)
   
   postdata=
   (
   {
      "content": "%EncodedMsg%"
   }
   )

   WebRequest := ComObjCreate("WinHttp.WinHttpRequest.5.1")
   WebRequest.Open("POST", url, false)
   WebRequest.SetRequestHeader("Content-Type", "application/json")
   WebRequest.Send(postdata)  
}


JsonReady(msg) {
q="
dq=
(
\"
)
    msg := StrReplace(msg, q, dq) ; Replace double quote with \"
    msg := StrReplace(msg, "/", "\\/") ; Replace slash with \/
    msg := StrReplace(msg, "`n", "\n") ; Replace newline with \n
    msg := StrReplace(msg, "`r", "\r") ; Replace carriage return with \r
    msg := StrReplace(msg, "`t", "\t") ; Replace horizontal tab with \t
    msg := StrReplace(msg, "`b", "\b") ; Replace backspace with \b
    msg := StrReplace(msg, "`f", "\f") ; Replace form feed with \f
    return % msg
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
            ImageSearch, OutputVarX, OutputVarY, 1200, 100, 1350, 300, %A_ScriptDir%\images\1p.png
            if (ErrorLevel == 0){
                InCoop = 1
            } else {
                InCoop = 0
            }
        } else {
            Sleep, 1000
            ImageSearch, OutputVarX, OutputVarY, 0, 0, 1366, 768, %A_ScriptDir%\images\kicked.png
            if (ErrorLevel == 0){
                InCoop = 2
            }
        }
    }
}

LeaveCoop(){
    Webhook("Leaving Coop")
    CoopScreen()

    Click(1145, 733)
    Load()
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
        Webhook("Collecting " LocalSpeciality)
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
    increment := 0
    Loop {
        Click(x, y)
        Sleep, 1000
        ImageSearch, OutputVarX, OutputVarY, 0, 0, 100, 100, %A_ScriptDir%\images\loaded.png
        if (ErrorLevel == 0){
            tp = 0
            break
        } 
        ImageSearch, OutputVarX, OutputVarY, 0, 0, 1366, 768, %A_ScriptDir%\images\discoveredtp.png
        if (ErrorLevel == 0){
            tp = 1
            break
        } 
        else {
            ImageSearch, OutputVarX, OutputVarY, 1000, 650, 1100, 736, %A_ScriptDir%\images\undiscoveredtp.png
            if (ErrorLevel == 0){
                tp = 0
                break
            }
        }
        Send, {Esc}
        increment += 1
        if (increment > 50){
            tp = 0
            break
        }
        ; error, next loop
    } ; check if tp waypoint is unlocked
    if (tp == 1){
        Click(1200, 700)
        Load()
        Webhook("Successful Teleport")
        IniRead, DoubleTp, %A_ScriptDir%/settings.ini, Settings, DoubleTp
        if (DoubleTp == 1){
            Webhook("DoubleTp")
            Send, m
            Sleep, 2000
            Click(683, 384)
            Sleep, 1000
            Click(1200, 700)
        }
        Load()
        return 1
    } else {
        Webhook("Exception occurred when teleporting")
        Home()
        return 0
    }
}

StatueOfSeven(){
    Webhook("Teleporting to Statue of Seven")
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
    Webhook("Requesting for " speciality ".")
    Message("Hi")
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
    Webhook("Swapping to Macro Party")
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

CoopScreen(){
    Home()
    Send, {F2}
    Sleep, 1000
}

JoinCoop(){
    index := 1
    joined := 0
    Loop{
        Webhook("Joining Coop, Loop " index)
        index += 1
        Home()
        ; 5 seconds coop check
        if (index != 2){
            Loop, 50 {
                Sleep, 100
                if (InCoop == 1){
                    joined = 1
                    break
                }
            }
        }
        CoopScreen()
        ; in coop, different interface
        Sleep, 1000
        ImageSearch, OutputVarX, OutputVarY, 1000, 650, 1366, 768, %A_ScriptDir%\images\leave.png
        if (ErrorLevel == 0){
            joined = 1
            break
        }
        ; if not in coop interface spam invites
        Loop, 20{
            SetCursorPos(1145, 175)
            Click
            send {WheelDown 7}
            ; coop loading screens
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
        }
        Sleep, 1000
        ; coop loading screens
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
    }
    Webhook("Joined Coop!")
}

Message(msg){
    if WinExist("ahk_exe GenshinImpact.exe"){
        WinActivate
        Send, {Enter}
        Sleep, 2000
        Click(80, 90)
        Sleep, 500
        SetKeyDelay, 0
        DllCall("SetCursorPos", int, 400, int, 710)
        Click
        Sleep, 500
        Send, %msg%
        Send, {Enter}
        Sleep, 2000
    }
}

Domain(domain){
    Loop, 1 {
        Home()
        Send, {F1}
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
        Sleep, 4000
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