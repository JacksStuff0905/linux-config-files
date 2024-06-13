#!/bin/bash

script_dir="$(dirname "$(realpath "$0")")"



function determine_package_manager() {

	local package_managers_file="$script_dir/../package-managers"
	
	while IFS= read -r line
	do
		if command -v $(echo $line | { read -r -a words; echo "${words[0]}"; }) &> /dev/null
		then 
  			
     			words=($line)
  			length="${#words[@]}"
			pckg_manager="${words[0]}"
			pckg_install="${words[1]}"
			pckg_remove="${words[2]}"
   			pckg_additional="${words[@]:3:$length}"
    			return 0
		fi
	done < $package_managers_file
	


	printf "\e[31mError: No known package manager detected; exiting\e[0m\n"
	exit 2
}


determine_package_manager



installs_file="$script_dir/../actions/install-remove"


# Install packages
while IFS= read -r line
do
	trimmed="${line#"${line%%[![:space:]]*}"}"  # Remove leading whitespace
	trimmed="${trimmed%"${trimmed##*[![:space:]]}"}"  # Remove trailing whitespace
 
	if test -z "${trimmed// /}" || [[ $trimmed == \#* ]]
	then
		continue
	fi
 	if [[ "$trimmed" == "&install"* ]]
	then
  		# install package
		trimmed="${trimmed#&install}"
 		{
	 		printf "\e[93mInstalling/updating package $trimmed...\e[0m "
			install_output=$(sudo $pckg_manager $pckg_additional $pckg_install $trimmed)
			printf "\e[32mInstall/update was succesfull\e[0m\n"
		} || printf "\e[31mInstall/update failed - Printing output: $install_output\e[0m\n"
  		continue
	fi



 	if [[ "$trimmed" == "&remove"* ]]
	then
 		# remove package
		trimmed="${trimmed#&remove}"
 		{
	  		printf "\e[93mRemoving package $trimmed...\e[0m "
			remove_output=$(sudo $pckg_manager $pckg_additional $pckg_remove $trimmed)
			printf "\e[32mRemoving was succesfull\e[0m\n"
		} || printf "\e[31mRemoving failed - Printing output: $remove_output\e[0m\n"
  		continue
	fi
	
	
done < $installs_file
