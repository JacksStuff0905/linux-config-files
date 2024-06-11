#!/bin/bash

script_dir="$(dirname "$(realpath "$0")")"


config_directory="$script_dir/config-files"

file_links_file="$script_dir/links/file-links"




# Create file-links directories
while IFS= read -r line
do
	trimmed="${line#"${line%%[![:space:]]*}"}"  # Remove leading whitespace
	trimmed="${trimmed%"${trimmed##*[![:space:]]}"}"  # Remove trailing whitespace

	if test -z "${line// /}" || [[ $trimmed == \#* ]]
	then
		continue
	fi

	# Skip if load only and trim save only prefix
	if [[ "$trimmed" == "&save-only"* ]]
	then
		trimmed="${trimmed#&save-only}"
	fi
	if [[ "$trimmed" == "&load-only"* ]]
	then
		continue
	fi


  	from=""
  	index=0
  	for path in $trimmed
  	do
     		if [ $index == 0 ]; then
       			from=$path
     		fi
     		if [ $index == 1 ]; then
       			mkdir -p "$config_directory/`dirname $path`"
			{
				if [[ $from == */ ]]
				then		
					path=${path%/}
					sudo cp -a "${from/#~\//$HOME\/}" $config_directory/$path &> /dev/null && printf "\e[32mCopied folder `basename $from`\e[0m\n"
					git add $config_directory/$path/`basename $from`/*

				else
					sudo cp "${from/#~\//$HOME\/}" $config_directory/`dirname $path`/`basename $from` &> /dev/null && printf "\e[32mCopied file `basename $from`\e[0m\n"
					git add $config_directory/`dirname $path`/`basename $from`

				fi
			} || {
				printf "\e[31mFailed to copy file `basename $from`\e[0m\n"
			}
     		fi
     		((index++))
  	done
done < "$file_links_file"

git add $config_directory

printf "\n\n\e[36m############################################\nLinux configuration files saved succesfully\n############################################\n\e[0m"
