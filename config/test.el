(setq consult-narrow-key (kbd "C-+"))  ;; pour "C-+", je sais pas pourquoi c'est ce nombre.
(define-key xah-fly-key-map [remap switch-to-buffer] #'consult-buffer)

;; (if (not termux-p)
  ;; (define-key xah-fly-key-map [remap next-line] #'avy-goto-char-2))

(message "fin try")
