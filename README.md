# penguintools
Various tools, predominantly written in bash, for linux server management.

## Tools

### cron_manager.sh

cron_manager.sh manages the user's crontab. The script begins by presenting the user with the current contents of the crontab followed by a menu of options. These options are:

1. Add line(s) to the file
2. Remove line(s) from the file
3. Comment line(s) out
4. Exit the program

### disk_manager.sh

disk_manager.sh manages the user's disks. It begins by presenting the user with a menu of options. At present, those options are:

1. Display the output of `lsblk`
2. Run the `ls` command on a directory
2. Mount a drive to the directory
3. Unmount a drive from the directory
4. Exit the program

### file_manger.sh

file_manager.sh can move, copy, and rename files as well as mirroring one directory to another (for backup purposes).

The script will provide a number of options:

1. Rename a file
2. Move a file
3. Copy a file
4. Mirror a directory
5. Run the ls command on a directory
6. Exit

### datafile_converter.sh

This file converts json files to csv files, and vice virsa. Simply run the script, and when prompted, specify the file or filepath of either a csv or json file and it will convert it to the alternative.

## Installation

There are no dependancies for most of these tools, only a linux instance. The only tool that requires js and csvtoolkit is `datafile_converter.sh` To get started, clone the repository into a desired folder and run the various `.sh` files.
