#!/bin/sh

## README
# /!\ Ce script d'installation est conçu pour mon usage. Ne le lancez pas sans vérifier chaque commande ! /!\

# Enregistrement des copies d'écran sur Dropbox
defaults write com.apple.screencapture location -string "$HOME/Dropbox/Bibou/Screenshots/"
# Attention, nécessite un redémarrage ou un `killall SystemUIServer` pour être pris en compte

echo "Installation de oh-my-zsh"
# Installation de oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

echo "Configuration de git"
git config --global init.defaultBranch main

echo ""
echo "ET VOILÀ !"
echo "Il est maintenant possible d'activer d'autres dossiers dans la synchronisation Dropbox."
