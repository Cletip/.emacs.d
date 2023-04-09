(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("dde643b0efb339c0de5645a2bc2e8b4176976d5298065b8e6ca45bc4ddf188b7" "6a94122cfa72865c9b7a211ee461e4cc8834451d035fb43ffa478a630dec3d5b" "745d03d647c4b118f671c49214420639cb3af7152e81f132478ed1c649d4597d" "234dbb732ef054b109a9e5ee5b499632c63cc24f7c2383a849815dacc1727cb6" "1d5e33500bc9548f800f9e248b57d1b2a9ecde79cb40c0b1398dec51ee820daf" "e2c926ced58e48afc87f4415af9b7f7b58e62ec792659fcb626e8cba674d2065" "1704976a1797342a1b4ea7a75bdbb3be1569f4619134341bd5a4c1cfb16abad4" default))
 '(dimmer-buffer-exclusion-regexps '(".*Minibuf.*" ".*which-key.*" ".*LV.*") nil nil "Customized with use-package dimmer")
 '(elfeed-feeds
   '("http://git-annex.branchable.com/design/assistant/blog/index.rss" "http://feeds.feedburner.com/InformationIsBeautiful" "http://orgmode.org" "http://www.terminally-incoherent.com/blog/feed" "http://nullprogram.com/feed" "http://planet.emacsen.org/atom.xml" "http://planet.phpunit.de/atom.xml" "http://feeds.feedburner.com/symfony/blog" "http://feeds.feedburner.com/qooxdoo/blog/content" "http://blog.eclipse-tips.com/feeds/posts/default?alt=rss" "http://ed-merks.blogspot.com/feeds/posts/default" "http://feeds.feedburner.com/eclipselive" "http://www.fosslc.org/drupal/rss.xml"))
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
   '((eval setq-local org-roam-directory
	   (pwd))
     (eval setq-local org-roam-db-location
	   (expand-file-name "org-roam.db" org-roam-directory))
     (eval setq-local org-roam-directory
	   (expand-file-name
	    (locate-dominating-file default-directory ".dir-locals.el")))
     (gac-automatically-add-new-files-p . t)
     (org-download-image-dir concat org-directory "org/artistesImages/")
     (org-download-heading-lvl . 0)
     (company-backends list
		       (company-capf))))
 '(smtpmail-smtp-service 587 t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(vertico-current ((t (:background "#3a3f5a")))))
