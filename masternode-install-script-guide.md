# Masternode Setup Guide Using Install Script - (Ubuntu)

- Instructions for using script (assumes you have already acquired a VPS)

  __Step-by-step:__
    - Connect to your VPS server as the root user
    - Type the following command to download the script:

      ```wget "https://raw.githubusercontent.com/EvilCrypto/mbpos-resources/master/masternode-install-script.sh"```
    - Next, type the following command to allow execution of the downloaded script:

      ```chmod +x masternode-install-script.sh```
    - Finally, start your installation with the following command:

      ```./masternode-install-script.sh```

      The script will evaluate your server, install required dependencies, and either install compiled binaries or download the MasterBitPOS source files and compile them for you.
  It will then create a default configuration, generate a private key, and print the server's information out for you to use when setting up your cold (control) wallet.
