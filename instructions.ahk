global instructions := {}
/*
First item must be domain number.
mw/ma/ms/md: movement, followed by miliseconds at the back
Will add more instructions in the future.
*/
instructions["test"] := [8, "ma3000"]
GetInstructions(key){
    return % instructions[key]
}