global import := {}
/*
First item must be domain number.

mw/ma/ms/md: movement, followed by miliseconds at the back
sleep500: Sleep for 500 miliseconds
sendhi: types hi
mghello mr kind guy: sends a "hello mr kind guy" in chat

not sure if it is still needed, but put an empty string at the back of instrutcions.
*/
import["test"] := [8,"mgmessage with space","sleep1000", ""]
GetInstructions(key){
    return % import[key]
}