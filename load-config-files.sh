#!/bin/bash

script_dir="$(dirname "$(realpath "$0")")"






config_directory="$script_dir/config-files"

downloads_directory="$script_dir/downloaded"

file_links_file="$script_dir/actions/file-links"

# Run pre-configuration script
bash $script_dir/scripts/pre.sh
echo ""

# Download all needed files
bash $script_dir/scripts/download.sh
echo ""

# Install all needed packages
bash $script_dir/scripts/install-remove.sh
echo ""

# Install all needed snap packages
printf "\e[93mInstall snap packages? [Y/n] \e[0m"
read install_snap_pckg
if ! [[ install_snap_pckg == n ]]
then
	printf "\n\e[93mInstalling snap packages...\e[0m\n"
 	{
		bash $script_dir/scripts/snap-install-remove.sh && printf "\n\e[32mInstallation was succesfull\e[0m\n"
	} || printf "\e[31mInstallation failed\e[0m\n"
 	echo ""
fi

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
       				path=${path%/}
   				if ! [ -d $config_directory/$path/`basename $to` ]
				then
   					printf "\e[31mNo $config_directory/$path/`basename $to` configuration folder to load\e[0m\n"
					continue 2
				fi
				printf "\e[93mCopying folder `basename $to`...\e[0m "
				{
					sudo cp -a $config_directory/$path/`basename $to` `dirname "${to/#~\//$HOME\/}"` && printf "\e[32mCopying was succesfull\e[0m\n"
				} || printf "\e[31mCopying failed\e[0m\n"
			else
   				if ! [ -f $config_directory/`dirname $path`/`basename $to` ]
				then
					printf "\e[31mNo $config_directory/`dirname $path`/`basename $to` configuration file to load\e[0m\n"
     					continue 2
				fi
    				printf "\e[93mCopying file `basename $to`...\e[0m "
				{
					sudo cp $config_directory/`dirname $path`/`basename $to` "${to/#~\//$HOME\/}" && printf "\e[32mCopying was succesfull\e[0m\n"			
				} || printf "\e[31mCopying failed\e[0m\n"
			fi
     		fi
     		((index++))
  	done
done < "$file_links_file"

# Rune post-configuration script
echo ""
bash $script_dir/scripts/post.sh
echo ""

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


while [[ $reboot_now != y ]] && [[ $reboot_now != n ]]
do
	printf "\n\n\e[93mTo finalize setup a reboot is needed. Reboot now? [y/n] \e[0m"
	read reboot_now
done

if [[ $reboot_now == y ]]
then
	systemctl reboot
fi
