PS1="\[$(tput setaf 166)\]\u";   # username in orange
PS1+="@\[$(tput setaf 228)\]\h ->";   # host machine in green
PS1+="\[$(tput sgr0)\]";   # change color back to normal
export PS1;

alias dt='cd ~/Desktop';
