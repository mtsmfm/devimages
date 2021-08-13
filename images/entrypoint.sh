#!/usr/bin/env bash

set -eux

function main() {
  local user_name=${USER_NAME:-user}

  if [ ! -d "${HOME}" ]; then
    mkdir -p "${HOME}"
  fi

  if ! whoami &> /dev/null; then
    if [ -w /etc/passwd ]; then
      echo "${user_name}:x:$(id -u):0:${user_name} user:${HOME}:/bin/bash" >> /etc/passwd
      echo "${user_name}:x:$(id -u):" >> /etc/group
      echo "${user_name}:!:$($(date +%s)/86400):0:99999:7:::" >> /etc/shadow
    fi

    if [ -d /etc/sudoers.d ]; then
      echo user ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/${user_name}
      chmod 0440 /etc/sudoers.d/${user_name}
    fi
  fi

  if curl --fail -I https://github.com/$CHE_WORKSPACE_NAMESPACE/dotfiles; then
    git clone https://github.com/$CHE_WORKSPACE_NAMESPACE/dotfiles ~/dotfiles
    ~/dotfiles/install
  else
    git clone git://github.com/ohmybash/oh-my-bash.git ~/.oh-my-bash
    cp ~/.oh-my-bash/templates/bashrc.osh-template ~/.bashrc
  fi
}

main

exec "$@"
