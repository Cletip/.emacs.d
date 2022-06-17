(setq org-directory (expand-file-name "org/" braindump-directory))

(setq org-roam-directory org-directory)

(setq my-bibliography-list (list (expand-file-name "biblio.bib" config-directory)
                                 ;; "/path/to/another/"
                                 ;; "/path/to/another/"
                                 )
      )

(use-package vulpea
  :if braindump-exists
  :straight (vulpea
             :type git
             :host github
             :repo "d12frosted/vulpea")
  ;; hook into org-roam-db-autosync-mode you wish to enable
  ;; persistence of meta values (see respective section in README to
  ;; find out what meta means)
  :hook ((org-roam-db-autosync-mode . vulpea-db-autosync-enable))
  :config
  (defun org-roam-vulpea-bdd ()
    (interactive)
    "Mets à jour la bdd pour l'utilisation de velpua"
    (org-roam-db-sync 'force)
    )
  )
(require 'vulpea) ;;sinon ne charge pas tout je comprends pas pk

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

(require 'org-tempo)

(add-to-list 'org-structure-template-alist '("sh" . "src sh"))
(add-to-list 'org-structure-template-alist '("cd" . "src C"))
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("sc" . "src scheme"))
(add-to-list 'org-structure-template-alist '("ts" . "src typescript"))
(add-to-list 'org-structure-template-alist '("py" . "src python"))
(add-to-list 'org-structure-template-alist '("yaml" . "src yaml"))
(add-to-list 'org-structure-template-alist '("json" . "src json"))

(use-package org-sidebar)

;;chargement d'une bibliothèque
;; (add-to-list 'org-modules 'org-fold)

(defun org-meta-return (&optional arg)
  "Insert a new heading or wrap a region in a table.
  Calls `org-insert-heading', `org-insert-item' or
  `org-table-wrap-region', depending on context.  When called with
  an argument, unconditionally call `org-insert-heading'."
  (interactive "P")
  ;; (org-fold-check-before-invisible-edit 'insert)
  (or (run-hook-with-args-until-success 'org-metareturn-hook)
      (call-interactively (cond (arg #'org-insert-heading)
                                (current-prefix-arg #'org-insert-heading)
                                ((org-at-table-p) #'org-table-wrap-region)
                                ((org-in-item-p) #'org-insert-item)
                                (t #'org-insert-heading-after-current)))))

;; (use-package org-bullets
  ;; :after org
  ;; :hook(org-mode . org-bullets-mode)
  ;; :config

  ;; (setq org-bullets-bullet-list '("◉" "✸" "☯" "✿" "✜" "◆" "▶"))
  ;; (setq org-bullets-bullet-list '("◉" "○" "✸" "✜" "◆" "▶"))
  ;; )

(use-package org-superstar
    :after org
    :hook (org-mode . org-superstar-mode)
    :config
    (setq org-superstar-headline-bullets-list '("◉" "○" "✸" "✜" "◆" "▶"))
      ;; (set-face-attribute 'org-superstar-header-bullet nil :inherit 'fixed-pitched :height 200)

    ;; :custom
    ;; set the leading bullet to be a space. For alignment purposes I use an em-quad space (U+2001)
    ;; (org-superstar-headline-bullets-list '(" "))
    ;; (org-superstar-todo-bullet-alist '(("DONE" . ?✔)
                                       ;; ("TODO" . ?⌖)
                                       ;; ("NEXT" . ?)
                                       ;; ("ISSUE" . ?)
                                       ;; ("BRANCH" . ?)
                                       ;; ("FORK" . ?)
                                       ;; ("MR" . ?)
                                       ;; ("MERGED" . ?)
                                       ;; ("GITHUB" . ?A)
                                       ;; ("WRITING" . ?✍)
                                       ;; ("WRITE" . ?✍)
                                       ;; ))
    ;; (org-superstar-special-todo-items t)
    ;; (org-superstar-leading-bullet "")

    )

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

(setq org-hide-emphasis-markers t)
(straight-use-package '(org-appear :type git :host github :repo "awth13/org-appear"))
(add-hook 'org-mode-hook 'org-appear-mode)

;;affiche les liens entier avec t
;; (setq org-appear-autolinks t)

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
  ;; (set-face-attribute (car face) nil :font "JetBrains Mono" :weight 'medium :height (cdr face))
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

(setq org-ellipsis "⬎")

;; (setq org-ellipsis " ")

(setq org-startup-with-inline-images t)
(setq org-image-actual-width 800)

(use-package org-fragtog
  :hook (org-mode . org-fragtog-mode)
  )

(add-hook 'org-mode-hook 'org-indent-mode)
(diminish org-indent-mode)

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

(setq org-confirm-babel-evaluate nil)

(setq org-src-tab-acts-natively t)

(setq org-src-fontify-natively t)

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
                   ("\\subparagraph{%s}" . "\\subparagraph*{%s}"))

)

)

(with-eval-after-load 'org-contrib
  (require 'ox-extra)
  (ox-extras-activate '(ignore-headlines))
  )

(use-package htmlize
  :config
  (setq org-html-doctype "html5")
  (setq org-html-indent nil) ;;indentation du code automatiquement si sur t, mais tue l'indentation des balise exemple, python etc
  )

(use-package ox-twbs)

(use-package ox-epub)

(when braindump-exists

(setq org-id-method 'ts)
(setq org-id-ts-format "%Y%m%d%H%M%S%6N") ;; le 6N est présent pour être sûr que se soit unique

(setq org-id-locations-file-relative t)

;; (org-roam-update-org-id-locations) ;; =  org-directory and org-roam-directory
(org-id-update-id-locations)


;; seul transclude en a besoin. Peut peut-être ralentir les choses

(advice-add 'org-transclusion-add :before #'org-id-update-id-locations)

;; This implies that when that function is executed, the files whose
;; content is searched for IDs (i.e. they are scanned) are
;;
;; + The files mentioned in =org-agenda-files=.
;; + The archives associated to the files in =org-agenda-files=.
;; + The files mentioned in =org-id-locations=.
;; + The files provided as arguments to the =org-id-update-id-locations=.
;;
;; The following are not mentioned in the documentation of
;; =org-id-update-id-locations=, but when looking at the source code, you
;; can see that the value of the following variables is used
;;
;; + =org-id-extra-files=
;; + =org-id-files=
;;

;; (setq org-id-files (org-roam-list-files))

;;plus propre d'y mettre dans les extras
(setq org-id-extra-files (append(directory-files-recursively config-directory "org$") (org-roam-list-files)))

;; Update ID file .org-id-locations on startup
;; (org-id-update-id-locations)

(setq capture-inbox-file
    (expand-file-name (format "inbox-%s.org" (system-name)) org-roam-directory)
    )

;; (setq org-capture-templates
      ;; '(("t" "todo" plain (file capture-inbox-file)
         ;; "* TODO %?\n%U\n" )))

;; quand on donne un truc relatif, alors le org-directory est bien appelé ! Si je mets des fonctions pour les templates à récupéré ça ne marche plus. Obligé de laisser les capture templates dans le dossier braindump et en dehors du dossier org-directory (sinon la bdd dit double id)



;;les raccourcis ici ne sont pas important, mais doivent faire le liens entre TODO

;; (setq org-capture-templates-models (expand-file-name "templatesOrgCapture/" user-emacs-directory))

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
        (file capture-inbox-file)
        (file "../templatesOrgCapture/next.org")
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

;; (add-hook 'org-capture-after-finalize-hook 'cp/org-capture-finalize)

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

;;Lieu de l'export org-icalendar-combine-agenda-files
(setq org-icalendar-combined-agenda-file (expand-file-name "agendapourgoogletest.ics" braindump-directory))

  (setq org-icalendar-with-timestamps 'active) ;; seulement les timestamp active pour exporter les évèmenements.
(setq org-icalendar-include-todo nil) ;; sinon ça clone les choses schedulded
(setq org-icalendar-use-scheduled '(
                                    ;; event-if-not-todo ;;pour pas exporter mes tickler
                                    event-if-todo-not-done
                                    )) 
(setq org-icalendar-use-deadline '(event-if-not-todo
                                   event-if-todo-not-done
                                   ))


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

;; quand je close emacs, lance le processus
;; (add-hook 'kill-emacs-hook #'org-icalendar-combine-agenda-files-foreground)

(add-to-list 'org-tags-exclude-from-inheritance "project")

;; ne pas mettre, empêche le démarrage d'emacs. Pk ?
(add-hook 'find-file-hook #'vulpea-project-update-tag)
(add-hook 'before-save-hook #'vulpea-project-update-tag)

(defun vulpea-project-update-tag ()
  "Update PROJECT tag in the current buffer."
  (when (and (not (active-minibuffer-window))
             (vulpea-buffer-p))
    (save-excursion
      (goto-char (point-min))
      (let* ((tags (vulpea-buffer-tags-get))
             (original-tags tags))
        (if (vulpea-project-p)
            (setq tags (cons "project" tags))
          (setq tags (remove "project" tags)))

        ;; cleanup duplicates
        (setq tags (seq-uniq tags))

        ;; update tags if changed
        (when (or (seq-difference tags original-tags)
                  (seq-difference original-tags tags))
          (apply #'vulpea-buffer-tags-set tags))))))

(defun vulpea-buffer-p ()
  "Return non-nil if the currently visited buffer is a note."
  (and buffer-file-name
       (string-prefix-p
        (expand-file-name (file-name-as-directory org-roam-directory))
        (file-name-directory buffer-file-name))))

(defun vulpea-project-p ()
  "Return non-nil if current buffer has any todo entry.

    TODO entries marked as done are ignored, meaning the this
    function returns nil if current buffer contains only completed
    tasks."
  (org-element-map                          ; (2)
      (org-element-parse-buffer 'headline) ; (1)
      'headline
    (lambda (h)
      (eq (org-element-property :todo-type h)
          'todo))
    nil 'first-match))                     ; (3)

(defun vulpea-project-files ()
  "Return a list of note files containing 'project' tag." ;
  (seq-uniq
   (seq-map
    #'car
    (org-roam-db-query
     [:select [nodes:file]
              :from tags
              :left-join nodes
              :on (= tags:node-id nodes:id)
              :where (like tag (quote "%\"project\"%"))]))))

(defun vulpea-agenda-files-update (&rest _)
  "Update the value of `org-agenda-files'."
  (setq org-agenda-files (vulpea-project-files)))

(vulpea-agenda-files-update) ;; on l'update une fois au démarrage

(advice-add 'org-agenda :before #'vulpea-agenda-files-update)
(advice-add 'org-todo-list :before #'vulpea-agenda-files-update)

(setq org-agenda-prefix-format
        '((agenda . " %i %(vulpea-agenda-category 12)%?-12t% s")
          (todo . " %i %(vulpea-agenda-category 12) ")
          (tags . " %i %(vulpea-agenda-category 12) ")
          (search . " %i %(vulpea-agenda-category 12) ")))

(defun vulpea-agenda-category (&optional len)
  "Get category of item at point for agenda.

Category is defined by one of the following items:

- CATEGORY property
- TITLE keyword
- TITLE property
- filename without directory and extension

When LEN is a number, resulting string is padded right with
spaces and then truncated with ... on the right if result is
longer than LEN.

Usage example:

  (setq org-agenda-prefix-format
        '((agenda . \" %(vulpea-agenda-category) %?-12t %12s\")))

Refer to `org-agenda-prefix-format' for more information."
  (let* ((file-name (when buffer-file-name
                      (file-name-sans-extension
                       (file-name-nondirectory buffer-file-name))))
         (title (vulpea-buffer-prop-get "title"))
         (category (org-get-category))
         (result
          (or (if (and
                   title
                   (string-equal category file-name))
                  title
                category)
              "")))
    (if (numberp len)
        (s-truncate len (s-pad-right len " " result))
      result)))

(setq org-agenda-custom-commands
      '(
        (" " "Agenda"
         ((tags
           "REFILE"
           ((org-agenda-overriding-header "To refile")
            (org-tags-match-list-sublevels nil)))))

        ("d" "dashboard"
         (
          (todo "RAPPEL" ((org-agenda-overriding-header "Se souvenir de ceci")))
          (todo "NEXT"
                ((org-agenda-overriding-header "Next Actions")
                 (org-agenda-max-todos nil)))
          (todo "TODO"
                ((org-agenda-overriding-header "Tout ce qui est dans Inbox(Unprocessed Inbox Tasks)")
                 (org-agenda-files capture-inbox-file))
                (org-agenda-text-search-extra-files nil))
          (todo "WAIT"
                ((org-agenda-overriding-header "Waiting items")
                 (org-agenda-max-todos nil)))
          ;;(stuck "") ;; review stuck projects as designated by org-stuck-projects
          ;; ...other commands here
          )
         )
        )
      )

(use-package org-ql)

(use-package org-yaap
  :straight (org-yaap :type git :host gitlab :repo "tygrdev/org-yaap")
  :config
  (org-yaap-mode 1))

(require 'org-habit)
;;pour que le logbook soit dans un tiroir

;;  Pour savoir qd fini une tâche
(setq org-log-done 'time)
(setq org-log-into-drawer t);; le mets dans un propreties

(defun vulpea-tags-add ()
  "Add a tag to current note."
  (interactive)
  ;; since https://github.com/org-roam/org-roam/pull/1515
  ;; `org-roam-tag-add' returns added tag, we could avoid reading tags
  ;; in `vulpea-ensure-filetag', but this way it can be used in
  ;; different contexts while having simple implementation.
  (when (call-interactively #'org-roam-tag-add)
    (vulpea-ensure-filetag)))

(defun vulpea-ensure-filetag ()
  "Add respective file tag if it's missing in the current note."
  (let ((tags (vulpea-buffer-tags-get))
        (tag (vulpea--title-as-tag)))
    (when (and (seq-contains-p tags "people")
               (not (seq-contains-p tags tag)))
      (vulpea-buffer-tags-add tag))))

(defun vulpea--title-as-tag ()
  "Return title of the current note as tag."
  (vulpea--title-to-tag (vulpea-buffer-title-get)))

(defun vulpea--title-to-tag (title)
  "Convert TITLE to tag."
  (concat "@" (s-replace " " "" title)))

(defun my-vulpea-insert-handle (note)
  "Hook to be called on NOTE after `vulpea-insert'."
  (when-let* ((title (vulpea-note-title note))
              (tags (vulpea-note-tags note)))
    (when (seq-contains-p tags "people")
      (save-excursion
        (ignore-errors
          (org-back-to-heading)
          (when (eq 'todo (org-element-property
                           :todo-type
                           (org-element-at-point)))
            (org-set-tags
             (seq-uniq
              (cons
               (vulpea--title-to-tag title)
               (org-get-tags nil t))))))))))

(defun vulpea--title-to-tag (title)
  "Convert TITLE to tag."
  (concat "@" (s-replace " " "" title)))

(add-hook 'vulpea-insert-handle-functions
          #'my-vulpea-insert-handle)

(defun vulpea-agenda-person ()
  "Show main `org-agenda' view."
  (interactive)
  (let* ((person (vulpea-select
                  "Person"
                  :filter-fn
                  (lambda (note)
                    (seq-contains-p (vulpea-note-tags note)
                                    "people"))))
         (node (org-roam-node-from-id (vulpea-note-id person)))
         (names (cons (org-roam-node-title node)
                      (org-roam-node-aliases node)))
         (tags (seq-map #'vulpea--title-to-tag names))
         (query (string-join tags "|")))
    (dlet ((org-agenda-overriding-arguments (list t query)))
      (org-agenda nil "M"))))

(use-package org-transclusion)

(setq org-attach-store-link-p 'file)
;; pour que le lien soit relatif au dossier data, modifier cette fonction
;; org attach attach

;;The first function in this list defines the preferred function which will be used when creating new attachment folders.
(setq org-attach-id-to-path-function-list
      '(org-attach-id-ts-folder-format
        org-attach-id-uuid-folder-format))


(defun org-attach-id-ts-folder-format (id)
  "Translate an ID based on a timestamp to a folder-path.
Useful way of translation if ID is generated based on ISO8601
timestamp.  Splits the attachment folder hierarchy into
year-month, the rest."
  (format "%s/%s/%s/%s"
          (substring id 0 4)
          (substring id 4 6)
          (substring id 6 8)
          (substring id 9)
          )
  )

(add-hook 'dired-mode-hook
          (lambda ()
            (define-key dired-mode-map
              (kbd "C-c C-x a")
              #'org-attach-dired-to-subtree)))

;; (setq org-attach-id-dir (expand-file-name ".data/" vulpea-directory))

(setq org-attach-id-dir (expand-file-name ".data/" org-roam-directory))

;; (advice-remove 'org-attach-attach 'my-new-org-attach-attach)

(defun org-attach-attach (file &optional visit-dir method)
  "Move/copy/link FILE into the attachment directory of the current outline node.
If VISIT-DIR is non-nil, visit the directory with `dired'.
METHOD may be `cp', `mv', `ln', `lns' or `url' default taken from
`org-attach-method'."
  (interactive
   (list
    (read-file-name "File to keep as an attachment: "
                    (or (progn
                          (require 'dired-aux)
                          (dired-dwim-target-directory))
                        default-directory))
    current-prefix-arg
    nil))
  (setq method (or method org-attach-method))
  (when (file-directory-p file)
    (setq file (directory-file-name file)))
  (let ((basename (file-name-nondirectory file)))
    (let* ((attach-dir (org-attach-dir 'get-create))
           (attach-file (expand-file-name basename attach-dir)))
      (cond
       ((eq method 'mv) (rename-file file attach-file))
       ((eq method 'cp)
        (if (file-directory-p file)
            (copy-directory file attach-file nil nil t)
          (copy-file file attach-file)))
       ((eq method 'ln) (add-name-to-file file attach-file))
       ((eq method 'lns) (make-symbolic-link file attach-file))
       ((eq method 'url) (url-copy-file file attach-file)))
      (run-hook-with-args 'org-attach-after-change-hook attach-dir)
      (org-attach-tag)
      (cond ((eq org-attach-store-link-p 'attached)
             (push (list (concat "attachment:" (file-name-nondirectory attach-file))
                         (file-name-nondirectory attach-file))
                   org-stored-links))
            ((eq org-attach-store-link-p t)
             (push (list (concat "file:" file)
                         (file-name-nondirectory file))
                   org-stored-links))
            ((eq org-attach-store-link-p 'file)
             (push (list (concat "file:" attach-file)
                         (file-name-nondirectory attach-file))
                   org-stored-links)))
      (if visit-dir
          (dired attach-dir)
        (message "File %S is now an attachment" basename)))))

(require 'org-attach-git)

(setq org-archive-location "%s_archive::* ArchivedTasksfrom%s")

(require 'org-protocol)

)

(use-package org-roam
  :if nil

:init
;;éviter d'avoir la nottif de version 1 à 2 
(setq org-roam-v2-ack t)

:config

(when nil

  ;; this is a chunglak's hack to get sqlite to work on Android with org-roam v2:
  ;; from: https://github.com/org-roam/org-roam/issues/1605#issuecomment-885997237
  (defun org-roam-db ()
    "Entrypoint to the Org-roam sqlite database.
Initializes and stores the database, and the database connection.
Performs a database upgrade when required."
    (unless (and (org-roam-db--get-connection)
                 (emacsql-live-p (org-roam-db--get-connection)))
      (let ((init-db (not (file-exists-p org-roam-db-location))))
        (make-directory (file-name-directory org-roam-db-location) t)
        (let ((conn (emacsql-sqlite3 org-roam-db-location)))
          (emacsql conn [:pragma (= foreign_keys ON)])
          (set-process-query-on-exit-flag (emacsql-process conn) nil)
          (puthash (expand-file-name org-roam-directory)
                   conn
                   org-roam-db--connection)
          (when init-db
            (org-roam-db--init conn))
          (let* ((version (caar (emacsql conn "PRAGMA user_version")))
                 (version (org-roam-db--upgrade-maybe conn version)))
            (cond
             ((> version org-roam-db-version)
              (emacsql-close conn)
              (user-error
               "The Org-roam database was created with a newer Org-roam version.  "
               "You need to update the Org-roam package"))
             ((< version org-roam-db-version)
              (emacsql-close conn)
              (error "BUG: The Org-roam database scheme changed %s"
                     "and there is no upgrade path")))))))
    (org-roam-db--get-connection))
  (defun org-roam-db--init (db)
    "Initialize database DB with the correct schema and user version."
    (emacsql-with-transaction db
      (emacsql db "PRAGMA foreign_keys = ON") ;; added
      (emacsql db [:pragma (= foreign_keys ON)])
      (pcase-dolist (`(,table ,schema) org-roam-db--table-schemata)
        (emacsql db [:create-table $i1 $S2] table schema))
      (pcase-dolist (`(,index-name ,table ,columns) org-roam-db--table-indices)
        (emacsql db [:create-index $i1 :on $i2 $S3] index-name table columns))
      (emacsql db (format "PRAGMA user_version = %s" org-roam-db-version))))
  ;; end chunglak hack

  (org-roam-setup)



  )

(setq org-roam-completion-everywhere t) ;; pour avoir la complétien partout

;; syncro automatique avec les fichiers 
(org-roam-db-autosync-mode +1)

;; pour améliorer les perf
(setq org-roam-db-gc-threshold most-positive-fixnum)

;; On prend pas les fichiers org dans org-attach
(setq org-roam-file-exclude-regexp ".data/")

(setq org-roam-capture-templates
      '(
        ("d" "default" plain "%?"
         :target (file+head "pages/%<%Y%m%d%H%M%S>-${slug}.org"
                            "#+title: ${title}\n")
         :unnarrowed t)
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

;;défini la capture de mon journal
(setq org-roam-dailies-directory "journals/")

;;ce qu'il y a dans le buffer de backlinks
(setq org-roam-mode-sections
      (list #'org-roam-backlinks-section
            #'org-roam-reflinks-section
            #'org-roam-unlinked-references-section
            ))

;; on peut mettre des options !
;; (org-roam-mode-sections
;; '((org-roam-backlinks-section :unique t)
;; org-roam-reflinks-section))

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

)

(use-package deft
  :after org-roam
  :config
  (setq deft-extensions '("org")
        deft-directory org-roam-directory
        deft-recursive t
        deft-strip-summary-regexp ":PROPERTIES:\n\\(.+\n\\)+:END:\n"
        deft-use-filename-as-title t)
  )

(use-package ox-hugo
  :after org org-roam
  ;; :custom
  ;;à modifier
  ;; (org-hugo-base-dir "/home/msi/Documents/Projet/SitesWeb/braindump")
  )

(when termux-p
  ;; This makes Emacs in Termux use your Android browser for opening urls
  (setq browse-url-browser-function 'browse-url-xdg-open)
  )

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
  (setq org-cite-csl--fallback-style-file (concat org-roam-directory "vancouver-brackets.csl"));; pour changer le style. Vancouver = numéro
  (setq org-cite-csl--fallback-locales-dir org-roam-directory)
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
