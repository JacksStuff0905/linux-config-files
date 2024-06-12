#!/bin/bash
root_dir="$(dirname "$(realpath "$0")")/../"

###############################################################
# Use this file to execute commands before configuration begins
###############################################################


# Install all needed snap packages
while [[ $install_snap_pckg != y ]] && [[ $install_snap_pckg != n ]]
do
	printf "\e[93mInstall snap packages? (These packages are optional and might impact performance on slow systems) [y/n] \e[0m"
	read install_snap_pckg
done
if [[ install_snap_pckg == y ]]
then
	bash $root_dir/scripts/snap-install-remove.sh
fi
echo ""



# Remove the i3 config file if it has any errors
grep -oP ".*ERROR: CONFIG:.*" <<< `i3 -C` &> /dev/null && printf "\e[93mFound i3 config error: removing i3 config file\e[0m\n" && sudo rm ~/.config/i3/config;


# Apply options to config files
bash $root_dir/scripts/config-file-options.sh
