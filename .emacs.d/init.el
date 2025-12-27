;; Set up package.el to work with MELPA
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)(package-refresh-contents)

;; Helpful package management
(require 'use-package)

;; In emacs < 29 this helps with annoying key issues
;;(require 'gnu-elpa-keyring-update)


;; Allow bundled packages to upgrade (used for seq package dependencies in Magit), generally useful even after building from source
(setq package-install-upgrade-built-in t)

;; Tabs are just 4 spaces. I hate tabs!
(setq indent-tabs-mode nil)
(setq tab-width 4)

;; Helper fn to load secrets from secret files
;; Loads from file with lines key=val
;; TODO - support multiple files
(defun load-secret (key)
  (with-temp-buffer
    (insert-file-contents "~/.secrets")
    ;;let* evaluates sequentially, not parallel so we can use secrets list
    (let* (
	  (secrets-list (split-string (buffer-string) "\n" t)) ; Get each line. 't' omits empty strings
	  (matching-secret (seq-filter
					  (lambda (x)  (equal key (car (split-string x "=" t))))
					  secrets-list)))
	  ;; Return here
	  (cadr (split-string (car matching-secret) "="))
    )
  )
)

;; Use ibuffer instead of standard buffer
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; Enable Evil MODE
(use-package evil
  :ensure t
  :init
  (setq evil-want-integration t) ;; This is optional since it's already set to t by default.
  (setq evil-undo-system 'undo-redo)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1))

;; Evil keybindings in many modes
(use-package evil-collection
  :after evil
  :ensure t
  :config
  (evil-collection-init))

;; Magit git
(use-package magit
  :ensure t
  )

;; Let's connect magit to github
(use-package forge
  :ensure t
  :after magit)

(use-package org
  :ensure t
  :after evil-org
  :config
  ;; Allows us to do advanced TODO tracking
  ;; The @ and ! are just timestamp tracking. We could theoretically log more if you rtfm
  (setq org-todo-keywords '((sequence "TODO(t!)" "REVISIT(r!)" "WAIT(w@/!)" "IN PROGRESS(p!)" "|" "PROJECT(j)" "DONE(d!)" "CANCELED(c@)")))

  (setq org-default-notes-file (concat org-directory "/notes.org"))

  ;; TODO - deal with this. Generally needed
  ;; (global-set-key (kbd "C-c l") #'org-store-link)
  (global-set-key (kbd "C-c a") #'org-agenda)
  (global-set-key (kbd "C-c c") #'org-capture)

  ;; Set up habits
  (add-to-list 'org-modules 'org-habit)
  ;; I like seeing a lot of days
  (setq org-agenda-span 14)

  ;; Record the date/time when a task is marked DONE
  (setq org-log-done 'time)
  ;; Record a note/timestamp specifically when a repeating task repeats
  (setq org-log-repeat 'time)
  ;; Put these logs into a drawer called :LOGBOOK: (keeps things tidy)
  (setq org-log-into-drawer t)
  ;; Native org agenda support for logs?
  (setq org-agenda-start-with-log-mode t)

  ;; TODO this can theoretically get slow
  ;; The string search avoids emacs swap files that start with .#
  ;; TODO rerun on org agenda load
  (defun reload-org-agenda-files ()
   (interactive)
   (setq org-agenda-files
    (seq-filter (lambda (x) (not (string-search "/.#" x)))
	(append
	 (directory-files-recursively "~/writing/" "")
	 (directory-files-recursively "~/org/" "\\.org$")
	 ;; Only certain projects for size reasons
	 (directory-files-recursively "~/projects/" "\\.org$")
	 )
    )
   )
  )
  (org-mode-restart)
  (reload-org-agenda-files))


;; EVILLLLLL in org
(use-package evil-org
  :ensure t
  :after org
  :hook (org-mode . (lambda () evil-org-mode))
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys))


;; Org roam dependencies are bad
(use-package sqlite3                       
  :ensure t
)
(use-package dash
  :ensure t
)
(use-package f
  :ensure t
)
(use-package s
  :ensure t
)
(use-package emacsql
  :ensure t
)
(use-package magit-section
  :ensure t
)

(use-package org-roam
  :ensure t
  :after org
  :config
  (require 'evil-org-agenda)
  (evil-org-agenda-set-keys)
  :init
  (if (file-directory-p "~/org/roam") () (make-directory "~/org/roam"))
  (setq org-roam-directory (file-truename "~/org/roam/"))
  (setq org-roam-db-location (concat org-roam-directory "roam.sqlite"))
)

;; Load org-roam db after startup
;; TODO - this may have  astartup performance cost
(org-roam-db-autosync-mode)
(org-roam-db-sync)

;; Trying this - TODO verify
(use-package org-habit-stats
  :ensure t
  :after org
)

;; LLM chat interface
(use-package gptel
  :ensure t
  :init
  ;; Load GEMINI_API_KEY=VAL\n from secrets file
  (setq gptel-backend (gptel-make-gemini "Gemini" :key (load-secret "GEMINI_API_KEY") :stream t))
  ;; I wish
  ;; TODO route to gemma if rate limited
  (setq gptel-model 'gemini-3-flash-preview)
  (setq gptel-default-mode 'org-mode)

  (defun gptel-new-session ()
    "Create a new gptel chat buffer without prompting."
    (interactive)
    (let* (
	   ;; Count existing buffers to generate new buffer name
	   (existing-count (length (seq-filter (lambda (x) (cl-search "gpt" x)) (mapcar #'buffer-name (buffer-list)))))
	   (buf (generate-new-buffer (format "*gpt%d*" existing-count)))
    )
      (with-current-buffer buf
	(org-mode)
	(gptel-mode 1))
      (pop-to-buffer buf))
  )


  ;; For now C-c g is gpt start
  (global-set-key (kbd "C-c g") 'gptel-new-session)
)

;; TODO copilot

;; w3m


;; My favorite theme - gruvbox dark
(use-package gruvbox-theme
  :ensure t
)

;; Dired mode ordering pref
;; lah standard,  F shows dir type, v makes dotfiles handling same, reverse makes prettier
(setq dired-listing-switches "-rlahFv --group-directories-first")

;; THEME!
(load-theme 'gruvbox-dark-medium t)

;; IVY for completion
;; TODO - Compile
;; Include ivy swiper and counsel for better completion (TODO: 
;; (add-to-list 'load-path "~/downloaded_repos/elisp_repos/swiper/")
;; (require ')
(use-package swiper
  :ensure t
  :init 
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) ")
)

;;TODO evaluate
;;(use-package ivy-prescient
;;  :ensure ()
;;  :init
;;)

;; MY custom things
;; Right now only wiki
;; TODO
;;(add-to-list 'load-path "~/projects/elisp/")




(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("75b371fce3c9e6b1482ba10c883e2fb813f2cc1c88be0b8a1099773eb78a7176"
     "8363207a952efb78e917230f5a4d3326b2916c63237c1f61d7e5fe07def8d378"
     "51fa6edfd6c8a4defc2681e4c438caf24908854c12ea12a1fbfd4d055a9647a3"
     "d5fd482fcb0fe42e849caba275a01d4925e422963d1cd165565b31d3f4189c87"
     "5a0ddbd75929d24f5ef34944d78789c6c3421aa943c15218bac791c199fc897d"
     default))
 '(org-enforce-todo-dependencies t)
 '(org-habit-graph-column 60)
 '(package-selected-packages
   '(evil-collection evil-org f forge gptel gruvbox-theme magit
		     org-habit-stats org-roam sqlite3 swiper))
 '(safe-local-variable-values
   '((vc-default-patch-addressee . "bug-gnu-emacs@gnu.org")
     (vc-prepare-patches-separately)
     (etags-regen-ignores "test/manual/etags/")
     (etags-regen-regexp-alist
      (("c" "objc") "/[ \11]*DEFVAR_[A-Z_ \11(]+\"\\([^\"]+\\)\"/\\1/"
       "/[ \11]*DEFVAR_[A-Z_ \11(]+\"[^\"]+\",[ \11]\\([A-Za-z0-9_]+\\)/\\1/"))
     (diff-add-log-use-relative-names . t)
     (vc-git-annotate-switches . "-w"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
