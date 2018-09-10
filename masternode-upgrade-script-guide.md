# How to upgrade your masternode to v1.1

- Instructions for using script (assumes you have a running masternode on Ubuntu server)

  __Step-by-step:__
    - Connect to your VPS server as the root user
    - Type the following command to download the script:

      ```wget "https://raw.githubusercontent.com/EvilCrypto/mbpos-resources/master/linux-masternode-upgrade-script.sh"```
    - Next, type the following command to allow execution of the downloaded script:

      ```chmod +x linux-masternode-upgrade-script.sh```
    - Finally, start your upgrade with the following command:

      ```./linux-masternode-upgrade-script.sh```

The script will stop your masternode software, replace the wallet binaries, and start a reindex of the blockchain database.
