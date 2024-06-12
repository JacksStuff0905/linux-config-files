#!/bin/bash

script_dir="$(dirname "$(realpath "$0")")"




installs_file="$script_dir/../actions/snap-install"
removes_file="$script_dir/../actions/snap-remove"


# Install packages
printf "\e[93mInstalling snap packages...\e[0m\n"

while IFS= read -r line
do
	trimmed="${line#"${line%%[![:space:]]*}"}"  # Remove leading whitespace
	trimmed="${trimmed%"${trimmed##*[![:space:]]}"}"  # Remove trailing whitespace
 
	if test -z "${trimmed// /}" || [[ $trimmed == \#* ]]
	then
		continue
	fi
	
 	if snap list | grep -oP "^$trimmed(?=\s+\d)"
   	then
    		printf "\e[32mSnap package $trimmed already installed; skipping\e[0m\n"
      		continue
     	else
      		{
	 		printf "\e[93mInstalling/updating snap package $trimmed...\e[0m "
			install_output=$(sudo snap install $trimmed)
			printf "\e[32mInstall/update was succesfull\e[0m\n"
  		
		} || printf "\e[31mInstall/update failed - Printing output: $install_output\e[0m\n"
  	fi
	
done < $installs_file
printf "\e[32mFinished installing snap packages\e[0m\n"


# Remove packages
printf "\e[93mRemoving snap packages...\e[0m\n"

while IFS= read -r line
do
	trimmed="${line#"${line%%[![:space:]]*}"}"  # Remove leading whitespace
	trimmed="${trimmed%"${trimmed##*[![:space:]]}"}"  # Remove trailing whitespace
 
	if test -z "${trimmed// /}" || [[ $trimmed == \#* ]]
	then
		continue
	fi

	if snap list | grep -oP "^$trimmed(?=\s+\d)"
   	then
    		{
	  		printf "\e[93mRemoving snap package $trimmed...\e[0m "
			remove_output=$(sudo snap remove $trimmed)
			printf "\e[32mRemoving was succesfull\e[0m\n"
		} || printf "\e[31mRemoving failed - Printing output: $remove_output\e[0m\n" 
     	else
      		printf "\e[32mSnap package $trimmed isn't installed; skipping\e[0m\n"
  	fi
	
done < $removes_file
printf "\e[32mFinished removing snap packages\e[0m\n"
