;; Set up package.el to work with MELPA
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)(package-refresh-contents)

;; Helpful package management
(package-install 'use-package)
;; Help with annoying key issues
(package-install 'gnu-elpa-keyring-update)
;; Allow bundled packages to upgrade (used for seq package dependencies in Magit)
;; In this case, you may need to manually update to get magit working
;; (M-x package-refresh-contents) then (M-x list-packages) then find seq, and press I over it to mark for installation
;; Then pressing x will execute
(setq package-install-upgrade-built-in t)



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


;; Org mode





(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(seq magit use-package gnu-elpa-keyring-update evil-collection)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
