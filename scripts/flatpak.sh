#!/bin/bash

script_dir="$(dirname "$(realpath "$0")")"




commands_file="$script_dir/../actions/flatpak"


# Install packages
printf "\t\e[93mPerforming flatpak commands...\e[0m\n"

while IFS= read -r line
do
	trimmed="${line#"${line%%[![:space:]]*}"}"  # Remove leading whitespace
	trimmed="${trimmed%"${trimmed##*[![:space:]]}"}"  # Remove trailing whitespace
 
	if test -z "${trimmed// /}" || [[ $trimmed == \#* ]]
	then
		continue
	fi
 
 	words=($trimmed)
    	length="${#words[@]}"

      	
  	link=false
 	if [[ "$trimmed" == "&link install"* ]]
 	then
		link=true
  		echo link
  		trimmed="${trimmed#&link install}"
    	fi
  	{
	 	printf "\t\t\e[93mPerforming flatpak command $trimmed...\e[0m "
		operation_output=$(sudo flatpak -y $trimmed &> /dev/null)
  		if [[ $link == true ]]
    		then
      			sudo ln -s "/var/lib/flatpak/exports/bin/${words[$length - 1]}" "/usr/bin/${words[1]}"
      		fi
		printf "\e[32mFlatpak command was succesfull\e[0m\n"
  		
	} || printf "\e[31mFlatpak command failed - Printing output: $operation_output\e[0m\n"
  	
	
done < $commands_file
printf "\t\e[32mFinished performing flatpak commands\e[0m\n"
