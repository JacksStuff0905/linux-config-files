#!/bin/bash

# This script enables options which are conditional in config files
# to enable syntax add an empty line with <use-options> somwhere in your file
# options syntax: <some-command> will be replaced with a # if the command fails and will be removed if the command succedes

script_dir="$(dirname "$(realpath "$0")")"

config_folder="$script_dir/../config-files/"


function process_file {
  echo test
  echo $1
}

echo $

find "$config_folder" -type f | while read -r file; do
  process_file "$file"
done
#sudo find $config_folder -type f -name "*" -exec "process_file {}" \;
