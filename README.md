# ark-scripts
Scripts for Linux-based Ark servers

This set of scripts should take care of the installation, maintenance, upkeep, and backups of your Ark server across Linux distros. This is currently a work in progress.

What's done:
- ark_start.sh will fire up your Ark server for you with all the best params. Be sure to set the correct map and Ark installation directory.
- update_ark.sh will automatically updated your Ark server for you. It first checks to see if anyone is connected to your server. If not, it will graciously stop the server, perform updates, and then restart the server.
- backup_ark.sh will create tarballs of your Ark server, named according to the time and date of backup. By default, S3 backups are disabled. You can remove "exit" from the end of the script to enable the S3 backups. Be sure that your AWS configuration is correct setup (will integrate checks for this in the future).
- cron job, located in cron.d - copy to your cron.d folder and it should be good to go. Verify the paths first, of course. If cron's not installed, I feel bad for you son, I've got 99 problems but a cron job ain't one.

TODO:
- Verify dependencies for this automation, install missing deps
- Automatic steam and Ark server installation and setup
- Automatic script setup
- Optional S3 setup
- Some simple configuration options (maybe - configs are up to you for now)
