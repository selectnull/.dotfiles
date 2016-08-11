#!/bin/bash

ACTION=$1

install () {
    program="$1"

    which "$program" > /dev/null && return

    which yum > /dev/null && installer="yum install -y"
    which apt > /dev/null && installer="apt install -y"

    echo "Installing $program via $installer"

    $installer "$program"
}

if [ "$ACTION" == "install" ]; then
    install git

    cd || exit
    git clone https://github.com/selectnull/.dotfiles.git

    ln -s .dotfiles/.vimrc
    ln -s .dotfiles/.tmux.conf
    ln -s .dotfiles/.gitconfig

    install curl

    vimanage_file=/usr/local/bin/vimanage
    curl https://raw.githubusercontent.com/selectnull/vimanage/master/bin/vimanage > "$vimanage_file" && chmod +x "$vimanage_file"

    vimanage -s
    vimanage -i .dotfiles/conf/server-vim-plugins.txt

elif [ "$ACTION" == "uninstall" ]; then
    echo "uninstall"
    rm /usr/local/bin/vimanage

    cd /root/ || exit
    rm .vimrc
    rm .tmux.conf
    rm .gitconfig

    rm -rf .dotfiles
    rm -rf .vim
fi
