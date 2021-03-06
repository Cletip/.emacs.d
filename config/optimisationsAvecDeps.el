(use-package ispell
  :if (file-exists-p "/usr/bin/hunspell")
  :config
  (setq ispell-program-name "hunspell")
  (setq ispell-local-dictionary "francais")



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
  :hook (lsp-mode . flycheck-mode)
  :config
  (setq
   ;; pas de faute avec les '
   flycheck-grammalecte-report-apos nil
   ;; pas de faute avec les espaces insécable
   flycheck-grammalecte-report-nbsp nil
   ;; pas de faute avec pleins d'espaces et de tab
   flycheck-grammalecte-report-esp nil)
  (flycheck-grammalecte-setup);;chargement de flychek-grammalecte


  ;; pour télécharger grammalect si jamais il n'y est pas déjà. Si il y est, ne fait rien
  (let ((local-version (grammalecte--version))
        (upstream-version (grammalecte--upstream-version)))
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

  ;;à faire pour enlever l'erreur des tirés
  ;; pour enlever l'erreur des des begin_src etc
  (setq flycheck-grammalecte-filters
        '( "(?ims)^[ \t]*#\\+begin_src.+#\\+end_src"
           "(?im)^[ \t]*#\\+begin[_:].+$"
           "(?im)^[ \t]*#\\+end[_:].+$"
           "(?m)^[ \t]*(?:DEADLINE|SCHEDULED):.+$"
           "(?m)^\\*+ .*[ \t]*(:[\\w:@]+:)[ \t]*$"
           "(?im)^[ \t]*#\\+(?:caption|description|keywords|(?:sub)?title):"
           "(?im)^[ \t]*#\\+(?!caption|description|keywords|(?:sub)?title)\\w+:.*$"
           "(?ims)^\- $"

           "-";; éviter l'erreur des tirets
           "\"" ;; éviter les erreurs de "" guillement
           )
        )


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

                    "-";; éviter l'erreur des tirets
                    "\"" ;; éviter les erreurs de "" guillement
                    ))
        )

  (defun flycheck-grammalecte-correct-error-before-point ()
    "Corrige la première erreur avant le curseur"
    (interactive)
    (save-excursion
      (flycheck-previous-error)
      (flycheck-grammalecte-correct-error-at-point (point)) 
      )
    )

  )

(use-package emacs-everywhere)

(use-package keepass-mode)
