#InstallMouseHook
#InstallKeybdHook
#SingleInstance Force
#Persistent
#NoEnv


#Include %A_ScriptDir%/instructions.ahk

SetKeyDelay, 0
CoordMode Pixel

IniRead, LocalSpeciality, %A_ScriptDir%/settings.ini, Collect, LocalSpeciality
IniRead, Ore, %A_ScriptDir%/settings.ini, Collect, Ore
IniRead, Character, %A_ScriptDir%/settings.ini, Settings, Character

width := 200
height := 250
Menu, Tray, Icon, %A_ScriptDir%/images/icon.ico
Gui, Font, s10, Verdana
Gui, Add, Tab3, x0 y-1 w%width% h%height%, Notice|Macro
Gui, Tab, Notice
Gui, Add, Text, x10 y30 w180 ,Create a team in the last slot of your party, consisting of:
Gui, Add, Text, x10 y80,1. Nahida(local specialities)
Gui, Add, Text, x10 y100,2. Zhongli(ores)
Gui, Add, Text, x10 y120, 3. Yelan(birds)
Gui, Add, Text, x10 y140,4. Sayu/Yaoyao(crystalfly)
Gui, Tab, Macro
Gui, Add, Button, default gLaunch, Launch Game
Gui, Add, Button, default gStart, Start(F6)
Gui, Add, Button, default gDebug, Debug(F8)
Gui, Add, Text, ,press F9 to stop macro =D
Gui, Show, x800 y450 w%width% h%height%, Genshin Macro
return

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

f8::
    Debug()
return

Debug:
    Debug()
return

Debug(){
    Genshin()
    PixelGetColor, c, 1075, 720
    MsgBox % c
}

Start:
    Start()
return

Start(){
    Webhook("Switching to Coop Party")
    Loop{
        e := ExecuteInstructions("start")
        if(e != -1){
            break
        }
    }
    Webhook("Teleporting to Statue of 7")
    Loop{
        e := ExecuteInstructions("local")
        if(e != -1){
            break
        }
    }
    Loop{
        Webhook("Swapping to Nahida")
        Send, 1
        JoinCoop()
        Message("Hi I want to take some mushrooms from Sumeru")
        ExecuteInstructions("mushroom")
        LeaveCoop()
        Webhook("Swapping to Nahida")
        Send, 1
        JoinCoop()
        Message("Hi I want to take some lotuses from Sumeru")
        ExecuteInstructions("lotus")
        LeaveCoop()
    }
}

JoinCoop(){
    Webhook("Joining Coop")
    Genshin()
    Loop {
        if(InCoop() = 1){
            Webhook("Joined Coop")
            return
        }
        Send, {F2}
        ; wait for coop screen to load.
        Loop {
            ;safe?
            PixelGetColor, c, 1233, 721
            if(c = "0x8EBCD3"){  
                Webhook("screen loaded")
                break
            }
            if(c = "0x221C1C" || c = "0xFFFFFF"){
                ; coop screen
                Webhook("Joining Coop")
                return
            }
            PixelSearch, Px, Py, 1050, 700, 1100, 750, 0xdd9d38, 3, Fast
            if ErrorLevel
                Sleep, 100
            else
                Webhook("Joined Coop")
                return
            if(InCoop() = 1){
                Webhook("Joined Coop")
                return
            }
        }
        ;requests
        Webhook("Sending Coop Requests")
        SetCursorPos(1160, 630)
        Send, {WheelDown 350}
        Loop, 44{
            ; safe code
            PixelGetColor, c, 1233, 721
            if(c = "0x8EBCD3"){
                Click
                Send, {WheelUp 7}
            } else {
                Webhook("breaking loop")
                break
            }
        }
        Webhook("Returning to Home Screen")
        ; coop screen loading/coop screen
        Send, {Esc}
        Loop, {
            if(Kicked() = 1){
                Webhook("Kicked")
                return
            }
            if(c = "0x221C1C" || c = "0xFFFFFF"){
                ; coop screen
                Webhook("Join Request Accepted!")
                Loop{
                    if(Kicked() = 1){
                        Webhook("Kicked")
                        return
                    }
                    if(Loaded() = 1){
                        Webhook("Loaded")
                        return
                    }
                }
            }
            if(InCoop() = 1){
                Webhook("Joined Coop")
                return
            }
            if(FullScreenCheck() = 1){
                Webhook("Home Screen Detected")
                break
            }
            Sleep, 500
        }
    }
}

Turn(xdeg, ydeg=0){
    Genshin()
    SetMouseDelay -1  
    DllCall("mouse_event", "UInt", 0x01, "UInt", 3700 * xdeg / 360, "UInt", 3700 * ydeg / -360)
}

Dead(){
    SetCursorPos(0,0)
    PixelSearch, Px, Py, 600, 730, 630, 740, 0xc8d3df, 3, Fast
    if ErrorLevel
        return 0
    else
        Webhook("Player Dead")
        return 1
}


LeaveCoop(){
    Webhook("Leaving Coop")
    ; function ends when in own world
    ; very slacky coop leaving without checking for various cases haaha
    Genshin()
    Loop, {
        if(FullScreenCheck() = 1){
            break
        }
        Send, {Esc}
        Sleep, 1500
    }
    ; home screen
    if(InCoop() = 0){
        return
    }
    Send, {F2}
    Sleep, 2000
    Click(1074, 719)
    ; back to own world
    Loop, {
        if(Loaded() = 1 || FullScreenCheck() = 1){
            break
        }
        Send, {Esc}
        Sleep, 1500
    }
}

;0x221C1C coopscreen1
;0xFFFFFF coopscreen2

Message(message){
    Genshin()
    ;message. Assume that this would be sent at the start and would be at homescreen.
    ; no kick detection because this is not a loop
    Send, {Enter}
    Sleep, 1000
    SetCursorPos(50, 250)
    Send, {WheelUp 100}
    Sleep, 500
    Click(80, 100)
    Sleep, 1000
    Click(300, 715)
    Sleep, 500
    SetKeyDelay, 0
    Send, %message%
    Sleep, 500
    Send, {Enter}
    Sleep, 1000
    Send, {Esc}
    Sleep, 500
}


ExecuteInstructions(key){
    ; no forever loops are allowed to prevent exceptions
    Genshin()
    instructions := GetInstructions(key)
    domain := instructions[1]
    for k,instruction in instructions {
        if(instruction != domain){
            ; not the first instruction
            if(SubStr(instruction, 1, 2) = "mw" || SubStr(instruction, 1, 2) = "ma" || SubStr(instruction, 1, 2) = "ms" || SubStr(instruction, 1, 2) = "md"){
                ;movement
                if(Dead() = 1){
                    Click(625, 725)
                    Loop{
                        if(FullScreenCheck() = 1){
                            break
                        }
                    }
                    Sleep, 1000
                    return -1
                }
                duration := SubStr(instruction, 3)
                key := SubStr(instruction, 2, 1)
                Send, % "{" key " down}"
                start_time := A_TickCount
                end_time := start_time + duration
                while (A_tickcount < end_time)
                {
                    if (Kicked() = 1){
                        return -1
                        Send, % "{" key " up}"
                    }
                    if(Dead() = 1){
                        Click(625, 725)
                        Loop{
                            if(FullScreenCheck() = 1){
                                break
                            }
                        }
                        Sleep, 1000
                        return -1
                    }
                    Sleep, 100
                }
                Send, % "{" key " up}"
            }
            if(instruction = "dtp"){
                ; series of clicks and inputs, no loops
                Send, m
                Sleep, 2500
                Click(683, 384)
                Sleep, 500
                Click(1200,700)
                Loop{
                    if(FullScreenCheck() = 1){
                        break
                    }
                    if(Dead() = 1){
                        Click(625, 725)
                        Loop{
                            if(FullScreenCheck() = 1){
                                break
                            }
                        }
                        Sleep, 1000
                        return -1
                    }
                    Send, {Esc}
                    Sleep, 1000
                }
                Sleep, 500
            }
            if(SubStr(instruction, 1, 1) = "t"){
                if(SubStr(instruction, 2, 1) != "p"){
                    RegExMatch(instruction, "[0-9]+", x)
                    rx := SubStr(instruction, 2) ; -180,-30. can also be 180,-30
                    if(SubStr(rx, 1, StrLen(x)) != x){
                        x := -1 * x
                    }
                    y := SubStr(instruction, StrLen(x) + 3)
                    Turn(x, y)
                    Sleep, 500
                }
            }
            if(SubStr(instruction, 1, 2) = "ns"){
                degree := SubStr(instruction, 3)
                Send, {e down} 
                Sleep, 1000
                Turn(degree)
                Sleep, 500 
                Send, {e up}
                Sleep, 1000
            }
            if(SubStr(instruction, 1, 2) = "mx"){
                SetCursorPos(683, 384)
                Send, {WheelUp 100}
                Sleep, 500
            }
            if(SubStr(instruction, 1, 2) = "mn"){
                SetCursorPos(683, 384)
                Send, {WheelDown 100}
                Sleep, 500
            }
            if(SubStr(instruction, 1, 5) = "sleep"){
                ;sleep
                duration := SubStr(instruction, 6)
                start_time := A_TickCount
                end_time := start_time + duration
                while (A_tickcount < end_time)
                {
                    if (Kicked() = 1){
                        return -1
                    }
                    if(Dead() = 1){
                        Click(625, 725)
                        Loop{
                            if(FullScreenCheck() = 1){
                                break
                            }
                        }
                        Sleep, 1000
                        return -1
                    }
                    Sleep, 100
                }
            }
            if(SubStr(instruction, 1, 4) = "send"){
                ;send
                SetKeyDelay, 0
                Send, % SubStr(instruction, 5)
            }
            if(SubStr(instruction, 1, 3) = "scp"){
                RegExMatch(instruction, "[0-9]+", x)
                RegExMatch(instruction, "[0-9]+", y, RegExMatch(instruction, "[0-9]+") + StrLen(x))
                SetCursorPos(x,y)
            }
            if(instruction = "p"){
                ; party. local. no coop check needed
                Home()
                Send, l
                while(FullScreenCheck() = 0){
                    Sleep, 100
                }
                Sleep, 5000
                Click(57, 722)
                Sleep, 1000
                SetCursorPos(190, 130)
                Send, {WheelDown 100}
                Sleep, 500
                Click(250, 600)
                Sleep, 500
                Click(230, 720)
                Sleep, 500
                Click(1200, 720)
                Home()
            }
            if(SubStr(instruction, 1, 1) = "c"){
                ;no coop check needed.
                RegExMatch(instruction, "[0-9]+", x)
                RegExMatch(instruction, "[0-9]+", y, RegExMatch(instruction, "[0-9]+") + StrLen(x))
                if(x = "" || y = ""){
                    Click
                }
                else {
                    Click(x,y)
                }
            }
            if(SubStr(instruction, 1, 2) = "tp"){
                Sleep, 500
                RegExMatch(instruction, "[0-9]+", x)
                RegExMatch(instruction, "[0-9]+", y, RegExMatch(instruction, "[0-9]+") + StrLen(x))
                Click(x,y)
                ; max load time
                u := -1
                duration := 1000
                start_time := A_TickCount
                end_time := start_time + duration
                while (A_tickcount < end_time)
                {
                    u = % WaypointUnlocked()
                    if (u != -1){
                        break
                    }
                }
                Sleep, 500
                duration := 3000
                start_time := A_TickCount
                end_time := start_time + duration
                while (A_tickcount < end_time)
                {
                    u = % WaypointUnlocked()
                    if (u != -1){
                        break
                    }
                }
                if (u = -1){
                    Webhook("Error?")
                    return -1
                }
                if(u = 1){
                    Click(1200, 700)
                    Sleep, 500
                    Webhook("Waypoint Detected")
                } else {
                    Webhook("Waypoint not found")
                    return -1
                }
                ; load script
                Loop{
                    if(FullScreenCheck() = 1){
                        break
                    }
                    if(Dead() = 1){
                        Click(625, 725)
                        Loop{
                            if(FullScreenCheck() = 1){
                                break
                            }
                        }
                        Sleep, 1000
                        return -1
                    }
                    Send, {Esc}
                    Sleep, 1000
                }
                ; small coop checking
                if(key != "local" && Substr(key,1,4) != "test"){
                    if(domain != 0){
                        Sleep, 500
                        if(InCoop() = 0){
                            Webhook("Could not detect Coop")
                            ;lmao got kicked while tp'ing
                            return -1
                        }
                    }
                }
            }
            if(SubStr(instruction, 1, 2) = "mg"){
                Genshin()
                ;message. Assume that this would be sent at the start and would be at homescreen.
                message := SubStr(instruction, 3)
                ; no kick detection because this is not a loop
                if(Loaded() = 1) {
                    Send, {Enter}
                    Sleep, 1000
                }
                SetCursorPos(50, 250)
                Send, {WheelUp 100}
                Sleep, 500
                Click(80, 100)
                Sleep, 1000
                Click(300, 715)
                Sleep, 500
                SetKeyDelay, 0
                Send, %message%
                Sleep, 500
                Send, {Enter}
                Sleep, 500
            }
        } else {
            ;set domain to 0 if debugging
            if(Kicked() = 1){
                return -1
            }
            ; home script
            if(Loaded() != 1){
                Loop{
                    if(FullScreenCheck() = 1){
                        break
                    }
                    if(Loaded() = 1){
                        break
                    }
                    if(Dead() = 1){
                        Click(625, 725)
                        Sleep, 500
                        Loop{
                            if(FullScreenCheck() = 1){
                                break
                            }
                        }
                        Sleep, 1000
                        return -1
                    }
                    Send, {Esc}
                    Sleep, 1500
                }
            }
            if(domain != 0){
                Genshin()
                Send, {F1}
                Loop {
                    if (FullScreenCheck() = 0){
                        break
                    }
                }
                Sleep, 3000
                Click(204, 308)
                SetCursorPos(810, 225)
                Sleep, 2000
                sendinput % "{WheelDown " 8 * domain - 8 "}"
                Sleep, 1000
                Click(1100, 250)
                Sleep, 3000
            }
        }
    }
    return 1
    ; successful debug, idk why but it works now. this is the end of instructions.
}

Loaded(){
    ImageSearch, ox, oy, 34, 23, 44, 38, %A_ScriptDir%\images\paimon.png
    if(ErrorLevel = 0){
        return 1
    } else {
        return 0
    }
}

Kicked(){
    PixelGetColor, c, 1050, 717
    if(c = "0x000000"){
        return 1
    } else {
        return 0
    }
}

WaypointUnlocked(){
    Genshin()
    PixelGetColor, c, 1050, 717
    if(c = "0x325C6A" || c = "0x325C6B" || c = "0x325C6C" || c = "0x325D6A" || c = "0x325D6B" || c = "0x325D6C"){
        return 1
    } else {
        if(c = "0x313131" || c = "0x323232"){
            return 0
        } else {
            return -1
        }
    }
}

InCoop(){
    Genshin()
    PixelGetColor, c, 1298, 216
    if(c = 0x007E3D){
        return 1 
    } else {
        return 0
    }
}

CharacterFilePath(Character){
    c := Character
    return % A_ScriptDir "\characters\" RegExReplace(c, "\s", "_") "_Icon.png"
}


FullScreenCheck(){
    SetCursorPos(0, 0)
    Sleep, 100
    MouseGetPos, x, y
    if(x = 683){
        return 1
    } else {
        return 0
    }
}

Genshin(){
    if WinExist("ahk_exe GenshinImpact.exe"){
        WinActivate
    }
}

Close:
    ExitApp
    Gui, Submit
return



MouseMove(x, y) {
    DllCall("mouse_event", "UInt", 0x01, "UInt", x, "UInt", y)
}

+p::
    MouseGetPos, mx , my
    PixelGetColor, c, mx, my
    MouseGetPos, x, y
    MsgBox %x%, %y%, %c%
return

f9::
    ExitApp
return

f6::
    Start()
return 

Launch:
    Launch()
return


Home(){
    Genshin()
    if(Loaded() != 1){
        Loop{
            if(FullScreenCheck() = 1){
                break
            } else {
                Send, {Esc}
                Sleep, 1500
            }
            if(Loaded() = 1){
                break
            }
        }
    }
}

SetCursorPos(x, y){
    DllCall("SetCursorPos", int, x, int, y)
}
    

Click(x, y){
    SetCursorPos(x, y)
    Click
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
