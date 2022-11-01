#! /usr/bin/bash

sudo su
apt update

# installation des choses de bases
apt install -y #-y répondre oui par avance aux demandes de confirmations

python3 python3-venv python3-pip




# installation des languages server protocol manuel

pip install 'python-lsp-server[all]' 


