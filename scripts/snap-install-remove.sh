#!/bin/bash

script_dir="$(dirname "$(realpath "$0")")"




installs_file="$script_dir/../actions/snap-install"
removes_file="$script_dir/../actions/snap-remove"


# Install packages
while IFS= read -r line
do
	if test -z "${line// /}" || [[ $line == \#* ]]
	then
		continue
	fi
	{
 		printf "\e[93mInstalling/updating snap package $line...\e[0m "
		install_output=$(sudo snap install $line)
		printf "\e[32mInstall/update was succesfull\e[0m\n"
	} || printf "\e[31mInstall/update failed - Printing output: $install_output\e[0m\n" 
	
done < $installs_file


# Remove packages
while IFS= read -r line
do
	if test -z "${line// /}" || [[ $line == \#* ]]
	then
		continue
	fi
	{
  		printf "\e[93mRemoving snap package $line...\e[0m "
		remove_output=$(sudo snap remove $line)
		printf "\e[32mRemoving was succesfull\e[0m\n"
	} || printf "\e[31mRemoving failed - Printing output: $remove_output\e[0m\n" 
done < $removes_file
