(defun cp/open-link ()
  ""
  (interactive)
  (if (string-equal (org-agenda-open-link) "No link to open here")
      (xah-open-file-at-cursor)
     (org-agenda-open-link)))

(defun cp/consult-line-or-with-word ()
  "Call `consult-line' on current word or text selection.
            “word” here is A to Z, a to z, and hyphen 「-」 and underline 「_」, independent of syntax table.
            URL `http://xahlee.info/emacs/emacs/modernization_isearch.html'
            Version 2015-04-09"
  (interactive)
  (let ($p1 $p2)
    (if (use-region-p)
        (progn
          (message "salut")
          (setq $p1 (region-beginning))
          (setq $p2 (region-end)))
      (save-excursion
        (setq $p1 (point))
        (setq $p2 (point))))
    (setq mark-active nil)
    (when (< $p1 (point))
      (goto-char $p1))
    (consult-line (buffer-substring-no-properties $p1 $p2))))

(use-package xah-fly-keys
  :straight (xah-fly-keys :type git :host github :repo "Cletip/xah-fly-keys"
                          :fork (:host github
                                       :repo "Cletip/xah-fly-keys"))
  ;; :custom
  ;; (xah-fork-cp-isearch-forward-function-name cp/consult-line-or-with-word)

  ;; (xah-fork-cp-isearch-forward-function-name consult-line)
  ;; (xah-fork-cp-recentf-function-name consult-recent-file)
  ;; (xah-fork-cp-ispell-word-function-name flyspell-auto-correct-previous-word)
  ;; (xah-fork-cp-xah-open-file-at-cursor-function-name cp/open-link)
  ;; (xah-fork-cp-xah-extend-selection-function-name er/expand-region)
  :config
  (setq xah-fork-cp-isearch-forward-function-name 'cp/consult-line-or-with-word)
  (setq xah-fork-cp-recentf-open-files-function-name 'consult-recent-file)
  (setq xah-fork-cp-ispell-word-function-name 'flyspell-auto-correct-previous-word)
  (setq xah-fork-cp-xah-open-file-at-cursor-function-name 'cp/open-link)
  (setq xah-fork-cp-xah-extend-selection-function-name 'er/expand-region)


  ;; To disable both Control and Meta shortcut keys, add the following lines to you init.el before (require 'xah-fly-keys):

  (setq xah-fly-use-control-key nil)
  (setq xah-fly-use-meta-key nil)

  ;; choisir son clavier, important
  ;; lsusb | grep Omkbd\ ErgoDash ;;pour obtenir si le clavier est connecté
  ;; ou bien peut-être termux-usb -l
  (if termux-p
      (xah-fly-keys-set-layout "azerty")
    (xah-fly-keys-set-layout "beopy"))


  ;; Les hook	     
  ;; sauvegarde automatique avec command mode
  ;; (add-hook 'xah-fly-command-mode-activate-hook 'xah-fly-save-buffer-if-file)

  ;; ;;Suites des hook
  (defvar cp/xfk-auto-insert-mode-fns '()
    "List of functions to automatically call xah-fly-insert-mode-activate on.")
  (setq cp/xfk-auto-insert-mode-fns
        '(
          execute-extended-command-for-buffer
          org-meta-return
          org-insert-heading-respect-content
          org-insert-link
          recentf-open-files

          ;; org-capture ;; désactivé car fait bugguer !

          ;; More function names here
          ))
  (defun cp/xfk-auto-insert-mode-activate ()
    "Wires xah-fly-insert-mode-activate to all functions from cp/xfk-auto-insert-mode-fns."
    (dolist (element cp/xfk-auto-insert-mode-fns)
      (advice-add element :after #'xah-fly-insert-mode-activate)))
  (cp/xfk-auto-insert-mode-activate)


  (defvar cp/xfk-auto-command-mode-fns '()
    "List of functions to automatically call xah-fly-command-mode-activate on.")
  (setq cp/xfk-auto-command-mode-fns
        '(dashboard-jump-to-recents
          dashboard-jump-to-projects
          recentf-cancel-dialog
          dashboard-jump-to-bookmarks
          org-agenda-show-dashboard
          dashboard-jump-to-if-dashboardweekagenda-agenda-for-the-coming-week-agenda-for-today
          ;; More function names
          ))

  (defun cp/xfk-auto-command-mode-activate ()
    "Wires xah-fly-command-mode-activate to all functions from cp/xfk-auto-command-mode-fns."
    (dolist (element cp/xfk-auto-command-mode-fns)
      (advice-add element :after #'xah-fly-command-mode-activate)))
  (cp/xfk-auto-command-mode-activate)

  ;;pour la commande xah-run-current-file
  (setq xah-run-current-file-hashtable
        #s(hash-table
           size 100
           test equal
           data
           (
            "clj" "clj"
            "go" "go run"
            "hs" "runhaskell"
            "java" "javac"
            "js" "deno run"
            "latex" "pdflatex"
            "m" "wolframscript -file"
            "mjs" "node --experimental-modules "
            "ml" "ocaml"
            "php" "php"
            "pl" "perl"
            "ps1" "pwsh"
            "py" "python3"
            "py2" "python2"
            "py3" "python3"
            "rb" "ruby"
            "rkt" "racket"
            "sh" "bash"
            "tex" "pdflatex"
            "ts" "deno run"
            "tsx" "tsc"
            "vbs" "cscript"
            "wl" "wolframscript -file"
            "wls" "wolframscript -file"
            ;; "pov" "/usr/local/bin/povray +R2 +A0.1 +J1.2 +Am2 +Q9 +H480 +W640"
            )))
  )

(defun touches-controle-au-bon-endroit ()
  "Permet de mapper les touches contrôle aux endroit définit dans le fichier Xmodmap"
  (interactive)
  ;; (shell-command "setxkbmap -option caps:none")
  (shell-command "xmodmap ~/.dotfiles/fichiersSauvegardePc/Xmodmap")     
  )

;; chargement des touches au démarrage
;; (touches-controle-au-bon-endroit)

(defun ancien-raccourcis-de-base ()
  ""
  (interactive)
  (org-babel-load-file (expand-file-name "/home/utilisateur/.dotfiles/.emacs.d/lisp/LayerXahFlyKey/LayerXahFlyKey.org"))
  )

(load "~/.emacs.d/config/lisp/my-abbrev.el")

(use-package keyfreq
  :config
  ;;   Pour exclure des commandes 
  (setq keyfreq-excluded-commands
        '(
          mouse-drag-region
          lsp-ui-doc--handle-mouse-movement
          mouse-set-point
          mwheel-scroll
          )
  )
  (keyfreq-mode 1)
  (keyfreq-autosave-mode 1)
  )
