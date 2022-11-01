;; ============================================================
;; Don't edit this file, edit config.org' instead ...
;; Auto-generated at Fri Mar 11 2022-03-11T16:16:48  on host utilisateur-GL65-Leopard-10SER
;; ============================================================



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


    ;; pour corriger la variable $JAVA_HOME
    (use-package exec-path-from-shell
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


;; #####################################################################################
(message "config • Le moteur …")


  (use-package company
    :after lsp-mode  ;;si ya lsp-mode
    :hook (lsp-mode . company-mode)  ;; au lieu de lsp, mettre c-mode, python mode etc
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
    (define-key company-active-map (kbd "SPC") #'company-abort)

    )


  ;; ne pas y mettre dans :config
  (with-eval-after-load 'company
    ;;pour =activer les yasnippets dans company !!!!!!=
    (setq lsp-completion-provider :none)
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
  
