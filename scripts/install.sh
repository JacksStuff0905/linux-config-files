#!/bin/bash

script_dir="$(dirname "$(realpath "$0")")"



function determine_package_manager() {

	local package_managers_file="$script_dir/../package-managers"
	
	while IFS= read -r line
	do
 		length=${#line[@]}
		if command -v $(echo $line | { read -r -a words; echo "${words[0]}"; }) &> /dev/null
		then
			pckg_manager=$(echo $line | { read -r -a words; echo "${words[0]}"; })
			pckg_install=$(echo $line | { read -r -a words; echo "${words[1]}"; })
			pckg_remove=$(echo $line | { read -r -a words; echo "${words[2]}"; })
   			pckg_additional=$(echo $line | { read -r -a words; echo "${words[3...$length]}"; })
    			return 0
		fi
	done < $package_managers_file
	


	printf "\e[31mError: No known package manager detected; exiting\e[0m\n"
	exit 2
}


determine_package_manager



installs_file=../links/install
removes_file=../links/remove

# Install packages
while IFS= read -r line
do
	if test -z "${line// /}" || [[ $line == \#* ]]
	then
		continue
	fi
	{
		install_output=$(sudo $pckg_manager $pckg_install $line $pckg_additional)
		printf "\e[32mSuccesfully installed/updated package $line\e[0m\n"
	} || printf "\e[31mInstall of package $line failed - Printing output: $install_output\e[0m\n" 
	
done < $script_dir/$installs_file


# Remove packages
while IFS= read -r line
do
	if test -z "${line// /}" || [[ $line == \#* ]]
	then
		continue
	fi
	{
		remove_output=$(sudo $pckg_manager $pckg_remove $line $pckg_additional)
		printf "\e[32mSuccesfully removed package $line\e[0m\n"
	} || printf "\e[31mRemove of package $line failed - Printing output: $remove_output\e[0m\n" 
done < $script_dir/$removes_file
