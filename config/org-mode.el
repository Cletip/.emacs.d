(setq org-directory (expand-file-name "org/" braindump-directory))

(setq org-roam-directory org-directory)

(setq bibliography-directory (expand-file-name "dossierCitation/" config-directory))
;; (setq my-bibliography-list (list (expand-file-name "dossierCitation/biblio.bib" bibliography-directory)
;; "/path/to/another/"
;; "/path/to/another/"
;; ))

(setq bibliography-file-list (list
                              (concat bibliography-directory "biblio.bib")
                              ;; "test"
                              ))


;; où sont mes fichiers
(setq bibliography-library-paths (list
                              (concat bibliography-directory "fichiers/")
                              ;; "test"
                              ))

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
(require 'vulpea);;sinon ne charge pas tout je comprends pas pk

(advice-add 'org-transclusion-add :before #'org-id-update-id-locations)

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

(setq-default org-catch-invisible-edits nil)

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

(defun org-mode-<>-syntax-fix (start end)
  "Change syntax of characters ?< and ?> to symbol within source code blocks."
  (let ((case-fold-search t))
    (when (eq major-mode 'org-mode)
      (save-excursion
        (goto-char start)
        (while (re-search-forward "<\\|>" end t)
          (when (save-excursion
                  (and
                   (re-search-backward "[[:space:]]*#\\+\\(begin\\|end\\)_src\\_>" nil t)
                   (string-equal (downcase (match-string 1)) "begin")))
            ;; This is a < or > in an org-src block
            (put-text-property (point) (1- (point))
                               'syntax-table (string-to-syntax "_"))))))))

(defun org-setup-<>-syntax-fix ()
  "Setup for characters ?< and ?> in source code blocks.
Add this function to `org-mode-hook'."
  (make-local-variable 'syntax-propertize-function)
  (setq syntax-propertize-function 'org-mode-<>-syntax-fix)
  (syntax-propertize (point-max)))

(add-hook 'org-mode-hook #'org-setup-<>-syntax-fix)

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

;; (org-id-update-id-locations) ;;plus besoin normalement

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

(defun cp-vulpea-meta-fait-add ()
  (interactive)
  (let* (
         (id (save-excursion (goto-char (point-min)) (org-id-get)))
         (key "Fait")
         (timestamp (format-time-string "%Y%m%d%H%M%S"))
         (fait-p (vulpea-meta-get id key))
         )
    (if fait-p
        (vulpea-meta-set id key (concat (vulpea-meta-get id key) ", " timestamp) t)
      (vulpea-meta-set id key timestamp t))

    )
  )

(defun cp-vulpea-meta-fait-remove ()
  (interactive)
  (let* (
         (id (save-excursion (goto-char (point-min)) (org-id-get)))
         (key "Fait")
         (timestamp (format-time-string "%Y%m%d%H%M%S"))
         (fait-p (vulpea-meta-get id key))
         )
    (when fait-p
      (vulpea-meta-remove id key)
      )
    )
  )

(setq capture-inbox-file
    (expand-file-name (format "inbox-%s.org" (system-name)) org-roam-directory)
    )

(setq org-capture-templates
      '(
        ("t" "todo" plain (file capture-inbox-file)
         (file "../templatesOrgCapture/todo.org"))
        ("u" "tickler" entry
         (function cp/vulpea-capture-tickler-target)
         (file "../templatesOrgCapture/tickler.org")
         :immediate-finish t
         )
        ("r" "un rdv" entry
         (function cp/vulpea-capture-rdv-target)
         (file "../templatesOrgCapture/rdv.org")
         :immediate-finish t
         )

        ("T" "test" entry
         (function cp/vulpea-capture-tickler-target)
         "* TODO %^{Nom du tickler} :tickler:\nSCHEDULED: %^T\n%?"
         )

        ;; ("c" "nouvelle connaissance" entry
        ;; (file capture-inbox-file)
        ;; (file "../templatesOrgCapture/connaissances.org")
        ;; :immediate-finish t
        ;; )

        ))

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

(defun cp/vulpea-capture-tickler-target ()
  "Return a target for a tickler capture."
  (let ((person (vulpea-select
                 "Où va le tickler selectionné : ")))
    ;; unfortunately, I could not find a way to reuse
    ;; `org-capture-set-target-location'
    (if (vulpea-note-id person)
        (let ((path (vulpea-note-path person)))
          (set-buffer (org-capture-target-buffer path))
          ;; Org expects the target file to be in Org mode, otherwise
          ;; it throws an error. However, the default notes files
          ;; should work out of the box. In this case, we switch it to
          ;; Org mode.
          (unless (derived-mode-p 'org-mode)
            (org-display-warning
             (format
              "Capture requirement: switching buffer %S to Org mode"
              (current-buffer)))
            (org-mode))

          (goto-char (point-max))

          (org-capture-put-target-region-and-position)
          (widen)
          )
      ;;cas si personne trouvé, alors ça va direct dans l'inbox
      (let ((path capture-inbox-file))
        (set-buffer (org-capture-target-buffer path))
        (org-capture-put-target-region-and-position)
        (widen)))))

;; plus besoin de cette fonction
(defun cp/vulpea-capture-tickler-template ()
  "Return a template for a meeting capture."
  (let ((anote (vulpea-select
                "Où va le tickler selectionné : ")))
    (org-capture-put :target-tickler anote)
    "* TODO %^{Nom du tickler} :tickler:\nSCHEDULED: %^T\n%?"))

(defun cp/vulpea-capture-rdv-target ()
  "Return a target for a tickler capture."
  (let ((person (vulpea-select
                 "Où va le rdv selectionné : ")))
    ;; unfortunately, I could not find a way to reuse
    ;; `org-capture-set-target-location'
    (if (vulpea-note-id person)
        (let ((path (vulpea-note-path person)))
          (set-buffer (org-capture-target-buffer path))
          ;; Org expects the target file to be in Org mode, otherwise
          ;; it throws an error. However, the default notes files
          ;; should work out of the box. In this case, we switch it to
          ;; Org mode.
          (unless (derived-mode-p 'org-mode)
            (org-display-warning
             (format
              "Capture requirement: switching buffer %S to Org mode"
              (current-buffer)))
            (org-mode))

          (goto-char (point-max))

          (org-capture-put-target-region-and-position)
          (widen)
          )
      ;;cas si personne trouvé, alors ça va direct dans l'inbox
      (let ((path capture-inbox-file))
        (set-buffer (org-capture-target-buffer path))
        (org-capture-put-target-region-and-position)
        (widen)))))

;; plus besoin de cette fonction
(defun cp/vulpea-capture-rdv-template ()
  "Return a template for a meeting capture."
  (let ((anote (vulpea-select
                "Où va le tickler selectionné : ")))
    (org-capture-put :target-tickler anote)
    "* TODO %^{Nom du tickler} :tickler:\nSCHEDULED: %^T\n%?"))

(defun vulpea-capture-meeting-template ()
  "Return a template for a meeting capture."
  (let ((person (vulpea-select
                 "Person"
                 :filter-fn
                 (lambda (note)
                   (let ((tags (vulpea-note-tags note)))
                     (seq-contains-p tags "people"))))))
    (org-capture-put :meeting-person person)
    (if (vulpea-note-id person)
        "* MEETING [%<%Y-%m-%d %a>] :REFILE:MEETING:\n%U\n\n%?"
      (concat "* MEETING with "
              (vulpea-note-title person)
              " on [%<%Y-%m-%d %a>] :MEETING:\n%U\n\n%?"))))

(defun vulpea-capture-meeting-target ()
  "Return a target for a meeting capture."
  (let ((person (org-capture-get :meeting-person)))
    ;; unfortunately, I could not find a way to reuse
    ;; `org-capture-set-target-location'
    (if (vulpea-note-id person)
        (let ((path (vulpea-note-path person))
              (headline "Meetings"))
          (set-buffer (org-capture-target-buffer path))
          ;; Org expects the target file to be in Org mode, otherwise
          ;; it throws an error. However, the default notes files
          ;; should work out of the box. In this case, we switch it to
          ;; Org mode.
          (unless (derived-mode-p 'org-mode)
            (org-display-warning
             (format
              "Capture requirement: switching buffer %S to Org mode"
              (current-buffer)))
            (org-mode))
          (org-capture-put-target-region-and-position)
          (widen)
          (goto-char (point-min))
          (if (re-search-forward
               (format org-complex-heading-regexp-format
                       (regexp-quote headline))
               nil t)
              (beginning-of-line)
            (goto-char (point-max))
            (unless (bolp) (insert "\n"))
            (insert "* " headline "\n")
            (beginning-of-line 0)))
      (let ((path vulpea-capture-inbox-file))
        (set-buffer (org-capture-target-buffer path))
        (org-capture-put-target-region-and-position)
        (widen)))))

;;pour voir le chemin lors du refile
(setq org-outline-path-complete-in-steps nil)
;; permet de déplacer avec un niveau de titre 1 ! (dans tickler par exemple)
(setq org-refile-use-outline-path (quote file))



(setq org-refile-targets
      '(
        ;;refile dans le buffer courant jusqu'au niveau 7
        (nil :maxlevel . 7)
        ;;refile dans tous les fichiers de l'agenda jusqu'au niveau 5
        ;; (org-agenda-files :maxlevel . 5) ;;c'est déjà orgzly-directory-all-org-files
        ;;refile dans mes notes
        (org-roam-list-files :maxlevel . 1)
        )
      )

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

;; permet de mettre  A B C nil priorité dans l'ordre
;; une tâche qui n'a pas de priorité "possède" donc une priorité négative
(setq cp/org-default-priority (+ org-priority-lowest 1))
(setq org-default-priority cp/org-default-priority)

;; on ne commence par par -1 pour mettre une priorité
(setq org-priority-start-cycle-with-default nil)

(defun cp/org-get-priority-p(s)
  "Renvoie vrai si il y a un ancêtre qui à une priorité, peut être en récursive un jour"
  (interactive)
  (save-excursion
    (while (ignore-errors (outline-up-heading 1 t)))
    (let (($p1 (progn (beginning-of-line) (point)))
          ;; ($p2 (progn (cp/org-goto-end-of-heading) (point)))
          ($p2 (progn (end-of-line) (point)))
          result)
      (save-restriction
        (narrow-to-region $p1 $p2)
        (goto-char $p1)
        (when (re-search-forward ".*?\\(\\[#\\([A-Z0-9]+\\)\\] ?\\)" nil t)
          (setq result t))))))

;; ne marche pas ? normal car je veux la priorité, pas les propriétés...
;; (setq org-use-property-inheritance t)

;; marche, mais seulement pour les fonctionnalité qui appelle org-priority-get-priority-function (donc presque tout)
(defun my/org-inherited-priority (s)
  (save-excursion
    (cond
     ;; Priority cookie in this heading
     ((string-match org-priority-regexp s)
      (* 1000 (- org-priority-lowest
                 (org-priority-to-value (match-string 2 s)))))
     ;; No priority cookie, but already at highest level
     ((not (org-up-heading-safe))
      (* 1000 (- org-priority-lowest org-priority-default)))
     ;; Look for the parent's priority
     (t
      (my/org-inherited-priority (org-get-heading))))))

(setq org-priority-get-priority-function #'my/org-inherited-priority)

;;Lieu de l'export org-icalendar-combine-agenda-files
(setq org-icalendar-combined-agenda-file (expand-file-name "agendapourgoogle.ics" braindump-directory))

(setq org-icalendar-with-timestamps 'active) ;; seulement les timestamp active pour exporter les évèmenements.
(setq org-icalendar-include-todo nil) ;; sinon ça clone les choses schedulded
(setq org-icalendar-use-scheduled '(
                                    ;; event-if-not-todo ;;pour pas exporter mes tickler
                                    event-if-todo-not-done
                                    event-if-not-todo ;;  pour exporter mes rdv
                                    ))
(setq org-icalendar-use-deadline '(event-if-not-todo
                                   event-if-todo-not-done
                                   ))


;; ne pas exporter les tickler
(setq org-icalendar-exclude-tags '("tickler"))


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
(add-hook 'kill-emacs-hook #'org-icalendar-combine-agenda-files-foreground)

;; dès que la data base se syncronise, je mets à jour mon calendrier

;; TODO

;; (advice-add 'org-roam-db-sync :after #'org-icalendar-combine-agenda-files-background)


;; (advice-remove 'org-roam-db-sync #'org-icalendar-combine-agenda-files-background)

(setq org-agenda-prefix-format
        '((agenda . " %i %(vulpea-agenda-category 12)%?-12t% s")
          (todo . " %i %(vulpea-agenda-category 12) ")
          (tags . " %i %(vulpea-agenda-category 12) ")
          (search . " %i %(vulpea-agenda-category 12) ")))

;; (todo . " %i %(vulpea-agenda-category 12) %(let ((scheduled (org-get-scheduled-time (point)))) (if scheduled (format-time-string \"Schedulded to <%Y-%m-%d-%H-%M %a>\" scheduled) \"\"))")

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

;; ajout des choses à voir avec org-agenda log mode (raccourcis "l" dans l'agenda).
;; permet de voir les différents states notamment
(setq org-agenda-log-mode-items '(closed clock state))

;; si je veux que cela commence en mode log-mode. Pas sûr que ce soit CETTE variable
;; (setq org-agenda-start-with-log-mode '(closed clock state))

(setq org-tags-exclude-from-inheritance '(
                                          "PROJET"
                                          "PERSONNE" ;;ça vraiment ?
                                          "crypt"
                                          )
      )

;; ne pas mettre, empêche le démarrage d'emacs. Pk ?
(add-hook 'find-file-hook #'vulpea-project-update-tag)

(add-hook 'before-save-hook #'vulpea-project-update-tag)

(defun vulpea-project-update-tag ()
  "Update PROJET tag in the current buffer."
  (when (and (not (active-minibuffer-window))
             (vulpea-buffer-p))
    (save-excursion
      (goto-char (point-min))
      (let* ((tags (vulpea-buffer-tags-get))
             (original-tags tags))
        (if (vulpea-project-p)
            (setq tags (cons "PROJET" tags))
          (setq tags (remove "PROJET" tags)))

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
  "Return a list of note files containing 'PROJET' tag." ;
  (seq-uniq
   (seq-map
    #'car
    (org-roam-db-query
     [:select [nodes:file]
              :from tags
              :left-join nodes
              :on (= tags:node-id nodes:id)
              :where (like tag (quote "%\"PROJET\"%"))]))))

(defun vulpea-agenda-files-update (&rest _)
  (interactive)
  "Update the value of `org-agenda-files'."
  (setq org-agenda-files (vulpea-project-files)))

;; on skip les fichiers qui ne sont pas accessible
(setq org-agenda-skip-unavailable-files t)

(add-hook 'emacs-startup-hook 'vulpea-agenda-files-update);; on l'update une fois au démarrage
;; (vulpea-agenda-files-update) 


(advice-add 'org-agenda :before #'vulpea-agenda-files-update)
(advice-add 'org-todo-list :before #'vulpea-agenda-files-update)

(advice-add 'org-roam-db-sync :after #'vulpea-agenda-files-update)

(use-package org-super-agenda
  :config
  (org-super-agenda-mode))

(setq org-agenda-custom-commands
      '(
        (" " "Agenda"
         ((tags
           "REFILE"
           ((org-agenda-overriding-header "To refile")
            (org-tags-match-list-sublevels nil)))))

        ;;à supprimer ?
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


;;(org-agenda-skip-if SUBTREE CONDITIONS)
(setq org-agenda-custom-commands
      '(("t" "Dashboard"
         (
          (agenda)
          (todo "TODO"
                ((org-agenda-overriding-header "Les deux  : first task et projet")
                 (org-agenda-skip-function 'cp/super-org-agenda-skip-function-first-task)
                 (org-agenda-todo-ignore-scheduled t)
                 ))
          (todo "TODO"
                ((org-agenda-overriding-header "Tous mes projets en cours")
                 ;; (org-tags-match-list-sublevels nil) ;;skip les subtask
                 (org-agenda-skip-function 'cp/org-agenda-skip-function-for-project)
                 ))
          (todo "TODO"
                ((org-agenda-overriding-header "Prochaines tâches pas dans les projets")
                 ;; (org-tags-match-list-sublevels nil) ;;skip les subtask
                 (org-agenda-skip-function 'cp/org-agenda-skip-function-next-task-not-project)
                 ))
          (todo "TODO"
                ((org-agenda-overriding-header "Liste de mes prochaines tâche à faire pour un projet")
                 (org-agenda-skip-function 'cp/org-agenda-skip-function-first-task)
                 ))

          ))
        ("s" "Liste des projets à faire TODO"
         (
          ;; (agenda "")
          (stuck "")
          (org-ql-block '(and (tags "project")
                              (not (done))
                              (not (ancestors))
                              ;; (not (descendants (todo "TODO"))) TODO here : trouver la tâche suivante, et elle n'est n'y schedulded ni todo, 
                              )
                        ((org-ql-block-header "Stuck projet"))
                        )
          (todo "" ((org-super-agenda-groups
                     '((:name "Test"  ; Disable super group header
                              :children todo)
                       (:name "Priority >= C items underlined, on black background"
                              :not (:priority>= "C"))
                       (:priority<= "B"
                                    ;; Show this section after "Today" and "Important", because
                                    ;; their order is unspecified, defaulting to 0. Sections
                                    ;; are displayed lowest-number-first.
                                    :order 1)
                       (:discard (:anything t))))))

          ))

        ("A" "En fonction d'un tag"
         (
          ;; (agenda "")
          (tags-todo (cp/org-get-one-of-all-tags)
                     ((org-agenda-overriding-header "Les deux  : first task et projet")
                      (org-agenda-skip-function 'cp/super-org-agenda-skip-function-first-task)
                      ))
          ))

        ("o" "Agenda and Office-related tasks"
         ((agenda "")
          (tags-todo "work")
          (tags "home|office")
          (org-ql-block '(and (todo "TODO")
                              (tags "projet")
                              (not (ancestors))
                              )
                        ((org-ql-block-header "Liste des projets non fini")))
          (org-ql-block '(and (todo "TODO")
                              (tags "WORK")
                              )
                        ((org-ql-block-header "Liste des Révisions, à suppr car pas trié par org-ql. Faire une requête org-ql à la place ?")))


          ))))

(defun cp/org-agenda-skip-function-for-project ()
  "On skip dès qu'on peut avec \"cond\""
  (when
      (cp/org-agenda-skip-function-for-project-cond)
    (save-excursion (org-end-of-subtree t))
    )
  )

(defun cp/org-agenda-skip-function-for-project-cond()
  (cond (
         ;;je ne veux voir le premier heading, car c'est mon projet
         (not (eq (org-current-level) 1)) t)      
        ;; si pas de priorité alors on skip, car pas besoin de les voir
        ((not (cp/org-get-priority-p (match-string 0))) t)       
        ;;si il n'a pas de fils, je le skip 
        ((not (save-excursion (org-goto-first-child))) t)              
        )
  )

(defun org-current-is-todo ()
  (string= "TODO" (org-get-todo-state)))

(defun cp/org-agenda-skip-function-first-task ()
  "On skip dès qu'on peut avec \"cond\""
  (when
      (cp/org-agenda-skip-function-first-task-cond)
    ;; on va voir la prochaine entrée, ou bien bout du fichier si ya plus rien
    (or (outline-next-heading)
        (goto-char (point-max)))
    )
  )

(defun cp/org-agenda-skip-function-first-task-cond()
  (cond
   ;; pas todo
   ((not (org-current-is-todo)) t)
   ;; si niveau 1 et qu'il n'a pas de fils
   ((and (eq (org-current-level) 1) (not (save-excursion (org-goto-first-child)))) t)

   ;; si pas dans un todo (ancêtre todo)
   ((progn (save-excursion (while (ignore-errors (outline-up-heading 1 t)))(ignore-errors (not (org-current-is-todo))))) t)

   ;; si il a des fils (pas sûr, cela me donner "les parents") dans mes commandes, mais lorsque je scheduldais, ça garder les parents. (Il faudrait faire un truc spécial "si pas de fils schedulded") Idem pour la priorité : si une tâche next avait une priorité différentes du projet... ça n'aller pas.
   ((save-excursion (org-goto-first-child)) t)

   ;; si pas de priorité
   ((not (cp/org-get-priority-p (match-string 0))) t)
   ;; si le frère précédent existe et est en todo
   ((let (should-skip-entry)
      (save-excursion
        ;; If previous sibling exists and is TODO,
        ;; skip this entry
        (while (and (not should-skip-entry) (org-goto-sibling t) (not (eq (org-current-level) 1)))
          (when (org-current-is-todo)
            (setq should-skip-entry t))))
      should-skip-entry
      )
    t)
   ;; si un ancêtre avec un todo existe ET que cette ancêtre possède sibling précédent avec un TODO, alors skip
   ((let (should-skip-entry
          (num-ancestors (org-current-level))
          (ancestor-level 1))
      (while (and (not should-skip-entry) (<= ancestor-level num-ancestors))
        (save-excursion
          ;; When ancestor (parent, grandparent, etc) exists
          (when (ignore-errors (outline-up-heading ancestor-level t))
            ;; j'ai rajouter ici que le heading doit être différent de 1, comme ça on ne skip pas les tâches qui ont un projet avec un todo... mais pourquoi ? c'est dans cette boucle while le pb
            ;;parce qu'on regarde les oncles jusqu'au niveau 1, et donc, quand ya un todo avant, on annule les suivant! Il faut donc arrerter de checker les oncle au plus haut niveau !
            (when (not (eq (org-current-level) 1))
              ;; Else if ancestor is TODO, check previous siblings of
              ;; ancestor ("uncles"); if any of them are TODO, skip
              (when (org-current-is-todo)
                (while (and (not should-skip-entry) (org-goto-sibling t))
                  (when (org-current-is-todo)
                    (setq should-skip-entry t)))))
            ))
        (setq ancestor-level (1+ ancestor-level))
        )
      should-skip-entry)
    t)

   )

  )

(defun cp/org-agenda-skip-function-next-task-not-project ()
  "On skip dès qu'on peut avec \"cond\""
  (when
      (cp/org-agenda-skip-function-next-task-not-project-cond)
    (save-excursion (org-end-of-subtree t))
    )
  )


(defun cp/org-agenda-skip-function-next-task-not-project-cond()
  (cond (;;je veux voir les premiers heading seulement
         (not (eq (org-current-level) 1)) t)      
        ;; si pas de priorité alors on skip, car pas besoin de les voir
        ((not (cp/org-get-priority-p (match-string 0))) t)
        ;;si il a un fils, je le skip 
        ((save-excursion (org-goto-first-child)) t)              
        )
  )

(defun cp/super-org-agenda-skip-function-first-task ()
  "On skip dès qu'on peut avec \"cond\""
  (when (and
         (cp/org-agenda-skip-function-next-task-not-project-cond)
         (cp/org-agenda-skip-function-first-task-cond)
         )
    (or (outline-next-heading)
        (goto-char (point-max)))
    )
  )

(defun cp/org-get-one-of-all-tags()
  "Renvoie un strig d'un des tags de org-agenda-files"
  (let* (
         ;;vive cette variable
         (org-complete-tags-always-offer-all-agenda-tags t)

         (all-tags (org-get-tags))
         (table (setq org-last-tags-completion-table
                      (org--tag-add-to-alist
                       (and org-complete-tags-always-offer-all-agenda-tags
                            (org-global-tags-completion-table
                             (org-agenda-files)))
                       (or org-current-tag-alist (org-get-buffer-tags)))))
         (current-tags
          (cl-remove-if (lambda (tag) (get-text-property 0 'inherited tag))
                        all-tags))
         (inherited-tags
          (cl-remove-if-not (lambda (tag) (get-text-property 0 'inherited tag))
                            all-tags))
         (tags
          (replace-regexp-in-string
           ;; Ignore all forbidden characters in tags.
           "[^[:alnum:]_@#%]+" ":"
           (if (or (eq t org-use-fast-tag-selection)
                   (and org-use-fast-tag-selection
                        (delq nil (mapcar #'cdr table))))
               (org-fast-tag-selection
                current-tags
                inherited-tags
                table
                (and org-fast-tag-selection-include-todo org-todo-key-alist))
             (let ((org-add-colon-after-tag-completion (< 1 (length table)))
                   (crm-separator "[ \t]*:[ \t]*"))
               (mapconcat #'identity
                          (completing-read-multiple
                           "Tags: "
                           org-last-tags-completion-table
                           nil nil (org-make-tag-string current-tags)
                           'org-tags-history)
                          ":"))))))
    tags))

(defun bjm/org-headline-to-top ()
  "Move the current org headline to the top of its section"
  (interactive)
  ;; check if we are at the top level
  (let ((lvl (org-current-level)))
    (cond
     ;; above all headlines so nothing to do
     ((not lvl)
      (message "No headline to move"))
     ((= lvl 1)
      ;; if at top level move current tree to go above first headline
      (org-cut-subtree)
      (beginning-of-buffer)
      ;; test if point is now at the first headline and if not then
      ;; move to the first headline
      (unless (looking-at-p "*")
        (org-next-visible-heading 1))
      (org-paste-subtree))
     ((> lvl 1)
      ;; if not at top level then get position of headline level above
      ;; current section and refile to that position. Inspired by
      ;; https://gist.github.com/alphapapa/2cd1f1fc6accff01fec06946844ef5a5
      (let* ((org-reverse-note-order t)
             (pos (save-excursion
                    (outline-up-heading 1)
                    (point)))
             (filename (buffer-file-name))
             (rfloc (list nil filename nil pos)))
        (org-refile nil nil rfloc))))))

(use-package org-ql
  :config

  )

(add-to-list 'org-agenda-custom-commands
      '("b" "Stuck Projects"
         ((org-ql-block '(and (tags "@project")
                              (not (done))
                              (not (descendants (todo "NEXT")))
                              (not (descendants (scheduled))))
                        ((org-ql-block-header "Stuck Projects"))))))

;; (setq org-stuck-projects
      ;; '("+PROJECT/-MAYBE-DONE" ("NEXT" "TODO") ("@shop")
        ;; "\\<IGNORE\\>"))

(setq org-agenda-bulk-custom-functions '(
                                         (?D (lambda nil (org-agenda-priority 65)))
                                         (?L (lambda nil (org-agenda-priority 66)))
                                         (?\? (lambda nil (org-agenda-priority 67)))
                                         (?Q (lambda nil (org-agenda-priority 68)))
                                         ))

(advice-add 'org-agenda-todo :after #'org-agenda-redo-all)

(use-package org-yaap
  :straight (org-yaap :type git :host gitlab :repo "tygrdev/org-yaap")
  :config

  (setq org-yaap-overdue-alerts '(5 30 180 3600)
        org-yaap-alert-before 30 
        org-yaap-exclude-tags '("tickler")
        org-yaap-todo-only t ;; pour pas 
        )

  (org-yaap-mode 1))

(setq org-todo-keywords
      '((sequence "TODO(!)" "|" "DONE(!)" )))

;; (setq org-log-done 'time) ;; rajoute "CLOSED:" quand on termine une tâche. Pas besoin grâce à la variables org-log-into-drawer
(setq org-log-into-drawer t);; le mets dans un propreties

(setq org-enforce-todo-dependencies t)

(require 'org-habit)

(setq org-tag-alist '((:startgrouptag)
                      ("GTD")
                      (:grouptags)
                      ("Control")
                      ("Persp")
                      (:endgrouptag)
                      (:startgrouptag)
                      ("Control")
                      (:grouptags)
                      ("Context")
                      ("Task")
                      (:endgrouptag)))

(setq org-tags-column 0)

(defun vulpea-tags-add ()
  "Add a tag to current note."
  (interactive)
  ;; since https://github.com/org-roam/org-roam/pull/1515
  ;; `org-roam-tag-add' returns added tag, we could avoid reading tags
  ;; in `vulpea-ensure-filetag', but this way it can be used in
  ;; different contexts while having simple implementation.
  (when (call-interactively #'org-roam-tag-add)
    (vulpea-ensure-filetag)))

(defun cp-vulpea-buffer-tags-remove-BROUILLON ()
  "Use all files for org-agenda."
  (interactive)
  (vulpea-buffer-tags-remove "BROUILLON"))

(defun cp/vulpea-note-meta-get-list-of-name (note)
  "Get a list of all metadata from NOTE"
  (mapcar 'car (vulpea-note-meta note)))

(defun cp/xah-list-to-hash (list)
  "Return a list that represent the HASHTABLE
            Each element is a proper list: '(key value).
            URL `http://xahlee.info/emacs/emacs/elisp_hash_table.html'
            Version 2019-06-11 2022-05-28"
  (let ((myHash (make-hash-table :test 'equal)))
    (mapcar
     (lambda (x)
       (let ((k (car x))
             (v (car(last x)))
             )
         (message "v =%s" v)
         (puthash k v myHash)
         )
       )
     list)
    myHash))

;; (setq var '(
;; ("salut" ("val" "vul"))
;; ("key" ("val" "vul"))
;; ))
;; (setq test (cp/xah-list-to-hash var))
;; (gethash "salut" test)

(defun cp/vulpea-buffer-tags-get (note)
    "Return filetags value in current buffer."
    (save-window-excursion
      (find-file (vulpea-db-get-file-by-id (vulpea-note-id note)))
      (vulpea-buffer-prop-get-list "filetags" "[ :]")))

;; tags à ignorer
(setq ignore-meta '("Origine" "Lieu" "Fait" ""))

;; mes tags avec leurs propriétés
(setq tags-for-meta-list '(
                           ("RECETTE" ("temps" "autre"))
                           ("INSTALLATION" ("val" "vul" "vol"))
                           ("Blog" ("Publish Date" "Pulbished Where" "Published Link"))
                           ("nateun" ("val"))
                           ))
(setq tags-for-meta (cp/xah-list-to-hash tags-for-meta-list))

;; (gethash "salut" tags-for-meta)

(defun all-meta-list()
  "Renvoie la liste de toutes mes métadata présente dans ma hiérarchie"
  (delq nil (delete-dups (let (result)
                           (dolist (value (hash-table-values tags-for-meta))
                             (setq result (append result value)))
                           result))))

(defun delete-parens-note-after-insertion(_)
  "Permet de supprimer les parenthèse. Attention, ne marche qu'après l'insertion !"
  (interactive)
  (save-excursion
    (let
        (($p2 (point))
         ($p1 (search-backward "[")))
      (save-restriction
        (narrow-to-region $p1 $p2)
        (when (search-forward "(" nil t) ;;cas où je trouve la parenthèse
          (unless (boundp 'delete-parens-for-node) ;; si pas de variable local activé
            (defvar-local delete-parens-for-node nil)
            )
          (when (and (not delete-parens-for-node) (y-or-n-p "Insertion d'une note avec des parenthèses, voulez vous les supprimer ? Si oui, vous n'aurez plus cette demande dans le buffer actuel la prochaine fois"))
            (setq-local delete-parens-for-node t)
            )
          (when delete-parens-for-node
            (xah-delete-backward-char-or-bracket-text)
            (xah-fly-delete-spaces)
            )))))
  )

;;on le "hook"
;; (advice-add 'vulpea-insert :after #'delete-parens-note-after-insertion)
;; (advice-remove 'vulpea-insert  #'delete-parens-note-after-insertion)

(add-hook 'vulpea-insert-handle-functions #'delete-parens-note-after-insertion)
;; (remove-hook 'vulpea-insert-handle-functions #'delete-parens-note-after-insertion)

(defun vulpea-ensure-filetag ()
  "Add respective file tag if it's missing in the current note."
  (let ((tags (vulpea-buffer-tags-get))
        (tag (vulpea--title-as-tag)))
    (when (and (seq-contains-p tags "PERSONNE")
               (not (seq-contains-p tags tag)))
      (vulpea-buffer-tags-add tag))

    (when (and (seq-contains-p tags "LIEU")
               (not (seq-contains-p tags tag)))
      (vulpea-buffer-tags-add tag))
    ))

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
    (when (seq-contains-p tags "PERSONNE")
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
               (org-get-tags nil t))))))))


    (when (seq-contains-p tags "LIEU")
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
               (org-get-tags nil t))))))))


    ))

(defun vulpea--title-to-tag (title)
  "Convert TITLE to tag."
  (concat "@" (s-replace " " "" title)))

(add-hook 'vulpea-insert-handle-functions
          #'my-vulpea-insert-handle)

(defun vulpea-agenda-personne ()
  "Show main `org-agenda' view."
  (interactive)
  (let* ((person (vulpea-select
                  "Person"
                  :filter-fn
                  (lambda (note)
                    (seq-contains-p (vulpea-note-tags note)
                                    "PERSONNE"))))
         (node (org-roam-node-from-id (vulpea-note-id person)))
         (names (cons (org-roam-node-title node)
                      (org-roam-node-aliases node)))
         (tags (seq-map #'vulpea--title-to-tag names))
         (query (string-join tags "|")))
    (dlet ((org-agenda-overriding-arguments (list t query)))
      (org-agenda nil "M"))))


(defun vulpea-agenda-lieu ()
  "Show main `org-agenda' view."
  (interactive)
  (let* ((person (vulpea-select
                  "Person"
                  :filter-fn
                  (lambda (note)
                    (seq-contains-p (vulpea-note-tags note)
                                    "LIEU"))))
         (node (org-roam-node-from-id (vulpea-note-id person)))
         (names (cons (org-roam-node-title node)
                      (org-roam-node-aliases node)))
         (tags (seq-map #'vulpea--title-to-tag names))
         (query (string-join tags "|")))
    (dlet ((org-agenda-overriding-arguments (list t query)))
      (org-agenda nil "M"))))

(defun cp/org-roam-property-file-add (prop val)
  "Add VAL value to PROP property for the node at point.
        Both, VAL and PROP are strings."
  (let* ((p (org-entry-get (point-min) prop))
         (lst (when p (split-string-and-unquote p)))
         (lst (if (memq val lst) lst (cons val lst)))
         (lst (seq-uniq lst)))
    (save-excursion
      (goto-char (point-min))
      (org-set-property prop (combine-and-quote-strings lst))
      val
      )
    ))

;;  TODO : (read-string "Enter name:") renvoie un string
(defun cp/add-other-auto-props-to-org-roam-properties ()
  ;; if the file already exists, don't do anything, otherwise...
  ;; if there's also a CREATION_TIME property, don't modify it
  (when (member "PERSONNE" (vulpea-buffer-tags-get))
    (cp/org-roam-property-file-add "VERSION" "3.0")
    (cp/org-roam-property-file-add "EMAIL" "")
    (cp/org-roam-property-file-add "EMAIL_HOME" "")
    (cp/org-roam-property-file-add "EMAIL_WORK" "")
    (cp/org-roam-property-file-add "PHONE" "")
    (cp/org-roam-property-file-add "CELL" "")
    (cp/org-roam-property-file-add "LANDLINE_HOME" "")
    (cp/org-roam-property-file-add "LANDLINE_WORK" "")
    (cp/org-roam-property-file-add "TITLE" "")
    (cp/org-roam-property-file-add "ORG" "")
    (cp/org-roam-property-file-add "ADDRESS_HOME" "")
    (cp/org-roam-property-file-add "ADDRESS_WORK" "")
    (cp/org-roam-property-file-add "BIRTHDAY" "")
    (cp/org-roam-property-file-add "URL" "")
    (cp/org-roam-property-file-add "NOTE" "")
    (cp/org-roam-property-file-add "CATEGORIES" "")
    (let
        ((note (vulpea-db-get-by-id (vulpea-db-get-id-by-file (buffer-file-name))))
         )
      (add-contact-to-file-of-contact note)
      )

    ;;on met à jour les tags après l'insertion des options
    (vulpea-ensure-filetag)

    )
  (when (member "LIEU" (vulpea-buffer-tags-get))


    ;;on met à jour les tags après l'insertion des options
    ;; (vulpea-ensure-filetag)
    )

  )

;;on hook après la capture
(add-hook 'org-capture-after-finalize-hook #'cp/add-other-auto-props-to-org-roam-properties)

;; (remove-hook 'org-roam-capture-new-node-hook #'cp/add-other-auto-props-to-org-roam-properties)

(setq file-of-contact (expand-file-name (concat org-roam-directory "pages/20220621120424-liste_de_mes_contacts_pour_org_contact.org")))
(defun add-contact-to-file-of-contact (note)
    (save-window-excursion
      (find-file file-of-contact)
      (search-forward "Inbox" nil t)
      (org-insert-heading-after-current)
      ;; (org-metaright)
      (insert (vulpea-note-title note))
      (newline)
      ;;on insère le lien, je pourrais concat mais flemme
      (insert ":PROPERTIES:")
      (newline)
      (insert "#+transclude:")
      ;;pour insérer la note (prendre fonction vulpea-utils-link-make-string un jour)
      (progn
        (insert (org-link-make-string
                 (concat " id:" (vulpea-note-id note))
                 (vulpea-note-title note)))
        (run-hook-with-args
         'vulpea-insert-handle-functions
         note))
      (insert " :lines 3-18")
      (newline)
      (insert ":END:")
      )
  )

(use-package org-vcard
  :init
  ;;la version utilisée (pour pouvoir y envoyer sur google)
  (setq org-vcard-default-version "3.0")
  :config
  (setq org-vcard-default-export-file (concat org-roam-directory "Contacts.vcf"))
  )


(fset 'cp/export-org-contact-macro
      (kmacro-lambda-form [?a ?o ?r ?g ?- ?v ?c ?a ?r ?d ?- ?e ?x ?p ?o ?r ?t return ?b ?u return ?f ?i ?l return home ?b ?p ?n ?u ?C ?o ?n ?t ?a ?c ?t ?s ?. ?v ?c ?f return] 0 "%d"))


(defun cp/function-to-export-org-contact ()
  (interactive)
  (save-window-excursion
    (find-file file-of-contact)
    (cp/export-org-contact-macro)
    )
  )

(use-package org-transclusion
  :config
  ;;pour exporter les propriétés
  (setq org-transclusion-exclude-elements nil)
  )

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

;; (use-package org-noter) ;; outdated ?


;; marche pas
;; (use-package org-noter
  ;; :straight (org-noter-plus-djvu
             ;; :type git
             ;; :host github
             ;; :repo "c1-g/org-noter-plus-djvu")
  ;; )


(use-package org-remark)
(require 'org-remark-global-tracking)
(org-remark-global-tracking-mode +1)

;; Key-bind `org-remark-mark' to global-map so that you can call it
;; globally before the library is loaded.

(define-key global-map (kbd "C-c n m") #'org-remark-mark)

;; The rest of keybidings are done only on loading `org-remark'
(with-eval-after-load 'org-remark
  (define-key org-remark-mode-map (kbd "C-c n o") #'org-remark-open)
  (define-key org-remark-mode-map (kbd "C-c n ]") #'org-remark-view-next)
  (define-key org-remark-mode-map (kbd "C-c n [") #'org-remark-view-prev)
  (define-key org-remark-mode-map (kbd "C-c n r") #'org-remark-remove))


;; (use-package org-noter
;;   :after (:any org pdf-view)
;;   :config
;;   (setq
;;    ;; The WM can handle splits
;;    org-noter-notes-window-location 'other-frame
;;    ;; Please stop opening frames
;;    org-noter-always-create-frame nil
;;    ;; I want to see the whole file
;;    org-noter-hide-other nil
;;    ;; Everything is relative to the main notes file
;;    org-noter-notes-search-path (list org_notes)
;;    )
;;   )

(use-package org-archive
  :straight nil
  :defer t

  :init
  (setq-default
   org-archive-file-header-format "" ;;ce qui est affiché au début du fichier
   org-archive-location
   (concat braindump-directory "org/.archive/%s_archive" "::" "* Tâches archivées")
   ;; (concat braindump-directory "org/.archive/%s_archive" "::" "datetree/")
   ;; (concat braindump-directory "org/.archive/datetree.org::datetree/")
   org-archive-save-context-info
   '(time file ltags itags todo category olpath))

  :config
  ;; (setq org-attach-archive-delete t) ;; permet, si jamais ya des pièces jointe avec un subtree qui est archivé, de les supprimer
  )

;; (setq org-archive-location "%s_archive::* ArchivedTasksfrom%s")

(defun cp/org-archive-done-tasks ()
  (interactive)
  (when (org-roam-buffer-p)
    (save-excursion
      (goto-char (point-min))
      (while (re-search-forward
              (concat "\\* " (regexp-opt org-done-keywords) " ") nil t)
        ;; (goto-char (line-beginning-position))
        (when (= (org-outline-level) 1)
          ;; (when (y-or-n-p  (format "voulez vous archiver %S ?" (org-entry-get nil "ITEM")))
          (org-archive-subtree)
          ;; )
          )))))

;; (add-hook 'org-trigger-hook 'save-buffer)
;; (remove-hook 'org-trigger-hook 'save-buffer)

(add-hook 'before-save-hook 'cp/org-archive-done-tasks)
;; (remove-hook 'before-save-hook 'cp/org-archive-done-tasks)

;; commande pour trouver et mettre en done les évènement passée
(defun cp/org-ql-search-for-past-timestamps()
  (org-ql-select (org-agenda-files)
    '(and
      (not (scheduled))
      (not (deadline))
      (not (done))
      (ts-active :to today)
      )
    :action '(org-todo "DONE")
    )
  )

;; on clean quand on kill emacs
(add-hook 'kill-emacs-hook #'cp/org-ql-search-for-past-timestamps)

(require 'org-protocol)

(use-package epa-file
  :straight nil ;; included with Emacs
  :config
  (epa-file-enable)
  ;; (setq epa-file-encrypt-to '("my@email.address.org"))
  (setq epa-file-select-keys nil)
  (when termux-p
    (setq epa-pinentry-mode 'loopback) ;;demande le mdp dans le mini-buffer
    (setq epg-gpg-program "/data/data/com.termux/files/usr/bin/gpg")
    )
  )

(use-package org-crypt
  :straight nil  ;; included with org-mode
  :after org
  :custom
  ;; (org-crypt-key "my@email.address.org")
  (org-crypt-key nil)
  :config
  (org-crypt-use-before-save-magic)
  ;; org-tags-exclude-from-inheritance '("crypt")
  ;; (require 'org-crypt)
  )

)

(use-package org-roam
  :if braindump-exists

:init
;;éviter d'avoir la nottif de version 1 à 2 
(setq org-roam-v2-ack t)

:config

(defun org-roam-db-sync-when-change (event)
  (message "Mise à jour de la base de donnée d'org-roam")
  (org-roam-db-sync)  
  )

(require 'filenotify)
(file-notify-add-watch (concat braindump-directory "org/pages")
                       '(attribute-change) 'org-roam-db-sync-when-change)

;; complétion et proprosition
(setq org-roam-completion-everywhere t) ;; pour avoir la complétion partout avec company
(setq completion-ignore-case t) ;; ne dépend pas de la case pour la complétion
(with-eval-after-load 'company
  (add-to-list 'company-backends 'company-capf) ;;completion avec org-roam
  )


(with-eval-after-load 'company-box

  (add-hook 'org-mode-hook 'company-mode)
  (add-hook 'org-mode-hook '(lambda () (company-box-mode 0)))

  )

;; syncro automatique avec les fichiers
(org-roam-db-autosync-mode)

;; pour améliorer les perf
(setq org-roam-db-gc-threshold most-positive-fixnum)

;; On prend pas les fichiers org dans org-attach
(setq org-roam-file-exclude-regexp ".data/")

;;ajout du tag BROUILLON tant que c'est pas fini
(defun jethro/tag-new-node-as-draft ()
  (when
      ;; (not (member (buffer-file-name) (org-roam-dailies--list-files)))
      (string-equal (expand-file-name default-directory)
                    (concat org-roam-directory org-roam-dailies-directory))
    (org-roam-tag-add '("BROUILLON"))
    )
  ;; (org-roam-tag-add '("BROUILLON"))
  )
(add-hook 'org-roam-capture-new-node-hook #'jethro/tag-new-node-as-draft)


(setq org-roam-capture-templates
      '(
        ("d" "default" plain "%?"
         :target (file+head "pages/%<%Y%m%d%H%M%S>-${slug}.org"
                            "#+title: ${title}\n")
         :unnarrowed t)
        ("p" "connaissances multiples à trier ds 2jours" plain (file "../templatesOrgCapture/connaissance.org")
         :target (file+head "pages/%(substring (shell-command-to-string \"uuidgen\")0 -1).org"
                            "#+title: ${title}\n")
         :unnarrowed t)

        ("l" "lien simple" plain (file "../templatesOrgCapture/lien.org")
         :target (file+head "liens/%(substring (shell-command-to-string \"uuidgen\")0 -1).org"
                            "#+title: ${title}\n")
         :unnarrowed t
         :immediate-finish t)
        ("s" "simple/basique" plain (file "../templatesOrgCapture/simple.org")
         :target (file+head "pages/%(substring (shell-command-to-string \"uuidgen\")0 -1).org"
                            "#+title: ${title}\n")
         :unnarrowed t
         :immediate-finish t)
        ("c" "contact" plain (file "../templatesOrgCapture/contact.org")
         :target (file+head "pages/%(substring (shell-command-to-string \"uuidgen\")0 -1).org"
                            "#+title: ${title}\n")
         :unnarrowed t)

        ("C" "Crypter" plain "%?"
         :target (file+head "pages/%(substring (shell-command-to-string \"uuidgen\")0 -1).org.gpg"
                            "#+title: ${title}\n")
         :unnarrowed t)


        ("T" "Test de nouveau nom" plain "%?"
         :target (file+head "pages/%(substring (shell-command-to-string \"uuidgen\")0 -1).org"
                            "#+title: ${title}\n")
         :unnarrowed t)

        ("r" "bibliography reference" plain
         (file "../templatesOrgCapture/key.org")
         :if-new 
         (file+head "reference/${citekey}.org" "#+title: ${title}\n")
         :unnarrowed t
         :jump-to-captured t)


        ("r" "bibliography reference" plain
         (file "../templatesOrgCapture/key.org")
         :target
         (file+head "reference/${citekey}.org" "#+title: ${title}\n")
         :unnarrowed t)

        )
      )

;;défini la capture de mon journal
(setq org-roam-dailies-directory "journals/")

(setq org-roam-dailies-capture-templates  '(
                                            ("d" "default" entry "* %<%H:%M> %?" :target
                                             (file+head "%<%Y-%m-%d>.org" "#+title: %<%Y-%m-%d>\n"))
                                            ))

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

(defun cp/org-roam-unlinked-references-find-and-replace ()
  (message "Check unlinked references")
  (save-window-excursion
    (if-let* ((note (vulpea-db-get-by-id (org-id-get)))
              (id (vulpea-note-id note))
              (title (vulpea-note-title note))
              (FROM-STRING title) 
              (TO-STRING (concat "[[id:" id "][" title "]]")))
        (progn


          (dolist (file (org-roam-list-files))
            ;; on check pas les fichiers cryptés !
            (unless (string-equal (file-name-extension file) "gpg")
              (find-file file)
              (unless (string-equal id (vulpea-db-get-id-by-file (buffer-file-name))) ;;faut pas que ce soit le fichier de base
                (save-excursion
                  (goto-char (point-min))
                  (while (re-search-forward
                          (concat "\\([ ]\\|^\\)" title "\\([ ]\\|$\\)")
                          nil t)
                    (goto-char (match-beginning 0))
                    (skip-chars-forward " ")
                    (search-forward FROM-STRING)

                    (when (y-or-n-p "Remplacé le texte par un lien vers le nouveau titre ?")

                      ;; obligé de faire ça à cause du y-or-n-p qui me brise mon match. Je pourrais juste mettre (search-forward FROM-STRING) ici, mais si je remplace pas le texte, boucle infini
                      (search-backward FROM-STRING)
                      (goto-char (match-end 0))

                      (replace-match TO-STRING)
                      (message "Texte remplacé")
                      )))
                ;; ancien ;;(query-replace FROM-STRING TO-STRING nil (point-min) (point-max)) ;; pour pas prendre en compte quand c'est dans une chaîne 3 argument t
                (save-buffer)
                )))
          (message "Fin check unlinked references")
          )        ;; fin du si oui

      (progn (message "Pas besoin de check les références"))
      )))

;;(add-hook 'org-capture-after-finalize-hook #'(lambda () (when (member (buffer-file-name) (org-roam-list-files)) (cp/org-roam-unlinked-references-find-and-replace))))


(add-hook 'org-capture-after-finalize-hook
          #'(lambda ()
              (save-window-excursion
                (org-capture-goto-last-stored)
                (when (member (buffer-file-name) (org-roam-list-files)) (cp/org-roam-unlinked-references-find-and-replace)))))

;; todo : utiliser ceci
  ;; (title-without-parens-and-space "testetau   ()")


(defun cp/org-roam-rename-and-replace ()
  (interactive)
  (save-window-excursion
    (let* ((note (vulpea-select-from "la note à changer de nom" (vulpea-db-query)))
           (id (vulpea-note-id note))
           (title (vulpea-note-title note))
           (new-title (read-string "nouveau nom "))
           (FROM-STRING (concat "[[id:" id "][" title "]]")) 
           (TO-STRING (concat "[[id:" id "][" new-title "]]")))
      ;; on rename dans le fichier de base
      (find-file (vulpea-db-get-file-by-id id))
      (vulpea-buffer-title-set new-title)
      ;; pour les autres fichiers
      (dolist (file (org-roam-list-files))
        (find-file file)
        (unless (string-equal id (vulpea-db-get-id-by-file (buffer-file-name))) ;;faut pas que ce soit le fichier de base
          (query-replace FROM-STRING TO-STRING nil (point-min) (point-max)) ;; pour pas prendre en compte quand c'est dans une chaîne 3 argument t
          (save-buffer)
          )))))

(defun cp/history-of-a-node (&optional file)
    (interactive (list (vulpea-db-get-file-by-id (vulpea-note-id (vulpea-select-from "historique de cette note : " (vulpea-db-query))))))
    (find-file file)
    (magit-log-buffer-file)
    (delete-other-windows)
    )

(defun cp/vulpea-get-id-at-point()
  "renvoie l'id du noeud au point actuel"
  (let ((id (org-id-get)))
    ;; tant que actuelle pas d'id, alors on monte,
    (save-excursion
      (while (and (ignore-errors (outline-up-heading 1 t)) (not id))
        (when (org-id-get)
          (setq id (org-id-get)))
        )
      ;; sinon on prend l'id du buffer
      (unless id
        (save-excursion
          (goto-char (point-min))
          (setq id (org-id-get)))
        ))
    id
    ))

(defun cp/vulpea-links-to()
  "Renvoie une liste de note présent dans le noeud"
  (let (end)
    (dolist (id (remove nil
                        (mapcar
                         (lambda (x)
                           (when (string-equal (car x) "id")
                             (cdr x))
                           )
                         (vulpea-note-links (vulpea-db-get-by-id
                                             (cp/vulpea-get-id-at-point)
                                             ))
                         )))
      ;; (message "test %S"(vulpea-db-get-by-id id))
      (push (vulpea-db-get-by-id id) end)
      )
    end
    )
  )


(defun cp/vulpea-find-backlink-and-links ()
  "Select and find a note linked to current note."
  (interactive)
  (let* ((node (org-roam-node-at-point 'assert))
         (backlinks (vulpea-db-query-by-links-some
                     (list (cons "id"
                                 (org-roam-node-id node)))))
         (links-to (cp/vulpea-links-to))
         )
    (unless (or backlinks links-to)
      (user-error "Pas de lien vers ni de backlinks"))
    ;; (message "les deux %S" (append test backlinks))
    ;; (message "back %S" backlinks)
    (vulpea-find
     :candidates-fn (lambda (_) (append
                                 backlinks
                                 ;; '(#s(vulpea-note "20220728120707052420" "/home/utilisateur/braindump/org/pages/20220728120707-test_nom_simpl.org" 0 "Liens vers :" nil nil nil (("id" . "20220617105540968308") ("id" . "20220617115633324937") ("id" . "20220623142208004885") ("id" . "20220616193340664791")) (("CATEGORY" . "20220728120707-test_nom_simpl") ("ID" . "20220728120707052420") ("BLOCKED" . "") ("FILE" . "/home/utilisateur/braindump/org/pages/20220728120707-test_nom_simpl.org") ("PRIORITY" . "D")) (("linkInTitle" "[[id:20220617105540968308][Git]]" "[[id:20220617115633324937][Page de Test]]" "[[id:20220623142208004885][Histoire de la chine]]" "[[id:20220616193340664791][Comment faire un second cerveau]]"))))
                                 links-to))
     :require-match t)))

(defun cp/vulpea-navigate-with-backlink-and-links ()
  (interactive)
  (if (member (buffer-file-name) (org-roam-list-files))
      (while t
        (cp/vulpea-find-backlink-and-links)
        )
    (message "il faut être dans un buffer org-mode")
    )
  )

;; l'améliorer en prenant les choses différents et avec tout dans un let
(defun cp/vulpea-heading-to-note()
  (interactive)
  (when-let* ((note (vulpea-db-get-by-id (cp/vulpea-get-id-at-point)))
              (heading (org-entry-get nil "ITEM"))
              (title (progn (while (setq name (vulpea-note-id (setq notetest (vulpea-select "Veuillez choisir un nom qui n'existe pas :" :initial-prompt heading))))
                              )
                            (vulpea-note-title notetest))
                     )

              (source (vulpea-meta-get note "Source"))
              (lieu (vulpea-meta-get note "Lieu"))
              )
    (save-excursion
      (ignore-errors (outline-up-heading 0))
      (save-restriction
        (org-narrow-to-subtree)
        ;; on coupe le titre
        (delete-region (line-beginning-position) (line-beginning-position 2))
        ;;
        (setq contenu (buffer-substring-no-properties (point-min) (point-max)))
        (delete-region (point-min) (point-max))
        (vulpea-create
         title
         "pages/%(substring (shell-command-to-string \"uuidgen\")0 -1).org"
         ;; :properties '(("COUNTER" . "1")
         ;; ("STATUS" . "ignore")
         ;; ("ROAM_ALIASES" . "\"Very rich note with an alias\""))
         ;; :tags '("documentation" "showcase")
         ;; :head "#+author: unknown\n#+date: today"
         :body (concat
                "- Source :: " source "\n"
                "- Lieu :: " lieu "\n"
                contenu
                )
         ;; :immediate-finish t
         )))))

(defun cp/org-roam-ref-add-check (keys-entries)
  (interactive (list (citar-select-ref :multiple nil :rebuild-cache t)))
  (let ((title (citar--format-entry-no-widths (cdr keys-entries)
                                              "${author editor} :: ${title}"))

        (citation-key (car keys-entries))
        )
    (when (member `(,citation-key) ;; ` = liste, mais permet d'évaluer la variable juste aprèsle,
                  (org-roam-db-query
                   [:select ref
                            :from refs
                            :left-join nodes
                            :on (= refs:node-id nodes:id)]))
      (org-roam-ref-remove (citar-org-return-citation-string (citar--extract-keys (list citation-key))))
      (user-error "La référence est déjà mise dans un autre noeud pour la ROAM_REFS"))
    ))

;; (advice-add 'cp/org-roam-ref-add :before #'cp/org-roam-ref-add-check)
;; (advice-remove 'cp/org-roam-ref-add #'cp/org-roam-ref-add-check)

;; (advice-add 'org-roam-ref-add :before #'cp/org-roam-ref-add-check)
;; (advice-remove 'org-roam-ref-add #'cp/org-roam-ref-add-check)

(defun citar-org-return-citation-string (keys &optional style)
  "Inspiré de citar-org-insert-citation. Au lieu d'insérer, renvoie"
  (let ((context (org-element-context)))
    (when style
      (let ((raw-style
             (citar-org-select-style)))
        (setq style
              (if (string-equal raw-style "") raw-style
                (concat "/" raw-style)))))
    (if-let ((citation (citar-org--citation-at-point context)))
        (when-let ((keys (seq-difference keys (org-cite-get-references citation t)))
                   (keystring (mapconcat (lambda (key) (concat "@" key)) keys "; "))
                   (begin (org-element-property :contents-begin citation)))
          (if (<= (point) begin)
              (org-with-point-at begin
                (insert keystring ";"))
            (let ((refatpt (citar-org--reference-at-point)))
              (org-with-point-at (or (and refatpt (org-element-property :end refatpt))
                                     (org-element-property :contents-end citation))
                (if (char-equal ?\; (char-before))
                    (insert-before-markers keystring ";")
                  (insert-before-markers ";" keystring))))))
      (format "[cite%s:%s]" (or style "")
              (mapconcat (lambda (key) (concat "@" key)) keys "; "))
      )))

(defun cp/org-roam-ref-add (keys-entries)
  "Add REF to the node at point."
  (interactive (list (citar-select-ref :multiple nil :rebuild-cache t)))
  (cp/org-roam-ref-add-check keys-entries) ;;check si la ref est déja mise
  (let ((node (org-roam-node-at-point 'assert))
        (ref-key (citar-org-return-citation-string (citar--extract-keys (list keys-entries)))))
    (save-excursion
      (goto-char (org-roam-node-point node))
      (org-roam-property-add "ROAM_REFS" ref-key))))

(defun cp-open-node-roam-ref-url (&optional id)
  "Open the URL in this node's ROAM_REFS property, if one exists"
  (interactive)
  (when-let*
      ((roam_refs
        (progn
          (save-window-excursion
            (when (not (null id))
              (find-file (vulpea-db-get-file-by-id id)))
            (ignore-errors(split-string (org-entry-get-with-inheritance "ROAM_REFS"))))))
       (url-re
        ;; "\\b\\(\\(www\\.\\|\\(s?https?\\|ftp\\|file\\|gopher\\|nntp\\|news\\|telnet\\|wais\\|mailto\\|info\\):\\)\\(//[-a-z0-9_.]+:[0-9]*\\)?\\(?:[-a-z0-9_=#$@~%&*+\\/[:word:]!?:;.,]+([-a-z0-9_=#$@~%&*+\\/[:word:]!?:;.,]+)\\(?:[-a-z0-9_=#$@~%&*+\\/[:word:]!?:;.,]+[-a-z0-9_=#$@~%&*+\\/[:word:]]\\)?\\|[-a-z0-9_=#$@~%&*+\\/[:word:]!?:;.,]+[-a-z0-9_=#$@~%&*+\\/[:word:]]\\)\\)"
        url-handler-regexp
        )
       ref-url 
       )
    (dolist (ref roam_refs)
      (when (string-match url-re ref)
        (setq ref-url ref)))
    (browse-url ref-url)))

(use-package consult-org-roam
   :config
   ;; Activate the minor-mode
   (consult-org-roam-mode 1)
   (setq consult-org-roam-grep-func #'consult-ripgrep))

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

(setq bibtex-dialect 'biblatex)

(setq bibtex-completion-bibliography bibliography-file-list)
(setq bibtex-completion-library-path bibliography-library-paths)
(setq bibtex-completion-pdf-field "File") ;; pour trouver les pdf

(use-package citar
  ;; :after all-the-icons ;; besoin des icones pour charger les propositions
  ;; :after oc-csl all-the-icons
  :custom
  ;;lieu de ma bibliographie
  (citar-bibliography bibliography-file-list)
  ;; lieu de mes fichiers pour citar
  (citar-library-paths bibliography-library-paths)
  :config
  ;; pour complété avec consult yeah, pas besoin
  ;; (advice-add #'completing-read-multiple :override #'consult-completing-read-multiple)

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
  (citar-filenotify-setup '(LaTeX-mode-hook org-mode-hook))

  ;;ancien et test    
  ;; (require 'filenotify)
  ;; (file-notify-add-watch "/home/utilisateur/biblio.bib"
  ;; '(attribute-change) 'citar-refresh)

  ;; (dolist (bibliography-file bibliography-file-list)
  ;; (file-notify-add-watch bibliography-file
  ;; '(attribute-change) 'citar-refresh)
  ;; )

  ;; (require 'filenotify)
  ;; (setq citar-filenotify-callback 'refresh-cache)
  ;; (citar-filenotify-setup '(LaTeX-mode-hook org-mode-hook))
  ;; (defun gen-bib-cache-idle ()
  ;; "Generate bib item caches with idle timer"
  ;; (run-with-idle-timer 0.5 nil #'citar-refresh))
  ;; (add-hook 'LaTeX-mode-hook #'gen-bib-cache-idle)
  ;; (add-hook 'org-mode-hook #'gen-bib-cache-idle)


  ;;patch pour ajouter des citations dans le mini-buffer avec le style POUR ORG-MODE SEULEMENT 
  (defcustom citar-major-mode-functions
    '(((org-mode) .
       ((local-bib-files . citar-org-local-bib-files)
        (insert-citation . citar-org-insert-citation)
        (insert-edit . citar-org-insert-edit)
        (key-at-point . citar-org-key-at-point)
        (citation-at-point . citar-org-citation-at-point)
        (list-keys . citar-org-list-keys)))
      ((latex-mode) .
       ((local-bib-files . citar-latex-local-bib-files)
        (insert-citation . citar-latex-insert-citation)
        (insert-edit . citar-latex-insert-edit)
        (key-at-point . citar-latex-key-at-point)
        (citation-at-point . citar-latex-citation-at-point)
        (list-keys . reftex-all-used-citation-keys)))
      ((markdown-mode) .
       ((insert-keys . citar-markdown-insert-keys)
        (insert-citation . citar-markdown-insert-citation)
        (insert-edit . citar-markdown-insert-edit)
        (key-at-point . citar-markdown-key-at-point)
        (citation-at-point . citar-markdown-citation-at-point)
        (list-keys . citar-markdown-list-keys)))

      ;;patch début ici
      ((minibuffer-mode) .
       ( (insert-citation . citar-org-insert-citation)
         ))
      ;;patch fin ici

      (t .
         ((insert-keys . citar--insert-keys-comma-separated))))
    "The variable determining the major mode specific functionality.

                It is alist with keys being a list of major modes.

                The value is an alist with values being functions to be used for
                these modes while the keys are symbols used to lookup them up.
                The keys are:

                local-bib-files: the corresponding functions should return the list of
                local bibliography files.

                insert-keys: the corresponding function should insert the list of keys given
                to as the argument at point in the buffer.

                insert-citation: the corresponding function should insert a
                complete citation from a list of keys at point.  If the point is
                in a citation, new keys should be added to the citation.

                insert-edit: the corresponding function should accept an optional
                prefix argument and interactively edit the citation or key at
                point.

                key-at-point: the corresponding function should return the
                citation key at point or nil if there is none.  The return value
                should be (KEY . BOUNDS), where KEY is a string and BOUNDS is a
                pair of buffer positions indicating the start and end of the key.

                citation-at-point: the corresponding function should return the
                keys of the citation at point, or nil if there is none.  The
                return value should be (KEYS . BOUNDS), where KEYS is a list of
                strings and BOUNDS is pair of buffer positions indicating the
                start and end of the citation.

                list-keys: the corresponding function should return the keys
                of all citations in the current buffer."
    :group 'citar
    :type 'alist)
  )

(use-package citeproc
  :straight (:host github :repo "andras-simonyi/citeproc-el")
  :after citar

  :init
  ;; nom du titre exporté pour la bibliographie
  (with-eval-after-load 'ox-hugo
    (plist-put org-hugo-citations-plist :bibliography-section-heading "References"))

  :config

  (setq org-cite-global-bibliography bibliography-file-list) ;; pour que org-cite sache où est ma biblio


  (require 'oc-csl)
  (setq org-cite-export-processors '((t csl)));; exporter tout le temps avec la méthode csl

  ;; les fichiers de configuration. Impossible de les configurer "normalement" (voir en dessous), j'utilise donc les fichiers "fallback" qui sont ceux par défaut
  ;; (setq org-cite-csl--fallback-style-file "/home/msi/documents/notes/braindump/org/chicago-author-date-16th-edition.csl") ;;

  (setq org-cite-csl--fallback-locales-dir bibliography-directory)
  (setq org-cite-csl--fallback-style-file (concat bibliography-directory "vancouver-brackets.csl"));; pour changer le style. Vancouver = numéro

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

(setq bibtex-autokey-year-length 4
      bibtex-autokey-name-year-separator "-"
      bibtex-autokey-year-title-separator "-"
      bibtex-autokey-titleword-separator "-"
      bibtex-autokey-titlewords 2
      bibtex-autokey-titlewords-stretch 1
      bibtex-autokey-titleword-length 5)

(use-package ebib
  :config
  (setq ebib-bibtex-dialect 'biblatex
        ebib-preload-bib-files bibliography-file-list

        ebib-link-file-path-type 'adaptive

        ebib-truncate-file-names t ;; pour pas couper le nom des fichiers
        ebib-default-directory "/home/utilisateur/.emacs.d/config/dossierCitation/"
        ebib-file-search-dirs bibliography-library-paths

        ebib-file-associations nil ;; pour ouvrir pdf ou autre. Si rien, alors fait juste un "find-file", donc parfait

        )

  (define-key ebib-index-mode-map [remap next-line] #'ebib-next-entry)
  (define-key ebib-index-mode-map [remap previous-line] #'ebib-prev-entry)

  (define-key ebib-entry-mode-map [remap next-line] #'ebib-next-field)
  (define-key ebib-entry-mode-map [remap previous-line] #'ebib-prev-field)

  )

(use-package parsebib
  :straight (parsebib
             :type git
             :host github
             :repo "joostkremers/parsebib")
  )

;; juste pour la fonction org-ref-clean-bibtex-entry
  (use-package org-ref
    :config
    (setq org-ref-bibtex-pdf-download-dir (car bibliography-library-paths))

    (setq org-ref-clean-bibtex-entry-hook
          '(org-ref-bibtex-format-url-if-doi
            orcb-key-comma
            ;; org-ref-replace-nonascii ;; pour que les accents ne reste pas
            orcb-&
            orcb-%
            org-ref-title-case-article
            orcb-clean-year
            orcb-key
            orcb-clean-doi
            orcb-clean-pages
            orcb-check-journal
            org-ref-sort-bibtex-entry
            orcb-fix-spacing
            orcb-download-pdf
            org-ref-stringify-journal-name
            ))


    (setq org-ref-bibtex-sort-order
          '(("article"  . ("author" "title" "journal" "volume" "number" "pages" "year" "doi" "url"))
            ("inproceedings" . ("author" "title" "booktitle" "year" "volume" "number" "pages" "doi" "url"))
            ("book" . ("author" "title" "year" "publisher" "url"))
            ("online" . ("author" "title" "booktitle" "year" "volume" "number" "pages" "doi" "url"))
            ))

    ;;dépendence non chargé

    (use-package async)

    ;; corrections

    (defun orcb-check-journal ()
      "Check entry at point to see if journal exists in `org-ref-bibtex-journal-abbreviations'.
              If not, issue a warning."
      (interactive)
      (bibtex-beginning-of-entry) ;;moddif ici
      (when
          (string= "article"
                   (downcase
                    (cdr (assoc "=type=" (bibtex-parse-entry)))))
        (save-excursion
          (bibtex-beginning-of-entry)
          (let* ((entry (bibtex-parse-entry t))
                 (journal (or (cdr (assoc "journal" entry)) (cdr (assoc "journaltitle" entry)))))  ;;moddif ici condition
            (when (null journal)
              (warn "Unable to get journal for this entry."))
            (unless (member journal (-flatten org-ref-bibtex-journal-abbreviations))
              (message "Journal \"%s\" not found in org-ref-bibtex-journal-abbreviations." journal))))))

    ;;   ;;check tjr les clées
    ;;   (defun orcb-key (&optional allow-duplicate-keys)
    ;;     "Replace the key in the entry.
    ;; Prompts for replacement if the new key duplicates one already in
    ;; the file, unless ALLOW-DUPLICATE-KEYS is non-nil."
    ;;     (let ((key (funcall org-ref-clean-bibtex-key-function
    ;;                         (bibtex-generate-autokey))))
    ;;       ;; remove any \\ in the key
    ;;       (setq key (replace-regexp-in-string "\\\\" "" key))
    ;;       ;; first we delete the existing key
    ;;       (bibtex-beginning-of-entry)
    ;;       (re-search-forward bibtex-entry-maybe-empty-head)
    ;;       (if (match-beginning bibtex-key-in-head)
    ;;           (delete-region (match-beginning bibtex-key-in-head)
    ;;                          (match-end bibtex-key-in-head)))
    ;;       ;; check if the key is in the buffer


    ;;       (message "salut %s %s %s" (not allow-duplicate-keys) key
    ;;                    (bibtex-search-entry key nil nil))

    ;;       (when (and (not allow-duplicate-keys)
    ;;                  (save-excursion

    ;;                    (bibtex-search-entry key)))

    ;;         (save-excursion
    ;;           (bibtex-search-entry key)
    ;;           (bibtex-copy-entry-as-kill)
    ;;           (switch-to-buffer-other-window "*duplicate entry*")
    ;;           (bibtex-yank))
    ;;         (setq key (bibtex-read-key "Duplicate Key found, edit: " key)))

    ;;       (insert key)
    ;;       (kill-new key)))

(defun bibtex-autokey-get-year ()
  "Return year field contents as a string obeying `bibtex-autokey-year-length'."
  (let* ((str (bibtex-autokey-get-field '("date" "year"))) ; possibly ""
         (year (or (and (iso8601-valid-p str)
                        (let ((year (decoded-time-year (iso8601-parse str))))
                          (and year (number-to-string year))))
                   ;; BibTeX permits a year field "(about 1984)", where only
                   ;; the last four nonpunctuation characters must be numerals.
                   (and (string-match "\\([0-9][0-9][0-9][0-9]\\)[^[:alnum:]]*\\'" str)
                        (match-string 1 str))
                   (user-error "Year or date field `%s' invalid" str))))
    (substring year (max 0 (- (length year) bibtex-autokey-year-length)))))
    
    )

(use-package org-roam-bibtex
  :config 

  (setq citar-open-note-functions '(orb-citar-edit-note))
  ;; (setq citar-notes-paths nil) ;; si jamais je ne configure pas citar-open-note-functions
  (setq orb-citekey-format 'org-cite) ;; pour @key

  (setq orb-preformat-keywords
        '("citekey" "title" "url" "author-or-editor" "keywords" "file")
        orb-process-file-keyword t
        orb-attached-file-extensions '("pdf"))

  )

(use-package biblio
  :config
  (setq biblio-download-directory (car bibliography-library-paths))
  )

(defun lancer-serveur-zotra()
  (interactive)
  (async-shell-command
   (concat
    "cd && cd .emacs.d/config/dossierCitation/translation-server/"
    " && npm start"
    ))
  )

(unless termux-p (lancer-serveur-zotra))

(use-package zotra
  :straight (zotra
             :type git
             :host github
             :repo "mpedramfar/zotra")
  :config

  (add-hook 'zotra-after-add-entry-hook 'org-ref-clean-bibtex-entry)

  (setq zotra-default-entry-format "biblatex")
  (setq zotra-default-bibliography (car bibliography-file-list))
  (setq zotra-url-retrieve-timeout 5) ;; plus de temps pour les demandes
  )
