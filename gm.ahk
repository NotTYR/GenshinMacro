#InstallMouseHook
#InstallKeybdHook
#SingleInstance Force
#Persistent
#NoEnv


#Include %A_ScriptDir%/instructions.ahk


CoordMode Pixel

IniRead, LocalSpeciality, %A_ScriptDir%/settings.ini, Collect, LocalSpeciality
IniRead, Ore, %A_ScriptDir%/settings.ini, Collect, Ore
IniRead, Character, %A_ScriptDir%/settings.ini, Settings, Character

width := 200
height := 250
Menu, Tray, Icon, %A_ScriptDir%/images/icon.ico
Gui, Font, s10, Verdana
Gui, Add, Tab3, x0 y-1 w%width% h%height%, Character|Macro
Gui, Tab, Character
Gui, Add, Text, , Select Character
Gui, Add, DropDownList, Choose1 vCharacter gCharacter, |Albedo|Alhaitham|Aloy|Amber|Arataki Itto|Baizhu|Barbara|Beidou|Bennett|Candace|Chongyun|Collei|Cyno|Dehya|Diluc|Diona|Dori|Eula|Faruzan|Fischl|Ganyu|Gorou|Hu Tao|Jean|Kaedehara Kazuha|Kaeya|Kamisato Ayaka|Kamisato Ayato|Kaveh|Keqing|Klee|Kujou Sara|Kuki Shinobu|Layla|Lisa|Mika|Mona|Nahida|Nilou|Ningguang|Noelle|Qiqi|Raiden Shogun|Razor|Rosaria|Sangonomiya Kokomi|Sayu|Shenhe|Shikanoin Heizou|Sucrose|Tartaglia|Thoma|Tighnari|Traveler|Venti|Wanderer|Xiangling|Xiao|Xingqiu|Xinyan|Yae Miko|Yanfei|Yaoyao|Yelan|Yoimiya|Yun Jin|Zhongli
Gui, Add, Picture, w150 h150 vCharacterPic, % A_ScriptDir "\characters\" Character "_Icon.png"
if(Character == ""){
    GuiControl, hide, CharacterPic
}
GuiControl, Choose, Character, |%Character%
Gui, Tab, Macro
Gui, Add, Button, default gLaunch, Launch Game
Gui, Show, x800 y450 w%width% h%height%, Genshin Macro
return

Character:
    Gui, Submit, nohide
    IniWrite, %Character%, %A_ScriptDir%/settings.ini, Settings, Character
    IniRead, Character, %A_ScriptDir%/settings.ini, Settings, Character
    if (Character == ""){
        GuiControl, hide, CharacterPic
    } else {
        cfp := CharacterFilePath(Character)
        GuiControl, , CharacterPic, %cfp%
        GuiControl, Show, CharacterPic
    }
return


Start(){
    ExecuteInstructions()
}

;0x221C1C coopscreen1
;0xFFFFFF coopscreen2

JoinCoop(){
    ; there might be unnecessary code, but it works.
    ;home screen at first, when player is definitely not in coop
    Home()
    Loop {
        Send, {F2}
        ; wait for coop screen to load.
        Loop {
            ;safe?
            PixelGetColor, c, 1233, 721
            if(c = "0x8EBCD3"){
                break
            }
            if(c = "0x221C1C" || c = "0xFFFFFF"){
                ; coop screen
                break 2
            }
            if(InCoop() = 1){
                break 2
            }
        }
        SetCursorPos(1160, 630)
        Send, {WheelDown 350}
        Loop, 44{
            ; safe code
            PixelGetColor, c, 1233, 721
            if(c = "0x8EBCD3"){
                Click
                Send, {WheelUp 7}
            } else {
                break 2
            }
        }
        Send, {Esc}
        Loop, {
            if(c = "0x221C1C" || c = "0xFFFFFF"){
                ; coop screen
                break 2
            }
            if(InCoop() = 1){
                break 2
            }
            if(Loaded() = 1){
                break
            }
        }
        if(c = "0x221C1C" || c = "0xFFFFFF"){
            ; coop screen
            break
        }
        if(InCoop() = 1){
            break
        }
    }
}

ExecuteInstructions(){
    ; no forever loops are allowed to prevent exceptions
    instructions := GetInstructions("test")
    domain := instructions[1]
    for k,instruction in instructions {
        if(instruction != domain){
            ; not the first instruction
            if(SubStr(instruction 1, 2) = "mw" || SubStr(instruction, 1, 2) = "ma" || SubStr(instruction, 1, 2) = "ms" || SubStr(instruction, 1, 2) = "md"){
                ;movement
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
                    Sleep, 100
                }
                Send, % "{" key " up}"
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
                    Sleep, 100
                }
            }
            if(SubStr(instruction, 1, 4) = "send"){
                ;send
                SetKeyDelay, 0
                Send, % SubStr(instruction, 5)
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
            ; domain function. when coop loaded must be in home screen
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
    if(c = "0x325C6A" || c = "0x325C6B" || c = "0x325C6C"c = "0x325D6A" || c = "0x325D6B" || c = "0x325D6C"){
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

Domain(d){
    Genshin()
    Loop {
        if(Loaded() = 1){
            break
        }
        if(FullScreenCheck() = 0){
            Send, {Esc}
            Sleep, 1500
        } else {
            Send, {Esc}
            Loop, {
                if(FullScreenCheck() = 0){
                    break
                }
            }
            Sleep, 1500
        }
        
    }
    Send, {F1}
    Loop {
        if (FullScreenCheck() = 0){
            break
        }
    }
    Sleep, 2000
    Click(210, 310)
    SetCursorPos(810, 225)
    Sleep, 2000
    sendinput % "{WheelDown " 8 * d - 8 "}"
    Sleep, 1000
    Click(1100, 250)
    Sleep, 3000
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
    Loop {
        if(Loaded() = 1){
            break
        }
        if(FullScreenCheck() = 0){
            Send, {Esc}
            Sleep, 1500
        } else {
            Send, {Esc}
            Loop, {
                if(FullScreenCheck() = 0){
                    break
                }
            }
            Sleep, 1500
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
