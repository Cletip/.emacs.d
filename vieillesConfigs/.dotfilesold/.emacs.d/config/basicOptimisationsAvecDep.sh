#! /usr/bin/bash
#emacs everywhere
sudo apt install xclip xdotool

# installation de org protocol
echo "[Desktop Entry]
Name=org-protocol
Exec=emacsclient %u
Type=Application
Terminal=false
Categories=System;
MimeType=x-scheme-handler/org-protocol;" > ~/.local/share/applications/org-protocol.desktop
# refresh pour org-protocol
update-desktop-database ~/.local/share/applications/

# correcteur orthographique
sudo apt-get install -y hunspell
