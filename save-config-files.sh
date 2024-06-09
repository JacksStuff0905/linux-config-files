#!/bin/bash

config_directory="./config-files"

folder_links_file="./links/folder-links"
file_links_file="./links/file-links"



# Create folder-links directories
while IFS= read -r line
do
  from=""
  index=0
  for path in $line
  do
     if [ $index == 0 ]; then
       from=$path
     fi
     if [ $index == 1 ]; then
       mkdir -p "$config_directory/$path"
       cp -a "${from/#~\//$HOME\/}." $config_directory/$path
       git add "$config_directory/$path/*" 
     fi
     ((index++))
  done
done < "$folder_links_file"



# Create file-links directories
while IFS= read -r line
do
  from=""
  index=0
  for path in $line
  do
     if [ $index == 0 ]; then
       from=$path
     fi
     if [ $index == 1 ]; then
       mkdir -p "$config_directory/`dirname $path`"
       cp "${from/#~\//$HOME\/}" $config_directory/`dirname $path`/`basename $from`
       git add $config_directory/`dirname $path`/`basename $from`
     fi
     ((index++))
  done
done < "$file_links_file"

echo "Linux configuration files saved succesfully"
