#!/bin/bash

#COLORS
BLUE='\033[0;34m'
CYAN='\033[0;36m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# License dPi Installer
#
# This script is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This script is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this script; if not, write to the
# Free Software Foundation, Inc., 59 Temple Place, Suite 330,
# Boston, MA  02111-1307  USA

#FUNCTIONS

# Show a progress bar for $1 seconds
#
# Copyleft 2017 by Ignacio Nunez Hernanz <nacho _a_t_ ownyourbits _d_o_t_ com>
# GPL licensed (see end of file) * Use at your own risk!
#
# Example: progress_bar 60
#

progress_bar()
{
  local DURATION=$1
  local INT=0.25      # refresh interval

  local TIME=0
  local CURLEN=0
  local SECS=0
  local FRACTION=0

  local FB=2588       # full block

  trap "echo -e $(tput cnorm); trap - SIGINT; return" SIGINT

  echo -ne "$(tput civis)\r$(tput el)│"                # clean line

  local START=$( date +%s%N )

  while [ $SECS -lt $DURATION ]; do
    local COLS=$( tput cols )

    # main bar
    local L=$( bc -l <<< "( ( $COLS - 5 ) * $TIME  ) / ($DURATION-$INT)" | awk '{ printf "%f", $0 }' )
    local N=$( bc -l <<< $L                                              | awk '{ printf "%d", $0 }' )

    [ $FRACTION -ne 0 ] && echo -ne "$( tput cub 1 )"  # erase partial block

    if [ $N -gt $CURLEN ]; then
      for i in $( seq 1 $(( N - CURLEN )) ); do
        echo -ne \\u$FB
      done
      CURLEN=$N
    fi

    # partial block adjustment
    FRACTION=$( bc -l <<< "( $L - $N ) * 8" | awk '{ printf "%.0f", $0 }' )

    if [ $FRACTION -ne 0 ]; then 
      local PB=$( printf %x $(( 0x258F - FRACTION + 1 )) )
      echo -ne \\u$PB
    fi

    # percentage progress
    local PROGRESS=$( bc -l <<< "( 100 * $TIME ) / ($DURATION-$INT)" | awk '{ printf "%.0f", $0 }' )
    echo -ne "$( tput sc )"                            # save pos
    echo -ne "\r$( tput cuf $(( COLS - 6 )) )"         # move cur
    echo -ne "│ $PROGRESS%"
    echo -ne "$( tput rc )"                            # restore pos

    TIME=$( bc -l <<< "$TIME + $INT" | awk '{ printf "%f", $0 }' )
    SECS=$( bc -l <<<  $TIME         | awk '{ printf "%d", $0 }' )

    # take into account loop execution time
    local END=$( date +%s%N )
    local DELTA=$( bc -l <<< "$INT - ( $END - $START )/1000000000" \
                   | awk '{ if ( $0 > 0 ) printf "%f", $0; else print "0" }' )
    sleep $DELTA
    START=$( date +%s%N )
  done

  echo $(tput cnorm)
  trap - SIGINT
}

printf "                     ${GREEN}_ ____ ${NC}${RED} _ ${NC}\n"
printf "                  "${GREEN}"__| |  _  ${NC}${RED}(_) ${NC}\n"
printf "                 ${GREEN}/ _  | |_) | |${NC}\n"
printf "                ${GREEN}| (_| |  __/| |${NC}\n"
printf "                 ${GREEN}\__._|_|   |_|${NC}\n"
printf "3333333333333333333333333333333333333333333333333\n"
printf "333333ddd${GREEN}--------${NC}dd33333333333dd${GREEN}--------${NC}ddd333333\n"
printf "3333${GREEN}-................${NC}d33333d${GREEN}................-${NC}3333\n"
printf "3333${GREEN}-.................-${NC}333d${GREEN}..................${NC}3333\n"
printf "3333d${GREEN}..................${NC}d33${GREEN}..................-${NC}3333\n"
printf "33333${GREEN}-..........---....${NC}333${GREEN}....---..........-${NC}33333\n"
printf "333333${GREEN}-............-${NC}d-33333dd${GREEN}-............-${NC}333333\n"
printf "33333333${GREEN}-..........-${NC}333333333${GREEN}-..........-${NC}33333333\n"
printf "3333333333${GREEN}---...--${NC}d33333333333d${GREEN}--....--${NC}3333333333\n"
printf "333333333333333333dddd---d--dd3333333333333333333\n"
printf "33333333333333d-------d--d--------333333333333333\n"
printf "333333333333--------........---------333333333333\n"
printf "3333333333----d-..--${RED}d3333333dd${NC}--.-d----3333333333\n"
printf "33333333d--dd-.-${RED}d333333333333333d${NC}-..d---d33333333\n"
printf "3333333d--d-.-${RED}33d${NC}--..--------${RED}d33333${NC}-.-d--d3333333\n"
printf "333333d--d-.-${RED}33333${NC}-..${RED}d3333d${NC}-...-${RED}3333d${NC}.-d--d333333\n"
printf "333333----.-${RED}333333${NC}-..${RED}d3333333${NC}-..-${RED}3333${NC}-.----333333\n"
printf "333333--3-.${RED}3333333${NC}-..${RED}d33333333${NC}...${RED}d3333${NC}.-3--333333\n"
printf "33333d--3..${RED}3333333${NC}-..${RED}d33333333${NC}...${RED}d3333${NC}..3--333333\n"
printf "333333--d-.${RED}d333333${NC}-..${RED}d33333333${NC}...${RED}3333d${NC}.-d--333333\n"
printf "333333---d.-${RED}333333${NC}-..${RED}d333333d${NC}...${RED}d3333${NC}-.d---333333\n"
printf "3333333--d-.-${RED}33333${NC}-..-${RED}dddd${NC}-...-${RED}33333${NC}-.-d--3333333\n"
printf "3333333d--dd..${RED}d3d${NC}----------${RED}d333333d${NC}..d---33333333\n"
printf "333333333---d-.--${RED}333333333333333${NC}--.-d---333333333\n"
printf "3333333333d---d--..--${RED}ddddddd${NC}---.--d---d3333333333\n"
printf "3333333333333-----------------------d333333333333\n"
printf "333333333333333dd----------------3333333333333333\n"
printf "333333333333333333333ddddddd333333333333333333333\n"
printf "3333333333333333333333333333333333333333333333333\n\n"

progress_bar 3

printf "${GREEN}Installing dPi, Denarius, and related dependancies${NC}\n"

lsof /var/lib/dpkg/lock >/dev/null 2>&1
[ $? = 0 ] && echo "dpkg is currently locked, cannot install dPi...Please ensure you are not running software updates"

sudo apt-get update -y && sudo apt-get upgrade -y

sudo apt-get install -y git unzip build-essential libssl-dev autogen automake curl wget jq snap snapd pwgen

sudo apt-get install -y libssl1.0-dev

printf "${GREEN}Dependancies Installed Successfully!${NC}\n"

printf "${GREEN}Installing NVM and Node Version 6.x!${NC}\n"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

if [ ! -d ~/.nvm ]; then
  wget -qO- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash
  source ~/.nvm/nvm.sh
  source ~/.profile
  source ~/.bashrc
  nvm install v8
  npm install
  npm install -g forever
fi

printf "${GREEN}Successfully Installed NVM and Node Version 6.x!${NC}\n"

printf "${GREEN}Snap installing Denarius...${NC}\n"

sudo snap install denarius

printf "${GREEN}Rebooting Denarius to inject credentials...${NC}\n"

denarius.daemon stop

echo "This will take 6 minutes.......Please wait....."

progress_bar 120

denarius.daemon

echo "This will take 4 minutes.......Please wait....."

progress_bar 120

denarius.daemon stop

echo "This will take 2 minutes.......Please wait....."

progress_bar 120

echo "Denarius stopped and prepared for credential injection"

#Generate random rpcuser and rpcpass for injection
PWUD1=$(pwgen 13 1)

PWPD2=$(pwgen 33 1)

echo "Generated random username and password..."

#Update denarius.conf to match env credentials
sed -i "s/.*rpcuser=.*/rpcuser="${PWUD1}"/" ~/snap/denarius/common/.denarius/denarius.conf

sed -i "s/.*rpcpassword=.*/rpcpassword="${PWPD2}"/" ~/snap/denarius/common/.denarius/denarius.conf

echo "Injected newly generated username and password..."

echo "Starting Denarius"

denarius.daemon

progress_bar 10

echo "Installing Forever and Nodemon"

sudo npm install -g forever nodemon

echo "Installing dPi from Github"

if [ -d "dpi" ]; then
  sudo rm -rf dpi
fi

git clone https://github.com/carsenk/dpi

cd dpi

echo "Installing dPi Node Modules..."

npm install

echo "Successfully Installed dPi Node Modules"

echo "Updating Enviroment..."

#Update enviroment file
sed -i "s/.*DNRUSER=.*/DNRUSER="${PWUD1}"/" .env

sed -i "s/.*DNRPASS=.*/DNRPASS="${PWPD2}"/" .env
echo "Successfully injected generated username and password to dPi"

PWDPI3=$(pwgen 15 1)

echo "Updating dPi Protection and Generating Password..."

sed -i "s/.*DPIPASS=.*/DPIPASS="${PWDPI3}"/" .env

sudo forever start app.js

echo "dPi and Denarius are successfully installed! dPi is now running on port 3000, open your browser to this devices local LAN IP, e.g. 192.168.x.x:3000"

echo "$(tput setaf 7)Your dPi credentials are $(tput setaf 2)dpiadmin $(tput setaf 7)& password is $(tput setaf 3)$PWDPI3"