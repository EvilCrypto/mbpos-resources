# How to upgrade your Nodemaster masternode to v1.1

### Note - This script is only for masternodes installed with the Nodemaster VPS script!

- Instructions for using script (assumes you have a running masternode on Ubuntu server)

  __Step-by-step:__
    - Connect to your VPS server as the root user
    - Type the following command to download the script:

      ```wget "https://raw.githubusercontent.com/EvilCrypto/mbpos-resources/master/nodemaster-upgrade-script.sh"```
    - Next, type the following command to allow execution of the downloaded script:

      ```chmod +x nodemaster-upgrade-script.sh```
    - Finally, start your upgrade with the following command:

      ```./nodemaster-upgrade-script.sh```

The script will stop your masternode software, replace the wallet binaries, and start a reindex of the blockchain database.
