
# Linux Configuration Files

Here are my linux config files.

<br>

#### Make sure wget is installed!
#### Before installing all the config files, check if there are i3 any config errors using

#### If there are, remove the i3 config file using the command below.
```bash
rm ~/.config/i3/config
```
<br>

### Use this command to install config files:
```bash
grep -oP ".*ERROR: CONFIG:.*" <<< `i3 -C` &> /dev/null && printf "\e[93mFound i3 config error: removing i3 config file\e[0m\n" && sudo rm ~/.config/i3/config; sudo rm master.zip &> /dev/null; sudo rm -r linux-config-files-master/ &> /dev/null; printf "\n\e[93mStarting config file installation...\e[0m\n\n"; wget https://github.com/JacksStuff0905/linux-config-files/archive/master.zip &> /dev/null && unzip master.zip &> /dev/null && bash linux-config-files-master/load-config-files.sh; sudo rm master.zip
```

### In case the command does not work use this command to get the full output:

```bash
sudo rm master.zip; sudo rm -r linux-config-files-master/; printf "\n\e[93mStarting config file installation...\e[0m\n\n"; wget https://github.com/JacksStuff0905/linux-config-files/archive/master.zip && unzip master.zip && bash linux-config-files-master/load-config-files.sh; sudo rm master.zip
```
<br><br>

#### *!!!WARNING: USE THOSE COMMANDS AT YOUR OWN RISK!!!*


<br><br><br>
## Info:
- Supported package managers:
    - apt
    - pacman
    - zypper
- Supported distros:
    - Ubuntu + Ubuntu-based
    - OpenSUSE
    - Arch (Limited)
