global import := {}
/*
First item must be domain number. If you don't want to teleport set domain number to 0

mw/ma/ms/md: movement, followed by miliseconds at the back. eg: md5000
sleep500: Sleep for 500 miliseconds
sendhi: types hi
mghello mr kind guy: sends a "hello mr kind guy" in chat
scp10,20:set cursor pos to 10, 20
tp100,200: teleports to waypoint at 100, 200
mn: minimise map
mx: maximise map
p: swap to macro party
c30,4: click. coordinates are optional
t-90,0: turn, followed by x and y degrees. y is optional.
ns190: nahida scan 190 degrees
dtp: double teleport

*/

import["start"] := [0, "p"]
import["local"] := [2, "mx", "send{WheelDown 4}", "tp285,0"]
import["lotus"] := [18, "mn", "send{WheelUp 10}", "tp656,630", "dtp", "send{w down}","sleep5000","send{Space}","sleep12500","send{w up}","c","sleep2500","ma2000","mw3000","t45", "ns-60", "ma1000","mw3000","sleep1000","t-20","ns-70"]
import["mushroom"] := [19, "mx", "send{WheelDown 2}", "tp733,23", "dtp", "t-145", "ns","send{w down}","send{d down}","sleep1500","send{d up}","sleep1000","send{w up}","sendt","sleep2000","mw1500","sleep2000","mw1000","sende","sleep1000","ms1000","t180","t0,-90","sleep2000","ns","sendf"]
import["test"] := [17, "tp683,384"]
import["test2"] := [0,"t0,-90"]
GetInstructions(key){
    return % import[key]
}