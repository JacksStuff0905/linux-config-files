#!/bin/bash

config_directory="./config-files"

folder_links_file="./links/folder-links"
file_links_file="./links/file-links"




# Create folder-links directories
while IFS= read -r line
do
  to=""
  index=0
  for path in $line
  do
     if [ $index == 0 ]; then
       to=$path
     fi
     if [ $index == 1 ]; then
       { 
         cp -a $config_directory/$path. "${to/#~\//$HOME\/}"	
       } || {
         echo "No $config_directory/$path configuration folder to load"
       }     
     fi
     ((index++))
  done
done < "$folder_links_file"



# Create file-links directories
while IFS= read -r line
do
  to=""
  index=0
  for path in $line
  do
     if [ $index == 0 ]; then
       to=$path
     fi
     if [ $index == 1 ]; then
       { 
         cp $config_directory/`dirname $path`/`basename $to` "${to/#~\//$HOME\/}"	
       } || {
         echo "No $config_directory/`dirname $path`/`basename $to` configuration file to load"
       }     
     fi
     ((index++))
  done
done < "$file_links_file"

echo "Linux configuration files loaded succesfully"
