;; ============================================================
;; Don't edit this file, edit config.org' instead ...
;; Auto-generated at Thu Mar 10 2022-03-10T12:14:46  on host utilisateur-GL65-Leopard-10SER
;; ============================================================



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
         mesdocuments-directory-all-org-files
         org-directory-all-org-files
         shared-directory-private-all-org-files
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
          (mesdocuments-directory-all-org-files :maxlevel . 1)
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
(message "config • Ignorer les headline avec le tag ignore: …")

  (with-eval-after-load 'org-contrib
    (require 'ox-extra)
    (ox-extras-activate '(ignore-headlines))
    )


;; #####################################################################################
(message "config • Html …")

  (use-package htmlize
    :config
    (setq org-html-doctype "html5")
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
  ;; (variable-pitch-mode 1)

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
    (set-face-attribute (car face) nil :font "Fira Mono" :weight 'medium :height (cdr face))
    )


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



;; #####################################################################################
(message "config • Optimisation de base …")


  ;; Nouvelle touche pour mieux naviguer avec xah
  (define-key org-agenda-mode-map [remap next-line] #'org-agenda-next-item)
  (define-key org-agenda-mode-map [remap previous-line] #'org-agenda-previous-item)
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
  (setq org-icalendar-combined-agenda-file (expand-file-name "agendapourgoogle.ics" shared-directory-private))

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
  ;; impossible de faire fonctionner la fonction en background... ne vient pas de ma config (du moins brute, peut-être le fait de l'export bizarrement. Même pas enfait car le init.el est chargé), ni des fichiers, ni de la version de org. WTF
  ;; (add-hook 'dashboard-mode-hook #'org-icalendar-combine-agenda-files-background)

  ;; TODO changer ce hook, car quand pas dashboard fonctionne pas
  ;; (add-hook 'dashboard-mode-hook #'org-icalendar-combine-agenda-files-foreground)

  ;; quand je close emacs
  (add-hook 'kill-emacs-hook #'org-icalendar-combine-agenda-files-foreground)



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


    ;; ça sert à qqch ça ?
    ;;on doit renvoyer une liste pour celui ci attention !
    (setq org-contacts-files (list(concat orgzly-directory "Contacts.org")))
    ;; 
    (setq org-contacts-vcard-file (concat orgzly-directory "Contacts.vcf"))
    )


;; #####################################################################################
(message "config • Export en vcard compris par google contact (.vcf files to .org marche aussi), en ce moment bug mais normalement ça marche …")


  (use-package org-vcard
    :init
    ;;la version utilisée (pour pouvoir y envoyer sur google)
    (setq org-vcard-default-version "3.0")
    :config
    (setq org-vcard-default-export-file (concat orgzly-directory "Contacts.vcf"))
    )




;; #####################################################################################
(message "config • Moteur de Org-capture …")


  ;;mettre mes template directement ici et pas dans templatesOrgCapture ?
  ;; quand on donne un truc relatif, alors le org-directory est bien appelé !
  ;; templatesOrgCapture dans Notes, car comme ça marchera partout

  (setq org-capture-templates '
        (


         ("t" "Pour les timestamps")
         ("tt" "Tickler" entry
          (file (lambda() (concat orgzly-directory "AgendaTickler.org")))
          (file "templatesOrgCapture/tickler.org")
          :immediate-finish t
          )
         ("te" "Évènement sur plusieurs heures" entry
          (file (lambda() (concat orgzly-directory "AgendaTickler.org")))
          (file "templatesOrgCapture/evenement.org")
          :immediate-finish t
          )

         ("td" "Évènement sur plusieurs jours" entry
          (file (lambda() (concat orgzly-directory "AgendaTickler.org")))
          (file "templatesOrgCapture/evenementplusieursjours.org")
          :immediate-finish t
          )


         ("i" "Inbox (TODO)" entry
          (file (lambda() (concat orgzly-directory "Inbox.org")))
          (file "templatesOrgCapture/todo.org")
          :immediate-finish t
          )
         ("n" "Inbox (NEXT)" entry
          (file (lambda() (concat orgzly-directory "Inbox.org")))
          (file "templatesOrgCapture/next.org")
          :immediate-finish t
          )

         ("s" "Slipbox for org-roam" entry  (file "braindump/org/inbox.org")
          "* %?\n")

         ("d" "Journal de dissactifaction" entry (file  "org/journal_de_dissatisfaction.org")
          "* %<%Y-%m-%d> \n- %?")

         ("c" "Contacts" entry
          (file+headline (lambda() (concat orgzly-directory "Contacts.org" ))"Inbox")
          (file "templatesOrgCapture/contacts.org")
          ;; :immediate-finish t
          ;; :jump-to-captured t
          )

         ("a" "Image dans Artiste")

         ("at" "Image + artiste" entry (file  "org/artistes.org" )
          (file "templatesOrgCapture/artistes.org")
          :jump-to-captured 1
          )

         ("as" "Image" entry (file "org/artistes.org" )
          (file "templatesOrgCapture/image.org")
          ;; :jump-to-captured 1
          )

         ;; ici se trouve les choses utilisé pour org-protocol
         ;; pour mes raccourcis
         ("O" "Link capture" entry
          (file+headline "org/orgzly/Bookmarks.org" "INBOX")
          "* %a %U"
          :immediate-finish t)


         ;; ("P" "org-popup" entry (file+headline "braindump/org/inbox.org" "Titled Notes")
         ;; "%[~/.emacs.d/.org-popup]" :immediate-finish t :prepend t)
         )
        )




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
      (when (string= key "as") 		;etc
        (org-capture-goto-last-stored)
        (newline)
        (newline)
        (org-download-clipboard)
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
          (mesdocuments-directory-all-org-files :maxlevel . 1)
          (org-directory :maxlevel . 1)
          (orgzly-directory-all-org-files :maxlevel . 8)
          ;; pour refile document_partage
          (shared-directory-private-all-org-files :maxlevel . 5)
          )
        )



;; #####################################################################################
(message "config • Gestion des images de fond d'écran/cool avec org-mode …")


    (use-package org-download
      :config

      ;; pour enlever la description de l'image


      (defun dummy-org-download-annotate-function (link)
        "")

      (defun org-download-annotate-default (link)
    "Annotate LINK with the time of download."
    (format "#+DOWNLOADED: %s @ %s\n"
            (if (equal link org-download-screenshot-file)
                "screenshot"
              link)
            (format-time-string "%Y-%m-%d %H:%M:%S"))
    (message "%s" link)
    )
      ;; setq in doom emacs
      ;; (setq org-download-annotate-function #'dummy-org-download-annotate-function)


      )

  



;; #####################################################################################
(message "config • Org protocol, pour liéer org-mode et le navigateur web …")

  (require 'org-protocol)


;; #####################################################################################
(message "config • Org roam(moteur) …")


  (use-package org-roam
    :if (file-exists-p (concat org-directory "zettelkasten/")) ;; je charge seulement si ya bien un dossier org roam
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
    :after oc-csl all-the-icons
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
      (plist-put org-hugo-citations-plist :bibliography-section-heading "References"))

    :config
    (setq org-cite-global-bibliography my-bibliography-list) ;; pour que org-cite sache où est ma biblio
    (setq org-cite-export-processors '((t csl)));; exporter tout le temps avec la méthode csl

    ;; les fichiers de configuration. Impossible de les configurer "normalement" (voir en dessous), j'utilise donc les fichiers "fallback" qui sont ceux par défaut
    ;; (setq org-cite-csl--fallback-style-file "/home/msi/documents/notes/braindump/org/chicago-author-date-16th-edition.csl") ;;


    ;;à remettre
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
