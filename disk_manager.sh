#!/bin/bash

while true; do
    # Print the menu
    echo
    echo "Menu:"
    echo
    echo "------------------------------------"
    echo "1. Run the lsblk command"
    echo "2. Run the ls command on a target directory"
    echo "3. Mount a drive to a directory"
    echo "4. Unmount a drive from a directory"
    echo "5. Exit"
    echo "------------------------------------"
    echo

    # Ask the user to choose an option
    read -p "Enter your choice: " choice
    echo

    case $choice in
        1)
            read -p "Enter any arguments for lsblk (leave blank for none): " args
            echo "Output of lsblk ${args:-}:"
            echo
            lsblk ${args:-} || echo "Error: Failed to run lsblk."
            ;;
        2)
            read -p "Enter the directory to run ls on: " dir
            read -p "Enter any arguments for the ls command (leave blank for none): " args
            if [ -d "$dir" ]; then
                echo "Output of ls ${args:-} $dir:"
                echo
                ls ${args:-} $dir || echo "Error: Failed to run ls on $dir."
            else
                echo "Error: Directory $dir does not exist."
            fi
            ;;
        3)
            read -p "Enter the drive/device path: " drive_path
            read -p "Enter the directory to mount to: " mount_point
            if [ -b "$drive_path" ]; then
                if [ -d "$mount_point" ]; then
                    sudo mount $drive_path $mount_point
                    if [ $? -eq 0 ]; then
                        echo "Drive mounted successfully."
                    else
                        echo "Error: Failed to mount $drive_path to $mount_point."
                    fi
                else
                    echo "Error: Directory $mount_point does not exist."
                fi
            else
                echo "Error: Device $drive_path does not exist."
            fi
            ;;
        4)
            read -p "Enter the directory to unmount: " mount_point
            if mountpoint -q $mount_point; then
                sudo umount $mount_point
                if [ $? -eq 0 ]; then
                    echo "Drive unmounted successfully."
                else
                    echo "Error: Failed to unmount $mount_point."
                fi
            else
                echo "Error: $mount_point is not a mount point."
            fi
            ;;
        5)
            echo "Exiting..."
            break
            ;;
        *)
            echo "Invalid option. Please enter a number from 1 to 5."
            ;;
    esac

    # Prompt to return to the menu
    echo
    read -p "Return to the menu? (y/n): " answer
    if [ "$answer" != "y" ]; then
        echo "Exiting..."
        break
    fi

    echo
done
