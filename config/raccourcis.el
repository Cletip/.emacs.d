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
