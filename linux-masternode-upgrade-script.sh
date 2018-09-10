#!/usr/bin/env bash
NONE='\033[00m'
RED='\033[01;31m'
GREEN='\033[01;32m'
YELLOW='\033[01;33m'
PURPLE='\033[01;35m'
CYAN='\033[01;36m'
WHITE='\033[01;37m'
BOLD='\033[1m'
UNDERLINE='\033[4m'
MAX=10
CURRSTEP=0

COINDOWNLOADLINK=https://github.com/EvilCrypto/MasterBitPOS/releases/download/v1.1.1/masterbitpos-1.1.1-aarch64-linux-gnu.tar.gz
COINDOWNLOADFILE=masterbitpos-1.1.1-aarch64-linux-gnu.tar.gz
COINREPO=https://github.com/EvilCrypto/MasterBitPOS.git
COINRPCPORT=9228
COINPORT=9229
COINDAEMON=masterbitposd
COINCLIENT=masterbitpos-cli
COINTX=masterbitpos-tx
COINCORE=.masterbitpos
COINCONFIG=masterbitpos.conf
COINDOWNLOADDIR=masterbitposdownload

purgeOldInstallation() {
    echo "Searching and removing old masternode binaries"
    #kill wallet daemon
    sudo killall masterbitposd > /dev/null 2>&1
    #remove old files
    #remove binaries and masterbitpos utilities
    cd /usr/local/bin && sudo rm masterbitpos-cli masterbitpos-tx masterbitposd > /dev/null 2>&1 && cd
    echo -e "${GREEN}* Done${NONE}";
}

installDependencies() {
    let "CURRSTEP++"
    echo
    echo -e "[${CURRSTEP}/${MAX}] Installing dependecies. Please wait..."
    sudo apt-get install libevent-dev libzmq5 -qq -y > /dev/null 2>&1
    echo -e "${NONE}${GREEN}* Done${NONE}";
}

downloadWallet() {
    let "CURRSTEP++"
    echo
    echo -e "[${CURRSTEP}/${MAX}] Downloading wallet binaries. Please wait, this might take a while to complete..."
    cd && mkdir -p $COINDOWNLOADDIR && cd $COINDOWNLOADDIR
    wget $COINDOWNLOADLINK > /dev/null 2>&1
    tar xzf $COINDOWNLOADFILE --directory /usr/local/bin/
    mv $COINDOWNLOADFILE > /dev/null 2>&1
    echo -e "${NONE}${GREEN}* Done${NONE}";
}

startWallet() {
    let "CURRSTEP++"
    echo
    echo -e "[${CURRSTEP}/${MAX}] Starting wallet daemon..."
    $COINDAEMON --reindex > /dev/null 2>&1
    sleep 2
    echo -e "${GREEN}* Done${NONE}";
}

cleanUp() {
    let "CURRSTEP++"
    echo
    echo -e "[${CURRSTEP}/${MAX}] Cleaning up";
    cd
    if [ -d "$COINDOWNLOADDIR" ]; then rm -rf $COINDOWNLOADDIR; fi
}
echo -e "-----------------------------------------------------------------------------------"
echo -e "-----------------------------------------------------------------------------------"
read -p "This script will upgrade your MasterBitPOS Masternode to v1.1. Do you wish to continue? (y/n)?" response
echo -e "${NONE}"

if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
echo
    purgeOldInstallation
    installDependencies
    downloadWallet
    startWallet
    cleanUp

    echo -e "================================================================================================"
    echo -e "${BOLD}The VPS side of your masternode has been upgraded and is now syncing"
    echo -e "================================================================================================"
else
    echo && echo "Installation cancelled" && echo
fi
