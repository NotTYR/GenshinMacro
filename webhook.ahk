#SingleInstance Force


IniRead, webhookurl, %A_ScriptDir%/settings.ini, Links, WebhookUrl
Menu, Tray, Icon, %A_ScriptDir%/images/icon.ico
Gui, Font, s10, Verdana
Gui, Add, Text, , Paste Webhook link here(Autosave)
Gui, Add, Edit, w200 vWebhookurl gA, %webhookurl%
Gui, Show, x600 y250 w250 h100, Webhook Configuration

A:
    Gui, Submit, nohide
    IniWrite, %Webhookurl% , %A_ScriptDir%/settings.ini, Links, Webhookurl