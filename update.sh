#!/usr/bin/env bash

set -x
# Update brew and upgrade all packages
brew update
brew outdated
brew upgrade
brew doctor

# Update Mac App Store apps
mas upgrade

set +x

red=`tput setaf 1`
green=`tput setaf 2`
reset=`tput sgr0`

# List all casks and for each of them,
# test if a newer version is available.
updateAvailable=( $(brew outdated --cask --greedy --verbose | grep -v '(latest)' | cut -f1 -d" ") )

echo "Scanning the casks…"
for updateAvailable in ${updateAvailable[@]}
do
    read -p "${red}${updateAvailable}${reset} requires ${red}update${reset}. Do youn want to update? (${green}y${reset}/${red}n${reset}) Default: ${red}no${reset} " -n 1 -r
    echo    # (optional) move to a new line
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Ok! Doing nothing."
    else
        echo "Ok! Let's update ${green}${updateAvailable}${green}!"
        (set -x; brew uninstall $updateAvailable --force;)
        (set -x; brew install $updateAvailable --cask --force;)
    fi
done

brew cleanup
