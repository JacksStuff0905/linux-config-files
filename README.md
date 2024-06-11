
# Linux Configuration Files

Here are my linux config files


### Use this command to install config files:
#### Make sure wget is installed!
```bash
sudo rm master.zip &> /dev/null; sudo rm -r linux-config-files-master/ &> /dev/null; printf "\n\e[93mStarting config file installation...\e[0m\n\n"; wget https://github.com/JacksStuff0905/linux-config-files/archive/master.zip &> /dev/null && unzip master.zip &> /dev/null && bash linux-config-files-master/load-config-files.sh; sudo rm master.zip
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
