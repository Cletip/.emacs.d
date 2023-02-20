;; -*- mode:emacs-lisp; coding: utf-8-emacs; -*-
;; Gnus startup file.
;; Never delete this file -- if you want to force Gnus to read the
;; .newsrc file (if you have one), touch .newsrc instead.
(setq gnus-newsrc-file-version "Gnus v5.13")

(setq gnus-newsrc-last-checked-date '"Sat, 11 Feb 2023 19:45:25 +0100")

(setq gnus-newsrc-alist '(("nndraft:drafts" 1 nil nil (nndraft "") ((gnus-dummy (gnus-draft-mode)))) ("nnimap+First Gmail : clement020302@gmail:INBOX" 3 nil nil "nnimap:First Gmail : clement020302@gmail" nil) ("nnimap+First Gmail : clement020302@gmail:[Gmail]/Brouillons" 3 nil nil "nnimap:First Gmail : clement020302@gmail" nil) ("nnimap+First Gmail : clement020302@gmail:[Gmail]/Corbeille" 3 nil nil "nnimap:First Gmail : clement020302@gmail" nil) ("nnimap+First Gmail : clement020302@gmail:[Gmail]/Important" 3 nil nil "nnimap:First Gmail : clement020302@gmail" nil) ("nnimap+First Gmail : clement020302@gmail:[Gmail]/Messages envoy\303\251s" 3 nil nil "nnimap:First Gmail : clement020302@gmail" nil) ("nnimap+First Gmail : clement020302@gmail:[Gmail]/Suivis" 3 nil nil "nnimap:First Gmail : clement020302@gmail" nil) ("nnimap+First Gmail : clement020302@gmail:[Gmail]/Tous les chats" 3 nil nil "nnimap:First Gmail : clement020302@gmail" nil) ("nnimap+First Gmail : clement020302@gmail:[Gmail]/Tous les messages" 3 nil nil "nnimap:First Gmail : clement020302@gmail" nil)))

(setq gnus-server-alist '(("archive" nnfolder "archive" (nnfolder-directory "/home/utilisateur/.emacs.d/var/Mail/archive") (nnfolder-active-file "/home/utilisateur/.emacs.d/var/Mail/archive/active") (nnfolder-get-new-mail nil) (nnfolder-inhibit-expiry t))))
