(use-package xah-fly-keys	     
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




;;Suites des hook
(defvar my/xfk-auto-insert-mode-fns '()
  "List of functions to automatically call xah-fly-insert-mode-activate on.")
(setq my/xfk-auto-insert-mode-fns
      '(org-meta-return
	org-insert-heading-respect-content
	org-insert-link
	recentf-open-files
	org-capture

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
      '(dashboard-jump-to-recent-files
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

(use-package LayerXahFlyKey
  :after (xah-fly-keys)
  :straight '(LayerXahFlyKey :host github
			     :repo "Cletip/LayerXahFlyKey"
			     :branch "main"
			     :files ("*.el" "out")
			     )

  )


;;pour load mon pack sans le push à chaque fois, le met également à jour
;; (org-babel-load-file (expand-file-name "/home/msi/Documents/Code/LayerXahFlyKey/LayerXahFlyKey.org"))

;; (makunbound 'xah--dvorak-to-beopy-kmap)

(defvar xah--dvorak-to-beopy-kmap
'(("." . "o")
  ("," . "é")
  ("'" . "b")
  (";" . "à")
  ("/" . "k")
  ("[" . "=")
  ("]" . "%")
  ("=" . "z")
  ("-" . "m")
  ("b" . "'")
  ("c" . "d")
  ("d" . "c")
  ("f" . "^"); NOTE: this is a dead key
  ("g" . "v")
  ("h" . "t")
  ("i" . ",")
  ("j" . "x")
  ("k" . ".")
  ("l" . "j")
  ("m" . "g")
  ("n" . "r")
  ("o" . "u")
  ("q" . "w")
  ("r" . "l")
  ("s" . "n")
  ("t" . "s")
  ("u" . "i")
  ("v" . "q")
  ("w" . "h")
  ("x" . "è")
  ("z" . "f")
  ("1" . "\"")
  ("2" . "«")
  ("3" . "»")
  ("4" . "(")
  ("5" . ")")
  ("6" . "@")
  ("7" . "+")
  ("8" . "-")
  ("9" . "/")
  ("0" . "*")
  ("\\" . "ç")
  ("`" . "$")))

(winner-mode 1) ;;naviguer avec les fenêtres

(use-package which-key
  ;; :diminish which-key-mode
  :config
  (which-key-mode)
  (setq which-key-idle-delay 0.01)
  ;; pour sur le côté, mais si marche pas en bas
  (which-key-setup-side-window-right-bottom)

  )

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

(use-package move-text
  :defer 0.5
  :config
  (move-text-default-bindings))

(use-package ace-window
  :custom aw-keys '(?t ?i ?s ?e ?r ?u ?n ?a ?,) )

(use-package avy
      ;;\ pour l'espace
      :custom
      ;;personnalition des touches
      (avy-keys '(?a ?u ?e ?i ?t ?s ?r ?n ?\ ))
      (avy-background t)
      ;;nouvelle touches pour escape avy go timer
      (avy-escape-chars '(?\e ?\M-g))
      :config



      (setq avy-timeout-seconds 0.15)

;;pour jump dans l'agenda
  (defun avy--org-agenda-cands ()
  (let (candidates point)
    (save-excursion
      (save-restriction
	(narrow-to-region (window-start) (window-end (selected-window) t))
	(setq point (goto-char (point-min)))
	(while (setq point (text-property-not-all point (window-end) 'org-marker nil))
	  (push (cons point (selected-window)) candidates)
	  (setq point (text-property-any point (window-end) 'org-marker nil)))))
    (nreverse candidates)))

(defun avy-org-agenda ()
  "Goto a visible item in an `org-mode-agenda' buffer."
  (interactive)
  (avy-action-goto (avy-with avy-org-agenda
		     (avy-process (avy--org-agenda-cands)))))

      )




  ;;personnaliser chaque commande :
  ;; (setq avy-keys-alist
	;; `((avy-goto-char . ,(number-sequence ?a ?f))
	  ;; (avy-goto-word-1 . (?f ?g ?h ?j))))

;; (use-package async
;;   :init (dired-async-mode 1)
;;   :diminish)

;; choice of the backup directory
(defconst my-backup-dir
  (expand-file-name (concat user-emacs-directory "backups")))

(setq make-backup-files t               ; backup of a file the first time it is saved.
     backup-by-copying t               ; don't clobber symlinks
     version-control t                 ; version numbers for backup files
     delete-old-versions t             ; delete excess backup files silently
     delete-by-moving-to-trash t
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

;; if no backup directory exists, then create it:
(if (not (file-exists-p my-backup-dir))
    (mkdir my-backup-dir t))

(global-auto-revert-mode t)

(fset 'yes-or-no-p 'y-or-n-p)

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(delete-selection-mode t)

;; (save-place-mode 1)

;; (use-package saveplace
;; :init (save-place-mode))

(use-package no-littering
  ;; :after savehist 
  :config
  (setq auto-save-file-name-transforms
	`((".*" ,(no-littering-expand-var-file-name "auto-save/") t)))
  )




;; (require 'recentf)
(use-package recentf
  ;;:after org
  :config


  ;; pour que recentf marche normalement avec no littering		  

  (add-to-list 'recentf-exclude no-littering-var-directory)
  (add-to-list 'recentf-exclude no-littering-etc-directory)


  ;;pour éviter les fichier org-roam dans recentf, mais ne conservera jamais les fichiers .org…
  ;; (add-to-list 'recentf-exclude "\\.org\\'")

  ;; résolution avec ceci :

  ;; (setq org-roam-directory "/home/msi/Notes/Roam")




  ;; (add-to-list 'recentf-exclude (expand-file-name org-roam-directory))

  (add-to-list 'recentf-exclude (expand-file-name "/home/msi/Notes/Roam/"))



  ;; 	pareil, mais avec le server (écrit dans le fichier toutes les x secondes, ici 200)	;; (run-at-time (current-time) 200 'recentf-save-list)



  )

(use-package let-alist)
     (use-package tablist)
	   (use-package pdf-tools
     
;;	     :pin manual ;; manually update
	     
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

(use-package diminish)

(use-package general
  :config
  (general-evil-setup t)

  (general-create-definer dw/leader-key-def
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC") 

  (general-create-definer dw/ctrl-c-keys
    :prefix "C-c"))

;;police de base    
    (set-face-attribute 'default nil
			     :font "Fira Mono"
			     :weight 'light
			     ;; :height 110
			     )



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
    (add-hook 'lsp-mode-hook 'Policepourcoder)

(setq-default fill-column 80)

(add-hook 'text-mode-hook 'visual-line-mode)
(add-hook 'org-mode-hook 'visual-line-mode)

(defun my/prog-auto-fill-mode ()
  "Turn on auto-fill only for comments."
  (setq-local comment-auto-fill-only-comments t)
  (auto-fill-mode 1))
(add-hook 'prog-mode-hook 'my/prog-auto-fill-mode)

(use-package beacon
:diminish
:config
(setq beacon-blink-delay 0.1)
(setq beacon-blink-duration 0.6)
(setq beacon-size 40)
(setq beacon-color "#ffa38f")
  (beacon-mode 1)
)

(global-hl-line-mode t)
(set-face-background hl-line-face "#311")

;; Thanks, but no thanks
(setq inhibit-startup-message t)


  (scroll-bar-mode -1)        ; Disable visible scrollbar
  
  (tooltip-mode -1)           ; Disable tooltips
  (set-fringe-mode 10)      ; Give some breathing room

(menu-bar-mode -1)            ; Disable the menu bar

;; Set up the visible bell
(setq visible-bell t)

(use-package dashboard
  :config
  ;;centrer (marche pas?)
  (setq dashboard-center-content t)
  ;;item
  (setq dashboard-items '((recents  . 10)			    
			  (agenda . 5)
			  (bookmarks . 5)
			  (projects . 5)
			  (registers . 5)
			  )
	)
  ;;agenda de la semaine 
  (setq dashboard-week-agenda t)
  ;;emacsclient avec dashboard
  (setq initial-buffer-choice (lambda () (get-buffer "*dashboard*")))
  (dashboard-setup-startup-hook)
  )

(use-package spacemacs-theme
		     :no-require t
		     :init
		     ;; (load-theme 'spacemacs-dark t)
		     )

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
	       (load-theme 'doom-moonlight t)
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
	      )


(use-package org-beautify-theme
  :if (display-graphic-p)
  :config
  (load-theme 'org-beautify t)
  (set-face-attribute 'org-document-title nil :height 1.5)
  (set-face-font 'org-level-1 "Sans Serif")
  (set-face-font 'org-level-2 "Sans Serif"))

(setq transparency_level 0)
(defun my:change_transparency ()
  "Toggles transparency of Emacs between 3 settings (none, mild, moderate)."
  (interactive)
  (if (equal transparency_level 0)
      (progn (set-frame-parameter (selected-frame) 'alpha '(75 . 85))
	 (setq transparency_level 1))
    (if (equal transparency_level 1)
    (progn (set-frame-parameter (selected-frame) 'alpha '(60 . 85))
	   (setq transparency_level 2))
      (if (equal transparency_level 2)
      (progn (set-frame-parameter (selected-frame) 'alpha '(100 . 85))
	 (setq transparency_level 0)))
      )))
(define-key global-map (kbd "C-c t") 'my:change_transparency)



(defun toggle-transparency ()
(interactive)
(let ((alpha (frame-parameter nil 'alpha)))
  (if (eq
   (if (numberp alpha)
       alpha
     (cdr alpha)) ; may also be nil
   100)
  (set-frame-parameter nil 'alpha '(60 . 50))
    (set-frame-parameter nil 'alpha '(100 . 100)))))

(toggle-transparency)

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

(defun ask-name-and-age (x y)
  "Ask name and age"
  (interactive "sEnter you name:
nEnter your age: ")
  (message "Name is: %s, Age is: %d" x y))
  
      (defun toggle-mode-line ()
	(interactive)
	(if (eval 'mode-line-format)
  (setq mode-line-format t)
  (message "Salut")
	  )
	(setq mode-line-format nil)
	(message "Test")
	)
  
  
	;; (setq mode-line-format t)

(use-package dimmer
  :custom
  (dimmer-fraction 0.3)
  (dimmer-exclusion-regexp-list
   '(".*Minibuf.*"
     ".*which-key.*"
     ".*LV.*"))
  :config
  (dimmer-mode 1))

;; Provides only the command “restart-emacs”.
(use-package restart-emacs
  ;; If I ever close Emacs, it's likely because I want to restart it.
  ;; :bind ("C-x C-c" . restart-emacs)
  ;; Let's define an alias so there's no need to remember the order.
  :config (defalias 'emacs-restart #'restart-emacs))

;; auto refresh dired when file changes
(add-hook 'dired-mode-hook 'auto-revert-mode)

  
  (setq dired-auto-revert-buffer t) ;; Refreshes the dired buffer upon revisiting
  (setq dired-dwim-target t) ;; If two dired buffers are open, save in the other when trying to copy
  (setq dired-hide-details-hide-symlink-targets nil) ;; Don't hide symlink targets
  (setq dired-listing-switches "-alh") ;; Have dired view all folders, in lengty format, with data amounts in human readable format
  (setq dired-ls-F-marks-symlinks nil) ;; Informs dired about how 'ls -lF' marks symbolic links, see help page for more details
  (setq dired-recursive-copies 'always) ;; Always copy recursively without asking
  (setq dired-recursive-deletes 'always) ; demande plus pour supprimer récursivement
  (setq dired-dwim-target t) ; qd t-on copie,

(use-package dired-quick-sort
  :config
  (dired-quick-sort-setup))

(use-package dired-rainbow
  :defer 2
  :config
  (dired-rainbow-define-chmod directory "#6cb2eb" "d.*")
  (dired-rainbow-define html "#eb5286" ("css" "less" "sass" "scss" "htm" "html" "jhtm" "mht" "eml" "mustache" "xhtml"))
  (dired-rainbow-define xml "#f2d024" ("xml" "xsd" "xsl" "xslt" "wsdl" "bib" "json" "msg" "pgn" "rss" "yaml" "yml" "rdata"))
  (dired-rainbow-define document "#9561e2" ("docm" "doc" "docx" "odb" "odt" "pdb" "pdf" "ps" "rtf" "djvu" "epub" "odp" "ppt" "pptx"))
  (dired-rainbow-define markdown "#ffed4a" ("org" "etx" "info" "markdown" "md" "mkd" "nfo" "pod" "rst" "tex" "textfile" "txt"))
  (dired-rainbow-define database "#6574cd" ("xlsx" "xls" "csv" "accdb" "db" "mdb" "sqlite" "nc"))
  (dired-rainbow-define media "#de751f" ("mp3" "mp4" "mkv" "MP3" "MP4" "avi" "mpeg" "mpg" "flv" "ogg" "mov" "mid" "midi" "wav" "aiff" "flac"))
  (dired-rainbow-define image "#f66d9b" ("tiff" "tif" "cdr" "gif" "ico" "jpeg" "jpg" "png" "psd" "eps" "svg"))
  (dired-rainbow-define log "#c17d11" ("log"))
  (dired-rainbow-define shell "#f6993f" ("awk" "bash" "bat" "sed" "sh" "zsh" "vim"))
  (dired-rainbow-define interpreted "#38c172" ("py" "ipynb" "rb" "pl" "t" "msql" "mysql" "pgsql" "sql" "r" "clj" "cljs" "scala" "js"))
  (dired-rainbow-define compiled "#4dc0b5" ("asm" "cl" "lisp" "el" "c" "h" "c++" "h++" "hpp" "hxx" "m" "cc" "cs" "cp" "cpp" "go" "f" "for" "ftn" "f90" "f95" "f03" "f08" "s" "rs" "hi" "hs" "pyc" ".java"))
  (dired-rainbow-define executable "#8cc4ff" ("exe" "msi"))
  (dired-rainbow-define compressed "#51d88a" ("7z" "zip" "bz2" "tgz" "txz" "gz" "xz" "z" "Z" "jar" "war" "ear" "rar" "sar" "xpi" "apk" "xz" "tar"))
  (dired-rainbow-define packaged "#faad63" ("deb" "rpm" "apk" "jad" "jar" "cab" "pak" "pk3" "vdf" "vpk" "bsp"))
  (dired-rainbow-define encrypted "#ffed4a" ("gpg" "pgp" "asc" "bfe" "enc" "signature" "sig" "p12" "pem"))
  (dired-rainbow-define fonts "#6cb2eb" ("afm" "fon" "fnt" "pfb" "pfm" "ttf" "otf"))
  (dired-rainbow-define partition "#e3342f" ("dmg" "iso" "bin" "nrg" "qcow" "toast" "vcd" "vmdk" "bak"))
  (dired-rainbow-define vc "#0074d9" ("git" "gitignore" "gitattributes" "gitmodules"))
  (dired-rainbow-define-chmod executable-unix "#38c172" "-.*x.*"))

(use-package dired-collapse
  :defer t)

  (add-hook 'dired-load-hook
          (lambda ()
            (interactive)
            (dired-collapse)))

(use-package all-the-icons-dired)

(setq dired-omit-files
      (rx (or (seq bol (? ".") "#")
	      (seq bol "." eol)
	      ;; (seq bol ".." eol)
	      )))

(add-hook 'dired-mode-hook
	  (lambda ()
	    (interactive)
	    (dired-omit-mode 1)
	    (all-the-icons-dired-mode 1)
	    (dired-sort-toggle-or-edit)
	    (dired-hide-details-mode)
	    (hl-line-mode 1)
	    ))

(use-package term
:config
(setq explicit-shell-file-name "bash") ;; Change this to zsh, etc
;;(setq explicit-zsh-args '())         ;; Use 'explicit-<shell>-args for shell-specific args

;; Match the default Bash shell prompt.  Update this if you have a custom prompt
(setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *"))

(use-package eterm-256color
:hook (term-mode . eterm-256color-mode))

(use-package keyfreq
  :config
  (keyfreq-mode 1)
  (keyfreq-autosave-mode 1))

(use-package vertico
     :bind (:map vertico-map
		 ("C-j" . vertico-next)
		 ("C-k" . vertico-previous)
		 ("C-f" . vertico-exit)
		 :map minibuffer-local-map
		 ("M-h" . dw/minibuffer-backward-kill))
     :custom
     (vertico-cycle t)
     :custom-face
     (vertico-current ((t (:background "#3a3f5a"))))
     :init
     (vertico-mode))



   (defun dw/get-project-root ()
     (when (fboundp 'projectile-project-root)
       (projectile-project-root)))

   (use-package consult
     :bind (("C-s" . consult-line)
	    ("C-M-l" . consult-imenu)
	    ("C-M-j" . persp-switch-to-buffer*)
	    :map minibuffer-local-map
	    ("C-r" . consult-history))
     :custom
     (consult-project-root-function #'dw/get-project-root)
     (completion-in-region-function #'consult-completion-in-region)
     )

   ;; Complétation par candidats      
   ;; Use the `orderless' completion style.
   ;; Enable `partial-completion' for files to allow path expansion.
   ;; You may prefer to use `initials' instead of `partial-completion'.
   (use-package orderless
     :init
     (setq completion-styles '(orderless)
	   completion-category-defaults nil
	   completion-category-overrides '((file (styles partial-completion)))))


   ;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
:init
(setq savehist-file "~/.emacs.d/var/savehist.el")
:config
(setq history-length 25)
(setq savehist-additional-variables '(kill-ring search-ring))
(savehist-mode t))  


   ;; A few more useful configurations...
   (use-package emacs
     :init
     ;; Add prompt indicator to `completing-read-multiple'.
     ;; Alternatively try `consult-completing-read-multiple'.
     (defun crm-indicator (args)
       (cons (concat "[CRM] " (car args)) (cdr args)))
     (advice-add #'completing-read-multiple :filter-args #'crm-indicator)

     ;; Do not allow the cursor in the minibuffer prompt
     (setq minibuffer-prompt-properties
	   '(read-only t cursor-intangible t face minibuffer-prompt))
     (add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

     ;; Enable recursive minibuffers
     (setq enable-recursive-minibuffers t))

;; info sur le côté du mini buffer
(use-package marginalia
  :after vertico
  :custom
  (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil))
  :init
  (marginalia-mode))

;; (add-to-list 'load-path "~/Téléchargements/md-roam/") ;Modify with your own path

;; (require 'md-roam) ;this must be before org-roam

;; (setq md-roam-file-extension-single "md")
  ;set your markdown extension
  ;you can omit this if md, which is the default.
;; (setq org-roam-title-sources '((mdtitle title mdheadline headline) (mdalias alias)))
  ;you need this as of commit `5f24103`.

;; (setq org-roam-file-extensions '("org" "md"))

;; (setq org-roam-title-sources '((mdtitle title mdheadline headline) (mdalias alias)))

(use-package org-bullets
  :after org
  :config
  (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))

(setq org-ellipsis "⬎")
;; pour changer la couleur : M-x customize group RET org-faces puis C-s ellipsis

(setq org-hide-emphasis-markers t)                            
(setq org-emphasis-alist   
      (quote (
	      ("*" bold)
	      ("/" (:foreground "red" :background "black"))
	      ("_" underline)
	      ("=" (:foreground "yellow" :background "black"))
	      ("~" org-verbatim verbatim)
	      ("+"
	       (:strike-through t))
	      )))

;;pour que pretty-icon fonctionne, à appeler en même temps que l'autre fonction


      (defun org-icons ()
       "Beautify org mode keywords."
       (interactive)
       (setq prettify-symbols-alist '(
				      ;; ("TODO" . "")
				      ;; ("PEUT-ÊTRE" . "")
				      ;; ("EN-COURS" . "")
				      ;; ("ANNULÉ" . "")
				      ;; ("DONE" . "")
				      ;; ("[#A]" . "")
				      ;; ("[#B]" . "")
				      ;; ("[#C]" . "")
				      ("-" . "➤")
				      ;; ("[ ]" . "")
				      ;; ("[X]" . "")
				      ;; ("[-]" . "")
				      ("#+begin_src" . ?)
				      ("#+BEGIN_SRC" . ?)
				      ("#+end_src" . ?)
				      ("#+END_SRC" . ?)
				      ;; (":PROPERTIES:" . "")
				      ;; (":END:" . "―")
				      ("#+STARTUP:" . "")
				      ;; ("#+TITLE: " . "")
				      ("#+RESULTS:" . "")
				      ("#+NAME:" . "")
				      (":ROAM_ALIASES:" . "")
				      ("#+FILETAGS:" . "")
				      ;; ("#+HTML_HEAD:" . "")
				      ("#+SUBTITLE:" . "")
				      ("#+AUTHOR:" . "")
				      (":Effort:" . "")
				      ("SCHEDULED:" . "")
				      ("DEADLINE:" . "")
				      ))
       (prettify-symbols-mode)
       ;; (magic-icon-fix)
       )  



(add-hook 'org-mode-hook 'org-icons)



(defun magic-icon-fix ()
    (interactive)
      (let ((fontset (face-attribute 'default :fontset)))
	    (set-fontset-font fontset '(?\xf000 . ?\xf2ff) "FontAwesome" nil 'append)))

(defun org-icons+todoicons ()
       "Beautify org mode keywords."
       (interactive)
       (setq prettify-symbols-alist '(
				      ("TODO" . "")
				      ("PEUT-ÊTRE" . "")
				      ("EN-COURS" . "")
				      ("ANNULÉ" . "")
				      ("DONE" . "")
				      ("[#A]" . "")
				      ("[#B]" . "")
				      ("[#C]" . "")
				      ("-" . "➤")
				      ("[ ]" . "")
				      ("[X]" . "")
				      ("[-]" . "")
				      ("#+begin_src" . ?)
				      ("#+BEGIN_SRC" . ?)
				      ("#+end_src" . ?)
				      ("#+END_SRC" . ?)
				      (":PROPERTIES:" . "")
				      (":END:" . "―")
				      ("#+STARTUP:" . "")
				      ("#+TITLE: " . "")
				      ("#+RESULTS:" . "")
				      ("#+NAME:" . "")
				      (":ROAM_ALIASES:" . "")
				      ("#+FILETAGS:" . "")
				      ("#+HTML_HEAD:" . "")
				      ("#+SUBTITLE:" . "")
				      ("#+AUTHOR:" . "")
				      (":Effort:" . "")
				      ("SCHEDULED:" . "")
				      ("DEADLINE:" . "")
				      ))
       (prettify-symbols-mode)
       (magic-icon-fix)
       )

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

(setq org-startup-with-inline-images t)
(setq org-image-actual-width 800)

(use-package org-fragtog
  :hook (org-mode . org-fragtog-mode)
  )

(straight-use-package '(org-appear :type git :host github :repo "awth13/org-appear"))

(add-hook 'org-mode-hook 'org-appear-mode)

;;affiche les liens entier avec t
;; (setq org-appear-autolinks t)

(use-package ox-twbs
 )

(use-package htmlize)

(use-package ox-epub)

(with-eval-after-load 'ox-latex
(add-to-list 'org-latex-classes
	     '("org-plain-latex"
	       "\\documentclass{article}
           [NO-DEFAULT-PACKAGES]
           [PACKAGES]
           [EXTRA]"
	       ("\\section{%s}" . "\\section*{%s}")
	       ("\\subsection{%s}" . "\\subsection*{%s}")
	       ("\\subsubsection{%s}" . "\\subsubsection*{%s}")
	       ("\\paragraph{%s}" . "\\paragraph*{%s}")
	       ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))))

;;(setq org-export-with-section-numbers nil)
(setq org-export-headline-levels 3)
(setq org-export-with-author nil)

(require 'org)
;; (define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)

(use-package org-sidebar
  :bind
  ("C-x x" . org-sidebar-tree-toggle)
  )

(require 'org-tempo)

(add-to-list 'org-structure-template-alist '("sh" . "src sh"))
(add-to-list 'org-structure-template-alist '("sql" . "src sql"))
(add-to-list 'org-structure-template-alist '("cd" . "src C"))
      (add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("sc" . "src scheme"))
(add-to-list 'org-structure-template-alist '("ts" . "src typescript"))
(add-to-list 'org-structure-template-alist '("py" . "src python"))
(add-to-list 'org-structure-template-alist '("yaml" . "src yaml"))
(add-to-list 'org-structure-template-alist '("json" . "src json"))

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

(use-package org-download
  :config
;;lieu où sont stocké les images
(setq-default org-download-image-dir "/home/msi/Notes/Roam/images/")

;; le nom du dossier est le nom du premier heading (pour donner au nom du dossier "Principales oeuvre de blabla")
  (setq-default org-download-heading-lvl 0)
;;obligatoire
  (add-hook 'dired-mode-hook 'org-download-enable)
  (add-hook #'org-download-yank #'org-download-rename-last-file)
  )

(defun my-org-latex-yas ()
  (yas-minor-mode)
  (yas-activate-extra-mode 'latex-mode))


(add-hook 'org-mode-hook #'my-org-latex-yas)

(eval-after-load 'org
  (add-hook 'org-babel-after-execute-hook 'org-redisplay-inline-images))

;; (use-package graphviz-dot-mode
;;    
;;   :config
;;   (setq graphviz-dot-indent-width 4))

;; (setq org-enforce-todo-dependencies t)
;; (setq org-enforce-todo-checkbox-dependencies t)

(setq org-confirm-babel-evaluate nil)

(setq org-confirm-babel-evaluate nil)

(setq org-src-tab-acts-natively t)

(setq org-src-fontify-natively t)

;; (global-set-key (kbd "<f12>") nil)

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
   )
 )

;;enterpreter of python
(setq org-babel-python-command "python3")

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

(defun my-org-after-todo-state-change ()
  (when (string-equal org-state "DONE")
    (org-clock-out-if-current)
    (emms-add-file "/home/msi/.emacs.d/sound/done.mp3")
    (emms-start)
    ;; (emms-play-file "/home/msi/.emacs.d/sound/done.mp3")
    )
  )

(add-hook 'org-after-todo-state-change-hook 'my-org-after-todo-state-change)

;;pour termux !!!
;; (setq org-directory
;; (if dw/is-termux
;;     "~/storage/shared/Notes"
;;     "~/Notes"))


(use-package org
  :custom
  ;; vue agenda, demande confirmation pour supprimer
  (org-agenda-confirm-kill 0)
  :config  


  ;; recursively find .org (or .txt, .exemple etc) files in provided directory
  ;; modified from an Emacs Lisp Intro example
  ;; ceci pour mettre 
  (defun sa-find-org-file-recursively (&optional directory filext)
    "Return .org and .org_archive files recursively from DIRECTORY.
If FILEXT is provided, return files with extension FILEXT instead."
    (interactive "DDirectory: ")
    (let* (org-file-list
	   (case-fold-search t)         ; filesystems are case sensitive
	   (file-name-regex "^[^.#].*") ; exclude dot, autosave, and backupfiles
	   (filext (or filext "org$\\\|org_archive"))
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


  ;; ceci renvoie une chaine de texte
  ;; (setq org-agenda-text-search-extra-files
  ;; (append (sa-find-org-file-recursively "~/org/dir1/" "txt")
  ;; (sa-find-org-file-recursively "~/org/dir2/" "tex")))

  (setq org-agenda-files
	(append (sa-find-org-file-recursively "/home/msi/Notes/Roam/" "org")
		(sa-find-org-file-recursively "/home/msi/Dossier_partage_nous_deux/Orgzly/" "org")))






  ;;pour start avec le mode follow dans org agenda  
  ;; (setq org-agenda-start-with-follow-mode t)

  (define-key org-agenda-mode-map [remap next-line] #'org-agenda-next-item)
  (define-key org-agenda-mode-map [remap previous-line] #'org-agenda-previous-item)
  (define-key org-agenda-mode-map [remap ?\r] #'org-agenda-goto)

  )

(use-package org-contrib
  :after org  
  :config
  (require 'org-contacts)
  (setq org-contacts-files '("/home/msi/Notes/Roam/GTD/7Contact.org"))
  )

(eval-after-load 'org
  (setq system-time-locale "C")
  )

(setq org-icalendar-combined-agenda-file "/home/msi/Notes/Roam/GTD/0org.ics")

;;fonction export en background + message pour vérif que ça marche
(defun org-icalendar-combine-agenda-files-background()
  (interactive)
  (message "Lancement du icalendar combine file (pour 0org.ics)")
  (org-icalendar-combine-agenda-files t)

  )


(defun org-icalendar-combine-agenda-files-forground()
  (interactive)
  (org-icalendar-combine-agenda-files nil)
  (message "fini")
  )


;;au démarrage
(add-hook 'dashboard-mode-hook #'org-icalendar-combine-agenda-files-background)

;;au démarrage

;; (add-hook 'emacs-startup-hook #'org-icalendar-combine-agenda-files-background)








;;lorsque l'on lance org agenda 
;; (add-hook 'org-agenda-mode-hook #'org-icalendar-combine-agenda-files-background)

;;quand on ferme emacs  
;; (add-hook #'kill-emacs-hook #'org-icalendar-combine-agenda-files)

(add-hook #'save-buffers-kill-terminal #'tool-bar-mode)

;;inclut seulement les todo, mais aussi les donne. Sans heure
;; (setq org-icalendar-include-todo t)


;;exporter avec les statse
(setq org-icalendar-categories '(all-tags category todo-state))

;; (setq org-icalendar-use-deadline '(event-if-not-todo todo-due))


;;export les schedulde seulement si elles sont pas en done ! N'exporte pas les titres sans le TODO NEXT etc
(setq org-icalendar-use-scheduled '(event-if-todo-not-done))

;; (setq org-icalendar-with-timestamps 'active)

;; (setq org-icalendar-alarm-time 30)

(defgroup ya-org-capture nil
  "Options specific to ya-org-capture."
  :tag "ya-org-capture"
  :group 'ya-org-capture)

(defcustom ya-org-capture/ya-prefix "YA-ORG-CAPTURE-PREFIX-- "
  "Prefix used to tag."
  :group 'ya-org-capture
  :type 'string)

(defcustom ya-org-capture/expand-snippet-functions (list 'yankpad-expand 'yas-expand)
  "Functions used to expand the snippet at point. Order is
  important: if the functions are able to expand a snippet with
  the same key, the first function of the list takes precedence
  over the second."
  :group 'ya-org-capture
  :type 'list)

(defun ya-org-capture/or-else (&rest fs)
  "Compose partial functions FS until one of them produces a result or there are no more FS available."
  `(lambda (i)
     (reduce
      (lambda (acc f) (or acc (when (fboundp f) (funcall f i))))
      ',fs
      :initial-value nil)))

(defun ya-org-capture/org-capture-fill-template ()
  "Post-process `org-mode' snippet to expand `org-capture' syntax. This only works for YASnippet."
  (let ((template (buffer-substring-no-properties yas-snippet-beg yas-snippet-end))
	(front-text (buffer-substring-no-properties (point-min) yas-snippet-beg))
	(back-text (buffer-substring-no-properties yas-snippet-end (point-max)))
	(ya-org-capture--temp-buffer (get-buffer-create "ya-org-capture-temp")))
    (with-current-buffer ya-org-capture--temp-buffer
      (insert front-text
	      (org-capture-fill-template template)
	      back-text))
    (replace-buffer-contents ya-org-capture--temp-buffer)
    (kill-buffer ya-org-capture--temp-buffer)))

(defun ya-org-capture/snippet-expand ()
  "Try to expand snippet at point with `yankdpad-expand' and then with `yas-expand'."
  (interactive)
  (funcall (apply 'ya-org-capture/or-else ya-org-capture/expand-snippet-functions) nil))

(defun ya-org-capture/support-org-syntax-for-yasnippets ()
  "Allow `org-capture' to expand its syntax for YASnippets."
  (add-hook 'yas-after-exit-snippet-hook 'ya-org-capture/org-capture-fill-template nil t))

(defun ya-org-capture/expand-snippets ()
  "Expand `ya-org-capture/ya-prefix'."
  (when (search-forward ya-org-capture/ya-prefix nil t)
    (replace-match "")
    (ya-org-capture/support-org-syntax-for-yasnippets)
    (end-of-line)
    (ya-org-capture/snippet-expand)))

;;;###autoload
(defun ya-org-capture/make-snippet (snippet-name &optional yp-category)
  "Concatenate prefix to SNIPPET-NAME for substitution in `org-capture' flow.
Optionally set `yankpad-category' to YP-CATEGORY."
  (if yp-category (yankpad-set-local-category yp-category))
  (concatenate 'string ya-org-capture/ya-prefix snippet-name "\n"))

(defun ya-org-capture/setup ()
  "Setup integration between org-capture and yasnippet/yankpad."
  (interactive)
  (add-hook 'org-capture-mode-hook 'ya-org-capture/expand-snippets))


(defun ya-org-capture/teardown ()
  "Teardown integration between org-capture and yasnippet/yankpad."
  (interactive)
  (remove-hook 'org-capture-mode-hook 'ya-org-capture/expand-snippets))


(use-package yankpad)



(ya-org-capture/setup)

(setq org-capture-templates '
      (  

       ("i" "Todo [inbox]" entry
        (file "/home/msi/Notes/Roam/GTD/1Inbox.org")
        "* TODO %(ya-org-capture/make-snippet \"toaf\")\n")


       ("t" "Agenda sur google")

       ("ts" "Évènement sur plusieurs heures" entry (file "/home/msi/Notes/Roam/GTD/2Agendatickler.org") "* TODO %(ya-org-capture/make-snippet \"tfoaf\"\n )" :empty-lines 2)

       ("ti" "Évenement plusieurs jours " entry
        (file "/home/msi/Notes/Roam/GTD/2Agendatickler.org")
        "* TODO %(ya-org-capture/make-snippet \"tsdoaf\")\n")


       ("te" "Tickler " entry
        (file "/home/msi/Notes/Roam/GTD/2Agendatickler.org")
        "* %(ya-org-capture/make-snippet \"twehoaf\")\n")

       ("tr" "Jour entier" entry (file "/home/msi/Notes/Roam/GTD/2Agendatickler.org") "* TODO %(ya-org-capture/make-snippet \"tdoaf\"\n )" :empty-lines 2)


       ("tt" "Edt / Todo avec temps refile" entry
        (file "/home/msi/Notes/Roam/GTD/2Agendatickler.org")
        "* TODO %(ya-org-capture/make-snippet \"twehoar\")\n")




       ("r" "Todo (refile)" entry
        (file "/home/msi/Notes/Roam/GTD/1Inbox.org")
        "* TODO %(ya-org-capture/make-snippet \"oafr\")\n")


       ("f" "Film org roam" entry
        (file "/home/msi/Notes/Roam/GTD/films_vus.org")
        (file "/home/msi/Notes/TemplatesOrgCapture/film_roam.org"))

       ("l" "Livre org roam" entry
        (file "/home/msi/Notes/Roam/GTD/livres_lus.org")
        (file "/home/msi/Notes/TemplatesOrgCapture/livre_roam.org"))


       ("C" "Contact" entry
        (file+headline "/home/msi/Notes/Roam/GTD/7Contact.org" "1Inbox")
        (file "/home/msi/Notes/TemplatesOrgCapture/contact.org")
        :immediate-finish t
        ;; :jump-to-captured t
        )

       ;; ("i" "Inbox/journal")

       ("a" "Image dans Artiste")

       ("at" "Image + artiste" entry (file  "/home/msi/Dossier_partage_nous_deux/Orgzly/8Artistes.org" )
        (file "/home/msi/Notes/TemplatesOrgCapture/artistes.org")
        :jump-to-captured 1
        )

       ("as" "Image" entry (file  "/home/msi/Dossier_partage_nous_deux/Orgzly/8Artistes.org" )
        (file "/home/msi/Notes/TemplatesOrgCapture/image.org")
        :jump-to-captured 1
        )



       ("d" "Journal de dissactifaction" entry (file  "/home/msi/Notes/Roam/journal_de_dissatisfaction.org" )
        "* %<%Y-%m-%d> \n- %?")

       ("L" "Web site" entry
        (file "/home/msi/notes.org")
        "* %a :website:\n\n%U %?\n\n%:initial")

       ("z" "Link" entry (file+olp "/path/to/notes.org" "Web Links")
        "* %a\n %?\n %i")


       ;;         ("c" "Contacts" entry (file "~/Org/contacts.org")
       ;;          "* %(org-contacts-template-name)
       ;; :PROPERTIES:
       ;; :EMAIL: %(org-contacts-template-email)
       ;; :END:")


       ("o" "[Ne pas utiliser]Pour stocker mes raccourcis" entry
        (file+headline "/home/msi/Notes/Roam/GTD/3Bookmarks.org" "1INBOX")
        "* %a %U"
        :immediate-finish t)


       ("E" "Microsoft Exchange diary entry" entry (file "/home/msi/Notes/TemplatesOrgCapture/test.org")
        (function my-visit-timestamped-file) "<test")


       ("A" "test" entry (file  "/home/msi/Notes/Roam/GTD/films_vus.org" )
        (file "/home/msi/Notes/TemplatesOrgCapture/test.org")
        )




       )

      )



;; pour rajouter un ID à la fin de la capture !
(defun cp-org-capture-finalize ()
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
    )
  )
  ;; (add-hook 'org-capture-after-finalize-hook 'cp-test-finalize)

;; pour supprimer un fichier de l'agenda

(org-remove-file "/home/msi/Notes/Roam/GTD/6Archives.org")

(setq
 org-refile-targets
 '(
  ;;refile dans le buffer courant jusqu'au niveau 9
   (nil :maxlevel . 9)
   ;;refile dans tous les fichiers de l'agenda
   (org-agenda-files :maxlevel . 5)

   ;;pour refile dans references commun
   ("/home/msi/Dossier_partage_nous_deux/Orgzly/1Referencescommun.org" :maxlevel . 5)

   ;; (org-roam-directory :maxlevel . 5)

("/home/msi/Notes/Roam/GTD/6Archives.org" :maxlevel . 5)

   ))







;;pour voir le chemin lors du refile
(setq org-outline-path-complete-in-steps nil)
					; permet de déplacer avec un niveau de titre 1 ! (dans tickler par exemple)
(setq org-refile-use-outline-path (quote file))

;; (setq org-agenda-custom-commands 
;;       '(("o" "At the office" tags-todo "@office"
;; 	 ((org-agenda-overriding-header "Office")))))

;; pour que le curseur soit sur l'agenda quand t on l'ouvre
    ;; (add-hook 'org-agenda-finalize-hook #'org-agenda-find-same-or-today-or-agenda 90)

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

    ;;?
    (setq org-agenda-start-with-log-mode t)

    ;; Make done tasks show up in the agenda log
    (setq org-log-done 'time)
    (setq org-log-into-drawer t)

    ;;pour la fonction org columns agenda. Utilité ?
    ;; (setq org-columns-default-format "%20CATEGORY(Category) %65ITEM(Task) %TODO %6Effort(Estim){:}  %6CLOCKSUM(Clock) %TAGS")



    (setq org-agenda-custom-commands 
	  '(
	    ("d" "Dashboard"
	     (

	      (todo "RAPPEL" ((org-agenda-overriding-header "Se souvenir")))

	      (tags-todo "+PRIORITY=\"A\""
			 ((org-agenda-overriding-header "High Priority")))
	      ;; (search "#A"
			 ;; ((org-agenda-overriding-header "Test de haut")))
	      (tags-todo "+followup" ((org-agenda-overriding-header "Needs Follow Up")))
	      (tags-todo "+batch" ((org-agenda-overriding-header "À ranger")))

	      (todo "NEXT"
		    ((org-agenda-overriding-header "Next Actions")
		     (org-agenda-max-todos nil)))
	      (todo "TODO"
		    ((org-agenda-overriding-header "Unprocessed Inbox Tasks (Tout ce qui est dans 1Inbox)")
		     (org-agenda-files '("/home/msi/Notes/Roam/GTD/1Inbox.org")))
		    (org-agenda-text-search-extra-files nil))
	      (agenda "" ((org-deadline-warning-days 7)))
	      (todo "WAIT"
		    ((org-agenda-overriding-header "Wait")
		     (org-agenda-max-todos nil)))
	      )


	     )

	    ("n" "Next Tasks"
	     (
	      (todo "NEXT"  
		    ((org-agenda-overriding-header "Next Tasks")))))


	    ("e" tags-todo "+TODO=\"NEXT\"+Effort<15&+Effort>0"
	     ((org-agenda-overriding-header "Low Effort Tasks")
	      (org-agenda-max-todos 20)
	      (org-agenda-files org-agenda-files)))


;; (("ii" "[i]nbox tagged unscheduled tasks" tags "+inbox-SCHEDULED={.+}/!+TODO|+STARTED|+WAITING"))


	    ("o" "At the office" tags-todo "@office"
	     ((org-agenda-overriding-header "Office")
	      (org-agenda-skip-function #'my-org-agenda-skip-all-siblings-but-first)))

	    ("p" "Avec pc" tags-todo "@pc"
	     ((org-agenda-overriding-header "Pc")
	      (org-agenda-skip-function #'my-org-agenda-skip-all-siblings-but-first)))

	    ("w" "Pour le boulot" tags-todo "@work"
	     ((org-agenda-overriding-header "Work")
	      (org-agenda-skip-function #'my-org-agenda-skip-all-siblings-but-first)))

	    ("n" "PourNell" tags-todo "@Nell"
	     ((org-agenda-overriding-header "Nell")
	      (org-agenda-skip-function #'my-org-agenda-skip-all-siblings-but-first)))

	    ("h" "À la maison" tags-todo "@home"
	     ((org-agenda-overriding-header "Home")
	      (org-agenda-skip-function #'my-org-agenda-skip-all-siblings-but-first)))

	    )
	  )




    ;; pour appeler directement dashboard

    (defun org-agenda-show-dashboard (&optional arg)
    (interactive "P")
    (setq org-agenda-todo-ignore-scheduled t) ;;pour ne pas afficher les tâche schedulded
    (org-agenda arg "d")
    )


  (global-set-key (kbd "<f12>") 'org-agenda-show-dashboard)


    (defun my-org-agenda-skip-all-siblings-but-first ()
      "Skip all but the first non-done entry."
      (let (should-skip-entry)
	(unless (org-current-is-todo)
	  (setq should-skip-entry t))
	(save-excursion
	  (while (and (not should-skip-entry) (org-goto-sibling t))
	    (when (org-current-is-todo)
	      (setq should-skip-entry t))))
	(when should-skip-entry
	  (or (outline-next-heading)
	      (goto-char (point-max))))))

    (defun org-current-is-todo ()
      (string= "TODO" (org-get-todo-state)))

(setq org-tag-alist '((:startgroup . nil)

   ; Put mutually exclusive tags here

		      (:endgroup . nil)

		      ("@work" . ?w)
		      ("@home" . ?h)
		      ("@pc" . ?p)
		      ("@tel" . ?t)
		      ("Nell" . ?n)
		      ("batch" . ?b)
		      ("followup" . ?f)

		      )

      )

(setq org-log-done t)

(setq org-archive-location "/home/msi/Notes/Roam/GTD/6Archives.org::* Archives Autres")

(setq org-todo-keywords
	'(
	  (sequence "TODO(t)" "NEXT(n)" "RAPPEL(r)""|" "DONE(d)")
	  (sequence "|" "WAIT(w)" "CANCELLED(c)")
	  )
	)



  ;; TODO: org-todo-keyword-faces
(setq org-todo-keyword-faces
  '(("NEXT" . (:foreground "orange red" :weight bold))
    ("WAIT" . (:foreground "HotPink2" :weight bold))
    ("BACK" . (:foreground "MediumPurple3" :weight bold))
    ("RAPPEL" . (:foreground "white" :weight bold))
    ))

(require 'org-protocol)



(use-package  org-protocol-capture-html
 :straight  (org-protocol-capture-html :type git :host github :repo "alphapapa/org-protocol-capture-html")
 :after (org)
 :init
 (require 'org-protocol-capture-html)
 )

(add-hook 'eww-after-render-hook 'eww-readable)

;; (use-package emacs-w3m)

(use-package org-roam-ui
:straight
  (:host github :repo "org-roam/org-roam-ui" :branch "main" :files ("*.el" "out"))
  :after org-roam
  :hook (after-init . org-roam-ui-mode)
  :config
  (setq org-roam-ui-sync-theme t
	org-roam-ui-follow t
	org-roam-ui-update-on-save t
	org-roam-ui-open-on-start nil))

(defhydra hydra-roam (:exit t :color teal
			       :hint nil)
    "
  _a_:deft  _e_:find filE  _i_:nsert   _g_:raph _,_:ajouter un alias
    _u_:donneruneidautitre  _s_:erver o:org-roam/backlinks j:daily roam
    "
    ("q" nil "quit" :color blue)
    ("o" org-roam-buffer-toggle)
    ("a" deft)
    ("e" org-roam-node-find)
    ("i" org-roam-node-insert)
    ("g" org-roam-graph)
    ("u" org-id-get-create)
    ("," org-roam-alias-add)
    ("s" org-roam-ui-mode)
    ("j" org-roam-dailies-capture-today)
    ("t" org-roam-node-random)



    )

  (global-set-key (kbd "C-c r") 'hydra-roam/body)


(pretty-hydra-define jnf-find-file-in-roam-project (:foreign-keys warn :title "test" :quit-key "q")
  (
   "Permanent"
   (("b" org-roam-dailies-map "Bibliography")
    ("c" go-roam-find-permanent-cards "Card"))
   "RPGs"
   (("a" go-roam-find-ardu "Ardu, World of")
    ("t" go-roam-find-thel-sector "Thel Sector"))
   "Work"
   (("h" go-roam-find-hesburgh-libraries "Hesburgh Libraries")
    ("s" go-roam-find-samvera "Samvera"))

   ))

(use-package deft
:config
(setq deft-extensions '("org")
      deft-directory "/home/msi/Notes/Roam/"
      deft-recursive t
      deft-strip-summary-regexp ":PROPERTIES:\n\\(.+\n\\)+:END:\n"
      deft-use-filename-as-title t)
:bind
("C-c n d" . deft))

(use-package org-roam
  :init
  ;;éviter d'avoir la nottif de version 1 à 2
  (setq org-roam-v2-ack t)
  :custom
  ;; (org-roam-directory "/home/msi/Notes/Roam")
  (org-roam-completion-everywhere t)
  ;;bien mettre "target" et non "if-new" !!!
  (org-roam-dailies-capture-templates
   '(("d" "default" entry "* %<%I:%M %p>: %?"
      :target (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n")
      :empty-lines 1)

     ))     

  :bind (("C-c n l" . org-roam-buffer-toggle)
	 ("C-c n f" . org-roam-node-find)
	 ("C-c n i" . org-roam-node-insert)
	 :map org-mode-map
	 ("C-M-i" . completion-at-point)
	 :map org-roam-dailies-map
	 ("Y" . org-roam-dailies-capture-yesterday)
	 ("T" . org-roam-dailies-capture-tomorrow))

  :bind-keymap
  ("C-c n d" . org-roam-dailies-map)
  :config

  (setq org-roam-directory (file-truename "~/Notes/Roam/"))


  ;; (setq org-roam-directory 
			     ;; "~/Notes/Roam/"

			     ;; '("/home/msi/Orgzly/" "~/Notes/Roam/GTD/Test/")

	;; )




  (require 'org-roam-dailies) ;; Ensure the keymap is available
  (org-roam-db-autosync-mode)

  ;; pour org-roam capture fonctionne
  (advice-remove 'org-roam-capture--get-target #'org-roam-capture--get-if-new-target-a)

  ;;bien mettre "target" et non "if-new" !!!
  (setq org-roam-capture-templates
	'(("d" "default" plain
	   "%?"
	   :target (file+head "${slug}.org" "#+title: ${title}\n#+date: %U\n")
	   :unnarrowed t)
	  ("a" "Quelqu'un avec des idée, œuvres" plain
	   "* Résumé de sa vie, personnel\n\nNé en %? et mort en \n\n* Principales œuvres ou idées de ${title}"
	   :target (file+head "${slug}.org" "#+title: ${title}\n#+date: %U")
	   :unnarrowed t)

	  ("v" "Ville" plain
	   "\n* Situation géographique, historique et politique de ${title}\n\n%?\n\n\n* Patrimoine architectural et culturel de ${title}\n\n\n* Dans la culture populaire et les généralités de ${title}\n"
	   :target (file+head "${slug}.org" "#+title: ${title}\n#+date: %U")
	   :unnarrowed t)




	  ;; ("b" "book notes" plain (file "~/RoamNotes/Templates/BookNoteTemplate.org")
	  ;; :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
	  ;; :unnarrowed t)


	  ("b" "book notes" plain
	   "\n* Source\n\nAuthor: %^{Author}\nTitle: ${title}\nYear: %^{Year}\n\n* Summary\n\n%?"
	   :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
	   :unnarrowed t)

	  ;; ("f" "Film" entry ;;(file "~/Notes/Roam/GTD/films_vus.org")
	  ;; "\n* Source\n\nAuthor: %^{Author}\nTitle: ${title}\nYear: %^{Year}\n\n** Summary\n\n%?"
	  ;; :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
	  ;; :unnarrowed t)

	  ("x" "book notes" entry (file "/home/msi/Notes/TemplatesOrgCapture/test.org")
	   :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
	   :unnarrowed t)


	  ))








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

  ;; (setq org-roam-node-display-template "${directories:10} ${tags:10} ${title:100} ${backlinkscount:6}")



  ;;pour avoir la hiérarchie lorsque c'est une sous note 
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
       title)) ;; erreur de parenthèse ici mais ça marche ?
    )



  ;; qu'est ce qu'on met lorsque l'on recherche un node (nombre = nombre de caractère)
  (setq org-roam-node-display-template "${directories:5} ${hierarchy:120} ${tags:40} ${backlinkscount:1}")







  ;; for org-roam-buffer-toggle
  ;; Recommendation in the official manual
  (add-to-list 'display-buffer-alist
	       '("\\*org-roam\\*"
		 (display-buffer-in-direction)
		 (direction . right)
		 (window-width . 0.33)
		 (window-height . fit-window-to-buffer)))


  ) ;; fin org roam ici



(add-hook 'org-roam-node-find-hook
	  (lambda ()
	    (and (org-roam-file-p)
		 (not (eq 'visible (org-roam-buffer--visibility)))
		 (org-roam-buffer-toggle))))

(require 'org-roam-protocol)

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

(straight-use-package '(eaf :type git
			    :host github
			    :repo "manateelazycat/emacs-application-framework"
			    :files ("*.el" "*.py" "core" "app")))

;;pour run la commande (eaf-install-and...) seulement une fois (finir d'installer eaf)
;; (unless (package-installed-p 'jedi)
;; (eaf-install-and-update)
;; )
;;





;;pour tout le reste  
(require 'eaf)


;;décocher les eaf nécessaire



(require 'eaf-browser)

;; Pour télécharger les fichiers du web, à mettre aussi sur l'ordinateur

;; (use-package aria2
;;     ;; :after (xah-fly-keys)
;;     :straight '(aria2 :host github
;; 			:repo "emacsmirror/aria2"
;; 			;; :branch "main"
;; 			;; :files ("*.el" "out")
;; 			)
;;     :init  (require 'monpack) 
;; )

;; (require aria2)






;; (require 'eaf-pdf-viewer)

;; (add-to-list 'load-path "/home/msi/.emacs.d/straight/build/eaf/app/image-viewer")
(require 'eaf-image-viewer)


(require 'eaf-terminal)
(require 'eaf-markdown-previewer)

(major-mode-hydra-define eaf-mode

  (:title "EAF-major-mode" :color yellow :separator "-") ;;:color yellow marche pas mais permet de quitter partout

  ("Déplacements/Base"

   (

    ("t" eaf-py-proxy-toggle_adblocker "Adblocker" :exit t)
    ("s" eaf-py-proxy-toggle_dark_mode "Darkmode" :exit t)
    ("i"       eaf-py-proxy-copy_text "Copy le texte" :exit t)
    ("e"       eaf-py-proxy-copy_link "Copy le link" :exit t)
    ("v"       eaf-py-proxy-insert_or_history_backward "Reviens en arrière" :exit t)
    ("l"       eaf-py-proxy-insert_or_history_forward "Reviens en avant" :exit t)
    ;;impossible de le convertir vers firefox, et pas l'inverse
    ;; ("s" eaf-py-proxy-insert_or_save_as_bookmark "Sauvegarde marque page" :exit t)


    )
   "Opération"
   (
    ;; ("f" org-capture-finalize "Finir-capture" :exit t)
    ("R" lsp-rename "Renomer une variable" :exit t)
    ("p" sp-rewrap-sexp "changer les parenthèse par une autre" :exit t)

    ;; ("f" hydra-zoom/body "chedule (unedate)" :exit t)

    )
   "TODO"
   (
    ("o" org-agenda-open-link "Ouvre lien" :exit t)
    )
   "Autre"
   (
    ("a" agenda/tags/body "Agenda/tags" :exit t)
    ("q" keyboard-quit "quit" :color blue)
    )
   )
  )


;; touche perso pour eaf browser !!!!
(defun eafconfiguration()
  (interactive)




  (define-key eaf-mode-map [remap avy-goto-char] #'eaf-py-proxy-open_link)
  (define-key eaf-mode-map [remap next-line] #'eaf-send-down-key)
  (define-key eaf-mode-map [remap previous-line] #'eaf-send-up-key)
  (define-key eaf-mode-map [remap \r] #'eaf-send-return-key)
  (define-key eaf-mode-map [remap xah-delete-backward-char-or-bracket-text] #'eaf-send-ctrl-delete-sequence)



  (define-key eaf-mode-map [remap undo] #'eaf-py-proxy-undo_action)
  (define-key eaf-mode-map [remap consult-line] #'eaf-py-proxy-search_text_forward)
  (define-key eaf-mode-map [remap xah-paste-or-paste-previous] #'eaf-py-proxy-yank_text)




  (define-key pdf-view-mode-map [remap previous-line] #'pdf-view-previous-line-or-previous-page)


  )

(add-hook 'eaf-mode-hook #'eafconfiguration)



;; pour isearch avec les flèches
(progn
  ;; set arrow keys in isearch. left/right is backward/forward, up/down is history. press Return to exit
  (define-key isearch-mode-map (kbd "<up>") 'isearch-ring-retreat )
  (define-key isearch-mode-map (kbd "<down>") 'isearch-ring-advance )

  (define-key isearch-mode-map (kbd "<left>") 'isearch-repeat-backward)
  (define-key isearch-mode-map (kbd "<right>") 'isearch-repeat-forward)

  (define-key minibuffer-local-isearch-map (kbd "<left>") 'isearch-reverse-exit-minibuffer)
  (define-key minibuffer-local-isearch-map (kbd "<right>") 'isearch-forward-exit-minibuffer))

(defun efs/lsp-mode-setup ()

  ;; (sleep-for 3)

  ;; (lsp-enable-which-key-integration)

  ;; (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  ;;activer le chemin en haut
  (lsp-headerline-breadcrumb-mode)
  ;;	 activer la vue des fonctions dans le fichier
  ;; (lsp-treemacs-symbols)
  ;;activer la vue de treemacs du projet

  ;; (treemacs-display-current-project-exclusively)

  )



(use-package lsp-mode
  :commands (lsp lsp-deferred)
  :init
  ;; map lsp keymap prefix mais on prend l'autre version dans :config
  ;; (setq lsp-keymap-prefix "C-é") 
  :hook (
	 ;; mode qui active lsp
	 ((typescript-mode js2-mode web-mode c-mode python-mode) . lsp)

	 ;; (lsp-mode . (treemacs-display-current-project-exclusively-mode lsp-enable-which-key-integration lsp-treemacs-symbols-mode))


	 ;; mode qui charge grâce à lsp
	 ;; (lsp-mode . yas-minor-mode-on)
	 (lsp-mode . efs/lsp-mode-setup)
	 (lsp-mode . lsp-enable-which-key-integration)
	 )
  ;; :bind (:map lsp-mode-map
  ;; ("TAB" . completion-at-point)
  ;; )
  :config
  ;; pour mapper lsp-command-map
  (define-key lsp-mode-map (kbd "C-c l") lsp-command-map)
  ;;pour =activer les yasnippets dans company !!!!!!=
  (setq lsp-completion-provider :none)




  ;;pour les perf
  (setq gc-cons-threshold 100000000)
  (setq read-process-output-max (* 1024 1024)) ;; 1mb
  (setq lsp-idle-delay 0.500)
  (setq lsp-log-io nil) ; if set to true can cause a performance hit





;; les options, voir le lien au dessus


  ;; (setq lsp-ui-doc-enable nil)
  (setq lsp-ui-doc-show-with-cursor nil) ;; enlever le gros pavé qui se met à chaque fois


;; (setq lsp-ui-sideline-enable nil)
  ;; (setq lsp-ui-sideline-enable nil)











  )

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'bottom))

(use-package lsp-treemacs
  :after lsp
  :config
  ;; pour syncro les dossier treemacs avec lsp

  ;;suis pour lsp
  (lsp-treemacs-sync-mode 1)



  )

(use-package consult-lsp
  :config
  (define-key lsp-mode-map [remap xref-find-apropos] #'consult-lsp-symbols)
)

(use-package dap-mode
  :after lsp
  ;; Uncomment the config below if you want all UI panes to be hidden by default!
  ;; :custom
  ;; (lsp-enable-dap-auto-configure nil)
  ;; :config
  ;; (dap-ui-mode 1)

  :config
  ;; Set up Node debugging
  (require 'dap-node)
  (dap-node-setup) ;; Automatically installs Node debug adapter if needed


  )

;;	  pour le raccourcis, à voir
	 (use-package general)


	 (general-define-key
	  :keymaps 'lsp-mode-map
	  :prefix lsp-keymap-prefix
	  "d" '(dap-hydra t :wk "debugger"))

(use-package clang-format+
  :ensure t)

(add-hook 'c-mode-common-hook #'clang-format+-mode)
;; (add-hook 'c-mode-common-hook
;;           (lambda ()
;;             (local-set-key (kbd "C-x <C-tab>") 'clang-format-region)))

(use-package ccls
  :after lsp
  :hook ((c-mode c++-mode objc-mode cuda-mode) .
	 (lambda () (require 'ccls) (lsp))))

(setq python-shell-interpreter "/home/msi/anaconda3/bin/python3")






(use-package python-mode
  :config
  ;; (setq python-shell-interpreter "python3")
  ;; (setq python-shell-interpreter "ipython")
  ;; (setq python-shell-interpreter-args "/home/msi/anaconda3/lib/python3.8/site-packages/bokeh/_testing/plugins/ipython.py") 
  (require 'dap-python)

     (add-to-list 'auto-mode-alist '("\\.rpy\\'" . python-mode))
  )






;; pour éviter les erreurs de doctstring	
(setq lsp-pylsp-plugins-pydocstyle-enabled nil)

(use-package pyvenv)

;; (use-package lsp-pyright
;;   :hook (python-mode . (lambda ()
;;                           (require 'lsp-pyright)
;;                           (lsp))))
					; or lsp-deferred

(use-package direnv
:config
(direnv-mode))

 (use-package python-black
   :after python
   :hook (python-mode . python-black-on-save-mode-enable-dwim))


 ;; rajoute le hook pour trouver black
 (add-hook 'python-mode-hook
	 (lambda ()
	   (when-let ((r (locate-dominating-file default-directory ".pyroot")))
	     (setq python-pytest-executable
		   (concat "PYTHONPATH=" r " " "pytest")))))

(use-package typescript-mode
	   :mode "\\.ts\\'"
	   :hook (typescript-mode . lsp-deferred)
	   :config
	   (setq typescript-indent-level 2)


;; Set up Node debugging (pour dap-mode)
(require 'dap-node)
(dap-node-setup) ;; Automatically installs Node debug adapter if needed

	   )

;; (use-package omnisharp
   ;;   :hook ((csharp-mode . omnisharp-mode)
   ;; 	 (before-save . omnisharp-code-format-entire-file))
   ;;   :config
   ;;   (add-hook 'omnisharp-mode-hook (lambda()
   ;; 				   (add-to-list (make-local-variable 'company-backends)
   ;; 						'(company-omnisharp)))
   ;;   )
   ;; )


   (use-package omnisharp
     :config
     (add-hook 'csharp-mode 'omnisharp-mode)
     (eval-after-load
    'company
    '(add-to-list 'company-backends 'company-omnisharp))

     (add-hook 'csharp-mode-hook #'company-mode)
     (add-hook 'csharp-mode-hook #'flycheck-mode)
   )


  ;; (eval-after-load
 ;;   'company
 ;;   '(add-to-list 'company-backends #'company-omnisharp))

 (defun my-csharp-mode-setup ()
  (omnisharp-mode)
    (company-mode)
    (flycheck-mode)

 ;;   (setq indent-tabs-mode nil)
 ;;   (setq c-syntactic-indentation t)
 ;;   (c-set-style "ellemtel")
 ;;   (setq c-basic-offset 4)
 ;;   (setq truncate-lines t)
 ;;   (setq tab-width 4)
 ;;   (setq evil-shift-width 4)

 ;;   ;csharp-mode README.md recommends this too
 ;;   ;(electric-pair-mode 1)       ;; Emacs 24
 ;;   ;(electric-pair-local-mode 1) ;; Emacs 25

 ;;   (local-set-key (kbd "C-c r r") 'omnisharp-run-code-action-refactoring)
 ;;   (local-set-key (kbd "C-c C-c") 'recompile)
    (omnisharp-start-omnisharp-server))

(add-hook 'csharp-mode-hook 'my-csharp-mode-setup t)

(use-package csharp-mode)

(use-package lsp-java :config (add-hook 'java-mode-hook 'lsp))

(defun java-eval-nofocus ()
  "run current program (that requires no input)"
  (interactive)
  (let* ((source (file-name-nondirectory buffer-file-name))
     (out    (file-name-sans-extension source))
     (class  (concat out ".class")))
    (save-buffer)
    (shell-command (format "rm -f %s && javac %s" class source))
    (if (file-exists-p class)
    (shell-command (format "java %s" out) "*OutputJava*")
      (progn
    (set (make-local-variable 'compile-command)
         (format "javac %s" source))
    (command-execute 'compile)))))

(use-package flycheck
  :defer t
  :init
  :diminish
  :hook (lsp-mode . flycheck-mode)
  :config
  (global-flycheck-mode t)
  (set-face-attribute 'flycheck-error nil :foreground "black" :background
		      "#EE4400")
  (set-face-attribute 'flycheck-warning nil :foreground "black" :background
		      "#EE9900")
  (set-face-attribute 'flycheck-info nil :foreground "black" :background
		      "#008800")
  )

;; (use-package company-lsp		
;;   :config
;;   (require 'company-lsp)
;;   (push 'company-lsp company-backends)
;;   )

(use-package company
  :after lsp-mode  ;;si ya lsp-mode
  :init
  :hook (lsp-mode . company-mode)  ;; au lieu de lsp, mettre c-mode, python mode etc
  :bind (:map company-active-map
	      ("<tab>" . company-complete-selection)) ;; logique pour complêter

  :custom
  (company-minimum-prefix-length 2) ;;taille avant que le popup arrive
  (company-idle-delay 0.6);;temps avant qu'il pop
  ;;pour cycler dans les sélections
  ( company-selection-wrap-around t)
  :config





  ;; (add-hook 'company-mode
  ;; (lambda ()
  ;; (setq company-backends
  ;; (mapcar #'mars/company-backend-with-yas company-backends))))



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



;;pour l'estéthéque 
(use-package company-box
  :after company
  :hook (company-mode . company-box-mode))

(use-package company-prescient
  :after company
  :config
  (company-prescient-mode 1)
  ;; Remember candidate frequencies across sessions
  (prescient-persist-mode 1)
  )

(with-eval-after-load 'company


  ;; Add yasnippet support for all company backends
  ;; https://github.com/syl20bnr/spacemacs/pull/179
  (defvar company-mode/enable-yas t
    "Enable yasnippet for all backends.")

  (defun company-mode/backend-with-yas (backend)
    (if (or (not company-mode/enable-yas) (and (listp backend) (member 'company-yasnippet backend)))
	backend
      (append (if (consp backend) backend (list backend))
	      '(:with company-yasnippet))))

  (setq company-backends (mapcar #'company-mode/backend-with-yas company-backends))


  (defun activeryasnippets ()
    (interactive)
    (setq company-backends (mapcar #'company-mode/backend-with-yas company-backends))


    )



  (global-set-key (kbd "<f6>") 'activeryasnippets)


  (add-hook 'company-mode
	    (lambda ()
	      (setq company-backends (mapcar #'company-mode/backend-with-yas company-backends))))



  (add-hook #'company-select-next 'activeryasnippets)

  )

(use-package projectile
   :config
   (use-package ripgrep);; pour projectile ripgrep, chercher dans un projet
   (projectile-global-mode)
   ;;(setq projectile-completion-system 'ivy)
   )




;;   (setq projectile-project-search-path '("~/projects/" "home/msi/Documents/Project/Code/"))

(use-package yasnippet
	;; si on veux les yas que en prog mode, décocher ça et cocher yas global mode
	;; :hook (prog-mode . yas-minor-mode)
	:config
	(yas-reload-all)
	(yas-global-mode 1)
	(setq yas-triggers-in-field t) ;;appeler des snippets dans des snippets
	)

      (use-package yasnippet-snippets ;; un pack de snippets
	:diminish
	)

      (eval-after-load 'yasnippet
	'(progn
   (global-unset-key (kbd "C-s"))
	   (define-key yas-keymap (kbd "TAB") nil)
	   ;; (define-key yas-keymap (kbd "C-s") 'yas-next-field)
	   (define-key yas-keymap (kbd "C-s") 'yas-next-field-or-maybe-expand)
	   ;; (key-chord-define  "ie" 'yas-next-field)
	   )
	)




;;pour plus tard, si jamais la complétion plus tart
;;    (defun yas-org-very-safe-expand ()
;;      (interactive)
;;   (let ((yas-fallback-behavior 'return-nil)) (yas-expand)))

;; (add-hook 'org-mode-hook
;;       (lambda ()
;; 	(add-to-list 'org-tab-first-hook 'yas-org-very-safe-expand)
;; 	(define-key yas-keymap [tab] 'yas-next-field)))






      ;; déjà au bon endroit :   /home/msi/.emacs.d/etc/yasnippet/snippets/
      ;; (setq yas-snippet-dirs
      ;;       '(
      ;; 	"/home/msi/.emacs.d/etc/yasnippet/snippets/"
      ;; 	"yasnippet-snippets-dir"
      ;; 	))

(define-key yas-minor-mode-map (kbd "<tab>") nil)
(define-key yas-minor-mode-map (kbd "TAB") nil)
(define-key yas-minor-mode-map (kbd "<C-tab>") 'yas-expand)

;; (define-key yas-minor-mode-map (kbd "SPC") 'yas-maybe-expand)

;; (company-mode)




;; Fait, et trop fort
;; à faire

;;	    (use-package helm-c-yasnippet
;;	      :config
;;	      (setq helm-yas-space-match-any-greedy t)
;;	    (global-set-key (kbd "C-<tab>") 'helm-yas-complete))

(use-package highlight-doxygen
  :config
  (highlight-doxygen-global-mode 1)
  )

(use-package doxygen)

;; (use-package doxymacs)

(use-package aggressive-indent
  :config
  ;; (add-hook 'emacs-lisp-mode-hook #'aggressive-indent-mode)
  (add-hook 'java-mode-hook #'aggressive-indent-mode)
  )

(use-package smartparens
  :hook ((lsp-mode org-mode) . smartparens-mode)

  :config

(sp-pair "\«" "\»")

  ;;pour enlever un truc
  ;; the second argument is the closing delimiter, so you need to skip it with nil
  (sp-pair "'" nil :actions :rem)

  ;; pour rajouter à un mode :
  ;; (sp-local-pair 'org-mode "*" "*") ;; adds `' as a local pair in emacs-lisp-mode



  )

(setq electric-pair-pairs '(

			    (?\( . ?\))
			    (?\{ . ?\{)
			    (?\[ . ?\])

			    (?\* . ?\*)
			    (?\= . ?\=)
			    (?\/ . ?\/)
			    (?\" . ?\")
			    (?\~ . ?\~)
			    (?\$ . ?\$)
			    ))





;;pour ne pas avoir <> mais juste le début
(setq electric-pair-inhibit-predicate
      (lambda (c)
	(if (char-equal c ?\<) t (electric-pair-default-inhibit c))))

;; (electric-pair-mode t)

(add-hook 'org-mode-hook 'electric-pair-local-mode)
;; (add-hook 'lsp-mode-hook 'electric-pair-local-mode)

(show-paren-mode 1)
;; (setq show-paren-style 'parenthesis)
(setq show-paren-style 'mixed)

;; couleur
(set-face-background 'show-paren-match "gray")
(set-face-foreground 'show-paren-match "black")
(set-face-attribute 'show-paren-match nil :weight 'extra-bold)

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package hungry-delete
  :ensure t
  :config
    (global-hungry-delete-mode)
  :diminish)

(setq compilation-finish-functions
      (append compilation-finish-functions
          '(fmq-compilation-finish)))

(defun fmq-compilation-finish (buffer status)
  (when (not (member mode-name '("Grep" "rg")))
    (call-process "notify-send" nil nil nil
          "-t" "0"
          "-i" "emacs"
          "Compilation finished in Emacs"
          status)))

;;pour compiler et run directement le makefile	     
	     (defun desperately-compile ()
	       "Traveling up the path, find a Makefile and `compile'."
	       (interactive)
	       (when (locate-dominating-file default-directory "Makefile")
		 (with-temp-buffer
		   (cd (locate-dominating-file default-directory "Makefile"))
		   (compile "make run"))))

	     (global-set-key [f10] 'desperately-compile)

(defun run-buffer()
	    (interactive)
	    (shell-pop)
	    )
	  ;; (global-set-key (kbd "<f9>") 'run-buffer)


(use-package shell-pop)

(add-hook 'prog-mode-hook #'linum-mode)

(use-package go-mode)

(use-package origami)

(setq compilation-window-height 15)

(defun ct/create-proper-compilation-window ()
  "Setup the *compilation* window with custom settings."
  (when (not (get-buffer-window "*compilation*"))
    (save-selected-window
      (save-excursion
        (let* ((w (split-window-vertically))
               (h (window-height w)))
          (select-window w)
          (switch-to-buffer "*compilation*")

          ;; Reduce window height
          (shrink-window (- h compilation-window-height))

          ;; Prevent other buffers from displaying inside
          (set-window-dedicated-p w t) 
  )))))
(add-hook 'compilation-mode-hook 'ct/create-proper-compilation-window)

;;  (setq mu4e-mu-binary "/home/msi/mu/mu")

  
  	;;   ;; :defer 20 ; Wait until 20 seconds after startup
	;;   :config
     (require 'mu4e)
	   ;; This is set to 't' to avoid mail syncing issues when using mbsync
	   (setq mu4e-change-filenames-when-moving t)
    
	   ;; Refresh mail using isync every 10 minutes
	   (setq mu4e-update-interval (* 10 60))
	   (setq mu4e-get-mail-command "mbsync -a")
	   (setq mu4e-maildir "~/Mail")
    
	   (setq mu4e-drafts-folder "/[Gmail]/Drafts")
	   (setq mu4e-sent-folder   "/[Gmail]/Sent Mail")
	   (setq mu4e-refile-folder "/[Gmail]/All Mail")
	   (setq mu4e-trash-folder  "/[Gmail]/Trash")
    
	   (setq mu4e-maildir-shortcuts
	       '(("/Inbox"             . ?i)
	    ("/[Gmail]/Sent Mail" . ?s)
	    ("/[Gmail]/Trash"     . ?t)
	    ("/[Gmail]/Drafts"    . ?d)
	    ("/[Gmail]/All Mail"  . ?a)))
    ;;)

(setq smtpmail-smtp-server "smtp.gmail.com"
	smtpmail-smtp-service 465
	smtpmail-stream-type  'ssl)
  
  
  ;; Configure the function to use for sending mail
(setq message-send-mail-function 'smtpmail-send-it)

(auto-fill-mode 0)
(visual-line-mode 1)

(defun taille-interligne ()
  "Toggle line spacing between no extra space to extra half line height.
URL `http://ergoemacs.org/emacs/emacs_toggle_line_spacing.html'
Version 2017-06-02"
  (interactive)
  (if line-spacing
      (setq line-spacing nil)
    (setq line-spacing 0.5))
  (redraw-frame (selected-frame)))

(use-package darkroom
  :hook (org-mode . darkroom-tentative-mode)
  :commands darkroom-mode
  :config
  (setq darkroom-text-scale-increase 0)
  )



;;pour que les fonction marche du 1er coup, activé désactivé.
(darkroom-mode 1)
(darkroom-mode 0)

(defun dw/enter-focus-mode ()

  (darkroom-mode 1)
  (menu-bar-mode 0)
  (scroll-bar-mode 0 )
  (toggle-frame-fullscreen)
  )

(defun dw/leave-focus-mode ()

  (darkroom-mode 0)
  ;; (menu-bar-mode 1)
  (scroll-bar-mode 1 )
  (toggle-frame-fullscreen)
  )

(defun dw/toggle-focus-mode ()
  (interactive)
  (if (symbol-value darkroom-mode)
      (dw/leave-focus-mode)
    (dw/enter-focus-mode)))

;; (add-hook 'org-mode-hook #'dw/toggle-focus-modebis)

(setq ispell-local-dictionary-alist- 
      '(("francais" "[[:alpha:]]" "[^[:alpha:]]" "[']" nil ("-d" "fr") nil utf-8)
        ("en_US" "[[:alpha:]]" "[^[:alpha:]]" "[']" nil ("-d" "en_US") nil utf-8)
        ))
(setq ispell-program-name "hunspell"          ; Use hunspell to correct mistakes
      ispell-dictionary   "francais")

(defun switch-dictionary-fr-en ()
  "Switch french and english dictionaries."
  (interactive)
  (let* ((dict ispell-current-dictionary)
         (new (if (string= dict "francais") "en_US"
                   "francais")))
    (ispell-change-dictionary new)
    (message "Switched dictionary from %s to %s" dict new)))

(global-set-key (kbd "C-c d") 'switch-dictionary-fr-en)

;; (add-hook 'prog-mode-hook 'flyspell-prog-mode) ;; if you write text with a
;; lot of text, it is possible to activte it, the problem is that it suggests errors
;; when you put code inside ""
(global-set-key (kbd "C-c f") 'flyspell-check-previous-highlighted-word)

;;-------------
;; Text mode
;;-------------
(add-hook 'text-mode-hook 'flyspell-mode)
(add-hook 'prog-mode-hook 'flyspell-prog-mode)

;; Highlight BUG FIXME TODO NOTE keywords in the source code.
(add-hook 'find-file-hook
	  (lambda()
	    (highlight-phrase "\\(BUG\\|FIXME\\|TODO\\|NOTE\\):")))

(use-package flycheck-grammalecte
  :after flycheck
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

;;And we can also avoid loading them in any other specific text-mode, for example change-log-mode and log-edit-mode:

(dolist (hook '(change-log-mode-hook log-edit-mode-hook))
    (add-hook hook (lambda () (flyspell-mode -1))))

(use-package nov
  :config
  (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode)))

;; (use-package go-translate
;;   :config
;;   (setq go-translate-local-language "fr")
;;   (setq go-translate-target-language "en")
;;   (global-set-key "\C-ct" 'go-translate)
;;   (global-set-key "\C-cT" 'go-translate-popup))

(use-package magit
  :bind ("C-x g" . magit-status)
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1)
  )





;;  (defun dw/leader-key-def()
;; (interactive)
;; 	"g"   '(:ignore t :which-key "git")
;; 	"gs"  'magit-status
;; 	"gd"  'magit-diff-unstaged
;; 	"gc"  'magit-branch-or-checkout
;; 	"gl"   '(:ignore t :which-key "log")
;; 	"glc" 'magit-log-current
;; 	"glf" 'magit-log-buffer-file
;; 	"gb"  'magit-branch
;; 	"gP"  'magit-push-current
;; 	"gp"  'magit-pull-branch
;; 	"gf"  'magit-fetch
;; 	"gF"  'magit-fetch-all
;; 	"gr"  'magit-rebase)

(use-package keycast)

(eval-after-load 'ox '(require 'ox-koma-letter))

 ;; KOMA-SCript letter
  (eval-after-load 'ox-koma-letter
    '(progn
       (add-to-list 'org-latex-classes
		    '("my-koma-letter"
		      "\\documentclass\{scrlttr2\}
\\usepackage[hidelinks,unicode]{hyperref}
[NO-DEFAULT-PACKAGES]"))

       (setq org-koma-letter-default-class "my-koma-letter")))

(require 'ox-latex)


(setq org-latex-pdf-process
	'("pdflatex -interaction nonstopmode -output-directory %o %f"
	  "bibtex %b"
	  "pdflatex -interaction nonstopmode -output-directory %o %f"
	  "pdflatex -interaction nonstopmode -output-directory %o %f"))

  (setq org-latex-with-hyperref nil) ;; stop org adding hypersetup{author..} to latex export
  ;; (setq org-latex-prefer-user-labels t)

  ;; deleted unwanted file extensions after latexMK
  (setq org-latex-logfiles-extensions
	(quote ("lof" "lot" "tex~" "aux" "idx" "log" "out" "toc" "nav" "snm" "vrb" "dvi" "fdb_latexmk" "blg" "brf" "fls" "entoc" "ps" "spl" "bbl" "xmpi" "run.xml" "bcf" "acn" "acr" "alg" "glg" "gls" "ist")))

  ;; (unless (boundp 'org-latex-classes)
  ;;   (setq org-latex-classes nil))



(require 'ox)
(eval-when-compile (require 'cl))

(defun org-latex-header-blocks-filter (backend)
  (when (org-export-derived-backend-p backend 'latex)
    (let ((positions
	   (org-element-map (org-element-parse-buffer 'greater-element nil) 'export-block
	     (lambda (block)
	       (when (and (string= (org-element-property :type block) "LATEX")
			  (string= (org-export-read-attribute
				    :header block :header)
				   "yes"))
		 (list (org-element-property :begin block)
		       (org-element-property :end block)
		       (org-element-property :post-affiliated block)))))))
      (mapc (lambda (pos)
	      (goto-char (nth 2 pos))
	      (destructuring-bind
		  (beg end &rest ignore)
		  (org-edit-src-find-region-and-lang)
		(let ((contents-lines (split-string
				       (buffer-substring-no-properties beg end)
				       "\n")))
		  (delete-region (nth 0 pos) (nth 1 pos))
		  (dolist (line contents-lines)
		    (insert (concat "#+latex_header: "
				    (replace-regexp-in-string "\\` *" "" line)
				    "\n"))))))
	    ;; go in reverse, to avoid wrecking the numeric positions
	    ;; earlier in the file
	    (reverse positions)))))


;; During export headlines which have the "ignore" tag are removed
;; from the parse tree.  Their contents are retained (leading to a
;; possibly invalid parse tree, which nevertheless appears to function
;; correctly with most export backends) all children headlines are
;; retained and are promoted to the level of the ignored parent
;; headline.
;;
;; This makes it possible to add structure to the original Org-mode
;; document which does not effect the exported version, such as in the
;; following examples.
;;
;; Wrapping an abstract in a headline
;;
;;     * Abstract                        :ignore:
;;     #+LaTeX: \begin{abstract}
;;     #+HTML: <div id="abstract">
;;
;;     ...
;;
;;     #+HTML: </div>
;;     #+LaTeX: \end{abstract}
;;
;; Placing References under a headline (using ox-bibtex in contrib)
;;
;;     * References                     :ignore:
;;     #+BIBLIOGRAPHY: dissertation plain
;;
;; Inserting an appendix for LaTeX using the appendix package.
;;
;;     * Appendix                       :ignore:
;;     #+LaTeX: \begin{appendices}
;;     ** Reproduction
;;     ...
;;     ** Definitions
;;     #+LaTeX: \end{appendices}
;;
(defun org-export-ignore-headlines (data backend info)
  "Remove headlines tagged \"ignore\" retaining contents and promoting children.
Each headline tagged \"ignore\" will be removed retaining its
contents and promoting any children headlines to the level of the
parent."
  (org-element-map data 'headline
    (lambda (object)
      (when (member "ignore" (org-element-property :tags object))
        (let ((level-top (org-element-property :level object))
              level-diff)
          (mapc (lambda (el)
                  ;; recursively promote all nested headlines
                  (org-element-map el 'headline
                    (lambda (el)
                      (when (equal 'headline (org-element-type el))
                        (unless level-diff
                          (setq level-diff (- (org-element-property :level el)
                                              level-top)))
                        (org-element-put-property el
                          :level (- (org-element-property :level el)
                                    level-diff)))))
                  ;; insert back into parse tree
                  (org-element-insert-before el object))
                (org-element-contents object)))
        (org-element-extract-element object)))
    info nil)
  data)

(defconst ox-extras
  '((latex-header-blocks org-latex-header-blocks-filter org-export-before-parsing-hook)
    (ignore-headlines org-export-ignore-headlines org-export-filter-parse-tree-functions))
  "A list of org export extras that can be enabled.
Should be a list of items of the form (NAME FN HOOK).  NAME is a
symbol, which can be passed to `ox-extras-activate'.  FN is a
function which will be added to HOOK.")

(defun ox-extras-activate (extras)
  "Activate certain org export extras.
EXTRAS should be a list of extras (defined in `ox-extras') which
should be activated."
  (dolist (extra extras)
    (let* ((lst (assq extra ox-extras))
	   (fn (nth 1 lst))
	   (hook (nth 2 lst)))
      (when (and fn hook)
	(add-hook hook fn)))))

(defun ox-extras-deactivate (extras)
  "Deactivate certain org export extras.
This function is the opposite of `ox-extras-activate'.  EXTRAS
should be a list of extras (defined in `ox-extras') which should
be activated."
  (dolist (extra extras)
    (let* ((lst (assq extra ox-extras))
	   (fn (nth 1 lst))
	   (hook (nth 2 lst)))
      (when (and fn hook)
	(remove-hook hook fn)))))


(ox-extras-activate '(latex-header-blocks ignore-headlines))

(setq org-latex-logfiles-extensions (quote ("lof" "lot" "tex~" "aux" "idx" "log" "out" "toc" "nav" "snm" "vrb" "dvi" "fdb_latexmk" "blg" "brf" "fls" "entoc" "ps" "spl" "bbl" "xmpi" "run.xml" "bcf")))
(add-to-list 'org-latex-classes
	     '("altacv" "\\documentclass[10pt,a4paper,ragged2e,withhyper]{altacv}

% Change the page layout if you need to
\\geometry{left=1.25cm,right=1.25cm,top=1.5cm,bottom=1.5cm,columnsep=1.2cm}

% Use roboto and lato for fonts
\\renewcommand{\\familydefault}{\\sfdefault}

% Change the colours if you want to
\\definecolor{SlateGrey}{HTML}{2E2E2E}
\\definecolor{LightGrey}{HTML}{666666}
\\definecolor{DarkPastelRed}{HTML}{450808}
\\definecolor{PastelRed}{HTML}{8F0D0D}
\\definecolor{GoldenEarth}{HTML}{E7D192}
\\colorlet{name}{black}
\\colorlet{tagline}{PastelRed}
\\colorlet{heading}{DarkPastelRed}
\\colorlet{headingrule}{GoldenEarth}
\\colorlet{subheading}{PastelRed}
\\colorlet{accent}{PastelRed}
\\colorlet{emphasis}{SlateGrey}
\\colorlet{body}{LightGrey}

% Change some fonts, if necessary
\\renewcommand{\\namefont}{\\Huge\\rmfamily\\bfseries}
\\renewcommand{\\personalinfofont}{\\footnotesize}
\\renewcommand{\\cvsectionfont}{\\LARGE\\rmfamily\\bfseries}
\\renewcommand{\\cvsubsectionfont}{\\large\\bfseries}

% Change the bullets for itemize and rating marker
% for \cvskill if you want to
\\renewcommand{\\itemmarker}{{\\small\\textbullet}}
\\renewcommand{\\ratingmarker}{\\faCircle}
"

	       ("\\cvsection{%s}" . "\\cvsection*{%s}")
	       ("\\cvevent{%s}" . "\\cvevent*{%s}")))
(setq org-latex-packages-alist 'nil)
(setq org-latex-default-packages-alist
      '(("rm" "roboto"  t)
	("defaultsans" "lato" t)
	("" "paracol" t)
	;; pour la cover letter
	("AUTO" "babel" t)
	))

(defun efs/exwm-update-class ()
	(exwm-workspace-rename-buffer exwm-class-name))

      (use-package exwm
	:config


  ;; Set the default number of workspaces
  (setq exwm-workspace-number 5)

  ;; When window "class" updates, use it to set the buffer name
  ;; (add-hook 'exwm-update-class-hook #'efs/exwm-update-class)

  ;; These keys should always pass through to Emacs
  (setq exwm-input-prefix-keys
    '(?\C-x
      ?\C-u
      ?\C-h
      ?\M-x
      ?\M-`
      ?\M-&
      ?\M-:
      ?\C-\M-j  ;; Buffer list
      ?\C-\ ))  ;; Ctrl+Space

  ;; Ctrl+Q will enable the next key to be sent directly
  (define-key exwm-mode-map [?\C-q] 'exwm-input-send-next-key)

  ;; Set up global key bindings.  These always work, no matter the input state!
  ;; Keep in mind that changing this list after EXWM initializes has no effect.
  (setq exwm-input-global-keys
	`(
	  ;; Reset to line-mode (C-c C-k switches to char-mode via exwm-input-release-keyboard)
	  ([?\s-r] . exwm-reset)

	  ;; Move between windows
	  ([s-left] . windmove-left)
	  ([s-right] . windmove-right)
	  ([s-up] . windmove-up)
	  ([s-down] . windmove-down)

	  ;; Launch applications via shell command
	  ;; ([?\s-&] . (lambda (command)
	  ;; 	       (interactive (list (read-shell-command "$ ")))
	  ;; 	       (start-process-shell-command command nil 
						    ;; command)))

	  ;; Switch workspace
	  ([?\s-w] . exwm-workspace-switch)

	  ;; 's-N': Switch to certain workspace with Super (Win) plus a number key (0 - 9)
	  ,@(mapcar (lambda (i)
		      `(,(kbd (format "s-%d" i)) .
			(lambda ()
			  (interactive)
			  (exwm-workspace-switch-create ,i))))
		    (number-sequence 0 9))))




  ;; Remap mes touches pour exwm     ;; Rebind CapsLock to Ctrl
  ;; (start-process-shell-command "xmodmap" nil "xmodmap ~/.emacs.d/exwm/Xmodmap")

    ;;(exwm-enable)


  ;; Show battery status in the mode line
(display-battery-mode 1)

;; Show the time and date in modeline
(setq display-time-day-and-date t)
(display-time-mode 1)
;; Also take a look at display-time-format and format-time-string


	)

;; (use-package counsel
;;   :demand t
;;   :bind (
;; 	 ;; ("M-x" . counsel-M-x)
;; 	 ("C-x b" . counsel-ibuffer)
;; 	 ;; ("C-x C-f" . counsel-find-file)
;; 	 ;; ("C-M-j" . counsel-switch-buffer)
;; 	 ("C-M-l" . counsel-imenu)
;; 	 :map minibuffer-local-map
;; 	 ("C-r" . 'counsel-minibuffer-history)
;; 	 )
;;   :custom
;;   ;; cette ligne notamment
;;   (counsel-linux-app-format-function #'counsel-linux-app-format-function-name-only)
;;   :config
;;   (setq ivy-initial-inputs-alist nil)
;;   )

(use-package desktop-environment
  :after exwm
  :config (desktop-environment-mode)
  :custom
  (desktop-environment-brightness-small-increment "2%+")
  (desktop-environment-brightness-small-decrement "2%-")
  (desktop-environment-brightness-normal-increment "5%+")
  (desktop-environment-brightness-normal-decrement "5%-")
  )

(with-eval-after-load 'exwm

(use-package exwm-firefox-core)

		     )

(use-package xah-elisp-mode)

(setq erc-server "irc.libera.chat"
      erc-nick "Cletip"    ; Change this!
      erc-user-full-name "Cletip"  ; And this!
      erc-track-shorten-start 8
;;      erc-autojoin-channels-alist '(("irc.libera.chat" "#systemcrafters" "#emacs"))
      erc-kill-buffer-on-part t
            erc-auto-query 'bury)



(use-package ox-hugo
  :after ox
  :config
  (setq org-hugo-base-dir

	;; "/home/msi/Documents/Projet/Git/Github/Siterecettes/"

	"/home/msi/Documents/Projet/SitesWeb/braindump"
	)
  )

(use-package minimap

  ;; :config
  ;; (minimap-mode 1)

  )

;; (defun dw/org-present-prepare-slide ()
;;   (org-overview)
;;   (org-show-entry)
;;   (org-show-children))

;; (defun dw/org-present-hook ()
;;   (setq-local face-remapping-alist '((default (:height 1.5) variable-pitch)
;;                                      (header-line (:height 4.5) variable-pitch)
;;                                      (org-code (:height 1.55) org-code)
;;                                      (org-verbatim (:height 1.55) org-verbatim)
;;                                      (org-block (:height 1.25) org-block)
;;                                      (org-block-begin-line (:height 0.7) org-block)))
;;   (setq header-line-format " ")
;;   (org-display-inline-images)
;;   (dw/org-present-prepare-slide))

;; (defun dw/org-present-quit-hook ()
;;   (setq-local face-remapping-alist '((default variable-pitch default)))
;;   (setq header-line-format nil)
;;   (org-present-small)
;;   (org-remove-inline-images))

;; (defun dw/org-present-prev ()
;;   (interactive)
;;   (org-present-prev)
;;   (dw/org-present-prepare-slide))

;; (defun dw/org-present-next ()
;;   (interactive)
;;   (org-present-next)

;;   (dw/org-present-prepare-slide))

(use-package org-present
  :bind (:map org-present-mode-keymap
	 ("C-c C-j" . dw/org-present-next)
	 ("C-c C-k" . dw/org-present-prev))
  :hook ((org-present-mode . dw/org-present-hook)
	 (org-present-mode-quit . dw/org-present-quit-hook)))

(cl-defmacro lsp-org-babel-enable (lang)
  "Support LANG in org source code block."
  (setq centaur-lsp 'lsp-mode)
  (cl-check-type lang stringp)
  (let* ((edit-pre (intern (format "org-babel-edit-prep:%s" lang)))
	(intern-pre (intern (format "lsp--%s" (symbol-name edit-pre)))))
    `(progn
       (defun ,intern-pre (info)
	(let ((file-name (->> info caddr (alist-get :file))))
	  (unless file-name
	    (setq file-name (make-temp-file "babel-lsp-")))
	  (setq buffer-file-name file-name)
	  (lsp-deferred)))
       (put ',intern-pre 'function-documentation
	   (format "Enable lsp-mode in the buffer of org source block (%s)."
		   (upcase ,lang)))
       (if (fboundp ',edit-pre)
	  (advice-add ',edit-pre :after ',intern-pre)
	(progn
	  (defun ,edit-pre (info)
	    (,intern-pre info))
	  (put ',edit-pre 'function-documentation
	       (format "Prepare local buffer environment for org source block (%s)."
		       (upcase ,lang))))))))
(defvar org-babel-lang-list
  '("go" "python" "ipython" "bash" "sh" "C"))
(dolist (lang org-babel-lang-list)
  (eval `(lsp-org-babel-enable ,lang)))

;;     (require 'lsp-mode)
;; (with-eval-after-load 'lsp-mode
;;   (let ((trace-buf "*trace*")
;;         (ctx
;;          (lambda ()
;;            (format
;;             " <+<%s|+|%s|+|%s|+|%s|+|%s>+>"
;;             (buffer-name)
;;             (local-variable-p 'lsp--cur-workspace)
;;             (local-variable-p 'lsp--buffer-workspaces)
;;             lsp--cur-workspace lsp--buffer-workspaces)))
;;         (watcher
;;          (lambda (symbol newval operation where)
;;           (let ((buf (buffer-name)))
;;             (with-current-buffer "*trace*"
;;               (goto-char (point-max))
;;               (insert (format "==>> %s|-|%s|-|%s|-|%s|-|%s|-|%s\n"
;;                               buf where symbol
;;                               (local-variable-p symbol)
;;                               operation (if newval "*val*")))
;;               ;; (when (and (not (string-match-p "\.rs$" buf))
;;               ;;            )
;;               ;;   (error "open back trace 1"))
;;               ))
;;           ;; (when (string= operation "makunbound")
;;           ;;   (error "open back trace 2"))
;;           ;; (when (and (eq symbol 'lsp--buffer-workspaces)
;;           ;;            (string= operation "set")
;;           ;;            (if newval t))
;;           ;;   (error "open back trace 3"))
;;           ))
;;         )

;;     (get-buffer-create trace-buf)

;;     (trace-function-background 'lsp-feature? trace-buf ctx)
;;     (trace-function-background 'lsp--find-workspaces-for trace-buf ctx)
;;     (add-variable-watcher 'lsp--cur-workspace watcher)
;;     (add-variable-watcher 'lsp--buffer-workspaces watcher)
;;     ))

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

(defun ap/garbage-collect ()
  "Run `garbage-collect' and print stats about memory usage."
  (interactive)
  (message (cl-loop for (type size used free) in (garbage-collect)
                    for used = (* used size)
                    for free = (* (or free 0) size)
                    for total = (file-size-human-readable (+ used free))
                    for used = (file-size-human-readable used)
                    for free = (file-size-human-readable free)
                    concat (format "%s: %s + %s = %s\n" type used free total))))



(use-package emojify
:hook (after-init . global-emojify-mode)
)

(use-package simple-httpd)

(use-package heaven-and-hell
:init

(setq heaven-and-hell-theme-type 'dark) ;; Omit to use light by default

(setq heaven-and-hell-themes
      '((light . doom-moonlight)
	(dark . doom-acario-dark))) ;; Themes can be the list: (dark . (tsdh-dark wombat))

;; Optionall, load themes without asking for confirmation.
(setq heaven-and-hell-load-theme-no-confirm t)

:hook (after-init . heaven-and-hell-init-hook)
:bind (("C-c <f6>" . heaven-and-hell-load-default-theme)
       ;; ("<f6>" . heaven-and-hell-toggle-theme)
       ))

;; (add-hook 'org-timer-set-hook #'org-clock-in)

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
               '(lambda (filename)
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
    (mapconcat '(lambda (obj) (format "%s" obj)) list " "))

(use-package calfw)
(use-package calfw-org)

(add-to-list 'display-buffer-alist 
'("^\\*Python\\*$" . (display-buffer-same-window)))


(defun my-py-execute-buffer ()
(interactive)
(set 'code-buffer (current-buffer))
(unless (get-buffer "*Python*")
  (py-shell)
  (set-buffer code-buffer)
  (sleep-for 0.2))
(py-execute-buffer))

(use-package org-vcard
  :config
  (setq org-vcard-default-version "3.0") ;;la version utilisée (pour pouvoir y envoyer sur google)
  (setq org-vcard-default-export-file "/home/msi/contactpourgoogle.vcf")
  )

;; (require 'org-crypt)




;;le fichier se trouve à /home/msi/.emacs.d/var/bbdb/bbdb.el
(use-package bbdb
  :config
  ;;If you don't live in Northern America, you should disable the
  ;;syntax check for telephone numbers by saying
  (setq bbdb-north-american-phone-numbers-p nil)
  ;;Tell bbdb about your email address:
  ;; (setq bbdb-user-mail-names
  ;; (regexp-opt '("Your.Email@here.invalid"
  ;; "Your.other@mail.there.invalid")))
  ;;cycling while completing email addresses
  (setq bbdb-complete-name-allow-cycling t)
  ;; permet d'eviter d'avoir une fenetre bbdb qui montre en permanence
  ;; les mises a jour dans bbdb lorsque l'on utilise VM, MH, RMAIL ou
  ;; GNUS
  (setq bbdb-use-pop-up nil)

  ;;      pas de code de localisation par defaut pour les numeros de
  ;; telephone
  ;; mettre ça de base, ne marche pas
  (setq bbdb-default-area-code "33")

  ;; permet d'empecher a bbdb de creer une nouvelle entree a chaque fois
  ;; qu'un mail d'une nouvelle personne est lu avec GNUS, RMAIL, VM ou
  ;; MH. 
  (setq bbdb/mail-auto-create-p nil)


  ;; nombre de lignes desire dans la fenetre popup de bbdb lorsque l'on
  ;; utilise VM/MH/RMAIL ou GNUS.
  (setq bbdb-pop-up-target-lines 7)

  ;;pour importer les contacts à chaque lancement emacs, mettre le bon fichi :





  )




;; (use-package ebdb)

(use-package bbdb-vcard
      :config
    
      ;; (setq bbdb-vcard-directory "~/home/msi/Dossier_partage//")
      ;; dossier par défaut
      (setq bbdb-vcard-default-dir "/home/msi/Dossier_partage_nous_deux/Clement/Test/")
      )

(with-eval-after-load 'bbdb-vcard


	;; (bbdb-vcard-import-file "/home/msi/Dossier_partage/Contacts.vcf")


	;; (delete-file "/home/msi/Dossier_partage/Contactscopie.vcf")
	;; (copy-file "/home/msi/Dossier_partage/Contacts.vcf" "/home/msi/Dossier_partage/Contactscopie.vcf")
      ;; (delete-file "/home/msi/Dossier_partage/Contacts.vcf")


	)

(use-package sms)

(use-package bbdb-sms
  :after bbdb sms
  )

(setq bbdb-mail-user-agent 'mu4e-user-agent)
(setq mu4e-view-mode-hook 'bbdb-mua-auto-update)
(setq mu4e-compose-complete-addresses nil)
(setq bbdb-mua-pop-up t)
(setq bbdb-mua-pop-up-window-size 5)
(setq mu4e-view-show-addresses t)

(use-package ebdb
  :config
  (setq ebdb-anniversary-ymd-format "%Y-%B-%d")
  (setq org-agenda-include-diary 1)
  (require 'ebdb)
  (require 'ebdb-vcard)
  )

(use-package sudo-edit)



;; BibLaTeX settings
;; bibtex-mode
(setq bibtex-dialect 'biblatex)


(setq bib-files-directory (directory-files
			   (concat (getenv "HOME") "/Notes/Référencesbib/") t
			   "^[A-Z|a-z].+.bib$")
      pdf-files-directory (concat (getenv "HOME") "/Notes/Référencesbib/"))

(with-eval-after-load 'helm
(define-key helm-map [remap next-line] #'helm-next-line)
(define-key helm-map  [remap previous-line] #'helm-previous-line)
)

;; (use-package helm-bibtex
;;   :config
;;   (require 'helm-config)
;;   (setq bibtex-completion-bibliography bib-files-directory
;; 	bibtex-completion-library-path pdf-files-directory
;; 	bibtex-completion-pdf-field "File"
;; 	bibtex-completion-notes-path org-directory))

(setq org-directory "~/Notes")


(use-package org-ref
  :config
   (setq
    org-ref-completion-library 'org-ref-helm-cite
     org-ref-get-pdf-filename-function 'org-ref-get-pdf-filename-helm-bibtex
     org-ref-default-bibliography bib-files-directory
     org-ref-notes-directory org-directory
     org-ref-notes-function 'orb-edit-notes)
   )

(use-package org-roam-bibtex
  :after (org-roam helm-bibtex)
  :bind (:map org-mode-map ("C-c n b" . orb-note-actions))
  :config
  (require 'org-ref)
  (org-roam-bibtex-mode)
  )

(use-package org-transclusion
  :after org
  :straight '(org-transclusion
	      :host github
	      :repo "nobiot/org-transclusion"
	      :branch "main"
	      :files ("*.el"))
  ;; :config  
  ;; (define-key global-map (kbd "<f12>") #'org-transclusion-add)
  ;; (define-key global-map (kbd "C-n t") #'org-transclusion-mode)

  )

(use-package trashed)

;;ma fonction pour enregistrer mes raccourcis dans orgzly, plus besoin

(defun cp/copy-bookmarks-to-org-linkz ()
  (delete-file "/home/msi/Dossier_partage_nous_deux/Clement/org-linkz/3Bookmarks.org")
  (copy-file "/home/msi/Notes/Roam/GTD/3Bookmarks.org" "/home/msi/Dossier_partage_nous_deux/Clement/org-linkz/3Bookmarks.org")
  )

(server-start)  ;; starts emacs as server (if you didn't already)
(setq org-html-validation-link nil)  ;; removes validation link from exported html file
(require 'org-protocol)


;; load the packaged named xyz.
;; (require org-linkz) ;; best not to include the ending “.el” or

(use-package floobits)

;; (with-eval-after-load 'emms

;;   (add-hook 'dashboard-mode-hook 'sound-after-start)
;;   (defun sound-after-start ()
;;     (interactive)
;;     (emms-play-file "/home/msi/.emacs.d/sondemarrage.mp3")
;;     )
;;   )


(with-eval-after-load 'org-roam

  (defun org-roam-node-random-after-start ()
    ;; (interactive)

    (split-window-right)
    (xah-next-window-or-frame)
    (org-roam-node-random)
    (xah-next-window-or-frame)
    )
  )

(add-hook 'emacs-startup-hook #'org-roam-node-random-after-start)

(use-package processing-mode)
(add-to-list 'auto-mode-alist '("\\.pde\\'" . processing-mode))


(setq processing-location "/home/msi/Téléchargements/processing-3.5.4/processing-java")

(use-package org-tree-slide
  :custom
  (org-image-actual-width nil))

;; Tell emacs where is my personal elisp lib dir
(add-to-list 'load-path "~/.emacs.d/lisp/")

(require 'test)

(setq org-id-link-to-org-use-id t)

;; Resizing the Emacs frame can be a terribly expensive part of changing the
;; font. By inhibiting this, we halve startup times, particularly when we use
;; fonts that are larger than the system default (which would resize the frame).
(setq frame-inhibit-implied-resize t)

(add-to-list 'default-frame-alist '(font . "Fira Code-14"))
(setq frame-inhibit-implied-resize t)

(use-package ctrlf)


(define-key ctrlf-mode-map [remap next-line] #'ctrlf-next-match)
(define-key ctrlf-mode-map [remap previous-line] #'ctrlf-previous-match)

(tool-bar-mode -1)
