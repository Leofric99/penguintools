#!/bin/bash

function clone_repo() {
    read -p "Enter the link to the GitHub repository: " repo_link
    read -p "Enter the path of the folder to store the repository: " repo_path
    read -p "Enter your GitHub username: " username
    read -p "Enter the project (repository) name: " project_name

    git clone "$repo_link" "$repo_path"
    if [ $? -eq 0 ]; then
        cd "$repo_path" || exit
        git init
        git add .
        git remote set-url origin "git@github.com:$username/$project_name.git"
        git commit -m "Initial Commit from new device"
        if [ $? -eq 0 ]; then
            git push
        else
            echo "Commit failed. Please check the repository status."
        fi
    else
        echo "Cloning failed. Please check the repository link and try again."
    fi
}

function pull_changes() {
    read -p "Enter the target directory: " target_dir
    cd "$target_dir" || exit
    git pull
}

function commit_changes() {
    read -p "Enter the target directory: " target_dir
    read -p "Enter the commit message: " commit_message
    cd "$target_dir" || exit
    git add .
    git commit -m "$commit_message"
}

function push_changes() {
    read -p "Enter the target directory: " target_dir
    cd "$target_dir" || exit
    git push
}

function generate_ssh_keys() {
    ssh-keygen
}

while true; do
    echo "1. Clone a repository and link with GitHub ready for pushing"
    echo "2. Pull changes to a GitHub repository"
    echo "3. Commit changes to a GitHub repository"
    echo "4. Push changes to a GitHub repository"
    echo "5. Generate SSH Keys for GitHub Authentication"
    echo "6. Quit"
    read -p "Select an option: " option

    case $option in
        1)
            clone_repo
            ;;
        2)
            pull_changes
            ;;
        3)
            commit_changes
            ;;
        4)
            push_changes
            ;;
        5)
            generate_ssh_keys
            ;;
        6)
            echo "Quitting..."
            break
            ;;
        *)
            echo "Invalid option. Please try again."
            ;;
    esac
done
