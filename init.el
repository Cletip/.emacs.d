;;; .emacs --- My emacs config -*- lexical-binding: t; -*-

(defvar my-init-el-start-time (current-time) "Time when init.el was started")

;; configuration of straight
;; Bootstrap `straight.el'
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 5))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/raxod502/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

;; installation of use-package
(straight-use-package 'use-package)
(require 'package)
;; always download package automatically (without :ensure t)
;;(setq use-package-always-ensure t)
;; Use straight.el for use-package expressions with the first line
(setq straight-use-package-by-default t)
;; Load the helper package for commands like `straight-x-clean-unused-repos'
(require 'straight-x)

;; (setq use-package-always-defer t)
(setq use-package-verbose t)
(setq use-package-minimum-reported-time 0.00001)

(use-package no-littering
  :config
  ;; définition de l'emplacement de certains fichiers
  (setq custom-file (no-littering-expand-var-file-name "custom.el")
	grammalecte-settings-file (no-littering-expand-var-file-name
				   "grammalecte-cache.el") ;;pour grammalecte
	)
  )


;;installation d'org mode
;;ici, je prends juste celui par défault
(use-package org :straight (:type built-in))

;; si je prends un autre, les titres ne se déploit plus quand je cherche
;; (use-package org
  ;; :straight '(org :type git
     ;; :repo "https://code.orgmode.org/bzg/org-mode.git"
     ;; :local-repo "org"
     ;; :depth full
     ;; :pre-build (straight-recipes-org-elpa--build)
     ;; :build (:not autoloads)
     ;; :files (:defaults "lisp/*.el" ("etc/styles/" "etc/styles/*"))))

;; load les variables customiser (chemin définit par no-littering)
;; (org-babel-load-file (expand-file-name "~/.emacs.d/var/custom.el"))
(when (file-exists-p custom-file)
  (load custom-file nil 'nomessage))

;; gnus-home-directory, faut le charger avant le reste à cause de org-babel-load-file
;; Sinon faire un jour un 
;; (add-to-list 'load-path "chemin/jusqu'à/ma/configgnus.el").
;; puis faire comme cela :
;; https://github.com/d12frosted/environment/blob/master/emacs/lisp/config-path.el
;; et enfin faire un (require 'nom-de-l'extension)
(setq gnus-home-directory (no-littering-expand-var-file-name "gnus/"))

;;on lance le reste
(org-babel-load-file (expand-file-name "~/.emacs.d/config/config.org"))

(message "→★ loading init.el in %.2fs" (float-time (time-subtract (current-time) my-init-el-start-time)))
