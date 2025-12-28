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