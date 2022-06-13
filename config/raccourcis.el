(use-package xah-fly-keys
:straight (xah-fly-keys :type git :host github :repo "Cletip/xah-fly-keys"
                          :fork (:host github
                                       :repo "Cletip/xah-fly-keys"))

  :config
  ;; To disable both Control and Meta shortcut keys, add the following lines to you init.el before (require 'xah-fly-keys):
  (setq xah-fly-use-control-key nil)
  (setq xah-fly-use-meta-key nil)

  ;; choisir son clavier, important
  (xah-fly-keys-set-layout "beopy")

  ;; Les hook	     
  ;; sauvegarde automatique avec command mode
  ;; (add-hook 'xah-fly-command-mode-activate-hook 'xah-fly-save-buffer-if-file)

  ;; ;;Suites des hook
  (defvar cp/xfk-auto-insert-mode-fns '()
    "List of functions to automatically call xah-fly-insert-mode-activate on.")
  (setq cp/xfk-auto-insert-mode-fns
        '(org-meta-return
          org-insert-heading-respect-content
          org-insert-link
          recentf-open-files
          ;; org-capture ;; désactivé car fait bugguer !

          ;; More function names here
          ))
  (defun cp/xfk-auto-insert-mode-activate ()
    "Wires xah-fly-insert-mode-activate to all functions from cp/xfk-auto-insert-mode-fns."
    (dolist (element cp/xfk-auto-insert-mode-fns)
      (advice-add element :after #'xah-fly-insert-mode-activate)))
  (cp/xfk-auto-insert-mode-activate)


  (defvar cp/xfk-auto-command-mode-fns '()
    "List of functions to automatically call xah-fly-command-mode-activate on.")
  (setq cp/xfk-auto-command-mode-fns
        '(dashboard-jump-to-recents
          dashboard-jump-to-projects
          recentf-cancel-dialog
          dashboard-jump-to-bookmarks
          org-agenda-show-dashboard
          dashboard-jump-to-if-dashboardweekagenda-agenda-for-the-coming-week-agenda-for-today
          ;; More function names
          ))

  (defun cp/xfk-auto-command-mode-activate ()
    "Wires xah-fly-command-mode-activate to all functions from cp/xfk-auto-command-mode-fns."
    (dolist (element cp/xfk-auto-command-mode-fns)
      (advice-add element :after #'xah-fly-command-mode-activate)))
  (cp/xfk-auto-command-mode-activate)

  ;;pour la commande xah-run-current-file
  (setq xah-run-current-file-hashtable
        #s(hash-table
           size 100
           test equal
           data
           (
            "clj" "clj"
            "go" "go run"
            "hs" "runhaskell"
            "java" "javac"
            "js" "deno run"
            "latex" "pdflatex"
            "m" "wolframscript -file"
            "mjs" "node --experimental-modules "
            "ml" "ocaml"
            "php" "php"
            "pl" "perl"
            "ps1" "pwsh"
            "py" "python3"
            "py2" "python2"
            "py3" "python3"
            "rb" "ruby"
            "rkt" "racket"
            "sh" "bash"
            "tex" "pdflatex"
            "ts" "deno run"
            "tsx" "tsc"
            "vbs" "cscript"
            "wl" "wolframscript -file"
            "wls" "wolframscript -file"
            ;; "pov" "/usr/local/bin/povray +R2 +A0.1 +J1.2 +Am2 +Q9 +H480 +W640"
            )))
  )
