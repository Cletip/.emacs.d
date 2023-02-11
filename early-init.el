;; éviter "Package cl is deprecated"
(setq byte-compile-warnings '(cl-functions))

;; Disable package.el in favor of straight.el
(setq package-enable-at-startup nil)

;; Optimisation du temps de chargement
;; prevent resize window on startup and boost a little speed
(setq frame-inhibit-implied-resize t)

;; Inspiré de la FAQ de doom : https://github.com/hlissner/doom-emacs/blob/develop/docs/faq.org
;;
;; Sauvegarde de la valeur de file-name-handler-alist à restaurer
(defvar cp/default-file-name-handler-alist file-name-handler-alist)

;; Définition des fonctions affectant les valeurs souhaitées
(defun cp/set-max-gc-cons-threshold ()
  (setq gc-cons-threshold most-positive-fixnum)) ; 2^61 bytes
(defun cp/set-default-gc-cons-threshold ()
  (run-at-time 1 nil ; délai de 1s pour profiter plus longtemps de l'absence de
                     ; déclenchement du GC
               (lambda () (setq gc-cons-threshold 16777216)))) ; 16 Mb

(defun cp/erase-file-name-handler-alist ()
  (setq file-name-handler-alist nil))
(defun cp/restore-file-name-handler-alist ()
  (setq file-name-handler-alist cp/default-file-name-handler-alist))
;; Application de la configuration souhaitée
(cp/set-max-gc-cons-threshold)
(cp/erase-file-name-handler-alist)
(add-hook 'emacs-startup-hook 'cp/set-default-gc-cons-threshold)
(add-hook 'emacs-startup-hook 'cp/restore-file-name-handler-alist)

;;
;; Buffer *Messages* avec timestamp
;;
(defun cp/ad-timestamp-message (FORMAT-STRING &rest args)
  "Advice to run before `message' that prepends a timestamp to each message.
Activate this advice with:
  (advice-add 'message :before 'cp/ad-timestamp-message)
Deactivate this advice with:
  (advice-remove 'message 'cp/ad-timestamp-message)"
  (if message-log-max
      (let ((deactivate-mark nil)
            (inhibit-read-only t))
        (with-current-buffer "*Messages*"
	  (save-excursion (goto-char (point-max))
          (if (not (bolp))
              (newline))
          (insert (format-time-string "[%F %T.%3N] ")))))))
(advice-add 'message :before 'cp/ad-timestamp-message)

(setq-default inhibit-redisplay t
              inhibit-message t)
(add-hook 'window-setup-hook
          (lambda ()
            (setq-default inhibit-redisplay nil
                          inhibit-message nil)
            (redisplay)))


;; pour le nom de ma frame
(setq frame-title-format "%b - Emacs"
      icon-title-format "%b - Emacs"
      ;; inhibit-startup-screen t
      )

;; Contrary to what many Emacs users have in their configs, you don't need
;; more than this to make UTF-8 the default coding system:
(set-language-environment "UTF-8")

;; set-language-enviornment sets default-input-method, which is unwanted
(setq default-input-method nil)
