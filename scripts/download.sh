#!/bin/bash

script_dir="$(dirname "$(realpath "$0")")"

downloads_file="$script_dir/../links/download"
downloads_folder="$script_dir/../downloaded/"

mkdir -p $downloads_folder
while IFS= read -r line
do
	if test -z "${line// /}" || [[ $line == \#* ]]
	then
		continue
	fi
	# Check if the file is missing and download
	if test -f $downloads_folder/`basename $line`; then
		printf "\e[32mFile `basename $line` already downloaded; skipping\e[0m\n"
	else
		printf "\e[93mDownloading file `basename $line`...\e[0m\n"
		if wget --timeout=20 $line &> /dev/null
		then
			printf "\e[32mDownload of file `basename $line` was succesfull\e[0m\n"
		else
			printf "\e[31mDownload of file `basename $line` failed\e[0m\n"
		fi
		move_output=$(mv `basename $line` $downloads_folder) || printf "\e[31mMove of file `basename $line` to $downloads_folder failed - Printing output: $move_output\e[0m\n" 
		
	fi

	# Check if is a .zip and unzip
	file="$downloads_folder`basename $line`"
	filename=`basename $file`
	if [[ "$line" == *.zip ]]; then
		if test -d ${file%.zip}
		then
			printf "\e[32mFile $filename already unzipped; skipping\e[0m\n"
		else
			unzip $file -d $downloads_folder/${filename%.zip} &> /dev/null
			printf "\e[32mUnzipped file $file\e[0m\n"
		fi
	fi
done < $downloads_file
