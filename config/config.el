(setq config-directory (expand-file-name "config/" user-emacs-directory))

(setq braindump-directory "~/braindump/")

(setq braindump-exists (file-exists-p braindump-directory))

(use-package diminish)

(org-babel-load-file (expand-file-name "raccourcis.org" config-directory))

(org-babel-load-file (expand-file-name "optimisationsSansDeps.org" config-directory))

(org-babel-load-file (expand-file-name "optimisationsAvecDeps.org" config-directory))

(org-babel-load-file (expand-file-name "org-mode.org" config-directory))

(org-babel-load-file (expand-file-name "programmation.org" config-directory))

(org-babel-load-file (expand-file-name "streaming.org" config-directory))

(message "Fin")
