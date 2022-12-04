;;; .emacs --- My emacs config -*- lexical-binding: t; -*-
;;; Commentary:
;;; Code:

;; Initialize package sources
(require 'package)

(setq package-archives '(("ELPA"  . "http://tromey.com/elpa/")
			 ("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)

;; automatically update the list of packages
(when (not package-archive-contents)
  (package-refresh-contents))

(unless package-archive-contents
  (package-refresh-contents))

 
(setq byte-compile-warnings '(cl-functions)) ;; supprime les avertissements concernant cl-libs


;;Default Coding System

;; UTF-8 as default encoding (pour le go notamment et autre norme)
(set-language-environment "UTF-8")
 
(setq shell-file-name "/bin/bash") ;; utilise le Bourne Again Shell

;; configuration de straight
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

;; installation de use-package
;; Use straight.el for use-package expressions with the first line
(straight-use-package 'use-package)
(require 'package)
(setq use-package-always-ensure t)

;; automaticaly install package with "use-package"
(setq straight-use-package-by-default t)

;; Install org-mode
(straight-use-package 'org) ;; old version, org 9.4
;;new version 9.5 :
;; (straight-override-recipe
   ;; '(org :type git :host github :repo "emacsmirror/org" :no-build t))
;; (use-package org)

;; Load the helper package for commands like `straight-x-clean-unused-repos'
(require 'straight-x)
 
;;load my config.org
(org-babel-load-file (expand-file-name "~/.emacs.d/config.org"))

;; the rest  


(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(vertico-current ((t (:background "#3a3f5a")))))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes '(doom-acario-dark))
 '(dimmer-buffer-exclusion-regexps '(".*Minibuf.*" ".*which-key.*" ".*LV.*") nil nil "Customized with use-package dimmer")
 '(org-agenda-files
   '("/home/msi/Notes/Roam/xenophon.org" "/home/msi/Notes/Roam/wolfgang_amadeus_mozart.org" "/home/msi/Notes/Roam/wittgenstein.org" "/home/msi/Notes/Roam/winston_churchill.org" "/home/msi/Notes/Roam/willem_de_kooning.org" "/home/msi/Notes/Roam/warren_buffett.org" "/home/msi/Notes/Roam/walter_lippmann.org" "/home/msi/Notes/Roam/vol_us_airways_1549.org" "/home/msi/Notes/Roam/vincent_lindon.org" "/home/msi/Notes/Roam/victor_hugo.org" "/home/msi/Notes/Roam/victor_emmanuel_iii.org" "/home/msi/Notes/Roam/victor_emmanuel_ii.org" "/home/msi/Notes/Roam/verdi.org" "/home/msi/Notes/Roam/umberto_eco.org" "/home/msi/Notes/Roam/troisième_revolution.org" "/home/msi/Notes/Roam/trois_glorieuses.org" "/home/msi/Notes/Roam/transcendantalisme.org" "/home/msi/Notes/Roam/tom_hanks.org" "/home/msi/Notes/Roam/todd_komarnicki.org" "/home/msi/Notes/Roam/the_doors.org" "/home/msi/Notes/Roam/test_de_chose_bibtex.org" "/home/msi/Notes/Roam/test.org" "/home/msi/Notes/Roam/systeme_nerveux.org" "/home/msi/Notes/Roam/systeme_immunitaire.org" "/home/msi/Notes/Roam/surrealisme.org" "/home/msi/Notes/Roam/strategies_militaires.org" "/home/msi/Notes/Roam/stakhanovisme.org" "/home/msi/Notes/Roam/spinoza.org" "/home/msi/Notes/Roam/sparte.org" "/home/msi/Notes/Roam/socrate.org" "/home/msi/Notes/Roam/societe_des_gens_de_lettres.org" "/home/msi/Notes/Roam/simone_de_beauvoir.org" "/home/msi/Notes/Roam/sigmund_freud.org" "/home/msi/Notes/Roam/seconde_restauration.org" "/home/msi/Notes/Roam/seconde_guerre_mondiale.org" "/home/msi/Notes/Roam/second_empire.org" "/home/msi/Notes/Roam/sciences_cognitives.org" "/home/msi/Notes/Roam/scarlatti.org" "/home/msi/Notes/Roam/sartres.org" "/home/msi/Notes/Roam/sarah_bernhardt.org" "/home/msi/Notes/Roam/salvador_dali.org" "/home/msi/Notes/Roam/saint_domingue_colonie_francaise.org" "/home/msi/Notes/Roam/rome.org" "/home/msi/Notes/Roam/romantisme.org" "/home/msi/Notes/Roam/romanov.org" "/home/msi/Notes/Roam/romain_rolland.org" "/home/msi/Notes/Roam/robespierre.org" "/home/msi/Notes/Roam/robert_paxton.org" "/home/msi/Notes/Roam/robert_badinter.org" "/home/msi/Notes/Roam/risorgimento.org" "/home/msi/Notes/Roam/richard_strauss.org" "/home/msi/Notes/Roam/rhetorique.org" "/home/msi/Notes/Roam/revolution_russe.org" "/home/msi/Notes/Roam/rene_guenon.org" "/home/msi/Notes/Roam/rembrandt.org" "/home/msi/Notes/Roam/relations_publiques.org" "/home/msi/Notes/Roam/reflexions_sur_la_revolution_de_france.org" "/home/msi/Notes/Roam/realisme.org" "/home/msi/Notes/Roam/ready_made.org" "/home/msi/Notes/Roam/raspoutitsa.org" "/home/msi/Notes/Roam/raspoutine.org" "/home/msi/Notes/Roam/ralph_waldo_emerson.org" "/home/msi/Notes/Roam/psychophysiologie.org" "/home/msi/Notes/Roam/psychologie_analytique.org" "/home/msi/Notes/Roam/psychologie.org" "/home/msi/Notes/Roam/psychanalyse.org" "/home/msi/Notes/Roam/prendre_de_bonnes_notes_zettelkasten.org" "/home/msi/Notes/Roam/premiere_guerre_mondiale.org" "/home/msi/Notes/Roam/poseidon.org" "/home/msi/Notes/Roam/porte_tambour.org" "/home/msi/Notes/Roam/platon.org" "/home/msi/Notes/Roam/pierre_bourdieu.org" "/home/msi/Notes/Roam/physiologie.org" "/home/msi/Notes/Roam/peter_pears.org" "/home/msi/Notes/Roam/paul_verlaine.org" "/home/msi/Notes/Roam/paul_ekman.org" "/home/msi/Notes/Roam/paul_ackerman.org" "/home/msi/Notes/Roam/paris.org" "/home/msi/Notes/Roam/pacifisme.org" "/home/msi/Notes/Roam/oscar_wilde.org" "/home/msi/Notes/Roam/orlando_bloom.org" "/home/msi/Notes/Roam/oreille_humaine.org" "/home/msi/Notes/Roam/ordinateur.org" "/home/msi/Notes/Roam/odyssee.org" "/home/msi/Notes/Roam/objection_de_conscience.org" "/home/msi/Notes/Roam/nuages.org" "/home/msi/Notes/Roam/non_violence.org" "/home/msi/Notes/Roam/nietzsche.org" "/home/msi/Notes/Roam/nicolas_sarkozy.org" "/home/msi/Notes/Roam/nicolas_poussin.org" "/home/msi/Notes/Roam/nicolas_ii.org" "/home/msi/Notes/Roam/nicolas_hulot.org" "/home/msi/Notes/Roam/new_york.org" "/home/msi/Notes/Roam/neurophysiologie.org" "/home/msi/Notes/Roam/nazisme.org" "/home/msi/Notes/Roam/naturalisme.org" "/home/msi/Notes/Roam/napoléon_ses_transformations_sur_la_France_et_l'Europe.org" "/home/msi/Notes/Roam/napoleon_iii.org" "/home/msi/Notes/Roam/napoleon_1er.org" "/home/msi/Notes/Roam/mythologie_grec.org" "/home/msi/Notes/Roam/mussolini.org" "/home/msi/Notes/Roam/musique_de_chambre.org" "/home/msi/Notes/Roam/mont_fuji.org" "/home/msi/Notes/Roam/mondrian.org" "/home/msi/Notes/Roam/monarchie_de_juillet.org" "/home/msi/Notes/Roam/mitterrand.org" "/home/msi/Notes/Roam/michel_ange.org" "/home/msi/Notes/Roam/methaphore.org" "/home/msi/Notes/Roam/memoire.org" "/home/msi/Notes/Roam/medias.org" "/home/msi/Notes/Roam/marcel_proust.org" "/home/msi/Notes/Roam/marcel_duchamp.org" "/home/msi/Notes/Roam/maladie.org" "/home/msi/Notes/Roam/majorite_silencieuse.org" "/home/msi/Notes/Roam/maison_phenix.org" "/home/msi/Notes/Roam/lvmh_moet_hennessy_louis_vuitton.org" "/home/msi/Notes/Roam/louis_xiv.org" "/home/msi/Notes/Roam/louis_xiii.org" "/home/msi/Notes/Roam/lobby.org" "/home/msi/Notes/Roam/linguistique_cognitive.org" "/home/msi/Notes/Roam/lieu_commun.org" "/home/msi/Notes/Roam/lethologica.org" "/home/msi/Notes/Roam/les_souffrances_du_jeune_werther.org" "/home/msi/Notes/Roam/les_grandes_civilisations.org" "/home/msi/Notes/Roam/leon_trotski.org" "/home/msi/Notes/Roam/leon_tolstoi.org" "/home/msi/Notes/Roam/leo_ferre.org" "/home/msi/Notes/Roam/lenine.org" "/home/msi/Notes/Roam/le_corbusier.org" "/home/msi/Notes/Roam/la_tentation_de_saint_antoine.org" "/home/msi/Notes/Roam/la_rochefoucauld.org" "/home/msi/Notes/Roam/la_conscience.org" "/home/msi/Notes/Roam/kurzgesagt.org" "/home/msi/Notes/Roam/karl_popper.org" "/home/msi/Notes/Roam/karl_marx.org" "/home/msi/Notes/Roam/journal_de_dissatisfaction.org" "/home/msi/Notes/Roam/joseph_staline.org" "/home/msi/Notes/Roam/jeff_koons.org" "/home/msi/Notes/Roam/jean_de_la_fontaine.org" "/home/msi/Notes/Roam/jean_cocteau.org" "/home/msi/Notes/Roam/jean_baptiste_lully.org" "/home/msi/Notes/Roam/jean_baptiste_de_lamarck.org" "/home/msi/Notes/Roam/jacques_monod.org" "/home/msi/Notes/Roam/jackson_pollock.org" "/home/msi/Notes/Roam/index.org" "/home/msi/Notes/Roam/impressionnisme.org" "/home/msi/Notes/Roam/iliade.org" "/home/msi/Notes/Roam/il_faut_sauver_le_soldat_ryan.org" "/home/msi/Notes/Roam/hyacinthe_rigaud.org" "/home/msi/Notes/Roam/homere.org" "/home/msi/Notes/Roam/henry_purcell.org" "/home/msi/Notes/Roam/gustave_le_bon.org" "/home/msi/Notes/Roam/gustave_flaubert.org" "/home/msi/Notes/Roam/gustave_courbet.org" "/home/msi/Notes/Roam/guerre_du_vietnam.org" "/home/msi/Notes/Roam/guerre_d_independance_grecque.org" "/home/msi/Notes/Roam/gueorgui_joukov.org" "/home/msi/Notes/Roam/grece_antique.org" "/home/msi/Notes/Roam/goethe.org" "/home/msi/Notes/Roam/gioachino_rossini.org" "/home/msi/Notes/Roam/gilles_deleuze.org" "/home/msi/Notes/Roam/ghandi.org" "/home/msi/Notes/Roam/george_sand.org" "/home/msi/Notes/Roam/george_orwell.org" "/home/msi/Notes/Roam/georg_wilhelm_friedrich_hegel.org" "/home/msi/Notes/Roam/generations_de_droits.org" "/home/msi/Notes/Roam/general_desaix.org" "/home/msi/Notes/Roam/game_of_thrones.org" "/home/msi/Notes/Roam/gafam.org" "/home/msi/Notes/Roam/frederic_chopin.org" "/home/msi/Notes/Roam/franz_schubert.org" "/home/msi/Notes/Roam/franklin_delano_roosevelt.org" "/home/msi/Notes/Roam/francois_hollande.org" "/home/msi/Notes/Roam/francois_d_aix_de_la_chaise.org" "/home/msi/Notes/Roam/francois_begaudeau.org" "/home/msi/Notes/Roam/franc_maconnerie.org" "/home/msi/Notes/Roam/fonctionnement_de_l_ordinateur_a_haut_niveau.org" "/home/msi/Notes/Roam/fonctionnement_de_l_ordinateur_a_bas_niveau.org" "/home/msi/Notes/Roam/fonctionnement_d_un_ordinateur.org" "/home/msi/Notes/Roam/figures_de_style.org" "/home/msi/Notes/Roam/fendi.org" "/home/msi/Notes/Roam/fauve.org" "/home/msi/Notes/Roam/faut_il_differencier_l_homme_de_l_artiste.org" "/home/msi/Notes/Roam/faust.org" "/home/msi/Notes/Roam/fascisme.org" "/home/msi/Notes/Roam/famille_windsor.org" "/home/msi/Notes/Roam/expressionnisme_abstrait.org" "/home/msi/Notes/Roam/europe.org" "/home/msi/Notes/Roam/eugene_delacroix.org" "/home/msi/Notes/Roam/etoiles_univers.org" "/home/msi/Notes/Roam/ethique_philosiphie.org" "/home/msi/Notes/Roam/esthetique_philosiphie.org" "/home/msi/Notes/Roam/esope.org" "/home/msi/Notes/Roam/epistemologie.org" "/home/msi/Notes/Roam/energie_houlomotrice.org" "/home/msi/Notes/Roam/emmanuel_kant.org" "/home/msi/Notes/Roam/emile_zola.org" "/home/msi/Notes/Roam/elsa_triolet.org" "/home/msi/Notes/Roam/elisabeth_ii.org" "/home/msi/Notes/Roam/egypte_antique.org" "/home/msi/Notes/Roam/effet_placebo.org" "/home/msi/Notes/Roam/effet_nocebo.org" "/home/msi/Notes/Roam/edward_bernays.org" "/home/msi/Notes/Roam/edouard_manet.org" "/home/msi/Notes/Roam/edouard_iii.org" "/home/msi/Notes/Roam/edmund_burke.org" "/home/msi/Notes/Roam/economie.org" "/home/msi/Notes/Roam/ecole_de_la_sorbonne.org" "/home/msi/Notes/Roam/dostoievski.org" "/home/msi/Notes/Roam/divinites_de_la_mythologie_grecque.org" "/home/msi/Notes/Roam/disney.org" "/home/msi/Notes/Roam/différences_émotion_ressenti_sentiments_etc.org" "/home/msi/Notes/Roam/dialectique.org" "/home/msi/Notes/Roam/deuxième_restauration.org" "/home/msi/Notes/Roam/descartes.org" "/home/msi/Notes/Roam/deroulement_apres_la_revolution_1789_1848.org" "/home/msi/Notes/Roam/definition_de_dieu.org" "/home/msi/Notes/Roam/debarquement_en_provence.org" "/home/msi/Notes/Roam/debarquement.org" "/home/msi/Notes/Roam/david_benioff.org" "/home/msi/Notes/Roam/daily/2021-11-07.org" "/home/msi/Notes/Roam/daily/daily/2021-09-03.org" "/home/msi/Notes/Roam/culte_de_la_personnalite.org" "/home/msi/Notes/Roam/critique_de_la_file_deroulement_apres_la_revolution_1789_1848_org_revolution_mettre_lien_par_edmund_burke.org" "/home/msi/Notes/Roam/criticisme.org" "/home/msi/Notes/Roam/corps_humain.org" "/home/msi/Notes/Roam/consumerisme.org" "/home/msi/Notes/Roam/communisme.org" "/home/msi/Notes/Roam/communication_verbale.org" "/home/msi/Notes/Roam/communication_non_verbale.org" "/home/msi/Notes/Roam/communication_de_masse.org" "/home/msi/Notes/Roam/communication.org" "/home/msi/Notes/Roam/colette.org" "/home/msi/Notes/Roam/clint_eastwood.org" "/home/msi/Notes/Roam/claude_monet.org" "/home/msi/Notes/Roam/claude_lorrain.org" "/home/msi/Notes/Roam/classicisme.org" "/home/msi/Notes/Roam/cimetiere_du_pere_lachaise.org" "/home/msi/Notes/Roam/ciceron.org" "/home/msi/Notes/Roam/christo.org" "/home/msi/Notes/Roam/cheval_blanc_courchevel.org" "/home/msi/Notes/Roam/chateau_de_windsor.org" "/home/msi/Notes/Roam/charybde_et_scylla.org" "/home/msi/Notes/Roam/charles_perrault.org" "/home/msi/Notes/Roam/charles_darwin.org" "/home/msi/Notes/Roam/charles_baudelaire.org" "/home/msi/Notes/Roam/chambre_chinoise.org" "/home/msi/Notes/Roam/cerveau_humain.org" "/home/msi/Notes/Roam/cercle_de_vienne.org" "/home/msi/Notes/Roam/celine.org" "/home/msi/Notes/Roam/caspar_david_friedrich.org" "/home/msi/Notes/Roam/carl_bark.org" "/home/msi/Notes/Roam/cardinal_de_richelieu.org" "/home/msi/Notes/Roam/caravage.org" "/home/msi/Notes/Roam/campagne_d_egypte.org" "/home/msi/Notes/Roam/camille_claudel.org" "/home/msi/Notes/Roam/brad_pitt.org" "/home/msi/Notes/Roam/bouddhisme.org" "/home/msi/Notes/Roam/bonheur.org" "/home/msi/Notes/Roam/blanchiment_des_troupes_coloniales.org" "/home/msi/Notes/Roam/biais_de_confirmation.org" "/home/msi/Notes/Roam/bernard_arnault.org" "/home/msi/Notes/Roam/bergson.org" "/home/msi/Notes/Roam/benjamin_graham.org" "/home/msi/Notes/Roam/benjamin_britten.org" "/home/msi/Notes/Roam/beethoven.org" "/home/msi/Notes/Roam/bataille_d_hernani.org" "/home/msi/Notes/Roam/baroque.org" "/home/msi/Notes/Roam/balzac.org" "/home/msi/Notes/Roam/bach.org" "/home/msi/Notes/Roam/babyloniens.org" "/home/msi/Notes/Roam/auguste_rodin.org" "/home/msi/Notes/Roam/aufklarung.org" "/home/msi/Notes/Roam/artur_rimbaud.org" "/home/msi/Notes/Roam/arthur_schopenhauer.org" "/home/msi/Notes/Roam/art_moderne.org" "/home/msi/Notes/Roam/art_contemporain.org" "/home/msi/Notes/Roam/art_abstrait.org" "/home/msi/Notes/Roam/aristote.org" "/home/msi/Notes/Roam/architecture_fasciste.org" "/home/msi/Notes/Roam/aragon.org" "/home/msi/Notes/Roam/anil_seth.org" "/home/msi/Notes/Roam/anarchisme.org" "/home/msi/Notes/Roam/alphonse_de_lamartine.org" "/home/msi/Notes/Roam/alfred_russel_wallace.org" "/home/msi/Notes/Roam/alfred_hitchcock.org" "/home/msi/Notes/Roam/alexandre_le_grand.org" "/home/msi/Notes/Roam/alexandre_ii_russie.org" "/home/msi/Notes/Roam/alessandro_manzoni.org" "/home/msi/Notes/Roam/alan_turing.org" "/home/msi/Notes/Roam/adolf_hitler.org" "/home/msi/Notes/Roam/References/CV/moncv.org" "/home/msi/Notes/Roam/PhilosophieDuMonde.org" "/home/msi/Notes/Roam/Gab.org" "/home/msi/Notes/Roam/GTD/1Inbox.org" "/home/msi/Notes/Roam/GTD/2Agendatickler.org" "/home/msi/Notes/Roam/GTD/2Agendatickler.sync-conflict-20220205-131911-DO4A5XI.org" "/home/msi/Notes/Roam/GTD/3Bookmarks.org" "/home/msi/Notes/Roam/GTD/4GTD.org" "/home/msi/Notes/Roam/GTD/5References.org" "/home/msi/Notes/Roam/GTD/7Contact.org" "/home/msi/Notes/Roam/GTD/Se_connaitre_soi_meme.org" "/home/msi/Notes/Roam/GTD/citations.org" "/home/msi/Notes/Roam/GTD/films_vus.org" "/home/msi/Notes/Roam/GTD/jeux_video_joues.org" "/home/msi/Notes/Roam/GTD/livres_lus.org" "/home/msi/Dossier_partage_nous_deux/Orgzly/8Artistes.org" "/home/msi/Dossier_partage_nous_deux/Orgzly/3Artistes.org" "/home/msi/Dossier_partage_nous_deux/Orgzly/1Referencescommun.org" "/home/msi/Dossier_partage_nous_deux/Orgzly/0Recettes.org"))
 '(safe-local-variable-values
   '((org-download-image-dir . "/home/msi/Orgzly/images/")
     (org-download-heading-lvl . 0)
     (org-refile-targets
      (nil :maxlevel . 1))
     (org-archive-location . "/home/msi/Notes/Roam/GTD/6Archives.org::* Archives de Projets")
     (eval add-hook 'after-save-hook 'org-html-export-to-html t t)
     (org-refile-targets
      (nil :maxlevel . 9))
     (org-archive-location . "/home/msi/Notes/Roam/GTD/6Archives.org::* Archives Agendatickler")
     (org-archive-location . "/home/msi/Notes/Roam/GTD/6Archives.org::* Archives Normales"))))
