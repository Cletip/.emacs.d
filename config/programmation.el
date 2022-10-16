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

  ;;pour de meilleurs performances
  ;; (setq gc-cons-threshold 100000000)
  ;; (setq read-process-output-max (* 1024 1024)) ;; 1mb
  ;; (setq lsp-idle-delay 0.500)
  (setq lsp-log-io nil) ; if set to true can cause a performance hit

  ;; les options, voir le lien au dessus

  ;; (setq lsp-ui-doc-enable nil)
  ;; (setq lsp-ui-doc-show-with-cursor nil) ;; enlever les gros pavés qui se mettent à chaque fois
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
  ;; (lsp-treemacs-sync-mode 1)	 
  )

;; (use-package lsp-jedi
  ;; :config
  ;; (with-eval-after-load "lsp-mode"
    ;; (add-to-list 'lsp-disabled-clients 'pyls)
    ;; (add-to-list 'lsp-enabled-clients 'jedi)))

(setq python-shell-interpreter "/usr/bin/python3")

;; pour éviter les erreurs de doctstring	
(setq lsp-pylsp-plugins-pydocstyle-enabled nil)

;; (use-package aggressive-indent-mode)
;; (add-hook 'java-mode-hook #'aggressive-indent-mode)



  ;; pour corriger la variable $JAVA_HOME avec asdf. a supprimer ?
  (use-package exec-path-from-shell
    :after lsp-mode org-roam
    :config
    (exec-path-from-shell-initialize)
    )
  ;; (when (daemonp)
  ;; (exec-path-from-shell-initialize)
  ;; )

  (use-package lsp-java
    :config
    ;; (setq lsp-java-jdt-download-url  "https://download.eclipse.org/jdtls/milestones/0.57.0/jdt-language-server-0.57.0-202006172108.tar.gz")
    )

;; (use-package lsp-javascript-typescript)

(use-package company
  :after lsp-mode  ;;si ya lsp-mode
  :hook (lsp-mode . company-mode)  ;; au lieu de lsp, mettre c-mode, python mode etc
  ;; (org-mode . company-mode)
  :custom
  (company-minimum-prefix-length 1) ;;taille avant que le popup arrive
  (company-idle-delay 0.6);;temps avant qu'il pop
  ;;pour cycler dans les sélections
  (company-selection-wrap-around t)



  ;; réglemeent des touches, assez explicite, sur azerty :
  ;; k i s 
  (define-key company-active-map (kbd "M-n") nil)
  (define-key company-active-map (kbd "M-p") nil)
  ;; (define-key company-active-map (kbd "s") #'company-select-next)
  ;; (define-key company-active-map (kbd "d") #'company-select-previous)
  (define-key company-active-map (kbd "C-s") #'company-select-next)
  (define-key company-active-map (kbd "C-d") #'company-select-previous)
  (define-key company-active-map (kbd "u") 'company-complete-selection)
  ;; (define-key company-active-map (kbd "SPC") #'company-abort)

  )

(use-package company-box
  :after company ;;logique
  :hook (company-mode . company-box-mode) ;;logique également
  )

(use-package company-prescient
  :after company
  :config
  (company-prescient-mode 1)
  ;; Remember candidate frequencies across sessions
  (prescient-persist-mode 1)
  )

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

(use-package projectile
  :config
  ;; (projectile-global-mode)
  ;;(setq projectile-completion-system 'ivy)
  )

(use-package page-break-lines
  :hook ((emacs-lisp-mode . page-break-lines-mode)))

(use-package prism
  :config

  ;; (setq prism-parens t) ;; color les parenthèses. Couleurs pas assez "forte"

  (defun cp/prism-set-colors ()
    (interactive)
    "DOCSTRING"
    (prism-set-colors :num 16
      :desaturations (cl-loop for i from 0 below 16
                              collect (* i 2.5))
      :lightens (cl-loop for i from 0 below 16
                         collect (* i 2.5))
      :colors (list  "OrangeRed3" "sandy brown" "dodgerblue")

      :comments-fn
      (lambda (color)
        (prism-blend color
                     (face-attribute 'font-lock-comment-face :foreground) 0.25))

      :strings-fn
      (lambda (color)
        (prism-blend color "white" 0.5))))

  (add-hook 'prism-mode-hook 'cp/prism-set-colors)
  )

(use-package rainbow-delimiters
:config
(add-hook 'emacs-lisp-mode-hook 'rainbow-delimiters-mode)
(add-hook 'scheme-mode-hook 'rainbow-delimiters-mode))

;; variable pour mettre mon mode elisp. ici, ce sera xah-elisp-mode. Si jamais
;; un jour je veux le changer, ce sera fait en une variable
(setq cp/emacs-lisp-mode "xah-elisp-mode")

(use-package xah-elisp-mode

  :config
  ;; activer xah-elisp-mode à la place de emacs-lisp-mode. fait par défaut

  ;; copie hook of emacs-lisp-mode
  (dolist (hook emacs-lisp-mode-hook)
    (unless (string-equal hook "xah-elisp-mode")
      (add-hook 'xah-elisp-mode-hook hook)))

  ;; àjouter le correcteur de flycheck à xah-elisp-mode
  (flycheck-add-mode 'emacs-lisp 'xah-elisp-mode)

  (add-hook 'xah-elisp-mode-hook 'company-mode)
  (add-hook 'xah-elisp-mode-hook 'prism-mode)

  ;; (setq ido-enable-flex-matching t) ;; activer la recherche de mots avec le fuzzy search, désactiver car usage de vertico

  ;;

  )


