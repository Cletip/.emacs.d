;; ============================================================
;; Don't edit this file, edit config.org' instead ...
;; Auto-generated at Mon Feb 28 2022-02-28T12:41:24  on host msi-GL65-Leopard-10SER
;; ============================================================



;; #####################################################################################
(message "config • Keycast (voir les commandes tapées)(keycast log buffer) …")

  (use-package keycast
    :config
    ;;pour rendre keycast compatible avec doom-modeline
    (define-minor-mode keycast-mode
      "Show current command and its key binding in the mode line (fix for use with doom-mode-line)."
      :global t
      (if keycast-mode
          (add-hook 'pre-command-hook 'keycast--update t)
        (remove-hook 'pre-command-hook 'keycast--update)))
    (add-to-list 'global-mode-string '("" mode-line-keycast))
    )

 
