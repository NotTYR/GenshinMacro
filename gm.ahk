#InstallMouseHook
#InstallKeybdHook
#SingleInstance Force
#Persistent
#NoEnv

CoordMode Pixel
SetKeyDelay, 0

IniRead, LocalSpeciality, %A_ScriptDir%/settings.ini, Collect, LocalSpeciality
IniRead, Ore, %A_ScriptDir%/settings.ini, Collect, Ore
IniRead, Character, %A_ScriptDir%/settings.ini, Settings, Character

width := 200
height := 250
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

Loaded(){
    ImageSearch, ox, oy, 34, 23, 44, 38, %A_ScriptDir%\images\paimon.png
    if(ErrorLevel = 0){
        return 1
    } else {
        return 0
    }
}

CharacterFilePath(Character){
    c := Character
    return % A_ScriptDir "\characters\" RegExReplace(c, "\s", "_") "_Icon.png"
}

Start(){
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
    MsgBox %mx%, %my% 
return


f6::
    Start()
return 

Launch:
    Launch()
return


Home(){

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
