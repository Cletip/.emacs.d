
Tout ce que j'ai à faire pour le conserver à jour : 

sur master (normalement c'est bon, faire un git status)
git pull --rebase upstream master
git push --force-with-lease origin master


ancien : 

https://reflectoring.io/github-fork-and-pull/#Updating-your-Fork

magit :

1. fetch upstream
2. me mettre sur master (normalement c'est déjà bon)
3. faire un merge avec upstream/master


# Le readme

Dans ce readme, je suppose que vous utiliser straight ou use-package (ou les deux) correctement.

## Speed Installation


Pas sûr de ceci :

```elisp
(use-package xah-fly-keys
   ;; :after (xah-fly-keys)
    :straight '(xah-fly-keys :host github
			:repo "Cletip/xah-fly-keys"
			:branch "main"
			:files ("*.el" "out")
			)
    
    )
```


##  Comment

Ceci est une "surcouche" de Xah fly keys qui permet de simplifier certaines utilisations. Elle nécessite d'autres packages (si une commande ne marche pas, regarder le nom de la commande et télécharger le package sur internet).

Le but de ce package et d'ajouter des raccourcis au package xah-fly-keys. De
plus, "SPC ENT"  permet d'appeler un menu différent à chaque major mode. Ce n'est pas vraiment dans la philosophie de xah-fly-keys, mais je trouve ça très pratique dans certains cas.


You can install xah-fly-keys like this (minimal configuration):  
  
```elisp
(use-package xah-fly-keys	     
    :config
     ;;chose your layout
    (xah-fly-keys-set-layout "azerty")

    (xah-fly-keys) ;;activate xah fly keys

    )
```  






xah-fly-keys
===================

A modal keybinding for emacs (like vim), but based on command frequency and ergonomics.

This is the most efficient editing system in the universe.

home page at
http://ergoemacs.org/misc/ergoemacs_vi_mode.html

2020-04-18 News: Key Engine Rewrite
===================

Major key engine rewrite by Dan Langlois (https://github.com/DanLanglois) and Will Dey (https://github.com/wi11dey) .

QWERTY layout
-------------------
![xah-fly-keys qwerty layout](xah_fly_keys_qwerty_layout_2020-04-18_4fgyk.png)

Manual Install
-------------------

put the file xah-fly-keys.el in ~/.emacs.d/lisp/
create the dir if doesn't exist.

put the following in your emacs init file:

```elisp
(add-to-list 'load-path "~/.emacs.d/lisp/")
(require 'xah-fly-keys)
(xah-fly-keys-set-layout "qwerty") ; required
```

The following keyboard layouts are supported:

* adnw
* azerty
* azerty-be
* beopy
* bepo
* carpalx-qfmlwy
* carpalx-qgmlwb
* carpalx-qgmlwy
* colemak
* colemak-mod-dh
* colemak-mod-dh-new
* dvorak
* koy
* neo2
* norman
* programer-dvorak
* pt-nativo
* qwerty
* qwerty-abnt
* qwerty-no (qwerty Norwegian)
* qwertz
* workman

Full Documentation
-------------------

http://ergoemacs.org/misc/ergoemacs_vi_mode.html

Been working on this since 2013, and since 2007 on ergoemacs-mode.

Put in 5 bucks in my patreon.
https://www.patreon.com/xahlee

or https://paypal.com
pay to xah@xahlee.org

Thanks.
