#!/bin/bash
set_variables () {
    # Providing Pre-req variables
    working_dir="/tmp/Dracula"
    themes_dir="/usr/share/themes"
    config_dir="${working_dir}/configs"
    git_dracula_gtk="https://github.com/dracula/gtk/archive/master.zip"
    git_dracula_term="https://github.com/dracula/gnome-terminal"
    git_dracula_zsh="https://github.com/dracula/gnome-terminal"
    deb_paper_icons="https://launchpadlibrarian.net/468844787/paper-icon-theme_1.5.728-202003121505~daily~ubuntu18.04.1_all.deb"
    deb_vscode="https://go.microsoft.com/fwlink/?LinkID=760868"
}
get_installation () {
    # clone the Dracula repo:
    # Set the variables
    # Move to Working Directory
    mkdir ${working_dir}
    cd ${working_dir}

    # Clone the Dracula Repositories down to the local working directory
    wget -O gtk.zip ${git_dracula_gtk} 
    wget -O icons.deb ${deb_paper_icons}
    wget -O vscode.deb ${deb_vscode}
    git clone ${git_dracula_term}
    git clone ${git_dracula_zsh}
}
make_installation () {
    # Move to the Working Directory
    cd ${working_dir}
    make_installation_depends () {
        # 1. Installing pre-req software
        apt update -y
        apt upgrade -y 
        apt install git ruby gnome-tweaks gnome-shell-extensions vim zsh dconf-cli curl -y
    }
    make_installation_gtk () {
        # Install the Dracula GTK Theme
        unzip gtk.zip gtk-master/* -d ${themes_dir}
        mv ${themes_dir}/gtk-master ${themes_dir}/Dracula
        rm master.zip

        # Enable the Dracula GTK Theme
        gsettings set org.gnome.desktop.interface gtk-theme Dracula
        gsettings set org.gnome.desktop.wm.preferences theme Dracula
        gsettings set org.gnome.shell.extensions.user-theme name Dracula
    }
    make_installation_icons () {
        # Install the Paper Icon Theme
        apt install icons.deb -y
        apt install -f -y

        # Enable the Paper Icon Theme
        gsettings set org.gnome.desktop.interface cursor-theme "Paper"
        gsettings set org.gnome.shell.extensions.dash-to-dock dock-position BOTTOM
        gsettings set org.gnome.shell.extensions.dash-to-dock intellihide true
    }
    make_installation_term () {
        # Install the Gnome-Terminal text theme
        printf '1\n1\nYES\n' | ${working_dir}/gnome-terminal/install.sh
    }
    make_installation_zsh () {
        # Install the ZSH default theme
        cp ${config_dir}/zshrc ~/.zshrc
        cp zsh ${themes_dir}/dracula_zsh
        mkdir ~/.oh_my_zsh/themes -d
        ln -s ${themes_dir}/dracula_zsh/dracula.zsh-theme ~/.oh-my-zsh/themes/dracula.zsh-theme
        echo "zsh" >> ~/.bashrc
    }
    make_installation_spotify () {
        # Install the Spotify app
        curl -sS https://download.spotify.com/debian/pubkey_0D811D58.gpg | sudo apt-key add - 
        echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
        apt update && apt install spotify-client 
    }
    make_installation_vscode () {
        # Install the VSCode App 
        apt install apt-transport-https
        apt update
        apt install vscode.deb -y
        apt install -f -y

        # Install the useful VSCode Plugins
        code --install-extension vscodevim.vim
        code --install-extension dracula-theme.theme-dracula
        code --install-extension knisterpeter.vscode-github
    }
    make_installation_depends
    make_installation_gtk
    make_installation_icons
    make_installation_term
    make_installation_zsh
    make_installation_spotify
    make_installation_vscode
}
cleanup_installation () {
    cd ~
    rm -rf ${working_dir}
}
set_variables
get_installation
make_installation
cleanup_installation