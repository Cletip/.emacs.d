;;; LayerXahFlyKey.el --- Permet de rajouter mes raccourcis au formidable "xah fly key". -*- lexical-binding: t -*-

;; Copyright (C) 2021  Clément Payard

;; Author: Payard Clément <clement020302@gmail.com>
;; Keywords: lisp
;; Version: 0.0.20
      ;;; Commentary:


;;comment here
;;test de commentaire

      ;;; Code:


(require 'straight)  
(require 'xah-fly-keys)
(require 'use-package)

;;changer la variable ici pour changer la touche de la major mode !
(defvar lieumajor)
(setq lieumajor ",")

(defun my-wrapper-bis (&rest args)
  "call different commands depending on what's current major mode."
  (interactive)
  ;;pour que ça marche, necessite un argument utilisé ici. Mais enlevé avec les autres messages pour pas que se soit moche
  ;; (message "wrapper called %s" args)
  (cond
   ((string-equal major-mode "org-mode")
    ;; (message "org mode")
    (define-key xah-fly-command-map (kbd lieumajor) 'org-mode-keymap)
    )
   ((string-equal major-mode "org-agenda-mode")
    ;; (message "")
    (define-key xah-fly-command-map (kbd lieumajor) 'xah-fly-org-agenda-mode-keymap)
    )
   ((string-equal major-mode "java-mode")
    ;; (message "org mode")
    (define-key xah-fly-command-map (kbd lieumajor) 'xah-fly-java-mode-keymap)
    )
   ((string-equal major-mode "c-mode")
    ;; (message "org mode")
    (define-key xah-fly-command-map (kbd lieumajor) 'xah-fly-c-mode-keymap)
    )
   ;; more major-mode checking here
   ;; if nothing match, mettre major mode hydra (tempo)
   (t
    ;; (message " Pas de mode pour le majeur mode ")
    ;; 
    (define-key xah-fly-command-map (kbd lieumajor) 'major-mode-hydra)
    )
   )
  )

;;chaque fois qu'on change de fenêtre/qu'on en créer etc
;;c'est le super hook en quelque sorte
(add-to-list 'window-buffer-change-functions #'my-wrapper-bis)
(add-to-list 'window-selection-change-functions #'my-wrapper-bis)
(add-hook 'window-selection-change-functions #'my-wrapper-bis)

(defun cp/refile-and-clear-state ()
  (interactive)
  (if (string= (buffer-name) "*Org Agenda*")
      (org-agenda-refile)
    (org-refile)
    )
  (org-refile-goto-last-stored)
  (org-todo "") 			;permet de switch sur le state "vide"
  (switch-to-buffer "*Org Agenda*")
  (delete-other-windows)
  (xah-fly-insert-mode-activate)
  (sleep-for 0.5)
  (setq unread-command-events (listify-key-sequence "g"))
  (xah-fly-command-mode-activate)
  )

(defun cp/refile-and-clear-state-v2 ()
  (interactive)
  (if (string= (buffer-name) "*Org Agenda*")
      (progn
	(org-agenda-switch-to)
	(org-todo "")
	(switch-to-buffer "*Org Agenda*")
	(org-agenda-refile)
	(xah-fly-insert-mode-activate)
	(sleep-for 0.5)
	(setq unread-command-events (listify-key-sequence "g"))
	(xah-fly-command-mode-activate)
	)
    (progn
      (org-todo "")
      (org-refile)
      )
    )
  )

(defun cp/go-to-config ()
  (interactive)
  (find-file "~/.emacs.d/config.org")
  )

(defun cp/go-to-code ()
(interactive)
(find-file "~/Documents/Code"))

(defun cp/go-to-cours ()
   (interactive)
   (find-file "~/documents/mesdocuments/professionnel/cours/S4"))

(defun cp/go-to-LayerXahFlyKey ()
   (interactive)
   (find-file (concat my-user-emacs-directory "lisp/LayerXahFlyKey/LayerXahFlyKey.org")))

(defun cp/go-to-documents ()
  (interactive)
  (find-file "~/Documents/"))

(defun cp/go-to-orgzly-Nell ()
  (interactive)
  (find-file "~/Dossier_partage_nous_deux/Orgzly")
  )

(defun cp/go-to-braindump ()
  (interactive)
  (find-file "~/Documents/Code/MesSitesWeb/braindump")
  )

(defun cp/go-to-windows ()
    (interactive)
    (find-file "/media/msi/Windows/Users/Utilisateur/Mes documents/Utile/Dossiercommunwindowslinux")
    )

(defun cp/go-to-téléchargements ()
    (interactive)
    (find-file "  ~/Téléchargements")
    )

(defun cp/go-to-temp ()
      (interactive)
      (find-file "~/.emacs.dclean")
      )

(fset 'Insertion-code-latex-dans-org
 (kmacro-lambda-form [?i ?\[ ?< backspace ?\\ menu ?t ?t ?i ?\\ menu ?r ?i ?  ?  ?  menu ?t ?t] 0 "%d"))

(use-package hydra)

(use-package pretty-hydra)

(use-package major-mode-hydra)

(defhydra move/texte (:color pink
			     :hint nil)
  "
^Ligne^             ^Region^          
^^^^^^^^-----------------------------
_d_: up         _D_: up     
_s_: down          _S_: down    

"
  ("d" move-text-line-up)
  ("s" move-text-line-down)

  ("D" move-text-region-up)
  ("S" move-text-region-down)


  ("q" quit-window "quit" :color blue)
  )

;; (pretty-hydra-define Navigation-hydra (:foreign-keys warn :title "navigation" :quit-key "q")
;;   (
;;    "Work"
;;    (
;;     ("c" Cours-visit "Cours-visit")
;;     ("g" github-visit "Github")
;;     ;; ("d" (dired "~/") "Général")
;;     )
;;    "RPGs"
;;    (
;;     ("a" go-roam-find-ardu "Ardu, World of")
;;     ("t" go-roam-find-thel-sector "Thel Sector")
;;     )
;;    "Autre"
;;    (
;;     ("h" go-roam-find-hesburgh-libraries "Hesburgh Libraries")
;;     ("s" go-roam-find-samvera "Samvera")
;;     )

;;    )
;;   )

(major-mode-hydra-define org-mode
  (:title "Org-mode" :color yellow :separator "-") ;;:color yellow marche pas mais permet de quitter partout
  ("Déplacements/Base"
   (
    ("s" org-next-visible-heading "Suivant")
    ("d" org-previous-visible-heading "Précédent")
    ("S" org-forward-heading-same-level "Suivantmêmetaille")
    ("D" org-backward-heading-same-level "Suivantmêmetaille")
    ("n" org-meta-return "NouveauSousTitre" :exit t)
    ("," outline-toggle-children "Collapse title")

    ("e" org-do-demote "Petit ce titre")
    ("u" org-do-promote "Grand ce titre")
    ("E" org-demote-subtree "Petitsubtree")
    ("U" org-promote-subtree "Grandsubtree")
    ("q" keyboard-quit "quit" :color blue)
    )
   "GTD/Org-roam"
   (
    ;; ("f" org-capture-finalize "Finir-capture" :exit t)
    ("f" org-set-tags-command "InsertTags" :exit t )
    ("r" org-refile "Refile (déplacer)" :exit t)
    ("h" org-schedule "scHedule (unedate)" )
    ("b" org-archive-subtree-default "Archiver" )      
    ("c" org-download-rename-last-file "Rename image org download" :exit t)
    ;; ("f" hydra-zoom/body "chedule (unedate)" :exit t)

    )
   "TODO"
   (("T" org-insert-todo-heading "NouveauSousTODO" :exit t)
    ("t" org-todo "cycleTodo")
    ("x" org-toggle-checkbox " X cocher checkboX")
    ("y" org-list-todo "lYste todo")
    )
   "Link"
   (
    ("L" org-store-link "Stocke le lien" :exit t)
    ("l" org-insert-link "Insert lien" :exit t)
    ("o" org-agenda-open-link "Ouvre lien" :exit t)

    )
   "Autre"
   (
    ("i" Insertioncodelatexhorsdudansorg "Insertion de code latex" :exit t)
    ("a" agenda/tags/body "Agenda/tags" :exit t)
    ("z" cfw:open-org-calendar "Jolie vue agenda" :exit t)
    ("q" keyboard-quit "quit" :color blue)
    )
   )
  )





(defhydra agenda/tags (:color pink
			      :hint nil)
  ("a" org-agenda "Agenda" :color blue)
  ("i" org-set-tags-command "InsertTags" :exit t )
  ("H" org-match-sparse-tree "sparce-tree(cHerchetags)")
  )

(major-mode-hydra-define c-mode

       (:title "C-mode" :color yellow :separator "-") ;;:color yellow marche pas mais permet de quitter partout

       ("Déplacements/Base"

	(

	 ("t" lsp-find-definition "Jump à la définion de la fonction" :exit t)
	 )
	"Opération"
	(
	 ;; ("f" org-capture-finalize "Finir-capture" :exit t)
	 ("R" lsp-rename "Renomer une variable" :exit t)
	 ("p" sp-rewrap-sexp "changer les parenthèse par une autre" :exit t)

	 ;; ("f" hydra-zoom/body "chedule (unedate)" :exit t)

	 )
	"TODO"
	(
	 ("o" org-agenda-open-link "Ouvre lien" :exit t)
	 )
	"Autre"
	(
	 ("a" agenda/tags/body "Agenda/tags" :exit t)
	 ("q" keyboard-quit "quit" :color blue)
	 )
	)
       )

;; (major-mode-hydra-define org-agenda-mode
;;   (:title "Org-agenda-mode" :color yellow :separator "-") ;;:color yellow marche pas mais permet de quitter partout
;;   ("Déplacements/Base"
;;    (
;;     ("s" org-agenda-next-item "Suivant")
;;     ("d" org-agenda-previous-item "Précédent")
;;     ;; ("S" org-forward-heading-same-level "Suivantmêmetaille")
;;     ;; ("D" org-backward-heading-same-level "Suivantmêmetaille")
;;     ;; ("n" org-meta-return "NouveauSousTitre" :exit t)
;;     ;; ("," outline-toggle-children "Collapse title")

;;     ("e" org-refile-goto-last-stored "Aller au dernier refile")
;;     ("u" org-capture-goto-last-stored "Aller au dernier capture")
;;     ;; ("E" org-demote-subtree "Petitsubtree")
;;     ;; ("U" org-promote-subtree "Grandsubtree")
;;     ("q" keyboard-quit "quit" :color blue)
;;     )
;;    "GTD/Org-roam"
;;    (
;;     ;; ("f" org-capture-finalize "Finir-capture" :exit t)
;;     ("f" org-agenda-set-tags "InsertTags")
;;     ("r" org-agenda-refile "Refile (déplacer)")
;;     ("h" org-agenda-schedule "scHedule (unedate)" )
;;     ("b" org-agenda-archive "Archive")
;;     ("," org-agenda-kill "Supprime")
;;     ("p" org-agenda-priority "Priorité !" )
;;     ("c" org-download-rename-last-file "Rename image org download" :exit t)      
;;     ;; ("f" hydra-zoom/body "chedule (unedate)" :exit t)

;;     )
;;    "TODO"
;;    (("T" org-insert-todo-heading "NouveauSousTODO" :exit t)
;;     ("t" org-agenda-todo "cycleTodo")
;;     ("x" org-toggle-checkbox " X cocher checkboX")
;;     ("y" org-list-todo "lYste todo")
;;     )
;;    "Link"
;;    (
;;     ("L" org-store-link "Stocke le lien" :exit t)
;;     ("l" org-insert-link "Insert lien" :exit t)
;;     ("o" org-agenda-open-link "Ouvre lien" :exit t)
;;     )
;;    "Autre"
;;    (
;;     ("a" agenda/tags/body "Agenda/tags" :exit t)
;;     ("q" keyboard-quit "quit" :color blue)
;;     )
;;    )
;;   )




;; ;; Hydra for org agenda (graciously taken from Spacemacs)
;; ;; (major-mode-hydra-define org-a
;; genda (:pre (setq which-key-inhibit t)
;; ;
					; 				 :post (setq which-key-inhibit nil)
;; 				 :hint none)
;;   "
;; Org agenda (_q_uit)

;; ^Clock^      ^Visit entry^              ^Date^             ^Other^
;; ^-----^----  ^-----------^------------  ^----^-----------  ^-----^---------
;; _ci_ in      _SPC_ in other window      _ds_ schedule      _gr_ reload
;; _co_ out     _TAB_ & go to location     _dd_ set deadline  _._  go to today
;; _cq_ cancel  _RET_ & del other windows  _dt_ timestamp     _gd_ go to date
;; _cj_ jump    _o_   link                 _+_  do later      ^^
;; ^^           ^^                         _-_  do earlier    ^^
;; ^^           ^^                         ^^                 ^^
;; ^View^          ^Filter^                 ^Headline^         ^Toggle mode^
;; ^----^--------  ^------^---------------  ^--------^-------  ^-----------^----
;; _vd_ day        _ft_ by tag              _ht_ set status    _tf_ follow
;; _vw_ week       _fr_ refine by tag       _hk_ kill          _tl_ log
;; _vt_ fortnight  _fc_ by category         _hr_ refile        _ta_ archive trees
;; _vm_ month      _fh_ by top headline     _hA_ archive       _tA_ archive files
;; _vy_ year       _fx_ by regexp           _h:_ set tags      _tr_ clock report
;; _vn_ next span  _fd_ delete all filters  _hp_ set priority  _td_ diaries
;; _vp_ prev span  ^^                       ^^                 ^^
;; _vr_ reset      ^^                       ^^                 ^^
;; ^^              ^^                       ^^                 ^^
;; "
;;   ;; Entry
;;   ("hA" org-agenda-archive-default)
;;   ("hk" org-agenda-kill)
;;   ("hp" org-agenda-priority)
;;   ("hr" org-agenda-refile)
;;   ("h:" org-agenda-set-tags)
;;   ("ht" org-agenda-todo)
;;   ;; Visit entry
;;   ("o"   link-hint-open-link :exit t)
;;   ("<tab>" org-agenda-goto :exit t)
;;   ("TAB" org-agenda-goto :exit t)
;;   ("SPC" org-agenda-show-and-scroll-up)
;;   ("RET" org-agenda-switch-to :exit t)
;;   ;; Date
;;   ("dt" org-agenda-date-prompt)
;;   ("dd" org-agenda-deadline)
;;   ("+" org-agenda-do-date-later)
;;   ("-" org-agenda-do-date-earlier)
;;   ("ds" org-agenda-schedule)
;;   ;; View
;;   ("vd" org-agenda-day-view)
;;   ("vw" org-agenda-week-view)
;;   ("vt" org-agenda-fortnight-view)
;;   ("vm" org-agenda-month-view)
;;   ("vy" org-agenda-year-view)
;;   ("vn" org-agenda-later)
;;   ("vp" org-agenda-earlier)
;;   ("vr" org-agenda-reset-view)
;;   ;; Toggle mode
;;   ("ta" org-agenda-archives-mode)
;;   ("tA" (org-agenda-archives-mode 'files))
;;   ("tr" org-agenda-clockreport-mode)
;;   ("tf" org-agenda-follow-mode)
;;   ("tl" org-agenda-log-mode)
;;   ("td" org-agenda-toggle-diary)
;;   ;; Filter
;;   ("fc" org-agenda-filter-by-category)
;;   ("fx" org-agenda-filter-by-regexp)
;;   ("ft" org-agenda-filter-by-tag)
;;   ("fr" org-agenda-filter-by-tag-refine)
;;   ("fh" org-agenda-filter-by-top-headline)
;;   ("fd" org-agenda-filter-remove-all)
;;   ;; Clock
;;   ("cq" org-agenda-clock-cancel)
;;   ("cj" org-agenda-clock-goto :exit t)
;;   ("ci" org-agenda-clock-in :exit t)
;;   ("co" org-agenda-clock-out)
;;   ;; Other
;;   ("q" nil :exit t)
;;   ("gd" org-agenda-goto-date)
;;   ("." org-agenda-goto-today)
;;   ("gr" org-agenda-redo)
;;   )

(bind-key "C-+" 'text-scale-increase)
(bind-key "C--" 'text-scale-decrease)

(use-package move-text
  :defer 0.5
  :config
  (move-text-default-bindings))

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

(bind-key "C-s" 'scroll-up-command)
(bind-key "C-d" 'scroll-down-command)

(use-package expand-region
  :after (org)
  :bind ("C-q" . er/expand-region)
  :diminish)

(use-package buffer-move
:straight t
    :config
    (global-set-key (kbd "<C-c up>")     'buf-move-up)
    (global-set-key (kbd "<C-c down>")   'buf-move-down)
    (global-set-key (kbd "<C-c left>")   'buf-move-left)
    (global-set-key (kbd "<C-c right>")  'buf-move-right))

;; HHH___________________________________________________________________

(xah-fly--define-keys
 (define-prefix-command 'xah-fly-c-keymap)
 '(
   ("," . xah-open-in-external-app)
   ("." . find-file)
   ("-" . burly-bookmark-windows);;perso

   ("a" . navigation-keymap);;perso
   ("c" . consult-bookmark);;perso
   ("e" . ibuffer)
   ("f" . xah-open-recently-closed)
   ("g" . xah-open-in-terminal)
   ;; ("h" . recentf-open-files)
   ("h" . consult-recent-file);;perso
   ("i" . xah-copy-file-path)
   ("l" . bookmark-bmenu-list);;perso
   ("n" . xah-new-empty-buffer)
   ("o" . xah-show-in-desktop)
   ("p" . xah-open-last-closed)
   ("r" . bookmark-set)
   ("s" . write-file)
   ("u" . xah-open-file-at-cursor)
   ("y" . xah-list-recently-closed)
   ))

(xah-fly--define-keys
 (define-prefix-command 'xah-fly-e-keymap)
 '(
   ("RET" . insert-char)
   ("SPC" . xah-insert-unicode)

   ("W" . xah-insert-double-angle-bracket)
   ("b" . xah-insert-black-lenticular-bracket)
   ("c" . xah-insert-ascii-single-quote)
   ("d" . xah-insert-double-curly-quote)
   ("f" . xah-insert-emacs-quote)
   ("g" . xah-insert-ascii-double-quote)
   ("h" . xah-insert-brace) ; {}
   ("i" . xah-insert-curly-single-quote)
   ("l" . xah-insert-formfeed)
   ("m" . xah-insert-corner-bracket)
   ("n" . xah-insert-square-bracket) ; []
   ("p" . xah-insert-single-angle-quote)
   ("r" . xah-insert-tortoise-shell-bracket )
   ("s" . xah-insert-string-assignment)
   ("t" . xah-insert-paren)
   ("u" . xah-insert-date)
   ("w" . xah-insert-angle-bracket)
   ("y" . xah-insert-double-angle-quote)
   ;;

   ))

(xah-fly--define-keys
 (define-prefix-command 'xah-fly-h-keymap)
 '(
   ;; ',.
   ;; ;
   ("a" . apropos-command)
   ("b" . describe-bindings)
   ("c" . describe-char)
   ("d" . apropos-documentation)
   ("e" . view-echo-area-messages)
   ("f" . describe-face)
   ("g" . info-lookup-symbol)
   ("h" . describe-function)
   ("i" . info)
   ("j" . man)
   ("k" . describe-key)
   ("l" . view-lossage)
   ("m" . xah-describe-major-mode)
   ("n" . describe-variable)
   ("o" . describe-language-environment)
   ;; p
   ;; q
   ("r" . apropos-variable)
   ("s" . describe-syntax)
   ;; t
   ("u" . elisp-index-search)
   ("v" . apropos-value)
   ;; wxy
   ("z" . describe-coding-system)))

(xah-fly--define-keys
 ;; commands here are “harmless”, they don't modify text etc.
 ;; they turn on minor/major mode, change display, prompt, start shell, etc.
 (define-prefix-command 'xah-fly-n-keymap)
 '(
   ("SPC" . whitespace-mode)
   ;; RET
   ;; TAB
   ;; DEL
   ("," . abbrev-mode)
   ("." . toggle-frame-fullscreen)
   ("'" . frameset-to-register)
   (";" . window-configuration-to-register)
   ("1" . set-input-method) 
   ("2" . global-hl-line-mode)
   ("4" . global-display-line-numbers-mode)
   ("5" . visual-line-mode)
   ("6" . calendar)
   ("7" . calc)
   ;; 8
   ("9" . shell-command)
   ("0" . shell-command-on-region)
   ("a" . text-scale-adjust)
   ("b" . toggle-debug-on-error)
   ("c" . toggle-case-fold-search)
   ("d" . narrow-to-page)
   ("e" . eshell)
   ;; f
   ("g" . xah-toggle-read-novel-mode)
   ("h" . widen)
   ("i" . make-frame-command)
   ("j" . flyspell-buffer)
   ("s" . flyspell-check-previous-highlighted-word)
   ("k" . menu-bar-open)
   ("l" . toggle-word-wrap)
   ("m" . jump-to-register)
   ("n" . narrow-to-region)
   ("o" . variable-pitch-mode)
   ("p" . read-only-mode)
   ;; q
   ;; r
   ;; s
   ("t" . narrow-to-defun)
   ("u" . shell)
   ;; v
   ("w" . eww)
   ("x" . save-some-buffers)
   ("y" . toggle-truncate-lines)
   ("z" . abort-recursive-edit)))

(xah-fly--define-keys
 ;; kinda replacement related
 (define-prefix-command 'xah-fly-r-keymap)
 '(
   ("SPC" . rectangle-mark-mode)
   ("," . apply-macro-to-region-lines)
   ("." . kmacro-start-macro)
   ("3" . number-to-register)
   ("4" . increment-register)
   ("a" . xah-copy-rectangle-to-kill-ring) ;;perso
   ("c" . replace-rectangle)
   ("d" . delete-rectangle)
   ("e" . call-last-kbd-macro)
   ("g" . kill-rectangle)
   ("l" . clear-rectangle)
   ("i" . xah-space-to-newline)
   ("n" . rectangle-number-lines)
   ("o" . open-rectangle)
   ;; ("p" . kmacro-end-macro)
   ("p" . kmacro-end-or-call-macro) ;;perso
   ("r" . yank-rectangle)
   ("u" . xah-quote-lines)
   ("y" . delete-whitespace-rectangle)))

(xah-fly--define-keys
 (define-prefix-command 'xah-fly-t-keymap)
 '(
   ("SPC" . xah-clean-whitespace)
   ("TAB" . move-to-column)

   ("1" . xah-append-to-register-1)
   ("2" . xah-clear-register-1)

   ("3" . xah-copy-to-register-1)
   ("4" . xah-paste-from-register-1)

   ("8" . xah-clear-register-1)
   ("7" . xah-append-to-register-1)

   ("." . sort-lines)
   ("," . sort-numeric-fields)
   ("'" . reverse-region)
   ;; a
   ("b" . xah-reformat-to-sentence-lines)
   ("c" . goto-char)
   ("d" . mark-defun)
   ("e" . list-matching-lines)
   ("f" . goto-line )
   ;; g
   ("h" . xah-close-current-buffer)
   ("i" . delete-non-matching-lines)
   ("j" . copy-to-register)
   ("k" . insert-register)
   ("l" . xah-escape-quotes)
   ("m" . xah-make-backup-and-save)
   ("n" . repeat-complex-command)
   ;; o
   ("p" . query-replace-regexp)
   ;; q
   ("r" . copy-rectangle-to-register)
   ;; s
   ("t" . repeat)
   ("u" . delete-matching-lines)
   ;; v
   ("w" . xah-next-window-or-frame)
   ;; x
   ("y" . delete-duplicate-lines)
   ;; z
   ))

(xah-fly--define-keys
 (define-prefix-command 'xah-fly-w-keymap)
 '(
   ("DEL" . xah-delete-current-file)
   ("." . Eval-buffer)
   ("e" . eval-defun)
   ("m" . eval-last-sexp)
   ("p" . eval-expression)
   ("u" . eval-region)
   ("q" . save-buffers-kill-terminal)
   ("w" . delete-frame)
   ("j" . xah-run-current-file)))

;; (xah-fly--define-keys
;;  (define-prefix-command 'xah-coding-system-keymap)
;;  '(
;;    ("n" . set-file-name-coding-system)
;;    ("s" . set-next-selection-coding-system)
;;    ("c" . universal-coding-system-argument)
;;    ("f" . set-buffer-file-coding-system)
;;    ("k" . set-keyboard-coding-system)
;;    ("l" . set-language-environment)
;;    ("p" . set-buffer-process-coding-system)
;;    ("r" . revert-buffer-with-coding-system)
;;    ("t" . set-terminal-coding-system)
;;    ("x" . set-selection-coding-system)))

(xah-fly--define-keys
 ;; kinda replacement related
 (define-prefix-command 'xah-fly-comma-keymap)
 '(
   ("t" . xref-find-definitions)
   ("n" . xref-pop-marker-stack)))


(xah-fly--define-keys
 ;; kinda replacement related
 (define-prefix-command 'ourkeymap) ;;perso
 '(("'" . restart-emacs)
   ("-" . magit-status)
   ("," . org-gcal-sync) ;; é
   ("/" . treemacs)
   ("a" . cp/go-to-config)
   ;; ("=" . dw/toggle-command-window)
   ("d" . org-capture)
   ("h" . eaf-open-browser-with-history)
   ("l" . org-sidebar-tree-toggle)
   ("m" . engine/search-google)
   ("o" . org-agenda)
   ("t" . flyspell-check-previous-highlighted-word)
   ;; ("x" . universal-argument)


   ("<up>" . buf-move-up)
   ("<down>" . buf-move-down)
   ("<left>" . buf-move-left)
   ("<right>" . buf-move-right)))


(xah-fly--define-keys
 (define-prefix-command 'xah-fly-leader-key-map)
 '(
   ("SPC" . ourkeymap)
   ("DEL" . xah-fly-insert-mode-activate)
   ("RET" . xah-fly-M-x)
   ("TAB" . xah-fly--tab-key-map)
   ("." . xah-fly-dot-keymap)

   ;; ("'" . avy-goto-char-timer) ;;perso
   ;; ("'" . xah-fill-or-unfill)

   ;; ("'" . cp/avy-goto-char) ;;perso, free


   ("," . xah-fly-comma-keymap)
   ("-" . xah-show-formfeed-as-line)
   ;; /
   ;; ;
   ;; =
   ;; [
   ("\\" . toggle-input-method)
   ;; `

   ;; 1
   ;; 2
   ("3" . delete-window)
   ("4" . split-window-right)
   ("5" . balance-windows)
   ("6" . xah-upcase-sentence)
   ;; 7
   ;; 8
   ("9" . ispell-word)
   ;; 0

   ("a" . mark-whole-buffer)
   ("b" . end-of-buffer)
   ("c" . xah-fly-c-keymap)
   ("d" . beginning-of-buffer)
   ("e" . xah-fly-e-keymap)
   ("f" . xah-search-current-word)
   ("g" . org-roam-keymap)
   ("h" . xah-fly-h-keymap)
   ("i" . kill-line)
   ;; ("j" . xah-copy-all-or-region)
   ("j" . winner-undo)
   ;; k, free
   ("l" . recenter-top-bottom)
   ("m" . dired-jump)
   ("n" . xah-fly-n-keymap)
   ("o" . exchange-point-and-mark)
   ("p" . query-replace)
   ("q" . xah-cut-all-or-region)
   ("r" . xah-fly-r-keymap)
   ;; ("s" . save-buffer)
   ;; ("s" . winner-undo);;touche dispo
   ("s" . major-mode-hydra);;perso
   ("t" . xah-fly-t-keymap)
   ("u" . switch-to-buffer)
   ;; v
   ("w" . xah-fly-w-keymap)
   ;; ("x" . xah-toggle-letter-case)
   ;; ("x" . xah-toggle-previous-letter-case)

   ("y" . popup-kill-ring)
   ;; z
   ;;
   ))



(xah-fly--define-keys
 xah-fly-command-map
 '(("~" . nil)
   (":" . nil)

   ("SPC" . xah-fly-leader-key-map)
   ("DEL" . xah-fly-leader-key-map)

   ("'" . avy-goto-char-2)
   ("," . xah-shrink-whitespaces)
   ("-" . xah-cycle-hyphen-lowline-space)
   ("." . backward-kill-word)
   (";" . xah-comment-dwim)
   ("/" . hippie-expand)
   ("\\" . nil)
   ;; ("=" . xah-forward-equal-sign)
   ("[" . xah-backward-punct)
   ("]" . xah-forward-punct)
   ("`" . other-frame)

   ;; ("#" . xah-backward-quote)
   ;; ("$" . xah-forward-punct)

   ("1" . xah-extend-selection)
   ("2" . xah-select-line)
   ("3" . delete-other-windows)
   ("4" . split-window-below)
   ("5" . delete-char)
   ("6" . xah-select-block)
   ("7" . xah-select-line)
   ("8" . xah-extend-selection)
   ("9" . er/expand-region)
   ("0" . xah-pop-local-mark-ring)

   ("a" . xah-fly-M-x)
   ("b" . consult-line)
   ;; ("b" . swiper)
   ("c" . previous-line)
   ("d" . xah-beginning-of-line-or-block)
   ("e" . xah-delete-backward-char-or-bracket-text)
   ("f" . undo)
   ("g" . backward-word)
   ("h" . backward-char)
   ;; ("i" . major-mode-hydra)
   ("i" . major-mode-hydra)

   ("j" . xah-copy-line-or-region)
   ("k" . xah-paste-or-paste-previous)
   ;; ("l" . xah-fly-insert-mode-activate-space-before)
   ("l" . xah-insert-space-before)
   ("m" . xah-backward-left-bracket)
   ("n" . forward-char)
   ;; ("o" . (kbd "RET")) ;; voir autre truc dans fichier de config
   ("p" . kill-word)
   ("q" . xah-cut-line-or-region)
   ("r" . forward-word)
   ("s" . xah-end-of-line-or-block)
   ("t" . next-line)
   ("u" . xah-fly-insert-mode-activate)
   ("v" . xah-forward-right-bracket)
   ;; ("w" . ace-window)
   ("w" . xah-next-window-or-frame)
   ;; ("w" . next-window-any-frame)
   ;; ("x" . xah-toggle-letter-case)
   ("x" . universal-argument) ;;perso
   ("y" . set-mark-command)
   ("z" . xah-goto-matching-bracket)))


(xah-fly--define-keys
 (define-prefix-command 'xah-fly-test-keymap)
 '(
   ;; ',.
   ;; ;
   ("a" . tool-bar-mode)
   ("b" . describe-bindings)
   ("c" . describe-char)
   ("d" . apropos-documentation)
   ("e" . view-echo-area-messages)
   ("f" . describe-face)
   ("g" . info-lookup-symbol)
   ("h" . describe-function)
   ("i" . info)
   ("j" . man)
   ("k" . describe-key)
   ("l" . view-lossage)
   ("m" . xah-describe-major-mode)
   ("n" . describe-variable)
   ("o" . describe-language-environment)
   ;; p
   ;; q
   ("r" . apropos-variable)
   ("s" . describe-syntax)
   ;; t
   ("u" . elisp-index-search)
   ("v" . apropos-value)
   ;; wxy
   ("z" . describe-coding-system)))

(xah-fly--define-keys
       (define-prefix-command 'navigation-keymap)
       '(
	 ("'" .   deuxièmecerveausite)
	 ("." .   cp/go-to-orgzly-Nell)
	 ;; ("-" .   org-sort)
	 ;; ("a" . Insertion-code-latex-dans-org)
	 ;; ("a" .   org-meta-return)
	 ;; ("A" .   org-insert-todo-heading)
	 ;; ("b" . org-export-dispatch)
	 ("c" . cp/go-to-documents)
	 ("d" . cp/go-to-code)
	 ("e" . cp/go-to-temp)
	 ;; ("f" . xah-search-current-word)
	 ;; ("g" . org-agenda-open-link)
	 ;; ("h" . org-todo)
	 ;; ("i" . kill-line)
	 ;; ("j" . xah-copy-all-or-region)
	 ;; ("j" . winner-undo)
	 ;; ("k" . xah-paste-or-paste-previous)
	 ;; ("l" . recenter-top-bottom)
	 ;; ("m" . github-visit)
	 ;; ("n" . org-refile)
	 ;; ("o" . exchange-point-and-mark)
	 ;; ("p" . query-replace)
	 ;; ("q" . xah-cut-all-or-region)
	 ;; ("r" . org-insert-link)
	 ;; ("L" . org-store-link)
	 ;; ("s" . save-buffer)
	 ;; ("s" . winner-undo);;touche dispo
	 ;; ("s" . major-mode-hydra) ;;perso
	 ("t" . cp/go-to-LayerXahFlyKey)
	 ("u" . cp/go-to-cours)
	 ;; ("v" . org-mode-capture-keymap)
	 ;; ("w" . org-capture-goto-last-stored)
	 ;; ("x" . xah-toggle-letter-case)
	 ;; ("x" . xah-toggle-previous-letter-case)

	 ;; ("y" . popup-kill-ring)
	 ;; ("z" . org-archive-subtree)
	 )
       )

(xah-fly--define-keys
	 (define-prefix-command 'org-roam-keymap)
	 '(
	   ("'" .   org-roam-buffer-toggle)
	   ;; ("." .   cp/go-to-orgzly-Nell)
	   ;; ("-" .   org-sort)
	   ("a" . deft)
	   ;; ("A" .   org-insert-todo-heading)
	   ;; ("b" . org-export-dispatch)
	   ;; ("c" . cp/go-to-documents)
	   ;; ("d" . cp/go-to-code)
	   ("e" . org-roam-node-find)
	   ;; ("f" . xah-search-current-word)
	   ;; ("g" . org-agenda-open-link)
	   ("h" . org-roam-node-random)
	   ("i" . org-roam-alias-add)
	   ;; ("j" . xah-copy-all-or-region)
	   ;; ("k" . xah-paste-or-paste-previous)
	   ;; ("l" . recenter-top-bottom)
	   ;; ("m" . github-visit)
	   ;; ("n" . org-refile)
	   ("o" . org-id-get-create)
	   ;; ("p" . query-replace)
	   ;; ("q" . xah-cut-all-or-region)
	   ;; ("r" . org-insert-link)
	   ;; ("L" . org-store-link)
	   ;; ("s" . save-buffer)
	   ("t" . org-roam-ui-mode)
	   ("u" . org-roam-node-insert)
	   ;; ("v" . org-mode-capture-keymap)
	   ;; ("w" . org-capture-goto-last-stored)
	   ;; ("x" . xah-toggle-letter-case)
	   ;; ("x" . xah-toggle-previous-letter-case)
	   ;; ("y" . popup-kill-ring)
	   ;; ("z" . org-archive-subtree)
	   )
	 )

;; HHH___________________________________________________________________
;;mes keymap, tout est perso

(xah-fly--define-keys
 (define-prefix-command 'org-mode-keymap)
 '(
   ("'" .   org-table-create-or-convert-from-region)
   ("-" .   org-sort)
   ;; ("a" . Insertion-code-latex-dans-org)
   ("a" .   org-meta-return)
   ("A" .   org-insert-todo-heading)
   ("b" . org-export-dispatch)
   ("c" . org-set-tags-command)
   ("d" . org-mode-action-keymap)
   ;; ("e" . xah-fly-e-keymap)
   ;; ("f" . xah-search-current-word)
   ("g" . org-agenda-open-link)
   ("h" . org-todo)
   ;; ("i" . kill-line)
   ;; ("j" . xah-copy-all-or-region)
   ;; ("j" . winner-undo)
   ;; ("k" . xah-paste-or-paste-previous)
   ;; ("l" . recenter-top-bottom)
   ("m" . org-refile-goto-last-stored)
   ("n" . org-refile)
   ;; ("o" . exchange-point-and-mark)
   ;; ("p" . query-replace)
   ;; ("q" . xah-cut-all-or-region)
   ("r" . org-insert-link)
   ("L" . org-store-link)
   ;; ("s" . save-buffer)
   ;; ("s" . winner-undo);;touche dispo
   ;; ("s" . major-mode-hydra) ;;perso
   ("t" . org-schedule)
   ;; ("u" . switch-to-buffer)
   ("v" . org-mode-capture-keymap)
   ("w" . org-capture-goto-last-stored)
   ;; ("x" . xah-toggle-letter-case)
   ;; ("x" . xah-toggle-previous-letter-case)

   ;; ("y" . popup-kill-ring)
   ("z" . org-archive-subtree)
   )
 )

(xah-fly--define-keys
	 (define-prefix-command 'org-mode-action-keymap)
	 '(
	   ;; ("a" . Insertion-code-latex-dans-org)
	   ;; ("a" .   org-meta-return)
	   ;; ("A" .   org-insert-todo-heading)
	   ;; ("b" . org-export-dispatch)
	   ;; ("c" . org-ctrl-c-ctrl-c)
	   ("d" . org-footnote-action)
	   ;; ("e" . xah-fly-e-keymap)
	   ;; ("f" . xah-search-current-word)
	   ;; ("g" . org-agenda-open-link)
	   ;; ("h" . org-todo)
	   ;; ("i" . kill-line)
	   ;; ("j" . xah-copy-all-or-region)
	   ;; ("j" . winner-undo)
	   ;; ("k" . xah-paste-or-paste-previous)
	   ;; ("l" . recenter-top-bottom)
	   ;; ("m" . org-refile-goto-last-stored)
	   ("n" . cp/refile-and-clear-state)
	   ;; ("o" . exchange-point-and-mark)
	   ;; ("p" . query-replace)
	   ;; ("q" . xah-cut-all-or-region)
	   ;; ("r" . )
	   ;; ("L" . org-store-link)
	   ;; ("s" . save-buffer)
	   ;; ("s" . winner-undo);;touche dispo
	   ;; ("s" . major-mode-hydra) ;;perso
	   ;; ("t" . org-schedule)
	   ;; ("u" . switch-to-buffer)
	   ;; v
	   ;; ("w" . org-capture-goto-last-stored)
	   ;; ("x" . xah-toggle-letter-case)
	   ;; ("x" . xah-toggle-previous-letter-case)

	   ;; ("y" . popup-kill-ring)
	   ;; ("z" . org-archive-subtree)
	   )
	 )

(xah-fly--define-keys
       (define-prefix-command 'org-mode-capture-keymap)
       '(

	 ("u" .   org-capture-finalize)
	 ;; ("A" .   org-insert-todo-heading)
	 ;; ("b" . org-export-dispatch)
	 ;; ("c" . org-ctrl-c-ctrl-c)
	 ;; ("d" . org-mode-action-keymap)
	 ;; ("e" . xah-fly-e-keymap)
	 ;; ("f" . xah-search-current-word)
	 ;; ("g" . org-agenda-open-link)
	 ;; ("h" . org-todo)
	 ;; ("i" . kill-line)
	 ;; ("j" . xah-copy-all-or-region)
	 ;; ("j" . winner-undo)
	 ;; ("k" . xah-paste-or-paste-previous)
	 ;; ("l" . recenter-top-bottom)
	 ;; ("m" . org-refile-goto-last-stored)
	 ("n" . org-capture-refile)
	 ;; ("o" . exchange-point-and-mark)
	 ;; ("p" . query-replace)
	 ;; ("q" . xah-cut-all-or-region)
	 ;; ("r" . org-insert-link)
	 ;; ("L" . org-store-link)
	 ;; ("s" . save-buffer)
	 ;; ("s" . winner-undo);;touche dispo
	 ;; ("s" . major-mode-hydra) ;;perso
	 ;; ("t" . org-schedule)
	 ;; ("u" . switch-to-buffer)
	 ;; ("v" . org-capture-finalize)
	 ;; ("w" . org-capture-goto-last-stored)
	 ;; ("x" . xah-toggle-letter-case)
	 ;; ("x" . xah-toggle-previous-letter-case)

	 ;; ("y" . popup-kill-ring)
	 ("'" . org-capture-kill)
	 )
       )

(xah-fly--define-keys
 (define-prefix-command 'xah-fly-org-agenda-mode-keymap)
 '(
   ;; ("a" . mark-whole-buffer)
   ;; ("b" . end-of-buffer)
   ("c" . org-agenda-set-tags)
   ("d" . org-mode-action-keymap)
   ;; ("e" . xah-fly-e-keymap)
   ;; ("f" . xah-search-current-word)
   ("g" . org-agenda-open-link)
   ("h" . org-agenda-todo)
   ;; ("i" . kill-line)
   ;; ("j" . xah-copy-all-or-region)
   ;; ("j" . winner-undo)
   ;; ("k" . xah-paste-or-paste-previous)
   ;; ("l" . recenter-top-bottom)
   ("m" . org-refile-goto-last-stored)
   ("n" . org-agenda-refile)
   ;; ("o" . exchange-point-and-mark)
   ;; ("p" . query-replace)
   ;; ("q" . xah-cut-all-or-region)
   ("r" . org-insert-link)
   ;; ("s" . save-buffer)
   ;; ("s" . winner-undo);;touche dispo
   ;; ("s" . major-mode-hydra) ;;perso
   ("t" . org-agenda-schedule)
   ;; ("u" . switch-to-buffer)
   ;; v
   ("w" . org-capture-goto-last-stored)
   ;; ("x" . xah-toggle-letter-case)
   ;; ("x" . xah-toggle-previous-letter-case)

   ;; ("y" . popup-kill-ring)
   ("z" . org-agenda-archive)
   )
 )

(xah-fly--define-keys
 (define-prefix-command 'xah-fly-c-mode-keymap)
 '(
   ;; ',.
   ;; ;
   ("a" . tool-bar-mode)
   ("s" . tool-bar-mode)
   ("e" . tool-bar-mode)
   ("x" . lsp-command-map)
   ;; wxy
   ("z" . describe-coding-system)
   )
 )

(xah-fly--define-keys
       (define-prefix-command 'xah-fly-java-mode-keymap)
       '(

	 ("a" . tool-bar-mode)
	 ("g" . java-eval-nofocus)
	 ("z" . describe-coding-system)
	 )
       )

(defun my-wrapper ()
  "call different commands depending on what's current major mode."
  (interactive)
  (message "wrapper called" )
  (cond
   ((string-equal major-mode "org-mode") ( (xah-fly-e-keymap)))
   ;; ((string-equal major-mode "org-mode") (xah-fly-r-keymap))
   ;; more major-mode checking here
   ;; if nothing match, do nothing
   (t (message "no mode matched. nothing is done" ))))




;; (global-set-key (kbd "<f2>") 'my-wrapper)
;; must come after loading xah-fly-keys

;; (define-key xah-fly-command-map (kbd ",") 'my-wrapper)




;; example of adding a leader key map to golang mode

(message "LayerXahFlyKey load")

(provide 'LayerXahFlyKey)


      ;;; LayerXahFlyKey.el ends here
