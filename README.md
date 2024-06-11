
# Linux Configuration Files

Here are my linux config files


### Use this command to install config files:

```bash
sudo rm -f master.zip; sudo rm -rf linux-config-files-master/; printf "\n\e[93mStarting config file installation...\e[0m\n\n"; wget https://github.com/JacksStuff0905/linux-config-files/archive/master.zip &> /dev/null && unzip master.zip &> /dev/null && bash linux-config-files-master/load-config-files.sh; sudo rm master.zip
```

### In case the command does not work use this command to get the full output:

```bash
sudo rm -f master.zip; sudo rm -rf linux-config-files-master/; printf "\n\e[93mStarting config file installation...\e[0m\n\n"; wget https://github.com/JacksStuff0905/linux-config-files/archive/master.zip && unzip master.zip && bash linux-config-files-master/load-config-files.sh; sudo rm master.zip
```

#### *USE THOSE COMMANDS AT YOUR OWN RISK!*


<br><br><br>
## Info:
- Supported package managers:
    - apt
    - pacman
    - zypper
