#!/bin/bash

################################################################
# Use this file to execute commands after configuration finishes
################################################################



# Add tiling to i3 config if i3 version is 4.21 or higher
i3_version=$(i3 --version | grep -oP "(?<=\bversion\s)\S+")
echo "i3 version: $i3_version"


