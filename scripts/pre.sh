#!/bin/bash

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
	bash $script_dir/scripts/snap-install-remove.sh
fi
echo ""



# Apply options to config files
bash 
