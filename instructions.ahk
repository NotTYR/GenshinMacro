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

*/
import["start"] := [0, "p"]
import["local"] := [1,"mx","tp290,253","send1","sleep1000","md1400","ms500"]
GetInstructions(key){
    return % import[key]
}