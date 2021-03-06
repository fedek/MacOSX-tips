#!/bin/bash
# A personal cheatsheet for setting up a osx for my needs
# fedek@infobytesec.com
#
shell_profile="$HOME/.profile"

# Terminal settings
touch $shell_profile
#colors
echo "[+] Terminal settings"
echo "export CLICOLOR=1" >> $shell_profile
#grep colors
echo "alias grep='grep --colour=auto'" >> $shell_profile
echo "alias egrep='egrep --color=auto'">> $shell_profile
#lazy opener
echo "alias preview='open -a Preview'" >> $shell_profile
echo "alias ql='qlmanage -p $*'" >> $shell_profile
#lunch gvim from terminal
echo "alias gvim='/Applications/MacVim.app/Contents/MacOS/Vim -g'" >> $shell_profile
echo "export EDITOR=vim"
####
#SSH timeout settings
#
mkdir $HOME/.ssh
echo '''
ServerAliveInterval 60
ServerAliveCountMax 5
	''' >> $HOME/.ssh/config
####
#GDB basic
#
echo '''
set disassembly-flavor intel

	''' >> $HOME/.gdbinit

#VIM basics
echo '''
syntax enable
set mouse=a
set ruler
set showmatch
set tabstop=4
	''' >> $HOME/.vimrc 
## Manage airport from the terminal
## ex: $airport scan
echo "[+] Airport utility linked to /usr/bin/"
sudo ln -s /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport /usr/bin/airport
###
## Activate locate db daemon
echo "[+] Run locate db daemon on boot"
sudo launchctl load -w /System/Library/LaunchDaemons/com.apple.locate.plist
#Finder Settings
#AppleShowAllFiles 
defaults  write com.apple.Finder AppleShowAllFiles YES
#Select from quicklook from widget
defaults write com.apple.finder QLEnableTextSelection -bool TRUE
# Show extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
#show full path in finder
defaults write com.apple.finder _FXShowPosixPathInTitle -bool YES
# quickviewer for folders
defaults write com.apple.finder QLEnableXRayFolders 1
###
#Show all users in login
sudo defaults write com.apple.loginwindow \HiddenUsersList -array-add ard

#use mouse for focus in terminal
defaults write com.apple.terminal FocusFollowsMouse -string YES
# No .DS_Store on network
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true

# Safari developer mode
defaults write com.apple.Safari IncludeDebugMenu 1
defaults write com.apple.Safari WebKitDeveloperExtras -bool true

# Crash Reporter Modes (basic, developer, server)
# basic: clasic prompt
# developer: crashed thread 
# server: no prompt (good on fuzzing)
defaults write com.apple.CrashReporter DialogType -string developer

## Screenshots
mkdir $HOME/screenshots
defaults write com.apple.screencapture location -string "$HOME/screenshots"
# Save screenshots in PNG format (other options: BMP, GIF, JPG, PDF, TIFF)
defaults write com.apple.screencapture type -string "png"

# Font tweak for external LCD displays
defaults write NSGlobalDomain AppleFontSmoothing -int 2
## General Sec
# Enable Require password for screen saver.
sudo defaults -currentHost write com.apple.screensaver askForPassword -int 1
# Enable secure virtual memory.
sudo defaults write /Library/Preferences/com.apple.virtualMemory UseEncryptedSwap -bool yes
# Enable Firewall options: # 1 essential, 2 specific services
sudo defaults write /Library/Preferences/com.apple.alf globalstate -int 2
# Fuck em'all (http://krypted.com/mac-os-x/the-os-x-application-layer-firewall-part-3-lion/)
/usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on --setblockall on
# Enable Stealth mode.
sudo defaults write /Library/Preferences/com.apple.alf stealthenabled 1
# Enable ipfw logs
sudo defaults write /Library/Preferences/com.apple.alf loggingenabled 1

####
#boot in verbose mode
#
echo "[+] Boot in verbose mode"
sudo nvram boot-args="-v"
