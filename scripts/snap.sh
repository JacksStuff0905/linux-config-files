#!/bin/bash

script_dir="$(dirname "$(realpath "$0")")"




commands_file="$script_dir/../actions/snap"


# Install packages
printf "\t\e[93mInstalling snap packages...\e[0m\n"

while IFS= read -r line
do
	trimmed="${line#"${line%%[![:space:]]*}"}"  # Remove leading whitespace
	trimmed="${trimmed%"${trimmed##*[![:space:]]}"}"  # Remove trailing whitespace
 
	if test -z "${trimmed// /}" || [[ $trimmed == \#* ]]
	then
		continue
	fi
	
 	words=($line)

  	# check if is an install
  	if [[ "${words[0]}" == "install" ]]
   	then
    		# perform installation
	 	if snap list | grep -oP "^${words[1]}(?=\s+\d)"
	   	then
	    		printf "\t\t\e[32mSnap package ${words[1]} already installed; skipping\e[0m\n"
	      		continue
	     	fi

       		{
		 	printf "\t\t\e[93mInstalling/Updating snap package ${words[1]}...\e[0m "
			install_output=$(sudo snap $trimmed)
			printf "\e[32mInstallation/update was succesfull\e[0m\n"
  		
		} || printf "\e[31mInstallation/update failed - Printing output: $install_output\e[0m\n"
      	fi

	# check if is a remove
  	if [[ "${words[0]}" == "remove" ]]
   	then
    		# perform removing
	 	if ! snap list | grep -oP "^${words[1]}(?=\s+\d)"
	   	then
     			printf "\t\t\e[32mSnap package ${words[1]} isn't installed; skipping\e[0m\n"
			continue
     		fi
	    	{
		  	printf "\t\t\e[93mRemoving snap package ${words[1]}...\e[0m "
			remove_output=$(sudo snap $trimmed)
			printf "\e[32mRemoving was succesfull\e[0m\n"
		} || printf "\e[31mRemoving failed - Printing output: $remove_output\e[0m\n" 

       	fi
      	{
	 	printf "\t\t\e[93mPerforming snap command $trimmed...\e[0m "
		operation_output=$(sudo snap $trimmed)
		printf "\e[32mSnap command was succesfull\e[0m\n"
  		
	} || printf "\e[31mSnap command failed - Printing output: $operation_output\e[0m\n"
  	
	
done < $commands_file
printf "\t\e[32mFinished performing snap commands\e[0m\n"
