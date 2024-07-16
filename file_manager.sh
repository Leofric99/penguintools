#!/bin/bash

# Function to display the menu
display_menu() {
    echo "Menu:"
    echo
    echo "1. Rename a file"
    echo "2. Move a file"
    echo "3. Copy a file"
    echo "4. Mirror a directory"
    echo "5. Run the ls command on a directory"
    echo "6. Exit"
    echo
}

# Function to handle option 1: Rename a file
rename_file() {
    echo "Enter the path to the file (e.g. /home/user/):"
    read -e FILE_PATH
    # Ensure FILE_PATH ends with a slash
    FILE_PATH="${FILE_PATH%/}/"

    echo "Enter the file name and extension (e.g. file.txt):"
    read FILE_NAME

    echo "Enter the new file name and extension (e.g. file2.txt):"
    read NEW_FILE_NAME

    # Perform the rename operation
    mv "${FILE_PATH}${FILE_NAME}" "${FILE_PATH}${NEW_FILE_NAME}"
    echo "Operation completed."
}

# Function to handle option 2: Move a file
move_file() {
    echo "Enter the current location of the file (including filename and extension):"
    read -e CURRENT_LOCATION

    echo "Enter the new desired location (including filename and extension):"
    read -e NEW_LOCATION

    # Perform the move operation
    mv "$CURRENT_LOCATION" "$NEW_LOCATION"
    echo "Operation completed."
}

# Function to handle option 3: Copy a file
copy_file() {
    echo "Enter the existing file location (including filename and extension):"
    read -e SOURCE_FILE

    echo "Enter the location to copy to (including filename and extension):"
    read -e DESTINATION

    # Perform the copy operation
    cp "$SOURCE_FILE" "$DESTINATION"
    echo "Operation completed."
}

# Function to handle option 4: Mirror a directory
mirror_directory() {
    echo "Note: Large directories are recommended to be performed in a"
    echo "      tmux session due to potential duration of operation."
    echo
    echo "      !! Use with Caution !!"
    echo "      This will mirror the contents of a directory. Any files"
    echo "      that are non-existant on the source dir will be removed"
    echo "      from the destination dir."
    echo "      !! Use with caution !!"
    echo
    echo "Enter the source directory:"
    read -e SOURCE_DIR

    echo "Enter the destination directory:"
    read -e DEST_DIR

    # Perform the mirror operation
    rsync -avu --delete "${SOURCE_DIR}/" "${DEST_DIR}/"
    echo "Operation completed."
}

# Function to handle option 5: List contents of a directory
list_directory_contents() {
    echo "Enter the directory to run ls on:"
    read -e dir
    read -p "Enter any arguments for the ls command (leave blank for none): " args
    if [ -d "$dir" ]; then
        echo "Output of ls ${args:-} $dir:"
        echo
        ls ${args:-} "$dir" || echo "Error: Failed to run ls on $dir."
    else
        echo "Error: Directory $dir does not exist."
    fi
}

# Main loop
while true; do
    display_menu

    read -p "Enter your choice (1-6): " choice
    case $choice in
        1) rename_file ;;
        2) move_file ;;
        3) copy_file ;;
        4) mirror_directory ;;
        5) list_directory_contents ;;
        6) echo "Exiting program."; break ;;
        *) echo "Invalid option. Please enter a number between 1 and 6." ;;
    esac

    read -p "Operation completed. Do you want to return to the menu? (y/n): " answer
    if [[ "$answer" != "y" ]]; then
        echo "Exiting program."
        break
    fi
done