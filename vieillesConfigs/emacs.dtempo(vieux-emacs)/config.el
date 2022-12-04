;; ============================================================
;; Don't edit this file, edit config.org' instead ...
;; Auto-generated at Fri Feb 18 2022-02-18T19:53:16  on host msi-GL65-Leopard-10SER
;; ============================================================



;; #####################################################################################
(message "config • Bug connu : …")

     (setq org-element-use-cache nil)


;; #####################################################################################
(message "config • Les variables des chemins des fichiers, et c'est tout (normalement si je rerespect bien l'organisation de mes fichiers) …")


  ;;où est ma config
  (setq my-user-emacs-configuration (concat my-user-emacs-directory "config.org"))

  ;; besoin d'une "liste " pour faire certaines choses
  (setq my-user-emacs-configuration-list (list my-user-emacs-configuration))

  (if (file-exists-p "~/documents/")
      (progn 
        (setq documents-directory "~/documents/");; pour que tous les liens fonctionnes
        )
    (progn 
      ;;quand c'est vide ça retourne nil
      )
    )
  (if (file-exists-p "~/documents/mesdocuments/")
      (progn 
        (setq documents-mesdocuments-directory "~/documents/mesdocuments/");; pour que tous les liens fonctionnes
        )
    (progn 
      ;;quand c'est vide ça retourne nil
      )
    )
  ;;pour que les captures fonctionne
  (if (file-exists-p "~/documents/notes/")
      (progn 
        (setq org-directory "~/documents/notes/")
        )
    (progn 
      ;;quand c'est vide ça retourne nil
      )
    )
  ;;pour le dossier partage
  (if (file-exists-p "~/dossier_partage/")
      (progn 
        (setq shared-directory "~/dossier_partage/")  ;; pour certaines choses
        )
    (progn 
      ;;quand c'est vide ça retourne nil
      )
    )
  ;;est ce que j'ai un dossier partagé perso ? (normalement pas utilisé)
  (if (file-exists-p (concat shared-directory "Clement/"))
      (progn 
        (setq shared-directory-private (concat shared-directory "Clement/"))
        )
    (progn 
      ;;quand c'est vide ça retourne nil
      )
    )
  ;;où sont mes fichiers org accessible sur mon téléphone ?
  (if (file-exists-p (concat "~/dossier_partage/Clement/" "orgzly/"))
      (progn 
        (setq orgzly-directory (concat shared-directory-private "orgzly/"))
        )
    (progn 
      ;;quand c'est vide ça retourne nil
      )
    )
  ;;est ce que ma braindump existe ?
  (if (file-exists-p (concat org-directory "braindump/"))
      (progn 
        (setq org-roam-directory (concat org-directory "braindump/org/"))
        )
    (progn 
      ;;quand c'est vide ça retourne nil
      )
    )


;; #####################################################################################
(message "config • Définition de la fonction …")



  ;; (setq max-specpdl-size 50)  ; default is 1000, reduce the backtrace level
  (setq debug-on-error t)  

    ;; recursively find .org files in provided directory
    ;; modified from an Emacs Lisp Intro example
    ;;
    (defun sa-find-org-file-recursively (&optional directory filext)
      "Return .org and .org_archive files recursively from DIRECTORY.
                       If FILEXT is provided, return files with extension FILEXT instead."
      (interactive "DDirectory: ")
      (let* (org-file-list
             (case-fold-search t)         ; filesystems are case sensitive
              (file-name-regex "^[^.#].*") ; exclude dot, autosave, and backupfiles
             ;; (file-name-regex "^[^#].*") ; pour trouver les fichiers cacher, ne marche pas
             (filext (or filext "org$\\\|org_archive"));;pas prendre les archives
             (fileregex (format "%s\\.\\(%s$\\)" file-name-regex filext))
             (cur-dir-list (directory-files directory t file-name-regex)))
        ;; loop over directory listing
        (dolist (file-or-dir cur-dir-list org-file-list) ; returns org-file-list
          (cond
           ((file-regular-p file-or-dir)             ; regular files
            (if (string-match fileregex file-or-dir) ; org files
                (add-to-list 'org-file-list file-or-dir)))
           ((file-directory-p file-or-dir)
            (dolist (org-file (sa-find-org-file-recursively file-or-dir filext)
                              org-file-list) ; add files found to result
              (add-to-list 'org-file-list org-file)))))))



;; #####################################################################################
(message "config • Mes fichiers org …")



  ;; faire attention au custom variable dans custom.el, j'ai eu un gros "nil" qui m'a tout déréglé pour cette variable

  ;;j'hésite à mettre également mes fichiers roam dans mon agenda. Pour l'instant, non
  ;;pour éviter un bug si j'ai pas mes documents



  (if (file-exists-p documents-directory) ;; condition par pas qu'il y est de bug
      (progn (setq ;;cas du oui
              documents-directory-all-org-files ;; qu'elle variable je définie ? X-directory + all-org-files
              (append (sa-find-org-file-recursively
                       documents-directory "org")
                      )))
    (progn 
      (setq documents-directory-all-org-files nil) ;;sinon je mets X-directory + all-org-files à nul
      )
    )

  (if (file-exists-p documents-mesdocuments-directory) ;; condition par pas qu'il y est de bug
      (progn (setq ;;cas du oui
              documents-mesdocuments-directory-all-org-files ;; qu'elle variable je définie ? X-directory + all-org-files
              (append (sa-find-org-file-recursively
                       documents-mesdocuments-directory "org")
                      )))
    (progn 
      (setq documents-mesdocuments-directory-all-org-files nil) ;;sinon je mets X-directory + all-org-files à nul
      )
    )

  (if (file-exists-p org-directory) ;; condition par pas qu'il y est de bug
      (progn (setq ;;cas du oui
              org-directory-all-org-files ;; qu'elle variable je définie ? X-directory + all-org-files
              (append (sa-find-org-file-recursively
                       org-directory "org")
                      )))
    (progn 
      (setq org-directory-all-org-files nil) ;;sinon je mets X-directory + all-org-files à nul
      )
    )

  (if (file-exists-p shared-directory) ;; condition par pas qu'il y est de bug
      (progn (setq ;;cas du oui
              shared-directory-all-org-files ;; qu'elle variable je définie ? X-directory + all-org-files
              (append (sa-find-org-file-recursively
                       shared-directory "org")
                      )))
    (progn 
      (setq shared-directory-all-org-files nil) ;;sinon je mets X-directory + all-org-files à nul
      )
    )

  (if (file-exists-p "~/dossier_partage/Clement/") ;; condition par pas qu'il y est de bug
      (progn (setq ;;cas du oui
              shared-directory-private-all-org-files ;; qu'elle variable je définie ? X-directory + all-org-files
              (append (sa-find-org-file-recursively
                       shared-directory-private "org")
                      )))
    (progn 
      (setq shared-directory-private nil) ;;sinon je mets X-directory + all-org-files à nul
      )
    )

  (if (file-exists-p orgzly-directory) ;; condition par pas qu'il y est de bug
      (progn (setq ;;cas du oui
              orgzly-directory-all-org-files ;; qu'elle variable je définie ? X-directory + all-org-files
              (append (sa-find-org-file-recursively
                       orgzly-directory "org")
                      )))
    (progn 
      (setq orgzly-directory-all-org-files nil) ;;sinon je mets X-directory + all-org-files à nul
      )
    )

  (if (file-exists-p org-roam-directory) ;; condition par pas qu'il y est de bug
      (progn (setq ;;cas du oui
              org-roam-directory-all-org-files ;; qu'elle variable je définie ? X-directory + all-org-files
              (append (sa-find-org-file-recursively
                       org-roam-directory "org")
                      )))
    (progn 
      (setq org-roam-directory-all-org-files nil) ;;sinon je mets X-directory + all-org-files à nul
      )
    )
  


;; #####################################################################################
(message "config • xah-fly-key …")


   (use-package xah-fly-keys
     ;; :straight '(xah-fly-keys :host github
                              ;; :repos "xahlee/xah-fly-keys"
                              ;; :branch "master")
     :config

    ;; (global-set-key (kbd "<menu>") 'xah-fly-command-mode-activate)

     ;; To disable both Control and Meta shortcut keys, add the following lines to you init.el before (require 'xah-fly-keys):
     (setq xah-fly-use-control-key nil)
     (setq xah-fly-use-meta-key nil)


     ;; permet de mettru "u" comme enter
     (defun my-xfk-addon-command ()
       "Modify keys for xah fly key command mode keys To be added to `xah-fly-command-mode-activate-hook'"
       (interactive)
       (define-key xah-fly-key-map (kbd "u") (kbd "RET"));;pareilnewlinecomme enter
       )
     (add-hook 'xah-fly-command-mode-activate-hook 'my-xfk-addon-command)

     ;; choisir son clavier, important
     (xah-fly-keys-set-layout "beopy")

     ;;M-x of your choice
     ;;(setq xah-fly-M-x-command 'counsel-M-x)
     ;;(setq xah-fly-M-x-command 'helm-M-x)

     ;; Les hook	     
     ;; sauvegarde automatique avec command mode
     (add-hook 'xah-fly-command-mode-activate-hook 'xah-fly-save-buffer-if-file)

     (xah-fly-keys);;activer xah au démarrage...
     ;; (xah-fly-insert-mode-init) ;;avec le mode insertion
     ) 

  ;; ;;Suites des hook
   (defvar my/xfk-auto-insert-mode-fns '()
    "List of functions to automatically call xah-fly-insert-mode-activate on.")
  (setq my/xfk-auto-insert-mode-fns
        '(org-meta-return
          org-insert-heading-respect-content
          org-insert-link
          recentf-open-files
          ;; org-capture ;; désactivé car fait bugguer !

          ;; More function names here
          ))
  (defun my/xfk-auto-insert-mode-activate ()
    "Wires xah-fly-insert-mode-activate to all functions from my/xfk-auto-insert-mode-fns."
    (dolist (element my/xfk-auto-insert-mode-fns)
      (advice-add element :after #'xah-fly-insert-mode-activate)))
  (my/xfk-auto-insert-mode-activate)


  (defvar my/xfk-auto-command-mode-fns '()
    "List of functions to automatically call xah-fly-command-mode-activate on.")
  (setq my/xfk-auto-command-mode-fns
        '(dashboard-jump-to-recents
          dashboard-jump-to-projects
          recentf-cancel-dialog
          dashboard-jump-to-bookmarks
          org-agenda-show-dashboard
          dashboard-jump-to-if-dashboardweekagenda-agenda-for-the-coming-week-agenda-for-today
          ;; More function names
          ))

  (defun my/xfk-auto-command-mode-activate ()
    "Wires xah-fly-command-mode-activate to all functions from my/xfk-auto-command-mode-fns."
    (dolist (element my/xfk-auto-command-mode-fns)
      (advice-add element :after #'xah-fly-command-mode-activate)))
  (my/xfk-auto-command-mode-activate)



;; #####################################################################################
(message "config • LayerXahFlyKey, version straight !!! …")



      ;; Tell emacs where is your personal elisp lib dir

      (if (file-exists-p "~/.emacs.d/lisp/")
        (let ((default-directory "~/.emacs.d/lisp/"))
        (normal-top-level-add-subdirs-to-load-path))
        )

      ;;avant, pas récursif
      ;; (add-to-list 'load-path "~/.emacs.d/lisp/")

      ;; chargement du package
      (require 'LayerXahFlyKey)

    ;; (use-package LayerXahFlyKey)  

      ;;pour load mon pack sans le push à chaque fois, le met également à jour
      ;; (org-babel-load-file (expand-file-name "/home/msi/.emacs.d/lisp/LayerXahFlyKey/LayerXahFlyKey.org"))




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
    (setq recentf-max-menu-items 50)
    (setq recentf-max-saved-items 50)

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


  ;; (server-start)  ;; starts emacs as server (if you didn't already)



;; #####################################################################################
(message "config • Démarrer avec les fichiers récents, titre etc …")


  (use-package dashboard
    :after projectile all-the-icons
    :config
    ;;centrer le dashboard
    (setq dashboard-center-content t)
    ;;item
    (setq dashboard-items '(
                            (recents  . 10)			    
                            (agenda . 5)
                            (bookmarks . 5)
                            (projects . 5)
                            (registers . 5)
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
    (which-key-mode)
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
    :diminish
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
(message "config • TODO Buffer cursor indicator …")

  (use-package nyan-mode
    ;; :config (nyan-mode)
    )

  (use-package poke-line
    :config
    (poke-line-global-mode 1)
    (poke-line-set-random-pokemon)
    ;; (setq-default poke-line-pokemon "gengar")
    )

  (use-package yascroll
    :custom (yascroll:delay-to-hide 100000)
    (yascroll:priority 20)
    :config
    (global-yascroll-bar-mode 1))




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
    :if (display-graphic-p)
    :config
    (unless (member "all-the-icons" (font-family-list))
    (all-the-icons-install-fonts t))
    )



;; #####################################################################################
(message "config • Thèmes (faire M-x customize-themes pour choisir) …")


  (use-package doom-themes
    :config
    ;; (load-theme 'doom-one t)
    ;; (load-theme 'doom-one-light t)
    ;; (load-theme 'doom-vibrant t) 
    ;; (load-theme 'doom-acario-dark t)
    ;; (load-theme 'doom-acario-light t)
    ;; (load-theme 'doom-city-lights t)
    ;; (load-theme 'doom-challenger-deep t)
    ;; (load-theme 'doom-dark+ t)
    ;; (load-theme 'doom-dracula t)
    ;;; (load-theme 'doom-fairy-floss t)
    ;;; (load-theme 'doom-gruvbox t)
    ;; (load-theme 'doom-horizon t)
    ;; (load-theme 'doom-Iosvkem t)
    ;; (load-theme 'doom-laserwave t)
    ;; (load-theme 'doom-material t)
    ;; (load-theme 'doom-manegarm t)
    ;; (load-theme 'doom-molokai t)
    ;; (load-theme 'doom-moonlight t)
    ;; (load-theme 'doom-nord t)
    ;; (load-theme 'doom-nord-light t)
    ;; (load-theme 'doom-nova t)
    ;; (load-theme 'doom-oceanic-next t)
    ;;; (load-theme 'doom-opera t)
    ;; (load-theme 'doom-opera-light t)
    ;; (load-theme 'doom-outrun-electric t)
    ;; (load-theme 'doom-palenight t)
    ;;; (load-theme 'doom-peacock t)
    ;; (load-theme 'doom-snazzy t)
    ;;; (load-theme 'doom-solarized-dark t)
    ;; (load-theme 'doom-solarized-light t)
    ;; (load-theme 'doom-sourcerer t)
    ;; (load-theme 'doom-spacegrey t)
    ;; (load-theme 'doom-tomorrow-night t)
    ;; (load-theme 'doom-tomorrow-day t)
    ;;; (load-theme 'doom-wilmersdorf t)
    (load-theme 'doom-shades-of-purple t)
    )

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
(message "config • Smiley ! …")

  (use-package emojify
    :hook (after-init . global-emojify-mode)
    )


;; #####################################################################################
(message "config • Très joli icône ! voir ce qui le désactive …")

  (use-package svg-lib
    :config

    (defvar svg-font-lock-keywords
      `(("TODO"
         (0 (list 'face nil 'display (svg-font-lock-todo))))
        ("NEXT"
         (0 (list 'face nil 'display (svg-font-lock-next))))
        ("TODO"
         (0 (list 'face nil 'display (svg-font-lock-todo))))
        ("\\:\\([0-9a-zA-Z]+\\)\\:"
         (0 (list 'face nil 'display (svg-font-lock-tag (match-string 1)))))
        ("DONE"
         (0 (list 'face nil 'display (svg-font-lock-done))))
        ("\\[\\([0-9]\\{1,3\\}\\)%\\]"
         (0 (list 'face nil 'display (svg-font-lock-progress_percent (match-string 1)))))
        ("\\[\\([0-9]+/[0-9]+\\)\\]"
         (0 (list 'face nil 'display (svg-font-lock-progress_count (match-string 1)))))))

    (defun svg-font-lock-tag (label)
      (svg-lib-tag label nil :margin 0))

    (defun svg-font-lock-todo ()
      (svg-lib-tag "TODO" nil :margin 0
                   :font-family "Fira Mono" :font-weight 500
                   :foreground "#FFFFFF" :background "#673AB7"))


    (defun svg-font-lock-next ()
      (svg-lib-tag "NEXT" nil :margin 0
                   :font-family "Fira Mono" :font-weight 500
                   :foreground "red" :background "#673AB7"))

    (defun svg-font-lock-done ()
      (svg-lib-tag "DONE" nil :margin 0
                   :font-family "Fira Mono" :font-weight 400
                   :foreground "#B0BEC5" :background "white"))

    (defun svg-font-lock-progress_percent (value)
      (svg-image (svg-lib-concat
                  (svg-lib-progress-bar (/ (string-to-number value) 100.0)
                                        nil :margin 0 :stroke 2 :radius 3 :padding 2 :width 12)
                  (svg-lib-tag (concat value "%")
                               nil :stroke 0 :margin 0)) :ascent 'center))

    (defun svg-font-lock-progress_count (value)
      (let* ((seq (mapcar #'string-to-number (split-string value "/")))
             (count (float (car seq)))
             (total (float (cadr seq))))
        (svg-image (svg-lib-concat
                    (svg-lib-progress-bar (/ count total) nil
                                          :margin 0 :stroke 2 :radius 3 :padding 2 :width 12)
                    (svg-lib-tag value nil
                                 :stroke 0 :margin 0)) :ascent 'center)))

    ;; Activate
    (push 'display font-lock-extra-managed-props)
    (font-lock-add-keywords nil svg-font-lock-keywords)
    (font-lock-flush (point-min) (point-max))

    ;; Deactivate 
    ;; (font-lock-remove-keywords nil svg-font-lock-keywords)
    ;; (font-lock-flush (point-min) (point-max))

    ;;qqch dans org désactive svg, je dois donc le hook comme ceci pour que ça marche
    (defun svg-icones ()
      (push 'display font-lock-extra-managed-props)
      (font-lock-add-keywords nil svg-font-lock-keywords)
      (font-lock-flush (point-min) (point-max))
      )

    (add-hook #'org-mode-hook #'svg-icones)

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
    :diminish
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
(message "config • Les TODO en done quand tous les sous arbres sont done …")

     (defun org-summary-todo (n-done n-not-done)
       "Switch entry to DONE when all subentries are done, to TODO otherwise."
       (let (org-log-done org-log-states)   ; turn off logging
         (org-todo (if (= n-not-done 0) "DONE" "TODO"))))

     (add-hook 'org-after-todo-statistics-hook 'org-summary-todo)
	    (defun my/org-checkbox-todo ()
	      "Switch header TODO state to DONE when all checkboxes are ticked, to TODO otherwise"
	      (let ((todo-state (org-get-todo-state)) beg end)
		(unless (not todo-state)
		  (save-excursion
		(org-back-to-heading t)
		(setq beg (point))
		(end-of-line)
		(setq end (point))
		(goto-char beg)
		(if (re-search-forward "\\[\\([0-9]*%\\)\\]\\|\\[\\([0-9]*\\)/\\([0-9]*\\)\\]"
			       end t)
		    (if (match-end 1)
		    (if (equal (match-string 1) "100%")
			(unless (string-equal todo-state "DONE")
			  (org-todo 'done))
		      (unless (string-equal todo-state "TODO")
			(org-todo 'todo)))
		      (if (and (> (match-end 2) (match-beginning 2))
			   (equal (match-string 2) (match-string 3)))
		      (unless (string-equal todo-state "DONE")
			(org-todo 'done))
		    (unless (string-equal todo-state "TODO")
		      (org-todo 'todo)))))))))
      
      (add-hook 'org-checkbox-statistics-hook 'my/org-checkbox-todo)


;; #####################################################################################
(message "config • Better templates / <el shortcutt …")

      (require 'org-tempo)
      
      (add-to-list 'org-structure-template-alist '("sh" . "src sh"))
      (add-to-list 'org-structure-template-alist '("cd" . "src C"))
      (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
      (add-to-list 'org-structure-template-alist '("sc" . "src scheme"))
      (add-to-list 'org-structure-template-alist '("ts" . "src typescript"))
      (add-to-list 'org-structure-template-alist '("py" . "src python"))
      (add-to-list 'org-structure-template-alist '("yaml" . "src yaml"))
      (add-to-list 'org-structure-template-alist '("json" . "src json"))


;; #####################################################################################
(message "config • Place de l'archive/pour archiver dans des fichiers différents …")

    (setq org-archive-location "%s_archive::* ArchivedTasksfrom%s")


;; #####################################################################################
(message "config • Pour mettre des liens directement avec org-insert-link id …")


  ;; pour que les liens soit relatif, et donc pour pouvoir l'installer sur n'importe qu'elle ordinateur !
  (setq org-id-locations-file-relative t)

  ;;lieu du fichier des loccation :
  ;;voir no-littering

  ;;voir le manual pour plus d'information. Ne me créera pas d'id inutile
  (setq org-id-link-to-org-use-id 'create-if-interactive-and-no-custom-id)

  ;; ;; Où chercher des fichiers en plus pour les ID.  Si la valeur de org-id-extra-files est nul, alors org-agenda-text-search-extra-files prendra le dessus, mais cela correspond aussi aux fichiers org-agenda ajouté. Il faut donc prendre d'autres fichiers. Là, j'ai vraiment tout mis.
  (setq org-id-extra-files
        (append
         documents-directory-all-org-files
         shared-directory-all-org-files
         my-user-emacs-configuration-list
         )
        )

  ;;ceci est la liste des fichiers (qui pernds des liste en paramètre) qui vont s'afficher quand on va faire un org-insert-link id. même syntaxe que les refile
  (setq org-try-targets
        '(
          ;;refile dans le buffer courant jusqu'au niveau 7
          (nil :maxlevel . 7)
          ;;refile dans tous les fichiers de l'agenda jusqu'au niveau 5
          (org-agenda-files :maxlevel . 5)
          ;;refile les documents
          (documents-mesdocuments-directory-all-org-files :maxlevel . 1)
          ;;pour refile document_partage
          (shared-directory-private-all-org-files :maxlevel . 5)
          (my-user-emacs-configuration-list :maxlevel . 5)
          )
        )


  ;; pour la complétion lors de l'insertion d'un lien id avec org-insert-link id, la complétion est 
  ;;il faut personnaliser org-try-targets comme un org-refile-targets
  (defun org-id-complete-link (&optional arg)
    "Create an id: link using completion"
    (concat "id:"
            (org-id-get-with-outline-path-completion org-try-targets)
            ;; (org-id-get-with-outline-path-completion org-id-extra-files)            ;; là je prends vraiment tout
            ;; (org-id-get-with-outline-path-completion org-refile-targets) ;;pas mal pour les refiles
            ;; (org-id-get-with-outline-path-completion) ;; pour avoir d'autres completion par exemple
            )
    )
  ;;pour que ça marche après org 9.0
  (org-link-set-parameters "id" :complete 'org-id-complete-link)



  ;; (setq org-refile-use-outline-path 'file)
  ;; (setq org-outline-path-complete-in-steps t)



;; #####################################################################################
(message "config • Pour avoir des id propre …")

(use-package org-id-cleanup)


;; #####################################################################################
(message "config • On update à la fin ? …")

  ;; Update ID file .org-id-locations on startup
  ;; (org-id-update-id-locations)


;; #####################################################################################
(message "config • Html …")

  (use-package htmlize
    :config
    ;; (setq org-html-doctype "html5") ;;mis directement dans les pages web
    )


;; #####################################################################################
(message "config • Pour twitter (why not) …")

  (use-package ox-twbs)


;; #####################################################################################
(message "config • Epub …")

  (use-package ox-epub)


;; #####################################################################################
(message "config • Petite bulles des titres …")


  (use-package org-bullets
    :after org
    :hook(org-mode . org-bullets-mode)
    )

  ;; (use-package org-superstar
  ;; :after org
  ;; :hook (org-mode . org-superstar-mode)
  ;; :custom
  ;; (org-superstar-remove-leading-stars t)
  ;; (org-superstar-headline-bullets-list '("◉" "○" "●" "○" "●" "○" "●")))



;; #####################################################################################
(message "config • Couleurs …")


  (setq org-emphasis-alist
	'(("*" bold)
	  ("/" italic)
	  ("_" underline)
	  ("=" (:foreground "yellow")) ;;on ne peut pas surligner lors de l'export
	  ("~" org-code verbatim)
	  ("+" (:strike-through t))))

  (defface my-org-emphasis-bold
    '((default :inherit bold)
      (((class color) (min-colors 88) (background light))
       :foreground "#a60000")
      (((class color) (min-colors 88) (background dark))
       :foreground "#ff8059"))
    "My bold emphasis for Org.")

  (defface my-org-emphasis-italic
    '((default :inherit italic)
      (((class color) (min-colors 88) (background light))
       :foreground "#005e00")
      (((class color) (min-colors 88) (background dark))
       :foreground "#44bc44"))
    "My italic emphasis for Org.")

  (defface my-org-emphasis-underline
    '((default :inherit underline)
      (((class color) (min-colors 88) (background light))
       :foreground "#813e00")
      (((class color) (min-colors 88) (background dark))
       :foreground "#d0bc00"))
    "My underline emphasis for Org.")

  (defface my-org-emphasis-strike-through
    '((((class color) (min-colors 88) (background light))
       :strike-through "#972500" :foreground "#505050")
      (((class color) (min-colors 88) (background dark))
       :strike-through "#ef8b50" :foreground "#a8a8a8"))
    "My strike-through emphasis for Org.")




;; #####################################################################################
(message "config • Pour voir directement les liens, faire disparaître l'emphasis …")


  (setq org-hide-emphasis-markers t)
  (straight-use-package '(org-appear :type git :host github :repo "awth13/org-appear"))
  (add-hook 'org-mode-hook 'org-appear-mode)

  ;;affiche les liens entier avec t
  ;; (setq org-appear-autolinks t)



;; #####################################################################################
(message "config • Org font (police et taille des titres et checkbox) …")


  ;;Pour obtenir des polices proportionnelles
  (variable-pitch-mode 1)

  ;; Make sure org-indent face is available
  (require 'org-indent)
  (set-face-attribute 'org-document-title nil :font "Fira Mono" :weight 'bold :height 1.5)
  (dolist (face '((org-level-1 . 1.3)
                  (org-level-2 . 1.25)
                  (org-level-3 . 1.20)
                  (org-level-4 . 1.15)
                  (org-level-5 . 1.10)
                  (org-level-6 . 1.05)
                  (org-level-7 . 1.0)
                  (org-level-8 . 1.0)))
    (set-face-attribute (car face) nil :font "Fira Mono" :weight 'medium :height (cdr face)))


  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-table nil  :inherit 'fixed-pitch)
  (set-face-attribute 'org-formula nil  :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-indent nil :inherit '(org-hide fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch)

  ;;couleur des checkbox
  (defface org-checkbox-todo-text
    '((t (:inherit org-todo)))
    "Face for the text part of an unchecked org-mode checkbox.")

  (font-lock-add-keywords
   'org-mode
   `(("^[ \t]*\\(?:[-+*]\\|[0-9]+[).]\\)[ \t]+\\(\\(?:\\[@\\(?:start:\\)?[0-9]+\\][ \t]*\\)?\\[\\(?: \\|\\([0-9]+\\)/\\2\\)\\][^\n]*\n\\)" 1 'org-checkbox-todo-text prepend))
   'append)

  (defface org-checkbox-done-text
    '((t (:inherit org-done)))
    "Face for the text part of a checked org-mode checkbox.")

  (font-lock-add-keywords
   'org-mode
   `(("^[ \t]*\\(?:[-+*]\\|[0-9]+[).]\\)[ \t]+\\(\\(?:\\[@\\(?:start:\\)?[0-9]+\\][ \t]*\\)?\\[\\(?:X\\|\\([0-9]+\\)/\\2\\)\\][^\n]*\n\\)" 1 'org-checkbox-done-text prepend))
   'append)



;; #####################################################################################
(message "config • Nouveau symbole à fin de titres …")


  (setq org-ellipsis "⬎")



;; #####################################################################################
(message "config • Voir directement les images + leur ajuster leur taille …")

(setq org-startup-with-inline-images t)
(setq org-image-actual-width 800)  


;; #####################################################################################
(message "config • Voir les prévisualisations de latex …")

  (use-package org-fragtog
    :hook (org-mode . org-fragtog-mode)
    )


;; #####################################################################################
(message "config • Indente automatiquement en fonction des titres (attention, que visuel) …")

  (add-hook 'org-mode-hook 'org-indent-mode)
  (diminish org-indent-mode)


;; #####################################################################################
(message "config • TODO Pour mettres les jolis tags : …")


(use-package org-pretty-tags
  :config
   (setq org-pretty-tags-surrogate-strings
	 (quote
	  (("@office" . "✍")
	   ("PROJEKT" . "💡")
	   ("SERVICE" . "✍")
	   ("Blog" . "✍")
	   ("music" . "♬")
	   )))
   (org-pretty-tags-global-mode))



;; #####################################################################################
(message "config • Les langages chargé par org-babel …")

  (org-babel-do-load-languages
   'org-babel-load-languages
   '(
     ;; (ditaa      . t)
     (C          . t)
     ;; (dot        . t)
     (emacs-lisp . t)
     ;; (scheme     . t)
     ;; (gnuplot    . t)
     ;; (haskell    . t)
     (latex      . t)
     ;; (js         . t)
     ;; (ledger     . t)
     ;; (matlab     . t)
     ;; (ocaml      . t)
     ;; (octave     . t)
     ;; (plantuml   . t)
     (python     . t)
     ;; (R          . t)
     ;; (ruby       . t)
     ;; (screen     . nil)
     ;; (scheme     . t)
     (shell      . t)
     (sql        . t)
     (sqlite     . t)
     (java     . t)
     (js . t) ;;javascripts
     )
   )  


;; #####################################################################################
(message "config • Annulation de la demande de confirmation lors de la demande d'évaluation du code …")

  (setq org-confirm-babel-evaluate nil)


;; #####################################################################################
(message "config • Indente le code selon le language …")

  (setq org-src-tab-acts-natively t)
  (setq org-src-fontify-natively t)


;; #####################################################################################
(message "config • TODO Nouveau keyword/state/todo + couleurs …")

  (setq org-todo-keywords
        '(
          (sequence "TODO(t)" "NEXT(n)" "|" "DONE(d)")
          (sequence "RAPPEL(r)" "WAIT(w)" "|" "CANCELLED(c)")
          )
        )


  ;; TODO: org-todo-keyword-faces
  (setq org-todo-keyword-faces
        '(("NEXT" . (:foreground "orange red" :weight bold))
          ("WAIT" . (:foreground "HotPink2" :weight bold))
          ("BACK" . (:foreground "MediumPurple3" :weight bold))
          ("RAPPEL" . (:foreground "white" :weight bold))
          ))


;; #####################################################################################
(message "config • Où sont mes fichiers agendas ? …")


  (setq org-agenda-files (append orgzly-directory-all-org-files))

  ;; pour supprimer mes archives de org agenda TODO
  ;; (org-remove-file "/home/msi/Notes/Roam/GTD/6Archives.org")

  ;; Nouvelle touche pour mieux naviguer avec xah
  ;; (define-key org-agenda-mode-map [remap next-line] #'org-agenda-next-item)
  ;; (define-key org-agenda-mode-map [remap previous-line] #'org-agenda-previous-item)
  ;;
  (define-key org-agenda-mode-map [remap ?\r] #'org-agenda-goto)

  ;;avoir "org", notamment org-schedule, en anglais, indispensable pour orgzly
  (eval-after-load 'org (setq system-time-locale "C"))

  ;;  pour que le curseur soit en haut de org agenda quand t on l'ouvre
  (add-hook 'org-agenda-finalize-hook (lambda () (goto-char (point-min))) 90)

  ;;ouvre l'agenda dans la window actuel
  (setq org-agenda-window-setup 'current-window)

  ;; quand commance l'agenda ?
  ;;pas le week
  (setq org-agenda-start-on-weekday nil)
  ;; mais X jour après aujourd'hui
  (setq org-agenda-start-day "+0d")

  ;;vue de l'agenda sur X jours
  (setq org-agenda-span 8)

  ;;  Pour savoir qd fini une tâche
  (setq org-log-done 'time)
  (setq org-log-into-drawer t);; le mets dans un propreties



;; #####################################################################################
(message "config • TODO Mes commandes pour séparer Inbox et AgendaTickler …")


  (defun cp/org-refile-schedulded-tasks-in-agendatickler ()
    ;; (interactive)
    )

  (defun cp/org-refile-deadline-tasks-in-agendatickler ()
    ;; (interactive)
    )

  (defun cp/org-refile-schedulded-and-deadline-tasks-in-agendatickler ()
    (interactive)
    )



;; #####################################################################################
(message "config • Ma commande dashboard (+ super agenda mais pas utilisé) …")




;; #####################################################################################
(message "config • Intégration/ syncronisation avec Google calendar …")


  ;;Lieu de l'export org-icalendar-combine-agenda-files
  (setq org-icalendar-combined-agenda-file (expand-file-name "Clement/agendapourgoogle.ics" shared-directory))

  ;;exporter avec les statse et tags, cela affiche "DL" pour deadline par exemple. Pratique pour voir que ça vient directement d'org-mode
  (setq org-icalendar-categories '(all-tags category todo-state))

  ;;export les schedulde seulement si elles non pas de state TODO DONE etc !
  (setq org-icalendar-use-scheduled '(event-if-not-todo))

  ;;fonction export en background + message pour vérif que ça marche
  (defun org-icalendar-combine-agenda-files-background()
    (interactive)
    (message "Lancement du icalendar combine file (pour org.ics)")
    (org-icalendar-combine-agenda-files t)
    )

  (defun org-icalendar-combine-agenda-files-foreground()
    (interactive)
    (org-icalendar-combine-agenda-files nil)
    (message "fini")
    )
  ;;au démarrage d'emacs
  (add-hook 'dashboard-mode-hook #'org-icalendar-combine-agenda-files-background)



;; #####################################################################################
(message "config • La fonction …")

  (defun my-org-agenda-skip-all-siblings-but-first ()
    (interactive)
    "Skip all but the first non-done entry."
    (let (should-skip-entry)
      (unless (org-current-is-todo)
        (setq should-skip-entry t))
      (save-excursion
        ;; If previous sibling exists and is TODO,
        ;; skip this entry
        (while (and (not should-skip-entry) (org-goto-sibling t))
          (when (org-current-is-todo)
            (setq should-skip-entry t))))
      (let ((num-ancestors (org-current-level))
            (ancestor-level 1))
        (while (and (not should-skip-entry) (<= ancestor-level num-ancestors))
          (save-excursion
            ;; When ancestor (parent, grandparent, etc) exists
            (when (ignore-errors (outline-up-heading ancestor-level t))
              ;; If ancestor is WAITING, skip entry
              (if (string= "WAITING" (org-get-todo-state))
                  (setq should-skip-entry t)
                ;; Else if ancestor is TODO, check previous siblings of
                ;; ancestor ("uncles"); if any of them are TODO, skip
                (when (org-current-is-todo)
                  (while (and (not should-skip-entry) (org-goto-sibling t))
                    (when (org-current-is-todo)
                      (setq should-skip-entry t)))))))
          (setq ancestor-level (1+ ancestor-level))
          ))
      (when should-skip-entry
        (or (outline-next-heading)
            (goto-char (point-max))))))

  (defun org-current-is-todo ()
    (string= "TODO" (org-get-todo-state)))



  ;; (save-excursion
  ;; test avec goto-first-chird, bien seul bémol : si jamais on est 
  ;; dans une situation plein de sous todo faites, alors celui d'au dessus
  ;; ne se vera pas (car il est todo mais tout est fini)
  ;; (while (and (not should-skip-entry) (org-goto-first-child t))
  ;; (setq should-skip-entry t)))


(defun my-org-agenda-skip-all-siblings-but-first-bis ()
      (interactive)
      "Skip all but the first non-done entry."
      (let (should-skip-entry)
        (unless (org-current-is-todo)
          (setq should-skip-entry t))
        (save-excursion
          ;; If previous sibling exists and is TODO,
          ;; skip this entry
          (while (and (not should-skip-entry) (org-goto-sibling t))
            (when (org-current-is-todo)
              (setq should-skip-entry t))))
        (save-excursion
          ;; test avec goto-first-chird, bien seul bémol : si jamais on est 
          ;; dans une situation plein de sous todo faites, alors celui d'au dessus
          ;; ne se vera pas (car il est todo mais tout est fini)
          (while (and (not should-skip-entry) (org-goto-first-child t))
            (setq should-skip-entry t)))
        (let ((num-ancestors (org-current-level))
              (ancestor-level 1))
          (while (and (not should-skip-entry) (<= ancestor-level num-ancestors))
            (save-excursion
              ;; When ancestor (parent, grandparent, etc) exists
              (when (ignore-errors (outline-up-heading ancestor-level t))
                ;; If ancestor is WAITING, skip entry
                (if (string= "WAITING" (org-get-todo-state))
                    (setq should-skip-entry t)
                  ;; Else if ancestor is TODO, check previous siblings of
                  ;; ancestor ("uncles"); if any of them are TODO, skip
                  (when (org-current-is-todo)
                    (while (and (not should-skip-entry) (org-goto-sibling t))
                      (when (org-current-is-todo)
                        (setq should-skip-entry t)))))))
            (setq ancestor-level (1+ ancestor-level))
            ))
        (when should-skip-entry
          (or (outline-next-heading)
              (goto-char (point-max))))))

  (defun org-current-is-todo ()
    (string= "TODO" (org-get-todo-state)))



;; #####################################################################################
(message "config • La basique …")



  (use-package org-super-agenda :config(org-super-agenda-mode t))

  (add-hook 'org-agenda-mode-hook 'org-super-agenda-mode)

  ;; pour mes tâches non faites
  (setq gtd-inbox-file (list (append (concat orgzly-directory "Inbox.org"))))

  (setq org-agenda-custom-commands
        '(("d" "dashboard"
           (
            (todo "RAPPEL" ((org-agenda-overriding-header "Se souvenir de ceci")))
            (todo "NEXT"
                  ((org-agenda-overriding-header "Next Actions")
                   (org-agenda-max-todos nil)))
            (todo "TODO"
                  ((org-agenda-overriding-header "Tout ce qui est dans Inbox(Unprocessed Inbox Tasks)")
                   (org-agenda-files gtd-inbox-file))
                  (org-agenda-text-search-extra-files nil))
            (todo "WAIT"
                  ((org-agenda-overriding-header "Waiting items")
                   (org-agenda-max-todos nil)))
            ;;(stuck "") ;; review stuck projects as designated by org-stuck-projects
            ;; ...other commands here
            )
           )))

  ;; pour appeler directement dashboard

  (defun org-agenda-show-dashboard (&optional arg)
    (interactive "P")
    (setq org-agenda-todo-ignore-scheduled t) ;;pour ne pas afficher les tâche schedulded
    (org-agenda arg "d")
    )

  (global-set-key (kbd "<f12>") 'org-agenda-show-dashboard)




;; #####################################################################################
(message "config • Le super-agenda …")







;; #####################################################################################
(message "config • Mettre toutes les tâches DONE en archive (fichier ou subtree) avec les commandes suivantes …")

  
  (defun org-archive-done-tasks-in-file ()
  (interactive)
  (org-map-entries
   (lambda ()
     (org-archive-subtree)
     (setq org-map-continue-from (org-element-property :begin (org-element-at-point))))
   "/DONE" 'file))
  
  (defun org-archive-done-tasks-in-subtree ()
  (interactive)
  (org-map-entries
   (lambda ()
     (org-archive-subtree)
     (setq org-map-continue-from (org-element-property :begin (org-element-at-point))))
   "/DONE" 'tree))
  


;; #####################################################################################
(message "config • TODO Mettre toutes les tâches passé en archive, presque fini …")

  (defun test-archiving-task ()
    (interactive)
    "Archive toute les task qui sont passées"
    (org-sparse-tree b);;ceci ne marche pas
  ;;(org-agenda nil "a")

    (while (next-error)
      (previous-line)
      (insert "Za marche")

      ;; (org-archive-subtree)

      )
    )


;; #####################################################################################
(message "config • TODO Tag, dans GTD ? Enlever ces putain de @ …")

  (setq org-tag-alist '((:startgroup . nil)

                                          ; Put mutually exclusive tags here
                        (:endgroup . nil)

                        ("@home" . ?h)
                        ("@office" . ?h)
                        ;; ("@anywhere" . ?h)
                        ("@pc" . ?p)                        
                        ("@tel" . ?t)
                        ("work" . ?w)
                        ("Nell" . ?n)
                        ("batch" . ?b)
                        ("followup" . ?f)
                        ("NEXT" . ?n)

                        )

        )


;; #####################################################################################
(message "config • La base …")


  (use-package org-contrib
    :config
    (require 'org-contacts)
    (require 'org-depend)
    ;; (setq org-contacts-files (cp/org-directory-path "org/orgzly/contacts.org"))
    ;; (setq org-contacts-files '(expand-file-name "org/orgzly/contacts.org" org-directory))
    ;; (setq org-contacts-files '(sa-find-org-file-recursively (cp/org-directory-path "org") "org/orgzly"))
    ;; (setq org-contacts-files (list "org/orgzly/contacts.org"))

    ;;on doit renvoyer une liste pour celui ci attention !
    (setq org-contacts-files (list(concat orgzly-directory "Contacts.org")))
    )


;; #####################################################################################
(message "config • Export en vcard compris par google contact (.vcf files to .org marche aussi), en ce moment bug mais normalement ça marche …")


  (use-package org-vcard
    :init
    ;;la version utilisée (pour pouvoir y envoyer sur google)
    (setq org-vcard-default-version "3.0")
    ;;le dossier à mettre
    ;; (setq org-contacts-vcard-files (cp/shared-directory-path "Clement/contactgoogle.vcf"))
    :config
    (setq org-contacts-vcard-files (concat orgzly-directory "Contacts.org"))
    )




;; #####################################################################################
(message "config • Moteur de Org-capture …")


  ;;mettre mes template directement ici et pas dans templatesOrgCapture ?
  ;; quand on donne un truc relatif, alors le org-directory est bien appelé !
  ;; templatesOrgCapture dans Notes, car comme ça marchera partout

  (setq org-capture-templates '
        (
         ("i" "Inbox (TODO)" entry
          (file (lambda() (concat orgzly-directory "Inbox.org")))
          (file "templatesOrgCapture/todo.org")
          :immediate-finish t
          )
         ("s" "Slipbox for org-roam" entry  (file "braindump/org/inbox.org")
          "* %?\n")

         ("t" "Tickler" entry
          (file (lambda() (concat orgzly-directory "AgendaTickler.org")))
          (file "templatesOrgCapture/tickler.org")
          :immediate-finish t
          )

         ("e" "Évènement sur plusieurs heures" entry
          (file (lambda() (concat orgzly-directory "AgendaTickler.org")))
          (file "templatesOrgCapture/tickler.org")
          :immediate-finish t
          )

         ("u" "Évènement sur plusieurs jours" entry
          (file (lambda() (concat orgzly-directory "AgendaTickler.org")))
          (file "templatesOrgCapture/evenementplusieursjours.org")
          :immediate-finish t
          )

         ("C" "Contacts" entry
          (file+headline (lambda() (concat orgzly-directory "Contact.org" ))"1Inbox")
          (file "templatesOrgCapture/contacts.org")
          :immediate-finish t
          ;; :jump-to-captured t
          )

         ("D" "Journal de dissactifaction" entry (file  "org/journal_de_dissatisfaction.org")
          "* %<%Y-%m-%d> \n- %?")

         ;; ("P" "org-popup" entry (file+headline "braindump/org/inbox.org" "Titled Notes")
          ;; "%[~/.emacs.d/.org-popup]" :immediate-finish t :prepend t)


         ))




;; #####################################################################################
(message "config • Ajouter des fonctions suites aux captures, comme pour mettre des dates ou créer un ID …")


  ;; pour rajouter un ID OU DES COMMANDES à la fin de la capture !
  (defun cp/org-capture-finalize ()
    "Comprend la valeur de la key de org capture et décide de faire qql après le capture ou pas"
    (let ((key  (plist-get org-capture-plist :key))
          (desc (plist-get org-capture-plist :description)))
      (if org-note-abort
          (message "Template with key %s and description “%s” aborted" key desc)
        (message "Template with key %s and description “%s” run successfully" key desc)
        )
      (when (string= key "A") 		;si jamais c'est A, alors faire la suite
        (org-capture-goto-last-stored)
        (org-id-get-create)	    
        )
      (when (string= key "t") 		;etc
        ;; (org-capture-goto-last-stored)
        ;; (org-schedule nil nil)
        ;; (winner-undo)
        )
      (when (string= key "e") 		;etc
        ;; (org-capture-goto-last-stored)
        ;; (org-schedule nil nil)
        ;; (winner-undo)
        )
      )
    )
  (add-hook 'org-capture-after-finalize-hook 'cp/org-capture-finalize)



;; #####################################################################################
(message "config • Org refile (pour déplacer rapidement les titres) …")


  ;;pour voir le chemin lors du refile
  (setq org-outline-path-complete-in-steps nil)
  ;; permet de déplacer avec un niveau de titre 1 ! (dans tickler par exemple)
  (setq org-refile-use-outline-path (quote file))

  ;;les targets
  (setq org-refile-targets
        '(
          ;;refile dans le buffer courant jusqu'au niveau 7
          (nil :maxlevel . 7)
          ;;refile dans tous les fichiers de l'agenda jusqu'au niveau 5
          (org-agenda-files :maxlevel . 5)
          ;;refile les documents
          (documents-mesdocuments-directory-all-org-files :maxlevel . 1)
          (org-directory :maxlevel . 1)
          (orgzly-directory-all-org-files :maxlevel . 8)
  
          ;;pour refile document_partage
          ;; (shared-directory-all-org-files :maxlevel . 5)
          )
        )



;; #####################################################################################
(message "config • Org protocol, pour faire des choses avec le pc …")

  (require 'org-protocol)


;; #####################################################################################
(message "config • Org roam(moteur) …")


  (use-package org-roam
    :if (file-exists-p org-roam-directory) ;; je charge seulement si ya bien un dossier org roam
    :init
    ;; (setq org-roam-directory "/home/msi/Notes/Roam")
    ;;éviter d'avoir la nottif de version 1 à 2
    (setq org-roam-v2-ack t)
    :custom
    (org-roam-completion-everywhere t) ;; pour avoir la complétien partout
    ;;défini la capture de mon journal, pas utilisé
    (org-roam-dailies-capture-templates 
     '(("d" "default" entry "* %<%I:%M %p>: %?"
        :target (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n")
        :empty-lines 1)  
       ))
    ;; défini mes capture normal



    :config
    ;; syncro automatique avec les fichiers 
    (org-roam-db-autosync-mode)



    )



;; #####################################################################################
(message "config • Les org-roam-capture …")


  (with-eval-after-load 'org-roam
    (setq org-roam-capture-templates
          '(
            ("i" "inbox" entry "* %?"
             :target
             (node  "Inbox")
             ;; :unnarrowed t
             )
            ("m" "main" plain
             "%?"
             :target (file+head "main/${slug}.org"
                                "#+title: ${title}\n")
             :immediate-finish t
             :unnarrowed t)
            ("r" "reference" plain "%?"
             :target
             (file+head "reference/${title}.org" "#+title: ${title}\n")
             :immediate-finish t
             :unnarrowed t)
            ("a" "article" plain "%?"
             :target
             (file+head "articles/${title}.org" "#+title: ${title}\n#+filetags: :article:\n")
             :immediate-finish t
             :unnarrowed t)
            )
          )
    )





;; #####################################################################################
(message "config • Gestion des citations TODO …")

    ;; SUPPER IMPORTANT : chargé la bibliothèque qui gère CSL !!!!!! normalement c'est fait tout seul mais enfait non LOL
  ;;  (require 'oc)
  (require 'oc-csl)
    ;; (require 'oc-biblatex)
    ;; (require 'oc-bibtex)
    ;; (require 'oc-natbib)

    (setq my-bibliography-list (list (concat org-roam-directory "biblio.bib")
                                     ;; "/path/to/another/"
                                     ;; "/path/to/another/"
                                     )
          )


;; #####################################################################################
(message "config • Citar, les propositions avec citar-insert-citation …")


  (use-package citar
    ;; :after all-the-icons ;; besoin des icones pour charger les propositions
    :after oc-csl
    :custom
    ;;lieu de ma bibliographie
    (citar-bibliography (list (concat org-roam-directory "biblio.bib")))
    :config
    ;; pour complété avec consult yeah
    (advice-add #'completing-read-multiple :override #'consult-completing-read-multiple)

    ;; comment on gère l'affichage des propositions en dur
    (setq citar-templates
          '((main . "${author editor:30}     ${date year issued:4}     ${title:48}")
            (suffix . "          ${=key= id:15}    ${=type=:12}    ${tags keywords:*}")
            (preview . "${author editor} (${year issued date}) ${title}, ${journal journaltitle publisher container-title collection-title}.\n")
            (note . "Notes on ${author editor}, ${title}")))
    ;;le séparateur
    (setq citar-symbol-separator "  ")

    ;; et affichage des icônes à gauche
    (setq citar-symbols
          `((file ,(all-the-icons-faicon "file-o" :face 'all-the-icons-green :v-adjust -0.1) . " ")
            (note ,(all-the-icons-material "speaker_notes" :face 'all-the-icons-blue :v-adjust -0.3) . " ")
            (link ,(all-the-icons-octicon "link" :face 'all-the-icons-orange :v-adjust 0.01) . " ")))

    ;; automatiquement refresh lorque l'on modifie la bibliographie
    (setq citar-filenotify-callback 'refresh-cache)
    )



;; #####################################################################################
(message "config • Pour les exports …")


  (use-package citeproc
    :straight (:host github :repo "andras-simonyi/citeproc-el")
    :after citar

    :init
    ;; nom du titre exporté pour la bibliographie
    (with-eval-after-load 'ox-hugo
      (plist-put org-hugo-citations-plist :bibliography-section-heading "Bibliographie"))

    :config
    (setq org-cite-global-bibliography my-bibliography-list) ;; pour que org-cite sache où est ma biblio
    (setq org-cite-export-processors '((t csl)));; exporter tout le temps avec la méthode csl

    ;; les fichiers de configuration. Impossible de les configurer "normalement" (voir en dessous), j'utilise donc les fichiers "fallback" qui sont ceux par défaut
    ;; (setq org-cite-csl--fallback-style-file "/home/msi/documents/notes/braindump/org/chicago-author-date-16th-edition.csl") ;;
    (setq org-cite-csl--fallback-style-file "/home/msi/documents/notes/braindump/org/vancouver-brackets.csl");; pour changer le style. Vancouver = numéro
    (setq org-cite-csl--fallback-locales-dir "/home/msi/documents/notes/braindump/org/")
    )







  ;;le bordel ici, mais pas utilisé
  ;; pas utilisé, mais voir aussi les variable de jethro
  ;; (setq
  ;; org-cite-global-bibliography my-bibliography-list ;; pour que org-cite sache où est ma biblio
  ;; citar-format-reference-function 'citar-citeproc-format-reference
  ;; org-cite-csl-styles-dir "~/Zotero/styles/"
  ;; citar-citeproc-csl-styles-dir org-cite-csl-styles-dir
  ;; citar-citeproc-csl-locales-dir "~/Zotero/locales/"

  ;; doute sur lui, voir le dot de jethro
  ;; citar-citeproc-csl-style (concat (expand-file-name org-cite-csl-styles-dir
  ;; )"apa.csl")


  ;;pour que ça marche, il faut régler ces deux variables
  ;; après avoir exécuté ceci, les export marches TODO
  ;; org-cite-csl--fallback-style-file "/home/msi/documents/notes/braindump/org/reference/chicago-author-date-16th-edition.csl"
  ;; org-cite-csl--fallback-locales-dir "/home/msi/documents/notes/braindump/org/reference"
  ;; )

  ;; (setq org-cite-csl-styles-dir "~/Zotero/styles/")
  ;; (setq org-cite-csl-locales-dir "/home/msi/documents/notes/braindump/org/reference/")



;; #####################################################################################
(message "config • Trouver si une citation est affilié à un noeud. Si oui, alors bug lol y'a plus qu'à la trouver ! Permet aussi d'ajouter les sources …")


            (with-eval-after-load 'citar

    (defun jethro/org-roam-node-from-cite (keys-entries)
      (interactive (list (citar-select-ref :multiple nil :rebuild-cache t)))
      (let (
            (title (citar--format-entry-no-widths (cdr keys-entries)
                                                  "${author editor} ${title}"))
            )
        (org-roam-capture- :templates
                           '(("r" "reference" plain "%?" :target
                              (file+head "reference/${citekey}.org"
                                         "
:PROPERTIES:
:ROAM_REFS: [cite:@${citekey}]
:END:
#+title: ${title}\n\n\n- source :: [cite:@${citekey}]\nÉcrire ici\n#+print_bibliography:")
                              :immediate-finish t
                              :unnarrowed t))
                           :info (list :citekey (car keys-entries))
                           :node (org-roam-node-create :title title)
                           :props '(:finalize find-file))))
              )


  (with-eval-after-load 'citar
    ;; pour ajouter la source, j'appelle cette fonction dans le capture, qui renvoie une chaîne de caractère, et le capture à besoin d'une fonction avec un argument
    (defun cp/ajoute-source-capture  (monargumentinutile)
      (let ((source (citar--format-entry-no-widths (cdr keys-entries)
                                                   "${author editor}. ${year}. \"${title url year}\" ${url}"))
            )
        ;;renvoie de la chaîne de caractère
        (message "%s" source)
        )
      )


    ;; pour ajouter la source, j'appelle cette fonction dans le capture, qui renvoie une chaîne de caractère, et le capture à besoin d'une fonction avec un argument
    (defun cp/ajoute-source-capture-main  (monargumentinutile)
      (interactive)
      (setq source (citar--format-entry-no-widths (cdr (citar-select-ref))
                                                  "${author editor}. ${year}. \"${title}\" ${url}"))
      ;;renvoie de la chaîne de caractère
      (message "test")
      ;; (insert source)
      (with-current-buffer "*scratch*"
        (insert source)
        (end-of-line)
        (newline-and-indent))
      )



    )






;; #####################################################################################
(message "config • Org roam ui (org roam server pour org roam v2), …")


  (use-package org-roam-ui
    :after org-roam
    :straight
    (:host github :repo "org-roam/org-roam-ui" :branch "main" :files ("*.el" "out"))
    ;; :hook (after-init . org-roam-ui-mode)
    :config
    (setq org-roam-ui-sync-theme t
          org-roam-ui-follow t
          org-roam-ui-update-on-save t
          org-roam-ui-open-on-start nil)
    )



;; #####################################################################################
(message "config • Voir le nombre de backlinks d'une note + Utiliser la souris sur le buffer backlinks …")


  (with-eval-after-load 'org-roam
    (define-key org-roam-mode-map [mouse-1] #'org-roam-visit-thing)
    ;; for org-roam-buffer-toggle
    ;; Recommendation in the official manual
    (add-to-list 'display-buffer-alist
                 '("\\*org-roam\\*"
                   (display-buffer-in-direction)
                   (direction . right)
                   (window-width . 0.33)
                   (window-height . fit-window-to-buffer)))
    ;;pour avoir le nombre de backlinks lorsque que l'on cherche un node
    (cl-defmethod org-roam-node-directories ((node org-roam-node))
      (if-let ((dirs (file-name-directory (file-relative-name (org-roam-node-file node) org-roam-directory))))
          (format "%s" (car (f-split dirs)))
        ""))
    (cl-defmethod org-roam-node-backlinkscount ((node org-roam-node))
      (let* ((count (caar (org-roam-db-query
                           [:select (funcall count source)
                                    :from links
                                    :where (= dest $s1)
                                    :and (= type "id")]
                           (org-roam-node-id node)))))
        (format "%d" count)))
    )




;; #####################################################################################
(message "config • hiérarchie quand on cherche/insert une note …")



  (with-eval-after-load 'org-roam


    ;; pour avoir la hiérarchie lorsque c'est une sous note 
    (cl-defmethod org-roam-node-filetitle ((node org-roam-node))
    "Return the file TITLE for the node."
    (org-roam-get-keyword "TITLE" (org-roam-node-file node)))


    (cl-defmethod org-roam-node-hierarchy ((node org-roam-node))
    "Return the hierarchy for the node."
    (let ((title (org-roam-node-title node))
    (olp (org-roam-node-olp node))
    (level (org-roam-node-level node))
    (filetitle (org-roam-node-filetitle node)))
    (concat
    (if (> level 0) (concat filetitle " -> "))
    (if (> level 1) (concat (string-join olp " -> ") " -> "))
    title))) ;; soit disant une erreur ici, mais tout va bien

    )


    ;; (setq org-roam-node-display-template "${directories:15} ${tags:40} ${backlinkscount:1}")
    ;; (setq org-roam-node-display-template "${directories:10} ${tags:10} ${title:100} ${backlinkscount:6}")



;; #####################################################################################
(message "config • Qu'est ce qu'on met lorsque l'on recherche un node (nombre = nombre de caractère) …")

  (with-eval-after-load 'org-roam
    ;; (setq org-roam-node-display-template "${directories:15} ${hierarchy:105} ${tags:40} ${backlinkscount:1}") ;;plus besion des fichiers


    (cl-defmethod org-roam-node-type ((node org-roam-node))
      "Return the TYPE of NODE."
      (condition-case nil
          (file-name-nondirectory
           (directory-file-name
            (file-name-directory
             (file-relative-name (org-roam-node-file node) org-roam-directory))))
        (error "")))

    (setq org-roam-node-display-template "${type:15} ${hierarchy:130} ${tags:40} ${backlinkscount:2}")

    )


;; #####################################################################################
(message "config • Fonction pour cacher les propertie au début des fichier, très peu utiliser …")

  (with-eval-after-load 'org-roam
    
    (defun org-hide-properties ()
      "Hide all org-mode headline property drawers in buffer. Could be slow if it has a lot of overlays."
      (save-excursion
        (goto-char (point-min))
        (while (re-search-forward
                "^ *:properties:\n\\( *:.+?:.*\n\\)+ *:end:\n" nil t)
          (let ((ov_this (make-overlay (match-beginning 0) (match-end 0))))
            (overlay-put ov_this 'display "")
            (overlay-put ov_this 'hidden-prop-drawer t))))
      (put 'org-toggle-properties-hide-state 'state 'hidden))

    (defun org-show-properties ()
      "Show all org-mode property drawers hidden by org-hide-properties."
      (remove-overlays (point-min) (point-max) 'hidden-prop-drawer t)
      (put 'org-toggle-properties-hide-state 'state 'shown))

    (defun org-toggle-properties ()
      "Toggle visibility of property drawers."
      (interactive)
      (if (eq (get 'org-toggle-properties-hide-state 'state) 'hidden)
          (org-show-properties)
        (org-hide-properties)))
    )


;; #####################################################################################
(message "config • Deft, pour chercher dans toutes les notes d'org-roam …")

  (use-package deft
    :after org-roam
    :config
    (setq deft-extensions '("org")
          deft-directory org-roam-directory
          deft-recursive t
          deft-strip-summary-regexp ":PROPERTIES:\n\\(.+\n\\)+:END:\n"
          deft-use-filename-as-title t)
    )


;; #####################################################################################
(message "config • Convertir les fichiers org en markdown hugo …")

  (use-package ox-hugo
    :after org
    :custom
    (org-hugo-base-dir "/home/msi/Documents/Projet/SitesWeb/braindump")
    )


;; #####################################################################################
(message "config • Hook pour les draft à chaque fois lors d'une capture …")


  (defun jethro/tag-new-node-as-draft ()
    (org-roam-tag-add '("draft")))
  (add-hook 'org-roam-capture-new-node-hook #'jethro/tag-new-node-as-draft)



;; #####################################################################################
(message "config • Pour faire des supers recherches, vraiment bien …")

(use-package org-ql)


;; #####################################################################################
(message "config • Moteur de lsp-mode …")


  (use-package lsp-mode
    :hook (((
             ;; les modes qui active lsp, et donc tout le reste
             typescript-mode
             js2-mode
             web-mode
             c-mode
             python-mode
             java-mode
             )
            . lsp)

           ;; compatibilité avec which-key
           (lsp-mode . lsp-enable-which-key-integration)
           )
    :config
    ;; pour mapper lsp-command-map
    (define-key lsp-mode-map (kbd "C-c l") lsp-command-map)
    ;;pour =activer les yasnippets dans company !!!!!!=
    (setq lsp-completion-provider :none)
    ;;pour de meilleurs performances
    ;; (setq gc-cons-threshold 100000000)
    ;; (setq read-process-output-max (* 1024 1024)) ;; 1mb
    ;; (setq lsp-idle-delay 0.500)
    (setq lsp-log-io nil) ; if set to true can cause a performance hit

    ;; les options, voir le lien au dessus

    ;; (setq lsp-ui-doc-enable nil)
    ;; (setq lsp-ui-doc-show-with-cursor nil) ;; enlever les gros pavés qui se mettent à chaque fois
    )




;; #####################################################################################
(message "config • Lsp-ui (pour les infos qd curseur dessus) …")

  (use-package lsp-ui
    :hook (lsp-mode . lsp-ui-mode)
    :custom
    (lsp-ui-doc-position 'bottom))


;; #####################################################################################
(message "config • Pour les fichiers sur le côté …")

  (use-package lsp-treemacs
    :after lsp
    :config
    ;; pour syncro les dossier treemacs avec lsp
    ;;suis pour lsp
    ;; (lsp-treemacs-sync-mode 1)	 
    )


;; #####################################################################################
(message "config • Java :Low: …")

      (use-package lsp-java
        :config
        (setq lsp-java-jdt-download-url  "https://download.eclipse.org/jdtls/milestones/0.57.0/jdt-language-server-0.57.0-202006172108.tar.gz")
        )


;; #####################################################################################
(message "config • TODO Le moteur …")


  (use-package company
    ;; :after lsp-mode  ;;si ya lsp-mode
    :init
    :hook (lsp-mode . company-mode)  ;; au lieu de lsp, mettre c-mode, python mode etc
    :bind (:map company-active-map
                ("<tab>" . company-complete-selection)) ;; logique pour complêter

    :custom
    (company-minimum-prefix-length 2) ;;taille avant que le popup arrive
    (company-idle-delay 0.6);;temps avant qu'il pop
    ;;pour cycler dans les sélections
    ( company-selection-wrap-around t)
    )  



  (with-eval-after-load 'company

    ;; réglemeent des touches, assez explicite, sur azerty :
    ;; k i s 
    (define-key company-active-map (kbd "M-n") nil)
    (define-key company-active-map (kbd "M-p") nil)
    ;; (define-key company-active-map (kbd "s") #'company-select-next)
    ;; (define-key company-active-map (kbd "d") #'company-select-previous)
    (define-key company-active-map (kbd "C-s") #'company-select-next)
    (define-key company-active-map (kbd "C-d") #'company-select-previous)
    (define-key company-active-map (kbd "u") 'company-complete-selection)
    (define-key company-active-map (kbd "SPC") #'company-abort)
    (add-to-list 'company-backends 'company-capf)
    )




;; #####################################################################################
(message "config • Pour l'esthétique de l'affichage …")

    (use-package company-box
      :after company ;;logique
      :hook (company-mode . company-box-mode) ;;logique également
      )


;; #####################################################################################
(message "config • Candidats intelligent, se base sur la fréquence d'apparition …")

  
  (use-package company-prescient
    :after company
    :config
    (company-prescient-mode 1)
    ;; Remember candidate frequencies across sessions
    (prescient-persist-mode 1)
    )
  
  


;; #####################################################################################
(message "config • Expand des choses préfaites …")


  (use-package yasnippet
    ;; si on veux les yas que en prog mode, décocher ça et cocher yas global mode
    ;; :hook (prog-mode . yas-minor-mode)
    :config
    (yas-reload-all)
    (yas-global-mode 1)
    (setq yas-triggers-in-field t) ;;appeler des snippets dans des snippets

    (define-key yas-minor-mode-map (kbd "<tab>") nil)
    (define-key yas-minor-mode-map (kbd "TAB") nil)
    (define-key yas-minor-mode-map (kbd "<C-tab>") 'yas-expand)
    )

  (use-package yasnippet-snippets ;; un pack de snippets
    :diminish)



;; #####################################################################################
(message "config • TODO Pour plier du code ? …")


  ;; (use-package origami)

    ;; (use-package lsp-origami
      ;; :config
      ;; (add-hook 'lsp-after-open-hook #'lsp-origami-try-enable)
    ;; (define-key origami-mode-map (kbd "<tab>") 'origami-toggle-node)
    ;; (define-key origami-mode-map (kbd "C-s") 'origami-next-fold)
    ;; (define-key origami-mode-map (kbd "C-d") 'origami-previous-fold)
      ;; )



;; #####################################################################################
(message "config • Error Checkinkg …")


  (use-package flycheck
    :defer t
    :diminish
    ;; :hook (lsp-mode . flycheck-mode)
    :config
    (global-flycheck-mode t)
    (set-face-attribute 'flycheck-error nil :foreground "black" :background
                        "#EE4400")
    (set-face-attribute 'flycheck-warning nil :foreground "black" :background
                        "#EE9900")
    (set-face-attribute 'flycheck-info nil :foreground "black" :background
                        "#008800")
    )



;; #####################################################################################
(message "config • Affiche les numéros de lignes qd on programme …")

   (add-hook 'prog-mode-hook #'linum-mode) 


;; #####################################################################################
(message "config • Gestion de projet …")

  (use-package projectile
    :config
    ;; (projectile-global-mode)
    ;;(setq projectile-completion-system 'ivy)
    )


;; #####################################################################################
(message "config • xah fly elisp mode, pas encore utilisé …")

(use-package xah-elisp-mode)


;; #####################################################################################
(message "config • Processing 3 (cours) …")

  
  (use-package processing-mode)
  (add-to-list 'auto-mode-alist '("\\.pde\\'" . processing-mode))

  
  (setq processing-location "/home/msi/Téléchargements/processing-3.5.4/processing-java")
  


;; #####################################################################################
(message "config • Emacs everywhere ! Pour éditer avec emacs n'importe où ! :High: …")

  (use-package emacs-everywhere
    :bind
    ;; ("C-<f9>" . emacs-everywhere-finish)
    )


;; #####################################################################################
(message "config • Restart emacs …")


  (use-package restart-emacs
    :config (defalias 'emacs-restart #'restart-emacs)
    )



;; #####################################################################################
(message "config • Correcteur grammaire fr :High:Medium: …")


  (use-package flycheck-grammalecte
    :after flycheck
    ;; :hook(org-mode . flycheck)
    :init
    (setq
     ;; pas de faute avec les '
     flycheck-grammalecte-report-apos nil
     ;; pas de faute avec les espaces insécable
     flycheck-grammalecte-report-nbsp nil
     ;; pas de faute avec pleins d'espaces et de tab
     flycheck-grammalecte-report-esp nil)
    :config

    ;;à faire pour enlever l'erreur des tirés
    ;; pour enlever l'erreur des des begin_src etc
    (setq flycheck-grammalecte-filters-by-mode
          '(
            (org-mode "(?ims)^[ \t]*#\\+begin_src.+#\\+end_src"
                      "(?im)^[ \t]*#\\+begin[_:].+$"
                      "(?im)^[ \t]*#\\+end[_:].+$"
                      "(?m)^[ \t]*(?:DEADLINE|SCHEDULED):.+$"
                      "(?m)^\\*+ .*[ \t]*(:[\\w:@]+:)[ \t]*$"
                      "(?im)^[ \t]*#\\+(?:caption|description|keywords|(?:sub)?title):"
                      "(?im)^[ \t]*#\\+(?!caption|description|keywords|(?:sub)?title)\\w+:.*$"
                      "(?ims)^\- $"
                      ))
          )
    (grammalecte-download-grammalecte)
    (flycheck-grammalecte-setup)
    )



;; #####################################################################################
(message "config • Le moteur …")


  (setq ispell-local-dictionary-alist- 
	'(("francais" "[[:alpha:]]" "[^[:alpha:]]" "[']" nil ("-d" "fr") nil utf-8)
	  ("en_US" "[[:alpha:]]" "[^[:alpha:]]" "[']" nil ("-d" "en_US") nil utf-8)
	  ))
  (setq ispell-program-name "hunspell"          ; Use hunspell to correct mistakes
	ispell-dictionary   "francais")
  


;; #####################################################################################
(message "config • Switch de dico (C-c d) …")


  (defun switch-dictionary-fr-en ()
    "Switch french and english dictionaries."
    (interactive)
    (let* ((dict ispell-current-dictionary)
	   (new (if (string= dict "francais") "en_US"
		     "francais")))
      (ispell-change-dictionary new)
      (message "Switched dictionary from %s to %s" dict new)))

  ;; (global-set-key (kbd "C-c d") 'switch-dictionary-fr-en)



;; #####################################################################################
(message "config • Indication des fautes + corriger le mot faux précédent le curseur …")

  
  (global-set-key (kbd "C-c f") 'flyspell-check-previous-highlighted-word)
  
  (add-hook 'text-mode-hook 'flyspell-mode)
  (add-hook 'prog-mode-hook 'flyspell-prog-mode)
  
  ;; Highlight BUG FIXME TODO NOTE keywords in the source code.
  (add-hook 'find-file-hook
	    (lambda()
	      (highlight-phrase "\\(BUG\\|FIXME\\|TODO\\|NOTE\\):")))
  


;; #####################################################################################
(message "config • Pdf …")


  (use-package pdf-tools
    :config
    ;; initialise
    (pdf-tools-install)
    ;; open pdfs scaled to fit page
    (setq-default pdf-view-display-size 'fit-page)
    ;; automatically annotate highlights
    (setq pdf-annot-activate-created-annotations t)
    ;; use normal isearch
    (define-key pdf-view-mode-map (kbd "C-s") 'isearch-forward)
    ;;mode nuit de base
    (add-hook 'pdf-tools-enabled-hook 'pdf-view-midnight-minor-mode)
    )


  (use-package magit
    :custom
    (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1)
    )



;; #####################################################################################
(message "config • Ripgrep …")


(use-package ripgrep);; pour projectile ripgrep, chercher dans un projet



;; #####################################################################################
(message "config • Google traduction …")


  (use-package go-translate
    :config
    (setq gts-translate-list '(("en" "fr")))
    )



;; #####################################################################################
(message "config • TODO Keypass :High: …")

(use-package keepass-mode)


;; #####################################################################################
(message "config • SSh …")

  ;; (setq tramp-default-method "ssh")


;; #####################################################################################
(message "config • Keycast (voir les commandes tapées)(keycast log buffer) …")

  (use-package keycast
    :config
    ;;pour rendre keycast compatible avec doom-modeline
    (define-minor-mode keycast-mode
      "Show current command and its key binding in the mode line (fix for use with doom-mode-line)."
      :global t
      (if keycast-mode
          (add-hook 'pre-command-hook 'keycast--update t)
        (remove-hook 'pre-command-hook 'keycast--update)))
    (add-to-list 'global-mode-string '("" mode-line-keycast))
    )

 
