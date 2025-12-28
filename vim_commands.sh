# vi : default visual editor
# Vim => Vi iMproved
# in most systems VI is also alias for VIM

# command mode => normal mode when vi is opened
# input mode => start with i
# move from input mode to command mode ESC

i    insert mode
I    insert mode and insert at start of the line
a    insert mode
A    insert mode at end of the line

vi : opens VIM 

move through the screen:  
k => up
j => down
h => left
l => right

:1   first line of the file
G    end of the file
:n   nth line of the file
H    first line on screen
L    last line on screen
M    middle line on screen
0    start of line
$    end of line

w => goes right word by word  | 2+w  goes 2 words ahead
b => goes back word by word | 3+b goes 3 words back

shift + } => goes down faster
shift + { => goes up faster

ctrl + d  => go Down fast
ctrl + u => go Up fast

when cursor is on a  ( { [  press % (shift+5) to go to its pair

u        undo last action
CTRL+R   redo last action
r        replace string character

x        delete a character
nx       delete n characters
dw       delete a word
ndw      deelete n words
dd       delete a line
ndd      delete n lines

v        mark text to be copied or cut by character
V        mark text to be copied or cut by line
y        copy marked text
X        cut the marked text
yy       copy current line
nyy      copy n lines into the buffer
p        paste cut/copied text after the cursor
P        paste cut/copied text before a cursor

quit vim => press "Esq" then ":wq" then enter to save and quit
quit vim =>  hold shift, ZZ  save changes
quit vim => press "Esq"  then ":q" then enter
quit vim => press "Esq"  then ":q!" then enter, force quit
quit vim => hold shift, ZQ  doesn't save changes

:w!     force write (ignore file permissions) 


d+$ (hold shift and 4) : delete from here until end of the line
shift+D : delete from here until end of the line
d+d : delete the whole line
d+5+w : delete from here to 5 words forward
d+2b+ : delete from here to 2 words backward
d+i+( : deletes everything inside () , works for () in current line

z+z : sends current line to middle of the screen

press i to enter text
press a to enter insert mode, one character after current cursor
press Esq to exit typing mode
o : start new paragraph and go to insert mode

shift + A : start entering text at the end of current line
shift + i : start entering text at the start of current line

g+g : goes to the start of the file
shift+g : goes to the bottom of the file

u : undo the last action
u+u : undo the last 2 actions
:earlier 2m  : goes back to state of the file 2 minutes ago

paste: press dd to delete a line, then press p to paste it in some other place
(also works with other kinds of delete)

delete and replace: use c instead of d, here we delete things but automatically go to inserting mode

Ctrl+g : shows cursor's line and location in the file

30% : goes to one third of the file
50% : goes to middle of the file

search:  press / then type word or character then press enter. it will go to first instance of it
press n to go to next instance
shift+n goes to previous instance
? then type word then press enter: same as / but searches backwards

replace
:s/WordOne/WordTwo/   : replace word one with word two, for only one instance in current line
:s/WordOne/WordTwo/g   : replace word one with word two, for all instances in current line
:%s/WordOne/WordTwo/g  : replace word one with word two, all instances

run external linux commands in vim:  :!ls : runs ls inside vim and shows result
press enter to go back to vim

Visually select
v : will go to visual mode, you can select text by moving the cursor
v+a+p : will select a whole paragraph

Yanking
press y after visually selecting a text, to save it in clipboard, press p to paste it
yy : yanks a whole line to clipboard
y+2+w : copy next 2 words, then press p to paste it somewhere

hold Ctrl+v : another way of selecting text, in the rectangular way

change 
c is command for change, c+i+( find next () and deletes what is inside it and goes to insert mode

norm
if you do one operation on one line, select some other lines with v , then press : and type norm , 
here you can do commands that apply to all of them. for example . means all of them will be applied 
what you did in that first line.

replace
R (hold shift+r) will replace current cursor character and all after it with what you type

spell check
:setlocal spell! spelllang=en_us  : will spellcheck the whole document and show all misspells
go to word, press z+= it will give you option to change that word.