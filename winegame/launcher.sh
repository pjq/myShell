#########################################################################
# Author: PengJianqing@sina.com
# Created Time: 2008年04月28日 星期一 21时31分58秒
# File Name: launcher.sh
# Description: 
#########################################################################
#!/bin/bash
#!/bin/sh
#uncomment if launching from console session
#sudo /etc/init.d/gdm stop
#KDE use this instead
#sudo /etc/init.d/kdm stop

# Launches a new X session on display 3. If you don't have an Nvidia card
# take out the "& nvidia-settings --load-config-only" part
X :3 -ac & nvidia-settings --load-config-only

# Goto game dir (modify as needed)
cd "$HOME/.wine/drive_c/Program Files/Game/Directory/"

# Forces the system to have a break for 2 seconds, X doesn't launch instantly
sleep 2

# Launches game (modify as needed)
DISPLAY=:3 WINEDEBUG=-all wine "/media/sda7/games/cs1.5/cs1.5/hl.exe"
