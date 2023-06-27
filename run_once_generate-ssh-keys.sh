#!/bin/bash

# Default values
save_to_clipboard=false
key_file_name="default.ed25519"

# Get the hostname, OS ID, and username
hostname=$(hostname)
os_id=$(grep -oP '(?<=^ID=)[^"]+' /etc/os-release)
username=$(whoami)

# Parse command line options
while getopts ":CN:" opt; do
  case $opt in
    C)
      save_to_clipboard=true
      ;;
    N)
      key_file_name=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
  esac
done

# Generate the SSH key pair
generate_key() {
  ssh-keygen -t ed25519 -C "$username@$hostname:$os_id" -f ~/.ssh/$key_file_name
}

# Add the generated key to the SSH agent
add_to_ssh_agent() {
  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/$key_file_name
}

# Save public key to clipboard if specified
save_public_key_to_clipboard() {
  if [ "$save_to_clipboard" = true ]; then
    if [ "$(uname)" == "Darwin" ]; then
      pbcopy < ~/.ssh/$key_file_name.pub
      echo "Public key copied to clipboard."
    elif [ "$(expr substr $(uname -s) 1 5)" == "Linux" ]; then
      if command -v "xclip" >/dev/null 2>&1; then
        xclip -sel clip < ~/.ssh/$key_file_name.pub
        echo "Public key copied to clipboard."
      else
        echo "xclip is not installed. Please install xclip or manually copy the public key."
      fi
    else
      echo "Clipboard copying is not supported on this operating system. Please manually copy the public key."
    fi
  fi
}

if [ -f ~/.ssh/$key_file_name ]; then
  echo "$key_file_name already exists";
else
  # Generate the key pair, add to SSH agent, and save public key to clipboard if specified
  generate_key
  add_to_ssh_agent
  save_public_key_to_clipboard
fi
