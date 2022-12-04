;; ============================================================
;; Don't edit this file, edit config.org' instead ...
;; Auto-generated at sam. mars 12 2022-03-12T12:43:19  on host utilisateur-GL65-Leopard-10SER
;; ============================================================



;; #####################################################################################
(message "config • Les variables des chemins des fichiers, et c'est tout (normalement si je rerespect bien l'organisation de mes fichiers) …")

  
  (setq my-user-emacs-configuration (concat my-user-emacs-directory "config.org"))
  ;; besoin d'une "liste " pour faire certaines choses sur mes fichiers de config emacs
  (setq my-user-emacs-configuration-list (list my-user-emacs-configuration))


  (if (file-exists-p "~/mesdocuments/")
      (progn 
        (setq mesdocuments-directory "~/mesdocuments/");; pour que tous les liens fonctionnes
        )
    (progn
      ;; (setq mesdocuments-directory nil)
      ;;quand c'est vide ça retourne nil
      )
    )
  ;;pour que les captures fonctionne
  (if (file-exists-p "~/sharedDirectoryPrivate/notes")
      (progn 
        (setq org-directory "~/sharedDirectoryPrivate/notes/")
        )
    (progn 
      ;;quand c'est vide ça retourne nil
      )
    )

  ;;est ce que j'ai un dossier partagé perso ? 
  (if (file-exists-p "~/sharedDirectoryPrivate")
      (progn 
        (setq shared-directory-private "~/sharedDirectoryPrivate/")
        )
    (progn 
      ;;quand c'est vide ça retourne nil
      )
    )


  ;;où sont mes fichiers org accessible sur mon téléphone ?
  (if (and (boundp 'shared-directory-private) (file-exists-p (concat shared-directory-private "notes/org/orgzly")))
      (progn 
        (setq orgzly-directory (concat shared-directory-private "notes/org/orgzly/"))
        )
    (progn 
      ;;quand c'est vide ça retourne nil
      )
    )


  ;;est ce que ma braindump existe ?
  (if (and (boundp 'org-directory) (file-exists-p (concat org-directory "zettelkasten/")))
      (progn 
        (setq org-roam-directory (concat org-directory "zettelkasten/"))
        )
    (progn
      (setq org-roam-directory nil)
      ;;quand c'est vide ça retourne nil
      )
    )

  ;; (setq org-roam-directory (concat org-directory "zettelkasten/"))


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


  (if (boundp 'mesdocuments-directory) ;; condition par pas qu'il y est de bug
      (progn (setq ;;cas du oui
              mesdocuments-directory-all-org-files ;; qu'elle variable je définie ? X-directory + all-org-files
              (append (sa-find-org-file-recursively
                       mesdocuments-directory "org")
                      )))
    (progn 
      (setq mesdocuments-directory-all-org-files nil) ;;sinon je mets X-directory + all-org-files à nul
      )
    )

  (if (boundp 'org-directory) ;; condition par pas qu'il y est de bug
      (progn (setq ;;cas du oui
              org-directory-all-org-files ;; qu'elle variable je définie ? X-directory + all-org-files
              (append (sa-find-org-file-recursively
                       org-directory "org")
                      )))
    (progn 
      (setq org-directory-all-org-files nil) ;;sinon je mets X-directory + all-org-files à nul
      )
    )


  (if (and (boundp 'shared-directory-private) shared-directory-private) ;; condition par pas qu'il y est de bug
      (progn (setq ;;cas du oui
              shared-directory-private-all-org-files ;; qu'elle variable je définie ? X-directory + all-org-files
              (append (sa-find-org-file-recursively
                       shared-directory-private "org")
                      )))
    (progn 
      (setq shared-directory-private nil) ;;sinon je mets X-directory + all-org-files à nul
      )
    )

  (if (and (boundp 'org-directory) org-directory) ;; condition par pas qu'il y est de bug
      (progn (setq ;;cas du oui
              orgzly-directory-all-org-files ;; qu'elle variable je définie ? X-directory + all-org-files
              (append (sa-find-org-file-recursively
                       orgzly-directory "org")
                      )))
    (progn 
      (setq orgzly-directory-all-org-files nil) ;;sinon je mets X-directory + all-org-files à nul
      )
    )

  (if (and (boundp 'org-roam-directory) org-roam-directory) ;; condition par pas qu'il y est de bug
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
(message "config • Bug connu : …")

     (setq org-element-use-cache nil)


;; #####################################################################################
(message "config • ACTIVE Fonction pour tangle la suite, =indispensable= ! …")


  ;; où est le dossier des fichiers de config ?
  (setq my-user-emacs-config-directory (concat my-user-emacs-directory "config/"))

  (defun my-tangle-a-file-of-config-org (file)
    "This function will write all source blocks from =config.org= into =config.el= that are ...
      - not marked as =tangle: no=
      - doesn't have the TODO state =DISABLED=
      - have a source-code of =emacs-lisp="
    (require 'org)
    (let* ((body-list ())
           (output-file (concat my-user-emacs-config-directory (concat file ".el")))
           (input-file (concat my-user-emacs-config-directory (concat file ".org")))
           (org-babel-default-header-args (org-babel-merge-params org-babel-default-header-args
                                                                  (list (cons :tangle output-file)))))
      (message "—————• Re-generating %s …" output-file)
      (save-restriction
        (save-excursion
          (org-babel-map-src-blocks input-file
            (let* (
                   (org_block_info (org-babel-get-src-block-info 'light))
                   ;;(block_name (nth 4 org_block_info))
                   (tfile (cdr (assq :tangle (nth 2 org_block_info))))
                   (match_for_TODO_keyword)
                   )
              (save-excursion
                (catch 'exit
                  ;;(when (string= "" block_name)
                  ;;  (message "Going to write block name: " block_name)
                  ;;  (add-to-list 'body-list (concat "message(\"" block_name "\")"));; adding a debug statement for named blocks
                  ;;  )
                  (org-back-to-heading t)
                  (when (looking-at org-outline-regexp)
                    (goto-char (1- (match-end 0))))
                  (when (looking-at (concat " +" org-todo-regexp "\\( +\\|[ \t]*$\\)"))
                    (setq match_for_TODO_keyword (match-string 1)))))
              (unless (or (string= "no" tfile)
                          (string= "DISABLED" match_for_TODO_keyword)
                          (not (string= "emacs-lisp" lang)))
                (add-to-list 'body-list (concat "\n\n;; #####################################################################################\n"
                                                "(message \"config • " (org-get-heading) " …\")\n\n")
                             )
                (add-to-list 'body-list body)
                ))))
        (with-temp-file output-file
          (insert ";; ============================================================\n")
          (insert ";; Don't edit this file, edit config.org' instead ...\n")
          (insert ";; Auto-generated at " (format-time-string current-date-time-format (current-time)) " on host " system-name "\n")
          (insert ";; ============================================================\n\n")
          (insert (apply 'concat (reverse body-list))))
        (message "—————• Wrote %s" output-file))))

  ;; when config.org is saved, re-generate the X.el:
  (defun my-tangle-a-file-of-config-org-hook-func (file)
    (message "%s" file)
    (when (string= (concat file ".org") (buffer-name))
      (let (
            (orgfile (concat my-user-emacs-config-directory (concat file ".org")))
            (elfile (concat my-user-emacs-config-directory (concat file ".el")))
            )
        (my-tangle-a-file-of-config-org file)
        )))
  
  (defun export-and-load-and-hook (file)
    (let (
          ;;création des fichiers de base
          (orgfile (concat my-user-emacs-config-directory (concat file ".org")))
          (elfile (concat my-user-emacs-config-directory (concat file ".el")))
          (gc-cons-threshold most-positive-fixnum))

      ;; création du fichier si jamais ça marche pas
      (when (or (not (file-exists-p elfile))
                (file-newer-than-file-p orgfile elfile))
        (my-tangle-a-file-of-config-org file)
        )
      ;;chargement du fichier
      (load-file elfile)
      )
    ;; (add-hook 'after-save-hook '(my-tangle-a-file-of-config-org-hook-func-"file"))
    (add-hook 'after-save-hook (apply-partially #'my-tangle-a-file-of-config-org-hook-func file))
    )



;; #####################################################################################
(message "config • ACTIVE Raccourcis …")

(export-and-load-and-hook "raccourcis")


;; #####################################################################################
(message "config • ACTIVE Optimisation de base …")


(export-and-load-and-hook "basicOptimisations")
 


;; #####################################################################################
(message "config • ACTIVE Optimisation de base, mais avec des dépendances …")


  (export-and-load-and-hook "basicOptimisationsAvecDep")



;; #####################################################################################
(message "config • ACTIVE Org-mode …")


  (export-and-load-and-hook "org-mode")



;; #####################################################################################
(message "config • ACTIVE Programmations …")

(export-and-load-and-hook "programmation")
