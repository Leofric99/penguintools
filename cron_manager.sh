#!/bin/bash

while true; do
    echo
    echo "Current crontab jobs:"
    echo "---------------------"
    crontab -l | nl -ba
    echo "---------------------"
    echo

    # Print the menu
    echo "Menu:"
    echo "1. Add line(s) to the crontab"
    echo "2. Remove line(s) from the crontab"
    echo "3. Comment out line(s) in the crontab"
    echo "4. Exit the program"
    echo

    # Ask the user to choose an option
    read -p "Enter your choice: " choice
    echo

    case $choice in
        1)
            # Add line(s) to the crontab
            echo "Enter the line(s) to add to the crontab (end with an empty line):"
            new_cron_jobs=""
            while true; do
                read line
                if [ -z "$line" ]; then
                    break
                fi
                new_cron_jobs="$new_cron_jobs$line"$'\n'
            done
            (crontab -l; echo "$new_cron_jobs") | crontab -
            echo "New cron jobs added."
            ;;
        2)
            # Remove line(s) from the crontab
            echo "Enter the line number(s) to remove (separated by spaces):"
            read -a line_numbers
            if [ -z "${line_numbers}" ]; then
                echo "No line numbers entered. Nothing to remove."
            else
                temp_crontab=$(mktemp)
                crontab -l | sed "$(printf '%sd;' "${line_numbers[@]}")" > "$temp_crontab"
                crontab "$temp_crontab"
                rm "$temp_crontab"
                echo "Selected cron jobs removed."
            fi
            ;;
        3)
            # Comment out line(s) in the crontab
            echo "Enter the line number(s) to comment out (separated by spaces):"
            read -a line_numbers
            if [ -z "${line_numbers}" ]; then
                echo "No line numbers entered. Nothing to comment out."
            else
                temp_crontab=$(mktemp)
                crontab -l | {
                    current_cron_jobs=$(cat)
                    for line_number in "${line_numbers[@]}"; do
                        line=$(echo "$current_cron_jobs" | sed -n "${line_number}p")
                        if [[ $line == \#* ]]; then
                            echo "Line $line_number is already commented out."
                        else
                            current_cron_jobs=$(echo "$current_cron_jobs" | sed "${line_number}s/^/#/")
                            echo "Line $line_number commented out."
                        fi
                    done
                    echo "$current_cron_jobs" > "$temp_crontab"
                }
                crontab "$temp_crontab"
                rm "$temp_crontab"
            fi
            ;;
        4)
            # Exit the program
            echo "Exiting..."
            break
            ;;
        *)
            echo "Invalid option. Please enter a number from 1 to 4."
            ;;
    esac

    echo
done
