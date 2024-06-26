#!/bin/sh

## README
# /!\ Ce script d'installation est conçu pour mon usage. Ne le lancez pas sans vérifier chaque commande ! /!\

# Sources :
# https://github.com/nicolinuxfr/macOS-post-installation
# https://www.macg.co/logiciels/2017/02/comment-synchroniser-les-preferences-des-apps-avec-mackup-97442
# https://github.com/OzzyCzech/dotfiles/blob/master/.osx

# Demande du mot de passe administrateur dès le départ
sudo -v

# Keep-alive: met à jour le timestamp de `sudo`
# tant que `post-install.sh` n'est pas terminé
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

## LA BASE : Homebrew et les lignes de commande
if test ! $(which brew)
then
  echo "Installation de Homebrew"
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Ajout des binaires Homebrew au PATH
echo 'export PATH="/usr/local/sbin:$PATH"' >> ~/.zshrc

# Mettre à jour la liste des applications disponibles
brew update

# Installer Dropbox au plus tôt pour lancer la synchro des settings
brew install dropbox --cask
echo "Ouverture de Dropbox pour commencer la synchronisation"
open -a Dropbox

# Installer les nouvelles applications du bundle Brewfile
# et mettre à jour celles déjà présentes
brew bundle

# echo "Finalisation de l'installation de The Fuck avec l'alias \"whoops\""
# echo 'eval "$(thefuck --alias whoops)"' >> ~/.zshrc

echo "Installation des outils de développement Ruby"
# Mise à jour de RubyGems
sudo gem update --system --silent
# Installation de RVM
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
curl -sSL https://get.rvm.io | bash -s stable --ruby
# Installation de Bundler
sudo gem install bundler

echo "Installation des outils de développement Node"
# Installation de composants Node
npm install -g npm

echo "Installation d'applications en Node"
# De meilleures aides en ligne : http://tldr.sh/
npm install -g http-serve
npm install -g npm-check-updates
npm install -g prettier

echo "Installation d'utilitaires de terminal"
# Installation d'utilitaires de terminal
eval "$(mcfly init zsh)"


## ************************* CONFIGURATION ********************************
echo "Configuration de quelques paramètres par défaut"

## FINDER

# Affichage de la bibliothèque
# chflags nohidden ~/Library

# Affichage de la barre latérale
defaults write com.apple.finder ShowStatusBar -bool true

# Afficher par défaut en mode colonne
# Flwv ▸ Cover Flow View
# Nlsv ▸ List View
# clmv ▸ Column View
# icnv ▸ Icon View
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

# Boite de dialogue lors de la mise en veille en appuyant sur le bouton
defaults write com.apple.loginwindow PowerButtonSleepsSystem -bool no

# Ne pas afficher le chemin d'accès
defaults write com.apple.finder ShowPathbar -bool false

# Affichage de toutes les extensions
sudo defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Afficher le dossier maison par défaut
defaults write com.apple.finder NewWindowTarget -string "PfHm"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

# Supprimer les doublons dans le menu "ouvrir avec…"
/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user

# Recherche dans le dossier en cours par défaut
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Fenêtre de sauvegarde complète par défaut
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true

# Fenêtre d'impression complète par défaut
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true

# Sauvegarde sur disque (et non sur iCloud) par défaut
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false

# Coup d'œil : sélection de texte
defaults write com.apple.finder QLEnableTextSelection -bool true

# Ne pas alerter en cas de modification de l'extension d'un fichier
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Pas de création de fichiers .DS_STORE sur les disques réseau et externes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Supprimer l'alerte de quarantaine des applications
defaults write com.apple.LaunchServices LSQuarantine -bool false

## DOCK

# Taille minimum
defaults write com.apple.dock tilesize -int 32
# Agrandissement actif
defaults write com.apple.dock magnification -bool true
# Taille maximale pour l'agrandissement
defaults write com.apple.dock largesize -float 128

## MISSION CONTROL

# Pas d'organisation des bureaux en fonction des apps ouvertes
defaults write com.apple.dock mru-spaces -bool false

# Mot de passe demandé immédiatement quand l'économiseur d'écran s'active
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

## CLAVIER ET TRACKPAD

# Accès au clavier complet (tabulation dans les boîtes de dialogue)
sudo defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

# Arrêt pop-up clavier façon iOS
sudo defaults write -g ApplePressAndHoldEnabled -bool false

# Trackpad : toucher pour cliquer
sudo defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
sudo defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

## APPS

# Ne pas afficher les applications récentes dans Dock
defaults write com.apple.dock show-recents -bool false

# Afficher les fichiers cachés
defaults write com.apple.finder AppleShowAllFiles YES

# Vérifier la disponibilité de mise à jour quotidiennement
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Safari : menu développeur / URL en bas à gauche / URL complète en haut / Do Not Track / affichage barre favoris
defaults write com.apple.safari IncludeDevelopMenu -int 1

# Chrome : désactiver la navigation dans l'historique au swipe
defaults write com.google.Chrome AppleEnableSwipeNavigateWithScrolls -bool FALSE

# Photos : pas d'affichage pour les iPhone
defaults -currentHost write com.apple.ImageCapture disableHotPlug -bool YES

# TextEdit : .txt par défaut
defaults write com.apple.TextEdit RichText -int 0

# TextEdit : ouvre et enregistre les fichiers en UTF-8
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

## SONS

# Démarrer en silence
sudo nvram SystemAudioVolume="%00"

# Alertes sonores quand on modifie le volume
sudo defaults write com.apple.systemsound com.apple.sound.beep.volume -float 1

## IMAGES

# Enregistrer les screenshots en PNG (autres options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

# Ne pas mettre d'ombre sur les screenshots
defaults write com.apple.screencapture disable-shadow -bool true

## ************ Fin de l'installation *********
echo "Finder et Dock relancés… redémarrage nécessaire pour terminer."
killall Dock
killall Finder

echo "Derniers nettoyages…"
brew cleanup
rm -f -r /Library/Caches/Homebrew/*

echo ""
echo "ET VOILÀ !"
echo "Après synchronisation des données Dropbox (seuls les dossiers « Mackup » et « Settings » sont nécessaires dans un premier temps), lancer le script post-cloud.sh"
