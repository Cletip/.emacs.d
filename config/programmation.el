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
