# penguintools
Various tools, predominantly written in bash, for linux server management.

## Tools
---

### cron_manager.sh

cron_manager.sh manages the user's crontab. The script begins by presenting the user with the current contents of the crontab followed by a menu of options. These options are:

1. Add line(s) to the file
2. Remove line(s) from the file
3. Comment line(s) out
4. Exit the program

### disk_manager.sh

disk_manager.sh manages the user's disks. It begins by presenting the user with a menu of options. At present, those options are:

1. Display the output of `lsblk`
2. Mount a drive to the directory
3. Unmount a drive from the directory
4. Exit the program

*Additional functionality is planned*

## Installation

There are no dependancies for these tools, only a linux instance. To get started, clone the repository into a desired folder and run the various executable files.