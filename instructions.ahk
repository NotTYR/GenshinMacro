global import := {}
/*
First item must be domain number.
mw/ma/ms/md: movement, followed by miliseconds at the back
sleep500: Sleep for 500 miliseconds
sendhi: types hide
mghello: sends a "hello" in chat
*/
import["test"] := [8,"mghe","sleep2000","mgaft",""]
GetInstructions(key){
    return % import[key]
}