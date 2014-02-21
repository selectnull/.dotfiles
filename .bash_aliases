if [ `uname -s` = "Darwin" ]
then
    alias ll='ls -alFhG'
    alias ls='ls -lFhG'
elif [ `uname -s` = "Linux" ]
then
    alias ls='ls -lhv --group-directories-first --color=auto'
    alias ll='ls -alFh --group-directories-first --color=auto'
fi
