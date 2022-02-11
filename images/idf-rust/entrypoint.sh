#!/usr/bin/env bash

# DO NOT EDIT
# Generated by bin/generate_files
set -ex

function main() {
  local user_name=${USER_NAME:-user}

  if [ ! -d "${HOME}" ]; then
    mkdir -p "${HOME}"
  fi

  if ! whoami &> /dev/null; then
    if [ -w /etc/passwd ]; then
      echo "${user_name}:x:$(id -u):0:${user_name} user:${HOME}:/bin/bash" >> /etc/passwd
      echo "${user_name}:x:$(id -u):" >> /etc/group
      echo "${user_name}:!:$(expr $(date +%s) / 86400):0:99999:7:::" >> /etc/shadow
    fi
  fi

  sudo chown -R $(id -u) "${HOME}"

  if [ -n "$CHE_WORKSPACE_NAMESPACE" ]; then
    if curl --fail -I https://github.com/$CHE_WORKSPACE_NAMESPACE/dotfiles; then
      git clone https://github.com/$CHE_WORKSPACE_NAMESPACE/dotfiles ~/dotfiles
      if [ -f ~/dotfiles/install ]; then
        ~/dotfiles/install || true
      fi
    else
      git clone git://github.com/ohmybash/oh-my-bash.git ~/.oh-my-bash --depth 1
      cp ~/.oh-my-bash/templates/bashrc.osh-template ~/.bashrc
    fi
  fi
}

main

exec "$@"