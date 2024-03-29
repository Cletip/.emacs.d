(use-package ispell
  :if (file-exists-p "/usr/bin/hunspell")
  :config
  (setq ispell-program-name "hunspell")

  (setq ispell-dictionary "francais")



  (if (file-exists-p "/usr/bin/hunspell")                                         
      (progn
        (setq ispell-program-name "hunspell")
        (setq ispell-local-dictionary "francais")
        ))

  (setq ispell-local-dictionary-alist- 
        '(("francais" "[[:alpha:]]" "[^[:alpha:]]" "[']" nil ("-d" "fr") nil utf-8)
          ("en_US" "[[:alpha:]]" "[^[:alpha:]]" "[']" nil ("-d" "en_US") nil utf-8)
          ))


  ;;Switch de dico 
  (defun switch-dictionary-fr-en ()
    "Switch french and english dictionaries."
    (interactive)
    (let* ((dict ispell-current-dictionary)
           (new (if (string= dict "francais") "en_US"
                  "francais")))
      (ispell-change-dictionary new)
      (message "Switched dictionary from %s to %s" dict new)))



  ;; Montrer les fautes en soulignant les mots faux 
  (add-hook 'text-mode-hook 'flyspell-mode)
  ;; (add-hook 'prog-mode-hook 'flyspell-prog-mode)


  ;; meilleur correction qui respecte l'interface de complétion
  (use-package flyspell-correct
    :after flyspell
    :bind (:map flyspell-mode-map ("C-;" . flyspell-correct-wrapper)))


  ;; Highlight BUG FIXME TODO NOTE keywords in the source code.
  (add-hook 'find-file-hook
            (lambda()
              (highlight-phrase "\\(BUG\\|FIXME\\|TODO
         ;;   \\|NOTE
         \\):")))
  )

(use-package flycheck
  :config
  (global-flycheck-mode t)
  )

(use-package flycheck-grammalecte
  ;; :hook (lsp-mode . flycheck-mode) ;; aucun sens avec le précédent
  :after flycheck
  :config

  ;; je sais pas pourquoi mais besoin de
  (when termux-p
    (flycheck-mode))

  (setq
   ;; pas de faute avec les '
   flycheck-grammalecte-report-apos nil
   ;; pas de faute avec les espaces insécable
   flycheck-grammalecte-report-nbsp nil
   ;; pas de faute avec pleins d'espaces et de tab
   flycheck-grammalecte-report-esp nil)
  (flycheck-grammalecte-setup) ;;chargement de flychek-grammalecte

  ;;d'abord vérifier que ça existe. si existe pas, download
  (unless (fboundp 'grammalecte--version)
    (grammalecte-download-grammalecte))

  ;; pour télécharger grammalect si jamais il n'y est pas déjà. Si il y est, ne fait rien
  (let ((local-version (grammalecte--version))
        (upstream-version
         ;; (grammalecte--upstream-version) ;; prend beaucoup de temps, mais remettre ça
         (grammalecte--version)))
    (when (stringp upstream-version)
      (if (stringp local-version)
          ;; It seems we have a local version of grammalecte.
          ;; Compare it with upstream
          (when (and (string-version-lessp local-version upstream-version)
                     (or grammalecte-download-without-asking
                         (yes-or-no-p
                          "[Grammalecte] Grammalecte is out of date.  Download it NOW?")))
            (grammalecte-download-grammalecte upstream-version))
        ;; It seems there is no currently downloaded Grammalecte
        ;; package. Force install it, as nothing will work without it.
        (grammalecte-download-grammalecte upstream-version))))

  ;;flycheck-grammalecte--convert-elisp-rx-to-python

  (setq flycheck-grammalecte-filters '(
                                       "\""   ;; éviter les erreurs de "" guillement

                                       ))


  ;;à faire pour enlever l'erreur des tirés
  ;; pour enlever l'erreur des des begin_src etc
  ;; cela doit être des regex pytohn !!
  ;; (setq flycheck-grammalecte-filters
  ;;       `("(?ims)^[ \t]*#\\+begin_src.+#\\+end_src"
  ;;         "(?im)^[ \t]*#\\+begin[_:].+$"
  ;;         "(?im)^[ \t]*#\\+end[_:].+$"
  ;;         "(?m)^[ \t]*(?:DEADLINE|SCHEDULED):.+$"
  ;;         "(?m)^\\*+ .*[ \t]*(:[\\w:@]+:)[ \t]*$"
  ;;         "(?im)^[ \t]*#\\+(?:caption|description|keywords|(?:sub)?title):"
  ;;         "(?im)^[ \t]*#\\+(?!caption|description|keywords|(?:sub)?title)\\w+:.*$"
  ;;         "(?ims)^\- $"

  ;;         "-"				 ;; éviter l'erreur des tirets
  ;;         "\""				 ;; éviter les erreurs de "" guillement
  ;;         "\[\[([^][]+)\]\[([^][]+)\]\]" ;; éviter les erreurs avec les liens
  ;;         ;; ,(regexp-emacs-to-python org-link-bracket-re)
  ;;         ))

  (setq flycheck-grammalecte-filters-by-mode
        `((org-mode "(?ims)^[ \t]*#\\+begin_src.+#\\+end_src"
                    "(?im)^[ \t]*#\\+begin[_:].+$"
                    "(?im)^[ \t]*#\\+end[_:].+$"
                    "(?m)^[ \t]*(?:DEADLINE|SCHEDULED):.+$"
                    "(?m)^\\*+ .*[ \t]*(:[\\w:@]+:)[ \t]*$"
                    "(?im)^[ \t]*#\\+(?:caption|description|keywords|(?:sub)?title):"
                    "(?im)^[ \t]*#\\+(?!caption|description|keywords|(?:sub)?title)\\w+:.*$"
                    "(?ims)^\- $"

                    "-"    ;; éviter l'erreur des tirets
                    ;; "\""   ;; éviter les erreurs de "" guillement

                    ;; "\[\[([^][]+)\]\[([^][]+)\]\]" ;; éviter les erreurs avec les liens
                    ;; "\[\[([^][]+)\]\]"
                    ;;                       "\[\[([^][]+)\]\[([^][]+)\]\]"
                    ;; ;
  ; ,org-link-bracket-re
                    ;; "\[\[(.*?)\]\]|\[\[(.*?)\]\[(.*?)\]\]"
                    ;; "\[\[[^\[\]]+:[^\[\]]+\]\](?:\[\w+\])?"
                    ;; "\[.*\:.*\]"
                    ;; ,(flycheck-grammalecte--convert-elisp-rx-to-python org-link-bracket-re)

                    )))

  (defun flycheck-grammalecte-correct-error-before-point ()
    "Corrige la première erreur avant le curseur"
    (interactive)
    (save-excursion
      (flycheck-previous-error)
      (flycheck-grammalecte-correct-error-at-point (point))))

  ;; correction bug pas de correction entre deux blocs de codes org-mode, TODO ne marche tjr pas
  ;; (setq flycheck-grammalecte-filters-by-mode
  ;; '((latex-mode "\\\\(?:title|(?:sub)*section){([^}]+)}"
  ;; "\\\\\\w+(?:\\[[^]]+\\])?(?:{[^}]*})?")
  ;; (org-mode "(?ims)^[ \t]*#\\+begin_src.*?#\\+end_src"
  ;; "(?im)^[ \t]*#\\+begin[_:].+$"
  ;; "(?im)^[ \t]*#\\+end[_:].+$"
  ;; "(?m)^[ \t]*(?:DEADLINE|SCHEDULED):.+$"
  ;; "(?m)^\\*+ .*[ \t]*(:[\\w:@]+:)[ \t]*$"
  ;; "(?im)^[ \t]*#\\+(?:caption|description|keywords|(?:sub)?title):"
  ;; "(?im)^[ \t]*#\\+(?!caption|description|keywords|(?:sub)?title)\\w+:.*$")
  ;; (message-mode "(?m)^[ \t]*(?:[\\w_.]+>|[]>|]).*")))

  )

(use-package emacs-everywhere)

(use-package keepass-mode)

(when (not termux-p)

  (use-package deferred)
  (use-package epc)

  (use-package chatgpt
    ;; :if (not termux-p)
    :after epc deferred
    :straight (:host github :repo "joshcho/ChatGPT.el" :files ("dist" "*.el"))
    :init
    (setq chatgpt-repo-path "~/.emacs.d/straight/repos/ChatGPT.el/")
    ;; :bind ("C-c q" . chatgpt-query)
    :config
    (setq chatgpt-python-interpreter "python3")
    (setq chatgpt-query-format-string-map
          '(
            ;; ChatGPT.el defaults
            ("doc" . "Please write the documentation for the following function.\n\n%s")
            ("bug" . "There is a bug in the following function, please help me fix it.\n\n%s")
            ("understand" . "What does the following do?\n\n%s")
            ("improve" . "Please improve that.\n\n%s")
            ;; your new prompt
            ("my-custom-type" . "My custom prompt.\n\n%s"))))
  )
