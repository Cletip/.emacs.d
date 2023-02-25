(use-package xah-fly-keys
  :straight (xah-fly-keys
             :type git
             :host github
             :repo "xahlee/xah-fly-keys")
  :config
  (require 'xah-fly-keys)
  ;; add optimot layout
  (push
   '("optimot" . (("-" . "^") ("'" . "à") ("," . "j") ("." . "o") (";" . "k") ("/" . "x") ("[" . "#") ("]" . "@") ("=" . "ç")
                  ("a" . "a") ("b" . "g") ("c" . "l") ("d" . "p") ("e" . "e") ("f" . "f") ("g" . "d") ("h" . "t") ("i" . ",")
                  ("j" . "è") ("k" . ".") ("l" . "q") ("m" . "c") ("n" . "r") ("o" . "i") ("p" . "é") ("q" . "y") ("r" . "'")
                  ("s" . "n") ("t" . "s") ("u" . "u") ("v" . "h") ("w" . "m")
                  ("x" . "w") ("y" . "b") ("z" . "v")
                  ("1" . "«") ("2" . "»") ("3" . "\"") ("4" . "-") ("5" . "+") ("6" . "*") ("7" . "/") ("8" . "=") ("9" . "(")
                  ("0" . ")") ("\\" . "ç") ("`" . "$")))
   xah-fly-layouts)
  ;; specify a layout
  (if termux-p
      (xah-fly-keys-set-layout "azerty")
    (xah-fly-keys-set-layout "optimot"))
  (xah-fly-keys 1))

(use-package xah-fly-keys-layer
  :after xah-fly-keys
  :straight (xah-fly-keys-layer
             :type git
             :host github
             :repo "Cletip/xah-fly-keys-layer")
  ;; :init

  :config

  ;; change variable before require the extension
  (setq xah-fly-keys-layer-auto-command-mode
        '(recentf-cancel-dialog
          dashboard-jump-to-bookmarks
          org-agenda-show-dashboard
          dired-jump
          vertico-exit
          ace-link-eww
          ))
  (setq xah-fly-keys-layer-auto-insert-mode
        '(
          execute-extended-command-for-buffer
          org-meta-return
          org-insert-heading-respect-content
          org-insert-link
          recentf-open-files
          ;; org-capture ;; désactivé car fait bugguer !
          ))
  (require 'xah-fly-keys-layer-auto-mode)

  ;; change variable before require the extension
  (setq xah-fly-keys-layer-better-place-isearch-forward t
        xah-fly-keys-layer-better-place-for-pinky-parens nil
        xah-fly-keys-layer-better-place-for-pinky-block t)
  (require 'xah-fly-keys-layer-better-place)

  ;; try :

  (xah-fly-keys-layer-add-keys-to-keymap 'xah-fly-command-map "z"
                                         'xah-forward-right-bracket)
  (xah-fly-keys-layer-add-keys-to-keymap 'xah-fly-command-map "v"
                                         'xah-goto-matching-bracket)
  (xah-fly-keys-layer-add-keys-to-keymap 'xah-fly-command-map "b"
                                         'xah-backward-left-bracket)

  ;;for all other extensions, you can change variable after require the extension

  (require 'xah-fly-keys-layer-better-remap)

  (setq xah-fly-keys-layer-isearch-forward-variable 'consult-line
        xah-fly-keys-layer-ispell-word-variable 'flyspell-correct-wrapper
        xah-fly-keys-layer-xah-extend-selection-variable 'er/expand-region
        xah-fly-keys-layer-xah-open-file-at-cursor-variable 'cp/open-link
        xah-fly-keys-layer-recentf-open-files-variable 'consult-recent-file
        ;;since I don't use save-buffer, I prefer this
        xah-fly-keys-layer-save-buffer-variable 'avy-goto-char-2
        xah-fly-keys-layer-describe-function-variable 'helpful-symbol
        xah-fly-keys-layer-describe-variable-variable 'helpful-at-point)

  (require 'xah-fly-keys-layer-major-mode)
  ;; like default place, but change here if you want
  (setq xah-fly-keys-layer-major-mode-key (xah-fly--convert-kbd-str "x"))
  ;; override a default keymap : 
  (xah-fly--define-keys
   (define-prefix-command 'xah-fly-keys-layer-org-mode-keymap)
   '(("SPC" . org-mode-babel-keymap)

     ;; ("-" . "^") NOTE: this is a dead key
     ("'" . org-table-create-or-convert-from-region)
     ("," . org-mark-element)
     ("." . org-todo)
     (";" . org-toggle-narrow-to-subtree)
     ;; ("/" . "x")

     ;; ("[" . "=")
     ;; ("]" . "%")

     ;; ("=" . "ç")

     ("a" . org-export-dispatch)
     ;; ("b" . org-goto)
     ("b" . consult-org-heading) ;; mieux
     ("c" . org-insert-link)
     ("L" . org-store-link)
     ("d" . org-mode-keymap-movement)
     ("e" . org-meta-return)
     ;; ("E" . org-insert-todo-heading)
     ("f" . org-roam-ref-add)
     ("g" . org-roam-buffer-toggle)
     ("h" . vulpea-insert)
     ;; ("i" . ",")
     ("j" . org-deadline)
     ("k" . org-schedule)
     ("l" . "cp-vulpea-buffer-tags-remove-BROUILLON")
     ;; ("m" . org-insert-todo-heading)
     ("n" . vulpea-tags-add)
     ("o" . org-refile)
     ("p" . org-set-tags-command)
     ("q" . org-sort)
     ("r" . vulpea-meta-add)
     ("s" . citar-insert-citation)
     ;; ("t" . vulpea-find-backlink)
     ;; ("u" . org-capture-keymap) ;; TODO, mis dans SPC SPC
     ;; ("u" . org-capture)  ;; TODO changer

     ("v" . org-insert-todo-heading)
     ;; ("v" . cp-vulpea-meta-fait-add)
     ("w" . consult-org-roam-forward-links)
     ("x" . org-time-stamp)
     ;; ("y" . "b")
     ;; ("z" . "v")
     ))

  ;; load your personnal keymap with SPC SPC
  (require 'xah-fly-keys-layer-personal-keymap)
  (xah-fly--define-keys
   (define-prefix-command 'xah-fly-keys-layer-personal-key-map)
   '(("RET" . cp/org-open-or-finish-capture)
     ;; ("<up>"  . xah-move-block-up)
     ;; ("<down>"  . xah-move-block-down)
     ("'" . save-buffers-kill-emacs)
     ("," . emacs-restart)
     ("." . org-agenda)
     ;; ("0" . nil)
     ;; ("1" . nil)
     ;; ("2" . nil)
     ;; ("3" . nil)
     ;; ("4" . nil)
     ;; ("5" . nil)
     ;; ("6" . nil)
     ;; ("7" . nil)
     ;; ("8" . nil)
     ("9" . flycheck-grammalecte-correct-error-before-point)

     ("a" . engine-mode-prefixed-map)
     ;; ("b" . nil)
     ;; ("c" . nil)
     ;; ("d" . org-capture-keymap)
     ;; ("d" . helpful-at-point)
     ;; ("e" . nil)
     ("f" . org-next-link)
     ("g" . consult-org-roam-search)
     ("h" . cp/org-edit-special-src-dwim)
     ;; ("i" . nil)
     ("j" . org-next-link)
     ;; ("k" . nil)
     ;; ("l" . nil)
     ("m" . vulpea-find)
     ("n" . winner-undo)
     ;; ("o" . nil)
     ("p" . org-capture)
     ("q" . org-previous-link)
     ;; ("r" . nil)
     ;; ("s" . nil)
     ;; ("t" . cp/consult-ripgrep-with-directory)
     ("t" . consult-ripgrep)
     ;; ("u" . mode-specific-map)
     ("v" . magit-status)
     ("w" . ace-swap-window)
     ;; ("x" . nil)
     ;; ("y" . nil)
     ;; ("z" . nil)
     ))

  ;; change variable before require the extension
  (setq xah-fly-keys-layer-misc-enter-open-line t
        xah-fly-keys-layer-misc-autosave t
        xah-fly-keys-layer-embark t
        embark-cycle-key (xah-fly--convert-kbd-str "i"))
  (require 'xah-fly-keys-layer-misc)

  ;; end of the package here
  )

;; pop-global-mark with SPC 0
(with-eval-after-load 'xah-fly-keys-layer
  (xah-fly-keys-layer-add-keys-to-keymap 'xah-fly-leader-key-map "0" 'pop-global-mark)
)

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

(with-eval-after-load 'xah-fly-keys-layer
  (defun cp/xah-insert-tilde () (interactive) (xah-insert-bracket-pair "~" "~") ) (xah-fly-keys-layer-add-keys-to-keymap 'xah-fly-leader-key-map "e o" 'cp/xah-insert-tilde))

(define-key minibuffer-mode-map [remap previous-line] #'previous-line-or-history-element)
(define-key minibuffer-mode-map [remap next-line] #'next-line-or-history-element)

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

(defun usb-device-connected-p (device) 
  (< 0 (length (cl-remove-if-not (lambda (x) (cl-search device x)) 
                                 (split-string (shell-command-to-string "lsusb") "\n")))))

(setq my-keyboard-p (usb-device-connected-p "ErgoDash"))

(when (and (not termux-p) (not my-keyboard-p))
  (touches-controle-au-bon-endroit)
  )



;; (if (usb-device-connected-p "Microsoft Corp. Natural Ergonomic Keyboard")
;;     (progn (global-set-key (kbd "<XF86Forward>") 'next-buffer)
;;            (global-set-key (kbd "<XF86Back>") 'previous-buffer)
;;            (global-set-key (kbd "<XF86Favorites>") 'buffer-menu)
;;            (global-set-key (kbd "<XF86HomePage>") 'buffer-menu))
;; )

;; (setq device "Intel Corp.")

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
