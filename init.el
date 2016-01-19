(require 'package)

(setq package-enable-at-startup nil)
(add-to-list 'package-archives
						 '("melpa" . "https://melpa.org/packages/"))
(add-to-list 'package-archives
						 '("marmalade" . "http://marmalade-repo.org/packages/"))

(add-to-list 'package-archives
						 '("org" . "http://orgmode.org/elpa/") t)
(package-initialize)

;; Bootstrap `use-package'
(unless (package-installed-p 'use-package)
	(package-refresh-contents)
	(package-install 'use-package))

;; Bootstrap `org'
(unless (package-installed-p 'org)
	;(package-refresh-contents)
	(package-install 'org))

(org-babel-load-file "~/.emacs.d/emacs.org")

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(flycheck-disabled-checkers (quote (emacs-lisp-checkdoc)))
 '(package-selected-packages (quote (org org-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(relative-line-numbers-current-line ((t (:inherit relative-line-numbers :foreground "highlightColor")))))
