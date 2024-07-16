#!/bin/bash

while true; do
    # Print the menu
    echo
    echo "Menu:"
    echo
    echo "------------------------------------"
    echo "1. Display the output of lsblk"
    echo "2. Mount a drive to a directory"
    echo "3. Unmount a drive from a directory"
    echo "4. Exit"
    echo "------------------------------------"
    echo

    # Ask the user to choose an option
    read -p "Enter your choice: " choice
    echo

    case $choice in
        1)
            echo "Output of lsblk:"
            echo
            lsblk || echo "Error: Failed to run lsblk."
            ;;
        2)
            read -p "Enter the drive/device path to mount: " drive_path
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
        3)
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
        4)
            echo "Exiting..."
            break
            ;;
        *)
            echo "Invalid option. Please enter a number from 1 to 4."
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
