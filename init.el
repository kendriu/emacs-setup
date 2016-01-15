(require eshell)
(defun set-exec-path-from-shell-PATH ()
	(let ((path-from-shell (replace-regexp-in-string
													"[ \t\n]*$"
													""
													(shell-command-to-string "$SHELL --login -i -c 'echo $PATH'"))))
		(setenv "PATH" path-from-shell)
		(setq eshell-path-env path-from-shell) ; for eshell users
		(setq exec-path (split-string path-from-shell path-separator))))

(when window-system (set-exec-path-from-shell-PATH))
(package-initialize)

;; Bars at start
(menu-bar-mode -1)
(toggle-scroll-bar -1)
(tool-bar-mode -1)

;; Fullscreen
(add-to-list 'default-frame-alist '(fullscreen . maximized))

(setq custom-safe-themes t)

;;; Instalation of packages
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil 'noerror)
	(with-current-buffer
			(url-retrieve-synchronously
			 "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
		(goto-char (point-max))
		(eval-print-last-sexp)))

(require 'el-get-recipes)
(require 'el-get)
(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get-user/recipes")
(el-get 'sync '(
								aggressive-indent-mode
								auto-complete
								beacon
								elpy
								evil
								evil-leader
								evil-matchit
								evil-nerd-commenter
								evil-surround
								helm
								dired+
								markdown-mode
								helm-projectile
								magit
								pony-mode
								neotree
								popup
								powerline
								projectile
								rainbow-delimiters
								relative-line-numbers
								solarized-emacs
								yascroll
								websocket
								smartparens
								fringe-helper
								))

(el-get-bundle AnthonyDiGirolamo/airline-themes
	(add-to-list 'custom-theme-load-path "~/.emacs.d/el-get/airline-themes/"))
(el-get-bundle flycheck/flycheck
	(add-hook 'after-init-hook #'global-flycheck-mode))
(el-get-bundle purcell/whitespace-cleanup-mode)
(el-get-bundle nonsequitur/git-gutter-fringe-plus)
(el-get-bundle nonsequitur/git-gutter-plus)
(el-get-bundle syohex/electric-operator)

;;; User Interface
(setq frame-background-mode 'dark)
(set-terminal-parameter nil 'background-mode 'dark)
(load-theme 'solarized-dark)
(if ( display-graphic-p )
		(load-theme 'airline-solarized-alternate-gui)
		(load-theme 'airline-molokai))
(require 'yascroll)
(global-yascroll-bar-mode 1)
(cua-mode)
(global-auto-revert-mode 1)
;; C-x C-j opens dired with the cursor right on the file you're editing
(require 'dired-x)

(defalias 'yes-or-no-p 'y-or-n-p)

;; No blinking cursor
(blink-cursor-mode -1)
(setq ring-bell-function 'ignore)

(defadvice relative-line-numbers-default-format ( around current-line (arg) activate)

	"If offset is 0 then return current line"
	(if (= arg 0)
			(ad-set-arg 0 (line-number-at-pos)))
	ad-do-it)
(global-relative-line-numbers-mode)

(require 'git-gutter-fringe+)
(global-git-gutter+-mode)


;; Whitespace
(setq show-trailing-whitespace t)
(require 'whitespace-cleanup-mode)
(global-whitespace-cleanup-mode)
(add-hook 'before-save-hook 'whitespace-cleanup)

(require 'beacon)
(beacon-mode 1)
(require 'rainbow-delimiters )
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)
(add-hook 'emacs-lisp-mode-hook #'rainbow-delimiters-mode)
(add-hook 'lisp-mode-hook 'rainbow-delimiters-mode)

(autoload 'markdown-mode "markdown-mode"
	"Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.text\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))


;;; Edition
(require 'auto-complete-config)
(ac-config-default)
(require 'elpy)
(elpy-enable)

(require 'evil)
(require 'evil-leader)
;; (add-to-list 'evil-emacs-state-modes 'magit-mode)

(evil-mode t)
(global-evil-leader-mode)

(require 'yasnippet)
(yas-global-mode 1)

;; Tabs and spaces
(setq-default tab-width 2)
(setq indent-tabs-mode nil)
(require 'electric-operator)

(require 'flycheck)
(setq-default flycheck-emacs-lisp-load-path 'inherit)

(setq inhibit-startup-message t)

(require 'aggressive-indent)
(global-aggressive-indent-mode 1)

(require 'smartparens-config)
(add-hook 'emacs-lisp-mode-hook #'smartparens-mode)
(smartparens-global-strict-mode t)


;;; Command Line
(require 'helm)
(require 'helm-command)
(require 'helm-mode)
(helm-mode 1)
(setq helm-mode-fuzzy-match t)
(setq helm-M-x-fuzzy-match t)
(setq helm-quick-update t)

;; keep a list of recently opened files
(recentf-mode 1)
(setq-default recent-save-file "~/.emacs.d/recentf")

;; Write backup files to own directory
(setq backup-directory-alist
			`(("." . ,(expand-file-name
								 (concat user-emacs-directory "backups")))))

;; Make backups of files, even when they're in version control
(setq vc-make-backup-files t)

;; Save point position between sessions
(require 'saveplace)
(setq-default save-place t)
(setq save-place-file (expand-file-name ".places" user-emacs-directory))

;; esc quits
(defun minibuffer-keyboard-quit ()
	"Abort recursive edit.
In Delete Selection mode, if the mark is active, just deactivate it;
then it takes a second \\[keyboard-quit] to abort the minibuffer."
	(interactive)
	(if (and delete-selection-mode transient-mark-mode mark-active)
			(setq deactivate-mark  t)
		(when (get-buffer "*Completions*") (delete-windows-on "*Completions*"))
		(abort-recursive-edit)))
(define-key evil-normal-state-map [escape] 'keyboard-quit)
(define-key evil-visual-state-map [escape] 'keyboard-quit)
(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)
(global-set-key [escape] 'evil-exit-emacs-state)

;;; Shortcuts
;; helm
;; under mac, have Command as Meta and keep Option for localized input
(when (string-match "apple-darwin" system-configuration)
	(setq mac-allow-anti-aliasing t)
	(setq mac-command-modifier 'meta)
	(setq mac-option-modifier 'none))
(global-set-key (kbd "M-x") 'helm-M-x)
(require 'evil-nerd-commenter)
(evilnc-default-hotkeys)
;; (define-key helm-read-file-map (kbd "TAB") 'helm-execute-persistent-action)
(evil-leader/set-key
	"m" 'helm-recentf
	"f" 'helm-find-files
	"b" 'helm-buffers-list
	)

;;;magit
(require 'magit)
(global-set-key (kbd "C-x g") 'magit-status)
(setq magit-clone-set-remote.pushDefault t)

(require 'projectile )
(require 'helm-projectile)
(projectile-global-mode)
(setq projectile-completion-system 'helm)
(helm-projectile-on)


(require 'neotree)
(global-set-key [f2] 'neotree-toggle)
(setq neo-smart-open t)
(add-hook 'neotree-mode-hook
					(lambda ()
						(define-key evil-normal-state-local-map (kbd "TAB") 'neotree-enter)
						(define-key evil-normal-state-local-map (kbd "SPC") 'neotree-enter)
						(define-key evil-normal-state-local-map (kbd "q") 'neotree-hide)
						(define-key evil-normal-state-local-map (kbd "RET") 'neotree-enter)))

;;; Custom set variables and faces
(require 'relative-line-numbers)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(flycheck-disabled-checkers (quote (emacs-lisp-checkdoc))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(relative-line-numbers-current-line ((t (:inherit relative-line-numbers :foreground "highlightColor")))))
