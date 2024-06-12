#!/bin/bash

# This script enables options which are conditional in config files
# to enable syntax add an empty line with <use-options> somwhere in your file
# options syntax: <some-command> will be replaced with a # if the command fails and will be removed if the command succedes

script_dir="$(dirname "$(realpath "$0")")"

config_folder="$script_dir/../config-files/"

# Compares version A to version B and if A is greater than or equal to B returns 0, otherwise returns 1
function version-gte {
  local version=$($1 --version | grep -oP "(?<=\bversion\s)\S+")
  if [ $version == $2 ]
  then
    return 0
  fi
  if [[ $(printf "%s\n" "$version" $2 | sort -V | head -n 1) != "$version" ]]
  then
      return 1
  fi
  return 0
}

# Compares version A to version B and if A is greater than B returns 0, otherwise returns 1
function version-gt {
  local version=$($1 --version | grep -oP "(?<=\bversion\s)\S+")
  if [[ $(printf "%s\n" "$version" $2 | sort -V | head -n 1) != "$version" ]]
  then
      return 1
  fi
  return 0
}

# Compares version A to version B and if A is less than or equal to B returns 0, otherwise returns 1
function version-lse {
  return ! version-gte
}

# Compares version A to version B and if A is less than B returns 0, otherwise returns 1
function version-ls {
  return ! version-gt
}




function process_file {
  local file="$1"
  if [ ! -r "$file" ]; then
    return
  fi
  
  if ! cat $file | grep -E '^\s*<use-options>\s*$' &> /dev/null
  then
    return
  fi

  sed -E -i '/^\s*<use-options>\s*$/d' $file
  
  grep -oP "(?<=<)[^<>]+(?=>)" $file | while read line
  do
    $line
    if [[ $? -eq 0 ]]
    then 
      sed -i "s/<$line>//" "$file"
    else
      sed -i "s/<$line>/#/" "$file"
    fi
  done
  
}


find "$config_folder" -type f | while read -r file; do
  process_file "$file"
done
