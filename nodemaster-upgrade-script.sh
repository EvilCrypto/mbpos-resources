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
MAX=7
CURRSTEP=0

COINDOWNLOADLINK=https://github.com/bifrost-actual/bifrost-coin/releases/download/v1.1.1/bifrost-1.1.1-aarch64-linux-gnu.tar.gz
COINDOWNLOADFILE=bifrost-1.1.1-aarch64-linux-gnu.tar.gz
COINREPO=https://github.com/bifrost-actual/bifrost-coin.git
COINRPCPORT=9228
COINPORT=9229
COINDAEMON=bifrostd
COINCLIENT=bifrost-cli
COINTX=bifrost-tx
COINCORE=.bifrost
COINCONFIG=bifrost.conf
COINDOWNLOADDIR=bifrostdownload
MASTERNODE_COUNT=0

detectMasternodes() {
    for i in {1..100}
    do
        if [ -d "/var/lib/masternodes/bifrost${i}" ]; then
            continue
        else
            break
        fi
    done
    let "i--"
    return ${i}
}
stopServers() {
    let "CURRSTEP++"
    echo
    echo -e "[${CURRSTEP}/${MAX}] Stopping masternode services. Please stand by..."
    for i in $(eval echo {1..$MASTERNODE_COUNT} )
    do
        echo "Stopping masternode ${i}"
        systemctl stop "bifrost_n${i}" > /dev/null 2>&1
    done
}

startServers() {
    let "CURRSTEP++"
    echo
    echo -e "[${CURRSTEP}/${MAX}] Starting services. Please stand by..."
    for i in $(eval echo {1..$MASTERNODE_COUNT} )
    do
        echo "Starting masternode ${i}"
        systemctl enable "bifrost_n${i}" > /dev/null 2>&1
        systemctl restart "bifrost_n${i}" > /dev/null 2>&1
        sleep 2
    done
}

purgeOldInstallation() {
    let "CURRSTEP++"
    echo
    echo -e "[${CURRSTEP}/${MAX}] Searching and removing old masternode binaries. Please stand by..."
    #remove binaries and bifrost utilities
    cd /usr/local/bin && sudo rm bifrost-cli bifrost-tx bifrostd > /dev/null 2>&1 && cd
    for i in $(eval echo {1..$MASTERNODE_COUNT} )
    do
        rm -rf "/var/lib/masternodes/bifrost${i}/blocks" > /dev/null 2>&1
        rm -rf "/var/lib/masternodes/bifrost${i}/chainstate" > /dev/null 2>&1
        rm -rf "/var/lib/masternodes/bifrost${i}/database" > /dev/null 2>&1
        rm -rf "/var/lib/masternodes/bifrost${i}/sporks" > /dev/null 2>&1
        rm -rf "/var/lib/masternodes/bifrost${i}/zerocoin" > /dev/null 2>&1
        rm -r "/var/lib/masternodes/bifrost${i}/debug.log" > /dev/null 2>&1
        rm -r "/var/lib/masternodes/bifrost${i}/db.log" > /dev/null 2>&1
        rm -r "/var/lib/masternodes/bifrost${i}/mncache.dat" > /dev/null 2>&1
        rm -r "/var/lib/masternodes/bifrost${i}/mnpayments.dat" > /dev/null 2>&1
        rm -r "/var/lib/masternodes/bifrost${i}/peers.dat" > /dev/null 2>&1
    done

    echo -e "${GREEN}* Done${NONE}";
}

addNodes(){
    let "CURRSTEP++"
    echo
    echo -e "[${CURRSTEP}/${MAX}] Adding core masternodes to config files. Please stand by..."
    for i in $(eval echo {1..$MASTERNODE_COUNT} )
    do
        grep -q -F 'addnode=144.202.109.227' "/etc/masternodes/bifrost_n${i}.conf" || echo 'addnode=144.202.109.227' >> "/etc/masternodes/bifrost_n${i}.conf" > /dev/null 2>&1
        grep -q -F 'addnode=144.202.108.165' "/etc/masternodes/bifrost_n${i}.conf" || echo 'addnode=144.202.108.165' >> "/etc/masternodes/bifrost_n${i}.conf" > /dev/null 2>&1
        grep -q -F 'addnode=144.202.104.91' "/etc/masternodes/bifrost_n${i}.conf" || echo 'addnode=144.202.104.91' >> "/etc/masternodes/bifrost_n${i}.conf" > /dev/null 2>&1
        grep -q -F 'addnode=45.77.1.99' "/etc/masternodes/bifrost_n${i}.conf" || echo 'addnode=45.77.1.99' >> "/etc/masternodes/bifrost_n${i}.conf" > /dev/null 2>&1
        grep -q -F 'addnode=45.77.3.72' "/etc/masternodes/bifrost_n${i}.conf" || echo 'addnode=45.77.3.72' >> "/etc/masternodes/bifrost_n${i}.conf" > /dev/null 2>&1
        grep -q -F 'addnode=144.202.111.53' "/etc/masternodes/bifrost_n${i}.conf" || echo 'addnode=144.202.111.53' >> "/etc/masternodes/bifrost_n${i}.conf" > /dev/null 2>&1
        grep -q -F 'addnode=45.63.85.36' "/etc/masternodes/bifrost_n${i}.conf" || echo 'addnode=45.63.85.36' >> "/etc/masternodes/bifrost_n${i}.conf" > /dev/null 2>&1
        grep -q -F 'addnode=104.207.149.100' "/etc/masternodes/bifrost_n${i}.conf" || echo 'addnode=104.207.149.100' >> "/etc/masternodes/bifrost_n${i}.conf" > /dev/null 2>&1
        grep -q -F 'addnode=144.202.107.197' "/etc/masternodes/bifrost_n${i}.conf" || echo 'addnode=144.202.107.197' >> "/etc/masternodes/bifrost_n${i}.conf" > /dev/null 2>&1
    done
}

installDependencies() {
    let "CURRSTEP++"
    echo
    echo -e "[${CURRSTEP}/${MAX}] Installing/updating dependecies. Please stand by..."

    sudo apt-get install bc git nano rpl wget python-virtualenv -qq -y > /dev/null 2>&1
    sudo apt-get install build-essential libtool automake autoconf -qq -y > /dev/null 2>&1
    sudo apt-get install autotools-dev autoconf pkg-config libssl-dev -qq -y > /dev/null 2>&1
    sudo apt-get install libgmp3-dev libevent-dev bsdmainutils libboost-all-dev -qq -y > /dev/null 2>&1
    sudo apt-get install software-properties-common python-software-properties -qq -y > /dev/null 2>&1
    sudo add-apt-repository ppa:bitcoin/bitcoin -y > /dev/null 2>&1
    sudo apt-get update -qq -y > /dev/null 2>&1
    sudo apt-get install libdb4.8-dev libdb4.8++-dev -qq -y > /dev/null 2>&1
    sudo apt-get install libminiupnpc-dev -qq -y > /dev/null 2>&1
    sudo apt-get install libzmq5 -qq -y > /dev/null 2>&1
    sudo apt-get install virtualenv -qq -y > /dev/null 2>&1
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

cleanUp() {
    let "CURRSTEP++"
    echo
    echo -e "[${CURRSTEP}/${MAX}] Cleaning up";
    cd
    if [ -d "$COINDOWNLOADDIR" ]; then rm -rf $COINDOWNLOADDIR; fi
}

echo
echo
echo
read -p "This script will upgrade your Bifrost Masternode to v1.1. Do you wish to continue? (y/n)?" response
echo

if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]; then
    detectMasternodes
    let "MASTERNODE_COUNT=$?"
    # let "MASTERNODE_COUNT=1"
    echo "Detected ${MASTERNODE_COUNT} masternodes"
    stopServers
    purgeOldInstallation
    installDependencies
    downloadWallet
    addNodes
    startServers
    cleanUp

    echo -e "================================================================================================"
    echo -e "${BOLD}The VPS side of your masternode(s) have been upgraded and are now syncing ${NONE}"
    echo -e "================================================================================================"
else
    echo && echo "Installation cancelled" && echo
fi
