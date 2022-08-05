(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(dimmer-buffer-exclusion-regexps '(".*Minibuf.*" ".*which-key.*" ".*LV.*") nil nil "Customized with use-package dimmer")
 '(ignored-local-variable-values
   '((elisp-lint-indent-specs
      (vulpea-utils-with-file . 1)
      (vulpea-utils-with-note . 1)
      (org-roam-with-file . 2)
      (org-with-point-at . 1)
      (org-element-map . 2)
      (file-templates-set . defun)
      (leader-def . 0)
      (dlet . 1)
      (general-create-definer . 1)
      (eval-with-default-dir . 1)
      (bui-define-interface . 2)
      (use-package . 1)
      (buffer-lines-map . 1)
      (buffer-lines-each . 1)
      (buffer-lines-each-t . 1)
      (request . defun))
     (company-backends list
		       (company-capf))))
 '(safe-local-variable-values
   '((gac-automatically-add-new-files-p . t)
     (org-download-image-dir concat org-directory "org/artistesImages/")
     (org-download-heading-lvl . 0)
     (company-backends list
		       (company-capf)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(vertico-current ((t (:background "#3a3f5a")))))
