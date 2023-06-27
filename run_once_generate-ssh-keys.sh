#!/bin/bash

# Default values
key_file_name="default.ed25519"
git_file_name="git.ed25519"

# Get the hostname, OS ID, and username
hostname=$(hostname)
os_id=$(grep -oP '(?<=^ID=)[^"]+' /etc/os-release)
username=$(whoami)

# Generate the SSH key pair
generate_key() {
  ssh-keygen -t ed25519 -C "$username@$hostname:$os_id" -f ~/.ssh/$1
}

# Add the generated key to the SSH agent
add_to_ssh_agent() {
  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/$1
}

if [ -f ~/.ssh/$key_file_name ] && [ -f ~/.ssh/$git_file_name ]; then
  echo "Default and git keys already exist";
else
  if ! [ -f ~/.ssh/$key_file_name ]; then
  generate_key $key_file_name
  add_to_ssh_agent $key_file_name
  fi
  if ! [ -f ~/.ssh/$git_file_name ]; then
  generate_key $git_file_name
  add_to_ssh_agent $git_file_name
  fi
fi
