#!/bin/bash

script_dir="$(dirname "$(realpath "$0")")"






config_directory="$script_dir/config-files"

downloads_directory="$script_dir/downloaded"

file_links_file="$script_dir/links/file-links"



# Download all needed files
bash $script_dir/scripts/download.sh
echo ""

# Install all needed packages
bash $script_dir/scripts/install.sh
echo ""

# Add all app links
bash $script_dir/scripts/app-aliases.sh
echo ""

# Create file-links directories
while IFS= read -r line
do
	trimmed="${line#"${line%%[![:space:]]*}"}"  # Remove leading whitespace
	trimmed="${trimmed%"${trimmed##*[![:space:]]}"}"  # Remove trailing whitespace


	if test -z "${line// /}" || [[ $trimmed == \#* ]]
	then
		continue
	fi
	
	# Skip if save only and trim load only prefix
	if [[ "$trimmed" == "&save-only"* ]]
	then
		continue
	fi
	if [[ "$trimmed" == "&load-only"* ]]
	then
		trimmed="${trimmed#&load-only}"
	fi


  	to=""
  	index=0
  	for path in $trimmed
  	do
     		if [ $index == 0 ]; then
       			to=$path
     		fi
     		if [ $index == 1 ]; then
			mkdir -p `dirname "${to/#~\//$HOME\/}"` 
			if [[ $to == */ ]]
			then
				{
					path=${path%/}
					sudo cp -a $config_directory/$path/`basename $to` `dirname "${to/#~\//$HOME\/}"`   && printf "\e[32mCopied folder `basename $to`\e[0m\n"
				} || {
					printf "\e[93mNo $config_directory/$path/`basename $to` configuration folder to load\e[0m\n"
				}
			else
				{
					sudo cp $config_directory/`dirname $path`/`basename $to` "${to/#~\//$HOME\/}" && printf "\e[32mCopied file `basename $to`\e[0m\n"			
				} || {
					printf "\e[93mNo $config_directory/`dirname $path`/`basename $to` configuration file to load\e[0m\n"
       				}  
			fi
     		fi
     		((index++))
  	done
done < "$file_links_file"

sudo rm -r $downloads_directory/

source ~/.bashrc

printf "\n\n\e[36m############################################\nLinux configuration files loaded succesfully\n############################################\n\e[0m"

printf "\n\n\e[93mWould you like to cleanup all the downloaded configuration files? [Y/n] \e[0m"
read cleanup
if ! [[ $cleanup == n ]]
then
	sudo rm -r $script_dir
 	printf "\n\e[32mRemoved all downloaded configuration files\e[0m\n"
fi

printf "\n\n\e[93mTo finalize setup a reboot is needed. Reboot now? [y/n] \e[0m"
read reboot_now

if [[ $reboot_now == y ]]
then
	reboot
fi
