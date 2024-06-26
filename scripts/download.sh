#!/bin/bash

script_dir="$(dirname "$(realpath "$0")")"

downloads_file="$script_dir/../actions/download"
downloads_folder="$script_dir/../downloaded/"

mkdir -p $downloads_folder
while IFS= read -r line
do
	trimmed="${line#"${line%%[![:space:]]*}"}"  # Remove leading whitespace
	trimmed="${trimmed%"${trimmed##*[![:space:]]}"}"  # Remove trailing whitespace

	words=($trimmed)
 	url=${words[0]}
  	filename=${words[1]}
 	
	if test -z "${trimmed// /}" || [[ $trimmed == \#* ]]
	then
		continue
	fi
	# Check if the file is missing and download
	if test -f $downloads_folder$filename; then
		printf "\e[32mFile $filename already downloaded; skipping\e[0m\n"
	else
		printf "\e[93mDownloading file $filename...\e[0m "
  		name="$downloads_folder$filename"
		if wget --timeout=20 -O $name $url &> /dev/null
		then
			printf "\e[32mDownload was succesfull\e[0m\n"
		else
			printf "\e[31mDownload failed\e[0m\n"
		fi
		
	fi

	# Check if is a .zip and unzip
	if [[ "$name" == *.zip ]]; then
		if test -d ${name%.zip}
		then
			printf "\e[32mFile $filename already unzipped; skipping\e[0m\n"
		else
  			printf "\e[93mUnzipping file `basename $name`...\e[0m "
     			{
				unzip $name -d ${name%.zip} &> /dev/null && printf "\e[32mUnzipping was succesfull\e[0m\n"
    				unnecessary_folder=$(find ${name%.zip} -mindepth 1 -maxdepth 1 -type d)
				mv "$unnecessary_folder"/* ${name%.zip}
    				rm -r "$unnecessary_folder"
    			} || {
       				printf "\e[31mUnzipping failed\e[0m\n"
	  		}
		fi
	fi
done < $downloads_file
