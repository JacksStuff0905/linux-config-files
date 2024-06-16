#!/bin/bash
root_dir="$(dirname "$(realpath "$0")")/.."

################################################################
# Use this file to execute commands after configuration finishes
################################################################



# Add tiling to i3 config if i3 version is 4.21 or higher
i3_config_file="$HOME/.config/i3/config"

#i3_version=$(i3 --version | grep -oP "(?<=\bversion\s)\S+")
#if [[ $(printf "%s\n" "$i3_version" "4.21" | sort -V | head -n 1) != "$i3_version" ]]
#then
#    sed -i 's/#\s*\b\(tiling_drag\)\b/\1/' $i3_config_file
#fi


# Install oh-my-zsh
yes | sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Install themes
bash $root_dir/downloaded/Everforest-GTK/themes/install.sh


