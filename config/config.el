(defconst path-home-dir (file-name-as-directory (getenv "HOME"))
  "Path to user home directory.

In a nutshell, it's just a value of $HOME.")

;; (defvar my-laptop-p (equal (system-name) "sacha-kubuntu"))

;; (defvar my-server-p (and (equal (system-name) "localhost") (equal user-login-name "sacha")))


(defvar termux-p (not (null (getenv "ANDROID_ROOT")))
  "If non-nil, GNU Emacs is running on Termux.")
(when termux-p (setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3"))
;; lancement de syncthing en arrière plan dans termux (impossible de le lancer en background normal)
(when termux-p (shell-command "syncthing &"))

(setq config-directory (expand-file-name "config/" user-emacs-directory))

(setq braindump-directory (concat path-home-dir "braindump/"))

(setq braindump-exists (file-exists-p braindump-directory))

(use-package diminish)

(org-babel-load-file (expand-file-name "raccourcis.org" config-directory))

(org-babel-load-file (expand-file-name "optimisationsSansDeps.org" config-directory))

(org-babel-load-file (expand-file-name "optimisationsAvecDeps.org" config-directory))

(org-babel-load-file (expand-file-name "org-mode.org" config-directory))

(org-babel-load-file (expand-file-name "programmation.org" config-directory))

(org-babel-load-file (expand-file-name "streaming.org" config-directory))

(org-babel-load-file (expand-file-name "mail.org" config-directory))

(org-babel-load-file (expand-file-name "test.org" config-directory))

(message "Fin")
