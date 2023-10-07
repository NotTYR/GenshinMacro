global import := {}
/*
First item must be domain number.
mw/ma/ms/md: movement, followed by miliseconds at the back
Will add more instructions in the future.
*/
import["test"] := [8,"ma100", "sleep500", "sendhi"]
GetInstructions(key){
    return % import[key]
}