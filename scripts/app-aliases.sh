#!/bin/bash

script_dir="$(dirname "$(realpath "$0")")"

app_links_file="$script_dir/../links/app-aliases"
root_apps_directory="/usr/bin"
user_apps_directory="$HOME/bin"

mkdir -p $root_apps_directory

while IFS= read -r line
do
	if test -z "${line// /}" || [[ $line == \#* ]]
	then
		continue
	fi
	from=""
  	index=0
	for path in $line
  	do
     		if [ $index == 0 ]; then
       			from=$path
     		fi
     		if [ $index == 1 ]; then
			if test -f $root_apps_directory/$from
			then
				from=$root_apps_directory/$from
			else
				if test -f $user_apps_directory/$from
				then
					from=$user_apps_directory/$from
				else
					printf "\e[31mFailed to create an app alias between $from and $path because $from does not exist in app directories\e[0m"
					continue 2
				fi
			fi
			{

				if [ ! -f $root_apps_directory/$path ] && [ ! -f $user_apps_directory/$path ]
				then
					link_output=$(sudo ln -s $from $root_apps_directory/$path && printf "\e[31mSuccesfully created an app alias between $from and $path\e[0m\n")
				else
					printf "\e[32mApp alias called `basename $path` already exists; skipping\e[0m\n"
				fi
			} || {
				printf "\e[31mFailed to create an app alias between $from and $path - Printing output: $link_output\e[0m\n"
			}
		fi
     		((index++))
  	done
	

done < $app_links_file
