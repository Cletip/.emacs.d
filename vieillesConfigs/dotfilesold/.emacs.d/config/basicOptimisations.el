;; ============================================================
;; Don't edit this file, edit config.org' instead ...
;; Auto-generated at Fri Mar 11 2022-03-11T10:23:02  on host utilisateur-GL65-Leopard-10SER
;; ============================================================



;; #####################################################################################
(message "config • Gestion des sauvegardes, et fichiers à ne pas mettre dans les backups …")


  (setq make-backup-files t               ; backup of a file the first time it is saved.
        backup-by-copying t               ; don't clobber symlinks
        version-control t                 ; version numbers for backup files
        delete-old-versions t             ; delete excess backup files silently
        delete-by-moving-to-trash t       ; Put the deleted files in the trash
        kept-old-versions 6               ; oldest versions to keep when a new numbered backup is made (default: 2)
        kept-new-versions 9               ; newest versions to keep when a new numbered backup is made (default: 2)
        auto-save-default t               ; auto-save every buffer that visits a file
        auto-save-timeout 20              ; number of seconds idle time before auto-save (default: 30)
        auto-save-interval 200            ; number of keystrokes between auto-saves (default: 300)
        )


  ;;fichier à ne pas copier dans les backups
  (setq auto-mode-alist
        (append
         (list
          '("\\.\\(vcf\\|gpg\\)$" . sensitive-minor-mode)
          )
         auto-mode-alist))



;; #####################################################################################
(message "config • Permet de r y ou n au lieu de yes ou no …")


  (fset 'yes-or-no-p 'y-or-n-p)
  


;; #####################################################################################
(message "config • Rafraichit automatiquement les buffers, sauf si ya eu des moddif évidemment …")


(global-auto-revert-mode t)



;; #####################################################################################
(message "config • Échap en une fois …")


  (global-set-key (kbd "<escape>") 'keyboard-escape-quit)
  ;; (global-unset-key (kbd "C-g"))
  ;; (global-set-key (kbd "C-g") 'keyboard-escape-quit)



;; #####################################################################################
(message "config • Réécriture/remplacement lors de texte sélectionné …")


  (delete-selection-mode t)
  


;; #####################################################################################
(message "config • Sauvegarde la place du curseur(marche sans no-litteralling) …")



  (with-eval-after-load 'no-littering ;;important
    (save-place-mode 1)
    )




;; #####################################################################################
(message "config • Fichiers récents …")


  (with-eval-after-load 'no-littering ;;important
    (require 'recentf)
    (recentf-mode 1)
    (setq recentf-max-menu-items 100)
    (setq recentf-max-saved-items 100)

    ;; fichier à exclure de recentf
    ;; If you use recentf then you might find it convenient to exclude all of the files in the no-littering directories using something like the following.
    (add-to-list 'recentf-exclude no-littering-var-directory)
    (add-to-list 'recentf-exclude no-littering-etc-directory)
    
    (add-to-list 'recentf-exclude "/tmp/") ;;pour emacs-everywhere notamment
    )





;; #####################################################################################
(message "config • Réavoir les dernière commandes …")


  ;; Persist history over Emacs restarts. Vertico sorts by history position.
  (use-package savehist
    :init
    (setq savehist-file (concat my-user-emacs-directory "var/savehist.el"))
    :config
    (setq history-length 200)
    ;;List of additional variables to save.
    (setq savehist-additional-variables '(kill-ring search-ring recentf-list))
    (savehist-mode t)
    
    ;; pour améliorer les perf ? voir avec Mathieu
    (put 'minibuffer-history 'history-length 50)
    (put 'evil-ex-history 'history-length 50)
    (put 'kill-ring 'history-length 25)
    )



;; #####################################################################################
(message "config • Keep .emacs.d clean …")


  (use-package no-littering
    ;;custom remplace tous les setq
    :custom
    ;; définition de l'emplacement de certains fichiers
    (custom-file (expand-file-name "var/custom.el" my-user-emacs-directory)) ;;pour les variable
    (grammalecte-settings-file (no-littering-expand-var-file-name "grammalecte-cache.el")) ;;pour grammalecte
    ;; (org-id-locations-file (no-littering-expand-var-file-name "org/id-locations.el"));;pour id-locations, de base c'est bon donc enlever
    )



;; #####################################################################################
(message "config • Launch emacs server …")


  (server-start)  ;; starts emacs as server (if you didn't already)



;; #####################################################################################
(message "config • TODO Démarrer avec les fichiers récents, titre etc …")


  (use-package dashboard
    :after all-the-icons
    :config
    ;;centrer le dashboard
    (setq dashboard-center-content t)
    ;;item
    (setq dashboard-items '(
                            (recents  . 10)			    
                            (agenda . 5)
                            (bookmarks . 5)
                            ;; (projects . 5) 
                            (registers . 5)
                            )
          )
    ;;si il y a projectile
    (with-eval-after-load 'projectile ;;important
      (setq dashboard-items '(
                              (recents  . 10)			    
                              (agenda . 5)
                              (bookmarks . 5)
                              (projects . 5) 
                              (registers . 5)
                              )
            )
      )

    ;;agenda de la semaine 
    (setq dashboard-week-agenda t)
    ;;emacsclient avec dashboard, enlever plus besoin mais gardé au cas où
    ;; (setq initial-buffer-choice (lambda () (get-buffer "*dashboard*")))
    (dashboard-setup-startup-hook)
    )



;; #####################################################################################
(message "config • Pour faire des commandes dans le mini-buffer …")


  (setq enable-recursive-minibuffers t)



;; #####################################################################################
(message "config • TODO Embark, pour faire des actions vraiment puissantes partout et sur tout …")

      (use-package embark
        :bind (("C-t" . embark-act))
        )

      (use-package embark-consult
        :after (embark consult)
        :demand t ; only necessary if you have the hook below
        ;; if you want to have consult previews as you move around an
        ;; auto-updating embark collect buffer
        :hook
        (embark-collect-mode . consult-preview-at-point-mode)
        )


   ;; pour afficher avec which-key
      (defun embark-which-key-indicator ()
     "An embark indicator that displays keymaps using which-key.
   The which-key help message will show the type and value of the
   current target followed by an ellipsis if there are further
   targets."
     (lambda (&optional keymap targets prefix)
       (if (null keymap)
           (which-key--hide-popup-ignore-command)
         (which-key--show-keymap
          (if (eq (plist-get (car targets) :type) 'embark-become)
              "Become"
            (format "Act on %s '%s'%s"
                    (plist-get (car targets) :type)
                    (embark--truncate-target (plist-get (car targets) :target))
                    (if (cdr targets) "…" "")))
          (if prefix
              (pcase (lookup-key keymap prefix 'accept-default)
                ((and (pred keymapp) km) km)
                (_ (key-binding prefix 'accept-default)))
            keymap)
          nil nil t (lambda (binding)
                      (not (string-suffix-p "-argument" (cdr binding))))))))

   (setq embark-indicators
     '(embark-which-key-indicator
       embark-highlight-indicator
       embark-isearch-highlight-indicator))

   (defun embark-hide-which-key-indicator (fn &rest args)
     "Hide the which-key indicator immediately when using the completing-read prompter."
     (which-key--hide-popup-ignore-command)
     (let ((embark-indicators
            (remq #'embark-which-key-indicator embark-indicators)))
         (apply fn args)))

   (advice-add #'embark-completing-read-prompter
               :around #'embark-hide-which-key-indicator)



;; #####################################################################################
(message "config • Vertico …")


  (use-package vertico

    ;;charger les extensions de vertico
    ;; :load-path "straight/build/vertico/extensions"
    :custom
    (vertico-cycle t)
    :custom-face
    (vertico-current ((t (:background "#3a3f5a"))))
    :config
    (vertico-mode)

    ;;pour activer vertico directory (remonte d'un dossier à chaque fois, pratique ! sur backword-kill)
    ;; (define-key vertico-map [remap xah-delete-backward-char-or-bracket-text] #'vertico-directory-up)
    ;; (define-key vertico-map [remap backward-kill-word] #'vertico-directory-up)

    ;; pour pouvoir jump à une entrée
    ;; (define-key vertico-map [remap avy-goto-char] #'vertico-quick-jump)


    )


;; #####################################################################################
(message "config • Consult …")


(use-package consult
      :custom
      (completion-in-region-function #'consult-completion-in-region)
      )



;; #####################################################################################
(message "config • Marginalia …")

  
  (use-package marginalia
    :after vertico
    :custom
    (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil))
    :init
    (marginalia-mode)
    )
  


;; #####################################################################################
(message "config • Orderless …")


    ;; Complétation par candidats      
    ;; Use the `orderless' completion style.
    ;; Enable `partial-completion' for files to allow path expansion.
    ;; You may prefer to use `initials' instead of `partial-completion'.
    (use-package orderless
      :init
      (setq completion-styles '(orderless)
	    completion-category-defaults nil
	    completion-category-overrides '((file (styles partial-completion)))))



;; #####################################################################################
(message "config • Pour faire retour à la configuration de fenêtre précédente …")


  (winner-mode 1) ;;naviguer avec les fenêtres





;; #####################################################################################
(message "config • Bookmark mais pour les fenêtre + frame …")

  (use-package burly
    :config
    ;; 'nouveaunom #'anciennom, anciennomexisteencore
    ;; (defalias 'bookmark-windows-burly #'burly-bookmark-windows)
    ;; (defalias 'bookmark-windows-and-frames-burly #'burly-bookmark-frames)
    ;; j'ai gardé et mis directement sur LayerXahFlyKey
    )


;; #####################################################################################
(message "config • Pour jump sur un endroit sur la fenêtre d'emacs …")


  (use-package avy
    ;;\ pour l'espace
    :custom
    ;;personnalition des touches, important
    (avy-keys '(?a ?u ?e ?i ?t ?s ?r ?n ?\ ))
    (avy-background t)
    ;;nouvelle touches pour escape avy go timer
    (avy-escape-chars '(?\e ?\M-g))
    :config
    (setq avy-timeout-seconds 0.15)

    ;;personnaliser chaque commande :
    ;; (setq avy-keys-alist
    ;; `((avy-goto-char . ,(number-sequence ?a ?f))
    ;; (avy-goto-word-1 . (?f ?g ?h ?j))))

    )



;; #####################################################################################
(message "config • Le bon vieux ctrlf, mais optimisé par emacs …")

  (use-package ctrlf
    :config
    (define-key ctrlf-mode-map [remap next-line] #'ctrlf-next-match)
    (define-key ctrlf-mode-map [remap previous-line] #'ctrlf-previous-match))



;; #####################################################################################
(message "config • Affichage des touches, which-key …")


  (use-package which-key
    ;; :diminish which-key-mode
    :config
    ;;activer which-key
    (which-key-mode)
    ;;temps avant déclenchement de wich-key minimum
    (setq which-key-idle-delay 0.01)
    ;; affichage sur le côté, mais si marche pas en bas
    (which-key-setup-side-window-right-bottom)
    ) 




;; #####################################################################################
(message "config • Les lignes reviennent à la ligne (lol) …")


  ;;retour à la ligne concrètrement
  (auto-fill-mode 1)
  ;; visuellement
  (global-visual-line-mode 1) 



;; #####################################################################################
(message "config • Tailles des interlignes …")


  (defun taille-interligne ()
    "Toggle line spacing between no extra space to extra half line height.
  URL `http://ergoemacs.org/emacs/emacs_toggle_line_spacing.html'
  Version 2017-06-02"
    (interactive)
    (if line-spacing
	(setq line-spacing nil)
      (setq line-spacing 0.5))
    (redraw-frame (selected-frame)))



;; #####################################################################################
(message "config • Longueur de ligne avant retour à la ligne, différent en fonction du mode …")


  (setq-default fill-column 70)

  ;; taille de 70 pour coder
  (add-hook 'prog-mode-hook
	  (lambda ()
	    (set-fill-column 70)))



;; #####################################################################################
(message "config • Trainée de lumière pour pas perdre le curseur …")


  (use-package beacon
    :config
    (setq beacon-blink-delay 0.0)
    (setq beacon-blink-duration 0.5)
    (setq beacon-size 60)
    ;; (setq beacon-color "#ffa38f")
    (setq beacon-color "red")
    (beacon-mode 1)
    )




;; #####################################################################################
(message "config • Surlignage ligne du curseur …")

 (global-hl-line-mode t)
 (set-face-background hl-line-face "#311")


;; #####################################################################################
(message "config • La barre en bas …")


  (use-package doom-modeline
    :hook (after-init . doom-modeline-mode)
    :custom    
    (doom-modeline-height 25)
    (doom-modeline-bar-width 1)
    (doom-modeline-icon t)
    (doom-modeline-major-mode-icon t)
    (doom-modeline-major-mode-color-icon t)
    (doom-modeline-buffer-file-name-style 'truncate-upto-project)
    (doom-modeline-buffer-state-icon t)
    (doom-modeline-buffer-modification-icon t)
    (doom-modeline-minor-modes nil)
    (doom-modeline-enable-word-count t)
    (doom-modeline-buffer-encoding nil)
    (doom-modeline-indent-info nil)
    (doom-modeline-checker-simple-format t)
    (doom-modeline-vcs-max-length 20)
    (doom-modeline-env-version t)
    (doom-modeline-irc-stylize 'identity)
    (doom-modeline-github-timer nil)
    (doom-modeline-gnus-timer nil)
    )



;; #####################################################################################
(message "config • Modes qui n'apparaissent plus dans la modeline …")


(use-package diminish)



;; #####################################################################################
(message "config • Police …")


    ;;police de base, mise dans le early-init.el pour démarrage plus rapide
  
  (defun Policedebase ()
      (interactive)
      (set-face-attribute 'default nil
                          :font "Fira Mono"
                          :weight 'light
                          :height 110
                          )
      )
    (defun Policepourcoder ()
      (interactive)
      (set-face-attribute 'default nil
                          :font "JetBrains Mono"
                          :weight 'light
                          ;; :height 150
                          )
      )
    ;;police pour coder
    ;; (add-hook 'lsp-mode-hook 'Policepourcoder)



;; #####################################################################################
(message "config • Les jolies icônes …")

  
  (use-package all-the-icons
    :init
    (unless (member "all-the-icons" (font-family-list))
      (all-the-icons-install-fonts t))
    :if (display-graphic-p)
    :config
    (unless (member "all-the-icons" (font-family-list))
      (all-the-icons-install-fonts t))
    )






;; #####################################################################################
(message "config • Thèmes (faire M-x customize-themes pour choisir) …")


  (use-package doom-themes
    :config
    ;; Enable flashing mode-line on errors
    (doom-themes-visual-bell-config)
    ;; Enable custom neotree theme (all-the-icons must be installed!)
    ;; for treemacs
    (setq doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
    (doom-themes-treemacs-config)
    ;; Corrects (and improves) org-mode's native fontification.
    (doom-themes-org-config)
    ;;load the theme
    (load-theme 'doom-moonlight t)
    )



  ;;charger le thème lors d'un client emacs :
  (defvar display-theme-loadedp nil)
  (defun load-display-theme ()
    (load-theme 'doom-moonlight t))
  (add-hook 'after-make-frame-functions (lambda (frame)
                                          (unless display-theme-loadedp
                                            (with-selected-frame frame
                                              (load-display-theme))
                                            (setq display-theme-loadedp t))))

  (defun mb/pick-color-theme (frame)
    (select-frame frame)
    (enable-theme 'doom-moonlight))
  (add-hook 'after-make-frame-functions 'mb/pick-color-theme)


  ;; (use-package spacemacs-theme
  ;; :no-require t
  ;; :init
  ;; (load-theme 'spacemacs-dark t)
  ;; )



;; #####################################################################################
(message "config • Mise en valeur du buffer actif (diminue la luminosité) …")


  (use-package dimmer
    :custom
    (dimmer-fraction 0.3)
    (dimmer-exclusion-regexp-list
     '(".*Minibuf.*"
       ".*which-key.*"
       ".*LV.*"))
    :config
    (dimmer-mode 1)
    )



;; #####################################################################################
(message "config • Optimisation de base …")


  ;;pour supprimer directement le buffer si un fichier est supprimé (ou directory)
  (defun my--dired-kill-before-delete (file &rest rest)
    (if-let ((buf (get-file-buffer file)))
        (kill-buffer buf)
      (dolist (dired-buf (dired-buffers-for-dir file))
        (kill-buffer dired-buf))))
  (advice-add 'dired-delete-file :before 'my--dired-kill-before-delete)



  ;; auto refresh dired when file changes
  (add-hook 'dired-mode-hook 'auto-revert-mode)

  (setq dired-auto-revert-buffer t) ;; Refreshes the dired buffer upon revisiting
  (setq dired-dwim-target t) ;; If two dired buffers are open, save in the other when trying to copy
  (setq dired-hide-details-hide-symlink-targets nil) ;; Don't hide symlink targets
  (setq dired-listing-switches "-alh") ;; Have dired view all folders, in lengty format, with data amounts in human readable format
  (setq dired-ls-F-marks-symlinks nil) ;; Informs dired about how 'ls -lF' marks symbolic links, see help page for more details
  (setq dired-recursive-copies 'always) ;; Always copy recursively without asking
  (setq dired-recursive-deletes 'always) ; demande plus pour supprimer récursivement
  (setq dired-dwim-target t) ; qd t-on copie, si un autre dired ouvert, copie dans lui "directement"



;; #####################################################################################
(message "config • Trier avec S dans dired …")


  (use-package dired-quick-sort
    :config
    (dired-quick-sort-setup)
    )



;; #####################################################################################
(message "config • Quand un fichier dans un dossier, le montre direct …")


  (use-package dired-collapse
    :defer t)
  (add-hook 'dired-load-hook
	    (lambda ()
	      (interactive)
	      (dired-collapse)))



;; #####################################################################################
(message "config • Les icônes + cacher certains fichiers …")


  (use-package all-the-icons-dired)

  (setq dired-omit-files
        (rx (or
             (seq bol (? ".") "#")
             (seq bol "." eol)
             (seq bol ".." eol)
             )))

  (add-hook 'dired-mode-hook
            (lambda ()
              (interactive)
              ;; (dired-omit-mode 1)
              (all-the-icons-dired-mode 1)
              (dired-sort-toggle-or-edit)
              (dired-hide-details-mode)
              (hl-line-mode 1)
              ))



;; #####################################################################################
(message "config • Compresser et décompresser du zip (mapper sur Z) …")


  (eval-after-load "dired-aux"
     '(add-to-list 'dired-compress-file-suffixes 
                   '("\\.zip\\'" ".zip" "unzip")))

  (eval-after-load "dired"
    '(define-key dired-mode-map "z" 'dired-zip-files))
  (defun dired-zip-files (zip-file)
    "Create an archive containing the marked files."
    (interactive "sEnter name of zip file: ")

    ;; create the zip file
    (let ((zip-file (if (string-match ".zip$" zip-file) zip-file (concat zip-file ".zip"))))
      (shell-command 
       (concat "zip " 
               zip-file
               " "
               (concat-string-list 
                (mapcar
                 #'(lambda (filename)
                    (file-name-nondirectory filename))
                 (dired-get-marked-files))))))
    (revert-buffer)

    ;; remove the mark on all the files  "*" to " "
    ;; (dired-change-marks 42 ?\040)
    ;; mark zip file
    ;; (dired-mark-files-regexp (filename-to-regexp zip-file))
    )



  (defun concat-string-list (list) 
     "Return a string which is a concatenation of all elements of the list separated by spaces" 
      (mapconcat #'(lambda (obj) (format "%s" obj)) list " ")) 

  


;; #####################################################################################
(message "config • Pour bouger les lignes/paragraphe comme dans org (avec CTRL) …")


(use-package move-text
     :defer 0.5
     :config
     (move-text-default-bindings))



;; #####################################################################################
(message "config • Better kill ring …")


  (use-package popup-kill-ring
    :config
    (with-eval-after-load 'company
    
      ;; touches perso, 
      (define-key popup-kill-ring-keymap (kbd "C-n") nil)
      (define-key popup-kill-ring-keymap (kbd "C-p") nil)
      (define-key popup-kill-ring-keymap (kbd "s") #'popup-kill-ring-next)
      (define-key popup-kill-ring-keymap (kbd "d") #'popup-kill-ring-previous)
      (define-key popup-kill-ring-keymap (kbd "u") 'popup-kill-ring-select)
      (define-key popup-kill-ring-keymap (kbd "SPC") #'company-abort)
      )
    (define-key popup-menu-keymap (kbd "s") #'popup-kill-ring-next)
  
  
  
    )



;; #####################################################################################
(message "config • Pour faire des delete intelligent …")


  (use-package smart-hungry-delete
    :bind (
	   ("<backspace>" . smart-hungry-delete-backward-char)
	   ;; ("C-d" . smart-hungry-delete-forward-char)
	   )
    :defer nil ;; dont defer so we can add our functions to hooks 
    :config (smart-hungry-delete-add-default-hooks)
    )



;; #####################################################################################
(message "config • Parenthèse et <> autres auto, pour modifier pair de parenthèse …")


  (use-package smartparens
    ;; :after lsp 
    :hook ((lsp-mode org-mode) . smartparens-mode)
    :config
    (sp-pair "\«" "\»")  
    ;;pour enlever un truc
    ;; the second argument is the closing delimiter, so you need to skip it with nil
    (sp-pair "'" nil :actions :rem)  
    ;; pour rajouter à un mode :
    ;; pas supprimer avec xah car ne fait pas partie de xah-right-brackets
    ;; changer org emphasis ?
    (sp-local-pair 'org-mode "*" "*") ;; adds * as a local pair in org mode
    (sp-local-pair 'org-mode "=" "=") ;; adds = as a local pair in org mode
    (sp-local-pair 'org-mode "\/" "\/")
    )



;; #####################################################################################
(message "config • Pour faire la commande sudo-edit, qui permet d'éditer en mode root …")

  (use-package sudo-edit)


;; #####################################################################################
(message "config • Compter le nombre de chaque commande faite (bien pour optimiser les raccourcis) …")


  (use-package keyfreq
    :config
    ;;   Pour exclure des commandes 
    ;; (setq keyfreq-excluded-commands
    ;;       '(
    ;;         backward-char
    ;;         previous-line
    ;;         next-line)
    ;; )
    (keyfreq-mode 1)
    (keyfreq-autosave-mode 1)
    )






;; #####################################################################################
(message "config • Dossier de base dans .emacs.d …")

(cd my-user-emacs-directory)


;; #####################################################################################
(message "config • Emacs restart …")

  (use-package restart-emacs
      :config (defalias 'emacs-restart #'restart-emacs)
      )


;; #####################################################################################
(message "config • Gérer Git dans emacs …")

  (use-package magit)


;; #####################################################################################
(message "config • Lire des epub …")

(use-package nov
    :config
    (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode)))
