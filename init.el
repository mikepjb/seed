;; init.el -*- lexical-binding: t -*-
;; gpg --homedir ~/.emacs.d/elpa/gnupg --receive-keys <RSA key hash in output>

(setq gc-cons-threshold 32000000
      garbage-collection-messages t)

(setq enabled '(ido-mode show-paren-mode electric-pair-mode
			 electric-indent-mode global-auto-revert-mode
			 savehist-mode))
(setq disabled '(tool-bar-mode menu-bar-mode scroll-bar-mode fringe-mode))
(setq-default
 split-height-threshold 1200
 split-width-threshold 2000
 indent-tabs-mode nil
 debug-on-error t
 inhibit-splash-screen t
 vc-follow-symlinks t
 column-number-mode t
 load-prefer-newer t
 ring-bell-function 'ignore
 fill-column 80
 show-trailing-whitespace t
 compilation-ask-about-save nil
 backup-directory-alist `(("." . ,(concat user-emacs-directory "saves")))
 custom-file (make-temp-file ""))

(defalias 'yes-or-no-p 'y-or-n-p)

(dolist (m enabled) (funcall m 1))
(dolist (m disabled) (funcall m -1))

(defmacro ifn (fn)
  `(lambda () (interactive) ,fn))

(defmacro include (name &rest args)
  `(progn
     (unless (assoc ',name package-archive-contents)
       (package-refresh-contents))
     (unless (package-installed-p ',name)
       (package-install ',name))
     (require ',name)))

;; third party code
(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

(when (include haskell-mode)
  (add-hook 'haskell-mode-hook 'interactive-haskell-mode))
;; haskell-mode must have started first
(include markdown-mode)
(include magit)

(defun code-config ()
  (if (version<= "26.0.50" emacs-version)
      (display-line-numbers-mode 1)
    (linum-mode 1)))

(dolist (hook '(prog-mode-hook css-mode-hook)) (add-hook hook 'code-config))

;; (include display-line-number-mode)
;; (include interactive-haskell-mode)
;; (setq package-check-signature nil)
;; intero?

(dolist
    (binding
     `(("M-o" . other-window)
       ("C-c i" . ,(ifn (find-file user-init-file)))
       ("C-c n" . ,(ifn (find-file (concat user-emacs-directory "notes.org"))))
       ("C-c g" . magit)
       ("C-c p" . projectile-find-file)
       ("C-c P" . projectile-grep)
       ("C-h" . delete-backward-char)
       ("M-H" . ,help-map)
       ;; ("C-;" . company-capf)
       ;; ("M-k" . paredit-forward-barf-sexp)
       ;; ("M-l" . paredit-forward-slurp-sexp)
       ("M-RET" . toggle-frame-fullscreen)))
  (global-set-key (kbd (car binding)) (cdr binding)))

(defadvice kill-region (before unix-werase activate compile)
  "When called interactively with no active region, delete a single word
    backwards instead."
  (interactive
   (if mark-active (list (region-beginning) (region-end))
     (list (save-excursion (backward-word 1) (point)) (point)))))

(add-hook 'ido-setup-hook
	  (lambda ()
	    (define-key ido-completion-map (kbd "C-w") 'backward-kill-word)
	    (define-key ido-file-completion-map (kbd "C-w") 'ido-delete-backward-word-updir)))
