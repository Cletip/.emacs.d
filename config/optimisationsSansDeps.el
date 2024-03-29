;;basique
(when window-system
  (progn
    (scroll-bar-mode 0)
    (tool-bar-mode 0))
  )

(menu-bar-mode 0)
(tooltip-mode 0)

(setq initial-scratch-message nil)

(defvaralias 'major-mode-for-buffer-scratch 'initial-major-mode)
(setq major-mode-for-buffer-scratch 'org-mode)

(use-package recentf
  :config

  (recentf-mode 1)
  (setq recentf-max-menu-items 100)
  (setq recentf-max-saved-items 100)

  ;; fichier à exclure de recentf
  ;; If you use recentf then you might find it convenient to exclude all of the files in the no-littering directories using something like the following.
  (add-to-list 'recentf-exclude no-littering-var-directory)
  (add-to-list 'recentf-exclude no-littering-etc-directory)
  (add-to-list 'recentf-exclude "/tmp/") ;;pour emacs-everywhere notamment
  ;; Exlcude the org-agenda files
  ;; (they flood the recentf because dashboard always checks their content)
  ;; (with-eval-after-load 'org ;;important
  ;; (add-to-list 'recentf-exclude (org-agenda-files))
  ;; )
  )

;; Persist history over Emacs restarts. Vertico sorts by history position.
(use-package savehist
  :init
  (setq savehist-file (concat user-emacs-directory "var/savehist.el"))
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

;;sauvegarde à tout les changement de fenêtre
(defun xah-save-all-unsaved (&rest args)
  "Save all unsaved files. no ask.
        Version 2019-11-05"
  (interactive)
  (unless (string-equal (file-name-extension buffer-file-name) "gpg")
    (save-some-buffers t))
  )

;; mis dans xfk-layer
;; (defun cp/xah-fly-save-buffer-if-file-not-gpg ()
;; "Save current buffer if it is a file."
;; (interactive)
;; (when (and (buffer-file-name) (not (string-equal (file-name-extension buffer-file-name) "gpg")))
;; (save-buffer)))

;; (add-to-list 'window-state-change-functions 'xah-save-all-unsaved)
;; sauvegarde automatique avec command mode
;; (add-hook 'xah-fly-command-mode-activate-hook 'cp/xah-fly-save-buffer-if-file-not-gpg)

(setq make-backup-files t	  ; backup of a file the first time it is saved.
      backup-by-copying t	  ; don't clobber symlinks
      version-control t		  ; version numbers for backup files
      delete-old-versions t	  ; delete excess backup files silently
      delete-by-moving-to-trash t ; Put the deleted files in the trash
      kept-old-versions 6 ; oldest versions to keep when a new numbered backup is made (default: 2)
      kept-new-versions 9 ; newest versions to keep when a new numbered backup is made (default: 2)
      auto-save-default t ; auto-save every buffer that visits a file into another file, not the original
      auto-save-timeout 20 ; number of seconds idle time before auto-save (default: 30)
      auto-save-interval 200 ; number of keystrokes between auto-saves (default: 300)
      ;; auto-save-visited-file-name t ;; sauvegarde directement sur le fichier original
      )

;;fichier à ne pas copier dans les backups
(setq auto-mode-alist
      (append
       (list
        '("\\.\\(vcf\\|gpg\\)$" . sensitive-minor-mode))
       auto-mode-alist))

(fset 'yes-or-no-p 'y-or-n-p)

(global-auto-revert-mode t)

(setq revert-without-query '(".pdf"))

(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(delete-selection-mode t)

(save-place-mode 1)

(cd user-emacs-directory)

(defun cp/find-symbol ()
  "Find symbol at point or proprose to find a symbol"
  (interactive)
  (let ((symbol
         (or
          ;; (symbol-at-point)
          (helpful--symbol-at-point)
          ;; (intern (completing-read "Symbol: " obarray))
          (helpful--read-symbol
           "Symbol: "
           (helpful--symbol-at-point)
           #'helpful--bound-p))))
    (cond
     ((and (boundp symbol) (fboundp symbol))
      (if (y-or-n-p
           (format "%s is a both a variable and a callable, show variable?"
                   symbol))
          (find-variable symbol)
        (find-function symbol)))

     ((fboundp symbol)
      (find-function symbol))
     ((boundp symbol)
      (find-variable symbol))
     ;; ((condition-case nil
     ;; (find-function-at-point)
     ;; (error nil)) (find-function-at-point))
     ;; ((condition-case nil
     ;; (find-variable-at-point)
     ;; (error nil)) (find-variable-at-point))
     (t (message "no symbol at point or don't find the path")))))



(defun describe-thing-in-popup ()
  (interactive)
  (let* ((thing (symbol-at-point)))
    (cond
     ((fboundp thing) (describe-in-popup 'describe-function))
     ((boundp thing) (describe-in-popup 'describe-variable)))))

(defun describe-in-popup (fn)
  (let* ((thing (symbol-at-point))
         (description (save-window-excursion
                        (funcall fn thing)
                        (switch-to-buffer "*Help*")
                        (buffer-string))))
    (popup-tip description
               :point (point)
               :around t
               :height 30
               :scroll-bar t
               :margin t)))

;; starts emacs as server (if you didn't already)

(require 'server) ;; pour se servir de (server-running-p)
(unless (server-running-p) (server-start))

;; en mode readble, plus sympa à lire (provoque un bug, mais pg. corrigé avec une maj ?)
(add-hook 'eww-after-render-hook 'eww-readable)
;; (remove-hook 'eww-after-render-hook 'eww-readable)


(with-eval-after-load 'xah-fly-keys
  (defun cp/xah-insert-mode-when-command-eww ()
    "Run xah-fly-insert-mode-activate after a search of eww. Don't works with a simple advice-add"
    (when
        ;; (and (> (length (eww-current-url)) (length eww-search-prefix)) ;; pas
        ;;besoin de vérifier si c'est déjà plus grand !
        ;; (string= eww-search-prefix (substring (eww-current-url) 0 (length eww-search-prefix))))
        ;; juste si c'est la même c'est ok
        (not (null (cl-search eww-search-prefix (eww-current-url))))
      (xah-fly-insert-mode-activate)))
  (add-hook 'eww-after-render-hook 'cp/xah-insert-mode-when-command-eww))

(setq
 eww-search-prefix "https://html.duckduckgo.com/html/?q="
 ;; eww-search-prefix "https://www.bing.com/search?q="
 shr-inhibit-images t  ;;n'affiche pas les images (au début (eww-toggle-images))
 eww-restore-desktop t ;; rafraîchit automatiquement
 eww-desktop-remove-duplicates t
 shr-use-colors nil
 shr-bullet "• "
 shr-folding-mode t
 shr-indentation 2  ; Left-side margin
 shr-width 70       ; Fold text to 70 columns
 shr-use-colors nil ; No colours
 url-privacy-level '(email agent cookies lastloc))

;; change automatiquement le nom
(when (fboundp 'eww)
  (defun xah-rename-eww-buffer ()
    "Rename `eww-mode' buffer so sites open in new page.
          URL `http://xahlee.info/emacs/emacs/emacs_eww_web_browser.html'
          Version 2017-11-10"
    (let (($title (plist-get eww-data :title)))
      (when (eq major-mode 'eww-mode)
        (if $title
            (rename-buffer (concat "eww " $title) t)
          (rename-buffer "eww" t)))))
  (add-hook 'eww-after-render-hook 'xah-rename-eww-buffer))

(use-package move-text
     :defer 0.5
     :config
     (move-text-default-bindings))

(use-package expand-region
  :config
  (setq expand-region-show-usage-message nil))

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

(use-package smartparens
  ;; :after lsp
:hook ((lsp-mode text-mode emacs-lisp-mode scheme-mode) . smartparens-mode)
:config
(sp-pair "\«" "\»")
;;pour enlever un truc
;; the second argument is the closing delimiter, so you need to skip it with nil

;;    (sp-pair "'" nil :actions :rem)

;; (sp-local-pair 'emacs-lisp-mode "'" nil :actions nil)
;; (sp-local-pair 'xah-elisp-mode "'" nil :actions nil)
;; (sp-local-pair 'emacs-lisp-mode "`" nil :actions nil)
;; (sp-local-pair 'xah-elisp-mode "`" nil :actions nil)
(sp-local-pair 'scheme-mode "'" nil :actions nil)

(defun cp/remove-local-pair-for-emacs-lisp-mode ()
  "Obligé de créer cette fonction, car pour prendre les même hook que emacs-lisp-mode pour xah-lisp-mode, pas de fonction lambda"
  (sp-local-pair major-mode "`" nil :actions nil)
  (sp-local-pair major-mode "'" nil :actions nil))

(add-hook 'emacs-lisp-mode-hook 'cp/remove-local-pair-for-emacs-lisp-mode)

(add-hook 'org-mode-hook 'cp/remove-local-pair-for-emacs-lisp-mode)

;; pour rajouter à un mode :
;; pas supprimer avec xah car ne fait pas partie de xah-right-brackets
;; changer org emphasis ?

;; (sp-local-pair 'org-mode "*" "*") ;; adds * as a local pair in org mode

;; (sp-local-pair 'org-mode "=" "=") ;; adds = as a local pair in org mode

;; (sp-local-pair 'org-mode "\/" "\/")
)

(use-package sudo-edit)

(use-package consult
:config

;; ordre dans la commande consult-buffer
(setq consult-buffer-sources
      '(consult--source-hidden-buffer
        consult--source-modified-buffer
        consult--source-buffer
        consult--source-bookmark
        consult--source-recent-file
        consult--source-file-register
        consult--source-project-buffer
        consult--source-project-recent-file))

(setq completion-in-region-function #'consult-completion-in-region)

;; Définition de mes fonctions
(defun cp/consult-line-or-with-word ()
  "Call `consult-line' on current word or text selection.
                  “word” here is A to Z, a to z, and hyphen 「-」 and underline 「_」, independent of syntax table.
                  URL `http://xahlee.info/emacs/emacs/modernization_isearch.html'
                  Version 2015-04-09"
  (interactive)
  (let ($p1 $p2)
    (if (use-region-p)
        (progn
          (setq $p1 (region-beginning))
          (setq $p2 (region-end)))
      (save-excursion
        (setq $p1 (point))
        (setq $p2 (point))))
    (setq mark-active nil)
    (when (< $p1 (point))
      (goto-char $p1))
    (consult-line (buffer-substring-no-properties $p1 $p2))))

;; au final cela pas ouf, car je suis obligé de passer par le mini-buffer. En plus, activé grâce à universal argument + consult-ripgrep
(defun cp/consult-ripgrep-with-directory (&optional dir)
  (interactive)
  (consult-ripgrep (or dir (read-directory-name "Directory:")))))

(use-package avy
  ;;\ pour l'espace
  :custom
  ;;personnalition des touches, important
  ;; (avy-keys '(?a ?u ?e ?i ?t ?s ?r ?n ?\ ?\^M)) ;;^M=enter
  ;; todo adapter à xah-fly-key !
  (avy-keys '(?\ ?e ?u ?i ?a ?s ?t ?r ?. ?c))
  (avy-background t)
  ;;nouvelle touches pour escape avy go timer
  (avy-escape-chars '(?\e ?\M-g))
  :config
  (setq avy-timeout-seconds 0.25)

  ;; pour que ça marche sur toutse les fenêtres
  (setq avy-all-windows 'all-frames)

  ;;personnaliser chaque commande :
  ;; (setq avy-keys-alist
  ;; `((avy-goto-char . ,(number-sequence ?a ?f))
  ;; (avy-goto-word-1 . (?f ?g ?h ?j))))

  (defun avy-goto-char-timer-end (&optional arg)
    "Read one or many consecutive chars and jump to the last one.
The window scope is determined by `avy-all-windows' (ARG negates it)."
    (interactive "P")
    (avy-goto-char-timer arg)
    (forward-char (length avy-text))))

(use-package ace-link
  :config
  (ace-link-setup-default))

(use-package holymotion
  :straight (holymotion :type git
                        :host github
                        :repo "Cletip/holymotion"
                        :branch "main")
  :config
  (require 'holymotion)
  ;; define some custom motions, I'm using smartparens here
  (holymotion-make-motion
   holymotion-xah-forward-right-bracket #'xah-forward-right-bracket)
  ;; (holymotion-make-motion
  ;;  holymotion-xah-backward-left-bracket #'xah-backward-left-bracket)

  (defun holymotion-next-line-only-with-prefix ()
    "DOCSTRING here"
    (interactive)
    (if current-prefix-arg
        (holymotion-next-line)
      (next-line))))

(use-package trashed)

(use-package which-key
  ;; :diminish which-key-mode
  :config
  ;;activer which-key
  (which-key-mode)
  ;;temps avant déclenchement de wich-key minimum
  (setq which-key-idle-delay 0.01)
  ;; affichage sur le côté, mais si marche pas en bas
  (which-key-setup-side-window-right-bottom)
  (setq which-key-frame-max-height 100)
  (setq which-key-min-display-lines 1000))

;;retour à la ligne concrètrement 
;; (add-hook 'text-mode-hook 'turn-on-auto-fill)

(add-hook 'prog-mode-hook 'turn-on-auto-fill)
(setq-default fill-column 80)

;; taille pour coder
;; (add-hook 'prog-mode-hook
;; (lambda ()
;; (setq fill-column 80)
;; (auto-fill-mode t)
;; )
;; )

;; visuellement
(global-visual-line-mode 1)

;; paragraphe
;; (refill-mode)

(defun taille-interligne ()
  "Toggle line spacing between no extra space to extra half line height.
URL `http://ergoemacs.org/emacs/emacs_toggle_line_spacing.html'
Version 2017-06-02"
  (interactive)
  (if line-spacing
      (setq line-spacing nil)
    (setq line-spacing 0.5))
  (redraw-frame (selected-frame)))

(defun numéro-des-lignes-relatif ()
    (interactive)
    (setq display-line-numbers 'relative)
    )

(add-hook 'prog-mode-hook #'numéro-des-lignes-relatif)
;; (add-hook 'org-mode-hook #'numéro-des-lignes-relatif)

(global-hl-line-mode t)
(set-face-background hl-line-face "#311")

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
  ;;fait chauffer emacs, désactivé
  (doom-modeline-enable-word-count nil)
  (doom-modeline-buffer-encoding nil)
  (doom-modeline-indent-info nil)
  (doom-modeline-checker-simple-format t)
  (doom-modeline-vcs-max-length 20)
  (doom-modeline-env-version t)
  (doom-modeline-irc-stylize 'identity)
  (doom-modeline-github-timer nil)
  (doom-modeline-gnus-timer nil)
  )

(use-package nyan-mode
  :config
  (nyan-mode)
  )

(use-package darkroom
  ;; :hook (org-mode . darkroom-tentative-mode)
  :commands darkroom-mode
  :config
  (setq darkroom-text-scale-increase 0))



;;pour que les fonction marche du 1er coup, activé désactivé.
;; (darkroom-mode 1)
;; (darkroom-mode 0)

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

(set-face-attribute 'default nil :height 130)

;;police de base, mise dans le early-init.el pour démarrage plus rapide
(defun Policedebase ()
  (interactive)
  (set-face-attribute 'default nil
                      :font "Fira Mono"
                      :weight 'light
                      :height 120
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

(use-package all-the-icons
  :init
  (unless (member "all-the-icons" (font-family-list))
    (all-the-icons-install-fonts t))
  :if (display-graphic-p)
  :config
  (unless (member "all-the-icons" (font-family-list))
    (all-the-icons-install-fonts t))
  )

;;pour les icônes dans dired
(use-package all-the-icons-dired)

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

;; Toggles background transparency
(defun toggle-transparency ()
  (interactive)
  (let ((alpha (frame-parameter nil 'alpha)))
    (set-frame-parameter
     nil 'alpha
     (if (eql (cond ((numberp alpha) alpha)
                    ((numberp (cdr alpha)) (cdr alpha))
                    ;; Also handle undocumented (<active> <inactive>) form.
                    ((numberp (cadr alpha)) (cadr alpha)))
              100)
         '(85 . 50) '(100 . 100)))))

;; (global-set-key (kbd "C-c t") 'toggle-transparency)


(setq transparency_level 0)
(defun cp/toggle-transparency ()
  "Toggles transparency of Emacs between 3 settings (none, mild, moderate)."
  (interactive)
  (if (equal transparency_level 0)
      (progn (set-frame-parameter (selected-frame) 'alpha '(85 . 85))
             (setq transparency_level 1))
    (if (equal transparency_level 1)
        (progn (set-frame-parameter (selected-frame) 'alpha '(70 . 85))
               (setq transparency_level 2))
      (if (equal transparency_level 2)
          (progn (set-frame-parameter (selected-frame) 'alpha '(100 . 85))
                 (setq transparency_level 0)))
      )))
(define-key global-map (kbd "C-c t") 'cp/toggle-transparency)

(defun cp/toggle-transparency2 ()
  (interactive)
  (let ((alpha (frame-parameter nil 'alpha)))
    (if (eq
         (if (numberp alpha)
             alpha
           (cdr alpha)) ; may also be nil
         100)
        (set-frame-parameter nil 'alpha '(60 . 50))
      (set-frame-parameter nil 'alpha '(100 . 100)))))

(use-package hide-mode-line)

(setq enable-recursive-minibuffers t)

(use-package vertico

  ;;charger les extensions de vertico
  :load-path "straight/build/vertico/extensions"
  :custom
  (vertico-cycle t)
  :custom-face
  (vertico-current ((t (:background "#3a3f5a"))))
  :config

  ;; Prefix the current candidate with “» ”. From
  ;; https://github.com/minad/vertico/wiki#prefix-current-candidate-with-arrow
  (advice-add #'vertico--format-candidate :around
              (lambda (orig cand prefix suffix index _start)
                (setq cand (funcall orig cand prefix suffix index _start))
                (concat
                 (if (= vertico--index index)
                     (propertize "» " 'face 'vertico-current)
                   "  ")
                 cand)))

  ;;pour activer vertico directory (remonte d'un dossier à chaque fois, pratique ! )
  (require 'vertico-directory)
  ;; (define-key vertico-map [remap backward-kill-word] #'vertico-directory-up)
  ;; (define-key vertico-map [remap xah-delete-backward-char-or-bracket-text] #'vertico-directory-up)
  (define-key vertico-map [remap open-line] #'vertico-directory-up)
  ;; (define-key vertico-map [remap delete-backward-char] #'vertico-directory-up)

  ;; pour pouvoir jump à une entrée
  ;; (define-key vertico-map [remap avy-goto-char] #'vertico-quick-jump)

  (with-eval-after-load 'avy

    (defun divide-list-in-two-equal-part (lst)
      (let ((len (length lst)))
        (list (seq-subseq lst 0 (/ len 2))
              (seq-subseq lst (/ len 2)))))

    (setq avy-keys-alist-two-part (divide-list-in-two-equal-part (mapconcat 'char-to-string '(?\ ?e ?u ?i ?a ?s ?t ?r ?n) "")))

    ;; lorsqu'il y a une touche
    (setq vertico-quick1 (car avy-keys-alist-two-part))
    ;; deux touches
    (setq vertico-quick2 (cadr avy-keys-alist-two-part))

    (require 'vertico-quick)
    (use-package vertico-quick
      :straight nil
      :after vertico
      :custom (test 2)
      :bind (:map vertico-map
                  ("C-<return>" . vertico-quick-exit))))

  (vertico-mode))

(use-package marginalia
  :after vertico
  :custom
  (marginalia-annotators '(marginalia-annotators-heavy marginalia-annotators-light nil))
  :init
  (marginalia-mode)
  )

;; Complétation par candidats      
;; Use the `orderless' completion style.
;; Enable `partial-completion' for files to allow path expansion.
;; You may prefer to use `initials' instead of `partial-completion'.
(use-package orderless
  :init

  (setq completion-styles '(orderless)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion))))
  :config

  (setq orderless-matching-styles
        '(
          orderless-regexp
          ;; orderless-literal
          orderless-initialism ;;très puissant
          ;; orderless-prefixes ;; utile pour les commandes de temps en temps
          ;; orderless-flex ;; sert à rien pour moi, donne même des candidats inutiles
          ;; orderless-without-literal ;; à ne pas utiliser directement
          ))

(setq orderless-component-separator 'orderless-escapable-split-on-space)

  ;;couleur avec company
  (defun just-one-face (fn &rest args)
    (let ((orderless-match-faces [completions-common-part]))
      (apply fn args)))
  (advice-add 'company-capf--candidates :around #'just-one-face))

(use-package embark
  :load-path "straight/build/embark"
  :bind (("C-t" . embark-become)) ;; pourquoi marche pas ?
  :config

  (setq embark-quit-after-action '((kill-buffer . t)
                                   (embark-insert . t)
                                   (embark-insert-in-outer-minibuffer . t)))

  ;; nouvelle commande pour insérer dans le minibuffer
  (defun embark-insert-in-outer-minibuffer (string)
    (if-let ((miniwin (active-minibuffer-window)))
        (with-current-buffer (window-buffer miniwin)
          (insert string))
      (message "Not in the minibuffer")))

  ;; (setf (alist-get 'embark-insert
  ;; embark-quit-after-action)
  ;; t)

  ;; (diredp-recent-dirs nil)
  (define-key embark-general-map "O" #'embark-insert-in-outer-minibuffer)

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

  (advice-add #'embark-completing-read-prompter :around #'embark-hide-which-key-indicator))

(with-eval-after-load 'consult
  (with-eval-after-load 'embark
    (require 'embark-consult)))      ;; besoin de le load avec require. Pk ?
(use-package embark-consult
  ;; :after consult embark
  ;; if you want to have consult previews as you move around an
  ;; auto-updating embark collect buffer
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

;; (with-eval-after-load 'org
;; (with-eval-after-load 'embark
;;     (require 'embark-org)))
(load-file (concat straight-base-dir "straight/build/embark/embark-org.el"))
(use-package embark-org
  ;; :load-path "straight/build/embark/"
  :straight nil)

;; ne sert à R ?
(load-file (concat straight-base-dir "straight/repos/embark/avy-embark-collect.el"))
(use-package avy-embark-collect
  ;; :load-path "straight/build/embark/"
  :straight nil)

;; actionner action embark dés l'arrivé avec . 
(setf (alist-get ?. avy-dispatch-alist) 'avy-action-embark)

(defun avy-action-embark (pt)
  (unwind-protect
      (save-excursion
        (goto-char pt)
        (embark-act))
    (select-window
     (cdr (ring-ref avy-ring 0))))
  t)



;; (define-key embark-become-match-map (kbd (xah-fly--convert-kbd-str "h")) 'xah-fly-keys-layer-isearch-forward-function) ;; différent, plus petit dans les résultats ?
(define-key embark-consult-search-map (kbd (xah-fly--convert-kbd-str "h")) 'xah-fly-keys-layer-isearch-forward-function)

(define-key embark-become-file+buffer-map (kbd (xah-fly--convert-kbd-str "h"))
  'xah-fly-keys-layer-recentf-open-files-function)


(define-key embark-become-help-map (kbd (xah-fly--convert-kbd-str "h"))
  'xah-fly-keys-layer-describe-variable-function)

(use-package consult-dir
  :bind (("C-x C-d" . consult-dir)
         :map minibuffer-local-completion-map
         ("C-x C-d" . consult-dir)
         ("C-x C-j" . consult-dir-jump-file))
  :config
  ;; ne pas mettre un "/" quand on insère
  (setq consult-dir-shadow-filenames nil))

(defvar action-counts (make-hash-table))

(cl-defun increment-action-count (&key action &allow-other-keys)
  (cl-incf (gethash action action-counts 0)))

(with-eval-after-load 'embark
  (push 'increment-action-count (alist-get :always embark-pre-action-hooks))
  )

(define-key embark-symbol-map (kbd "=") 'set-variable)

(use-package helpful  
  :config

  (with-eval-after-load 'xah-fly-keys
    ;; If you want to replace the default Emacs help keybindings, you can do so:

    ;; Note that the built-in `describe-function' includes both functions
    ;; and macros. `helpful-function' is functions only, so we provide
    ;; `helpful-callable' as a drop-in replacement.
    ;; (global-set-key (kbd "C-h f") #'helpful-callable)
    (define-key xah-fly-key-map [remap describe-function] #'helpful-callable)

    ;; (global-set-key (kbd "C-h v") #'helpful-variable)
    (define-key xah-fly-key-map [remap describe-variable] #'helpful-variable)


    ;; (global-set-key (kbd "C-h k") #'helpful-key)
    (define-key xah-fly-key-map [remap describe-key] #'helpful-key)

    ;; I also recommend the following keybindings to get the most out of helpful:

    ;; Lookup the current symbol at point. C-c C-d is a common keybinding
    ;; for this in lisp modes.
    (global-set-key (kbd "C-c C-d") #'helpful-at-point)

    ;; Look up *F*unctions (excludes macros).
    ;;
    ;; By default, C-h F is bound to `Info-goto-emacs-command-node'. Helpful
    ;; already links to the manual, if a function is referenced there.
    ;; (global-set-key (kbd "C-h F") #'helpful-function)

    ;; Look up *C*ommands.
    ;;
    ;; By default, C-h C is bound to describe `describe-coding-system'. I
    ;; don't find this very useful, but it's frequently useful to only
    ;; look at interactive functions.
    (define-key xah-fly-key-map [remap describe-coding-system] #'helpful-command)
    ;; (global-set-key (kbd "C-h C") #'helpful-command)
    )



  ;;meilleur gestion des fenêtres
  (setq helpful-switch-buffer-function #'+helpful-switch-to-buffer)

  (defun +helpful-switch-to-buffer (buffer-or-name)
    "Switch to helpful BUFFER-OR-NAME.

  The logic is simple, if we are currently in the helpful buffer,
  reuse it's window, otherwise create new one."
    (if (eq major-mode 'helpful-mode)
        (switch-to-buffer buffer-or-name)
      (pop-to-buffer buffer-or-name)))

  )

(winner-mode 1) ;;naviguer avec les fenêtres

(setq bookmark-file-coding-system "utf-8-emacs")

(use-package burly
  :straight (burly :type git :host github :repo "alphapapa/burly.el"
                   :fork (:host github
                                :repo "alphapapa/burly.el"))

  :config
  ;; 'nouveaunom #'anciennom, anciennomexisteencore
  ;; (defalias 'bookmark-windows-burly #'burly-bookmark-windows)
  ;; (defalias 'bookmark-windows-and-frames-burly #'burly-bookmark-frames)
  ;; j'ai gardé et mis directement sur LayerXahFlyKey
  )

;; (when window-system (setq pop-up-frames t))

(defvar display-pixel-width (display-pixel-width) "Width of DISPLAY’s screen in pixels.")
(defvar display-pixel-height (display-pixel-height) "Height of DISPLAY’s screen in pixels.")

(defvar size-frame-width nil "Where place the frame in x")
(setq size-frame-width (truncate (/ display-pixel-width 2.25))) ;; only this need to be configure
(defvar size-frame-height display-pixel-height "Where place the frame in x")
(defvar size-frame-shift (/ (- (/ display-pixel-width 2) size-frame-width) 2) "Size of the shift to center the windows")
(defvar place-frame-x (+ (/ display-pixel-width 2) size-frame-shift) "Where place the frame in x")
(defvar place-frame-y display-pixel-height "Where place the frame in x")

(setq frame-resize-pixelwise t) ;; sinon je ne peux pas dépasser 1050 en hauteur

(defun cp/frame-place-default ()
  "Place the frame to the default place"
  (set-frame-size (selected-frame) size-frame-width display-pixel-height t)
  (set-frame-position (selected-frame) place-frame-x place-frame-y))

(when window-system
  (cp/frame-place-default))

(defun cp/position-of-new-windows ()
  (if (and window-system (get 'cp/position-of-new-windows 'state))
      (progn
        (cp/frame-place-default)
        (put 'cp/position-of-new-windows 'state nil))
    (progn
      (set-frame-size (selected-frame) size-frame-width display-pixel-height t)
      (set-frame-position (selected-frame) size-frame-shift place-frame-y) ;; on décale juste la fenêtre en partant de 0
      (put 'cp/position-of-new-windows 'state t))))

(add-hook 'after-make-frame-functions
          (lambda (frame)
            (select-frame frame)
            (when (display-graphic-p frame)
              (cp/position-of-new-windows))))

;; (make-frame)

(use-package ace-window
  :config
(setq aw-keys '(?a ?u ?e ?i ?t ?s ?r ?n ?\ ))  )

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

(use-package dired-quick-sort
  :config
  (dired-quick-sort-setup)
  )

(use-package dired-collapse
  :defer t)
(add-hook 'dired-load-hook
	  (lambda ()
	    (interactive)
	    (dired-collapse)))

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

(defun rename-file-and-buffer (new-name)
  "Renames both current buffer and file it's visiting to NEW-NAME."
  (interactive "sNew name: ")
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not filename)
        (message "Buffer '%s' is not visiting a file!" name)
      (if (get-buffer new-name)
          (message "A buffer named '%s' already exists!" new-name)
        (progn
          (rename-file filename new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil))))))

;; (rename-file-and-buffer (concat "../liens/" (file-name-nondirectory buffer-file-name)))

(use-package dired+)

(use-package restart-emacs
    :config (defalias 'emacs-restart #'restart-emacs)
    )

(use-package magit)
;; gérer les pull request

(setq cp/magit-commit-directory-list '(
                                       braindump-directory
                                       ;; "~/test/"
                                       ))

(defun cp/magit-commit-directory-list(list)
  "prends une liste représentant les directory à commit"
  (dolist (directory list)
    (cp/magit-commit-directory directory))
  )

(defun cp/magit-commit-directory(directory)
  (interactive)
  (save-window-excursion
    (find-file
     (if (stringp directory) ;; à cause du do-list
         directory
       (symbol-value directory)
       )
     )
    (magit-call-git "add" ".")
    (magit-call-git "commit" "-m" "Auto commit")
    (magit-refresh)
    (message "Commit fait pour le dossier : %s" directory)
    )
  )

(cp/magit-commit-directory-list cp/magit-commit-directory-list)

(add-hook 'kill-emacs-hook #'(lambda () (cp/magit-commit-directory-list cp/magit-commit-directory-list)) 95) ;; doit commit à la fin

;; (remove-hook 'kill-emacs-hook #'(lambda () (cp/magit-commit-directory-list cp/magit-commit-directory-list)) )

(use-package nov
    :config
    (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode)))

(use-package pdf-tools
  :if (not termux-p)
  :config
  ;; initialise
  (pdf-tools-install t)
  ;; open pdfs scaled to fit page
  (setq-default pdf-view-display-size 'fit-page)
  ;; automatically annotate highlights
  (setq pdf-annot-activate-created-annotations t)
  ;; use normal isearch
  (define-key pdf-view-mode-map (kbd "C-s") 'isearch-forward)
  ;;mode nuit de base (active le thème actuel)
  (add-hook 'pdf-tools-enabled-hook 'pdf-view-midnight-minor-mode)
;;(remove-hook 'pdf-tools-enabled-hook 'pdf-view-midnight-minor-mode)
  ;; pour que "pdf-annot-list-annotations" marche, il faut remove les .emacs.d/straight/repos/tablist/*.elc
  )

(use-package engine-mode
         :straight t
         :config
         (engine-mode t)
         (defengine duckduckgo "https://duckduckgo.com/?q=%s" :keybinding "d")
         (defengine ecosia "https://www.ecosia.org/search?q=%s" :keybinding "e")
         (defengine google "http://www.google.com/search?ie=utf-8&oe=utf-8&q=%s" :keybinding "g")
         (defengine lilo "https://search.lilo.org/results.php?q=%s" :keybinding "l")
         (defengine qwant "https://www.qwant.com/?q=%s" :keybinding "q")
         (defengine wikipedia "http://www.wikipedia.org/search-redirect.php?language=fr&go=Go&search=%s" :keybinding "w")
         (defengine youtube "http://www.youtube.com/results?aq=f&oq=&search_query=%s" :keybinding "y"))

(use-package newsticker
  :ensure nil
  :custom
  (newsticker-url-list-defaults nil)
  (newsticker-url-list '(
                         ;; ("title" "URL" other options)
                         ("SécuMondeInfo" "https://www.lemondeinformatique.fr/flux-rss/thematique/internet/rss.xml") 
                         ("AnsiSécu" "https://www.ssi.gouv.fr/feed/actualite/")
                         ("MondeInter" "http://www.lemonde.fr/international/rss_full.xml")
                         ("SimonPuech" "https://www.youtube.com/feeds/videos.xml?channel_id=LeJeuVidéal")
                         ("FuturaEspace" "https://www.futura-sciences.com/rss/espace/actualites.xml")
                         ("EmacsLife" "https://planet.emacslife.com/")
                         ;; ("Reddit - Org-mode" "https://www.reddit.com/r/orgmode.rss")
                         ))

  ;; (newsticker-groups nil)
  (add-hook 'newsticker-mode-hook 'imenu-add-menubar-index)
  ;; (newsticker-new-item-functions '(newsticker-download-images newsticker-download-enclosures))
  ;; (newsticker-new-item-functions nil)

  :config

  ;; pour maj, corrigé dans les dernières versions d'emacs
  (defun newsticker--treeview-list-items-with-age (&rest ages)
    "Actually fill newsticker treeview list window with items of certain age.
    AGES is the list of ages that are to be shown."
    (mapc (lambda (feed)
            (let ((feed-name-symbol (intern (car feed))))
              (mapc (lambda (item)
                      (when (or (memq 'all ages)
                                (memq (newsticker--age item) ages))
                        (newsticker--treeview-list-add-item
                         item feed-name-symbol t)))
                    (newsticker--treeview-list-sort-items
                     (cdr (newsticker--cache-get-feed feed-name-symbol))))))
          (append newsticker-url-list-defaults newsticker-url-list))
    (newsticker--treeview-list-update nil))

  (defun newsticker-treeview-update ()
    "Update all treeview buffers and windows.
  Note: does not update the layout."
    (interactive)
    (let ((cur-item (newsticker--treeview-get-selected-item)))
      (if (newsticker--group-manage-orphan-feeds)
          (newsticker--treeview-tree-update))
      (newsticker--treeview-list-update t)
      (newsticker--treeview-item-update)
      (newsticker--treeview-tree-update-tags)
      (cond (newsticker--treeview-current-vfeed
             (newsticker--treeview-list-items-with-age
              (intern newsticker--treeview-current-vfeed)))
            (newsticker--treeview-current-feed
             (newsticker--treeview-list-items newsticker--treeview-current-feed)))
      (newsticker--treeview-tree-update-highlight)
      (newsticker--treeview-list-update-highlight)
      (let ((cur-feed (or newsticker--treeview-current-feed
                          newsticker--treeview-current-vfeed)))
        (if (and cur-feed cur-item)
            (newsticker--treeview-list-select cur-item)))))


  )

(use-package elfeed
  :config

  (setq elfeed-feeds
        '(("http://nullprogram.com/feed/" blog emacs)
          "http://www.50ply.com/atom.xml"  ; no autotagging
          ("http://nedroid.com/feed/" webcomic)))

  (setq elfeed-feeds nil)

  ;;touche v pour voir une vidéo
  (defun elfeed-v-mpv (url)
    "Watch a video from URL in MPV"
    (async-shell-command (format "mpv %s" url)))

  (defun elfeed-view-mpv (&optional use-generic-p)
    "Youtube-feed link"
    (interactive "P")
    (let ((entries (elfeed-search-selected)))
      (cl-loop for entry in entries
               do (elfeed-untag entry 'unread)
               when (elfeed-entry-link entry)
               do (elfeed-v-mpv it))
      (mapc #'elfeed-search-update-entry entries)
      (unless (use-region-p) (forward-line))))

  (define-key elfeed-search-mode-map (kbd "v") 'elfeed-view-mpv)

  )

(use-package elfeed-org
  :after elfeed
  :config

  (setq rmh-elfeed-org-files (list (concat config-directory "org-elfeed/org-elfeed.org")))
  (setq cp/rmh-elfeed-org-files-output (concat config-directory "org-elfeed/org-elfeed.opml"))

  ;; (cp/elfeed-org-export-opml-with-output)

  ;;pour la ranger dans un fichier
  (defun cp/elfeed-org-export-opml-with-output ()
    "Export Org feeds under `rmh-elfeed-org-files' to a temporary OPML buffer.
        The first level elfeed node will be ignored. The user may need edit the output
        because most of Feed/RSS readers only support trees of 2 levels deep."
    (interactive)
    (let ((opml-body (cl-loop for org-file in rmh-elfeed-org-files
                              concat (rmh-elfeed-org-convert-org-to-opml
                                      (find-file-noselect (expand-file-name org-file))))))

      (save-window-excursion
        (find-file cp/rmh-elfeed-org-files-output)
        (erase-buffer)
        (insert "<?xml version=\"1.0\"?>\n")
        (insert "<opml version=\"1.0\">\n")
        (insert "  <head>\n")
        (insert "    <title>Elfeed-Org Export</title>\n")
        (insert "  </head>\n")
        (insert "  <body>\n")
        (insert opml-body)
        (insert "  </body>\n")
        (insert "</opml>\n")
        (save-buffer)
        )
      ))




  ;; (elfeed-db-unload) ;; à appeler après avoir modifier la database
  ;; (delete-directory "/home/utilisateur/.emacs.d/var/elfeed/db/" t t)
  ;; (elfeed-db-unload)
  ;; (elfeed-db-gc)

  (elfeed-load-opml cp/rmh-elfeed-org-files-output)
  (elfeed-update)

  )

(use-package elfeed-goodies
  :after elfeed
  :config 
  (elfeed-goodies/setup))

(use-package hyperbole
  :config
  (hyperbole-mode 1))

(setq erc-server "irc.libera.chat"
      erc-nick "Cletip"    ; Change this!
      erc-user-full-name "Cletip"  ; And this!
      erc-track-shorten-start 8
      ;;      erc-autojoin-channels-alist '(("irc.libera.chat" "#systemcrafters" "#emacs"))
      erc-kill-buffer-on-part t
      erc-auto-query 'bury)
