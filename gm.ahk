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
IniRead, Character, %A_ScriptDir%/settings.ini, Settings, Character

width := 200
height := 250
margin := 30
Menu, Tray, Icon, %A_ScriptDir%/images/icon.ico
Gui, Font, s10, Verdana
Gui, Add, Tab3, x0 y-1 w%width% h%height%, Character|Settings
Gui, Tab, Character
Gui, Add, Text, , Select Character
Gui, Add, DropDownList, Choose1 vCharacter gCharacter, |Albedo|Alhaitham|Aloy|Amber|Arataki Itto|Baizhu|Barbara|Beidou|Bennett|Candace|Chongyun|Collei|Cyno|Dehya|Diluc|Diona|Dori|Eula|Faruzan|Fischl|Ganyu|Gorou|Hu Tao|Jean|Kaedehara Kazuha|Kaeya|Kamisato Ayaka|Kamisato Ayato|Kaveh|Keqing|Klee|Kujou Sara|Kuki Shinobu|Layla|Lisa|Mika|Mona|Nahida|Nilou|Ningguang|Noelle|Qiqi|Raiden Shogun|Razor|Rosaria|Sangonomiya Kokomi|Sayu|Shenhe|Shikanoin Heizou|Sucrose|Tartaglia|Thoma|Tighnari|Traveler|Venti|Wanderer|Xiangling|Xiao|Xingqiu|Xinyan|Yae Miko|Yanfei|Yaoyao|Yelan|Yoimiya|Yun Jin|Zhongli

Gui, Add, Picture, w150 h150 vCharacterPic, % A_ScriptDir "\characters\" Character "_Icon.png"
if(Character == ""){
    GuiControl, hide, CharacterPic
}
GuiControl, Choose, Character, |%Character%
Gui, Tab, Settings
Gui, Add, Button, default gLaunch, Launch Game
Gui, Add, Button, default gWebhook, Webhook Settings
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

CharacterFilePath(Character){
    c := Character
    return % A_ScriptDir "\characters\" RegExReplace(c, "\s", "_") "_Icon.png"
}

Close:
    ExitApp
    Gui, Submit
return


MouseMove(x, y) {
    DllCall("mouse_event", "UInt", 0x01, "UInt", x, "UInt", y)
}


f6::
    Start()
return 

Webhook:
    Run, %A_ScriptDir%/webhook.ahk
return

Launch:
    Launch()
return

Start(){
    Click(500, 500)
}

Home(){

}

SetCursorPos(x, y){
    DllCall("SetCursorPos", int, x, int, y)
}
    

Click(x, y){
    SetCursorPos(x, y)
    Click
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

Load(){
    Loop {
        loaded := 0
        increment := 0
        Loop {
            increment += 1
            Sleep, 100
            ImageSearch, OutputVarX, OutputVarY, 0, 0, 100, 100, %A_ScriptDir%\images\loaded.png
            if (ErrorLevel == 0){
                loaded = 1
                break
            }
            if (increment == 200){
                Webhook("Exception: Load failure after 20 seconds")
                break
            }
        }
        if (loaded = 1){
            break
        }
        Home()
    }
}


ZoomMap(){
    SwitchToGenshin()
    Click(32, 300)
}

SwitchToGenshin(){
    if WinExist("ahk_exe GenshinImpact.exe"){
        WinActivate
        Load()
    }
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
