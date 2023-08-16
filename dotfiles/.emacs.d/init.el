;; emacs init.el

;;;;;; pray
(package-initialize)

;;;;;; basic package
(require 'cl-lib)

;;;;;; parameter
;; dir
(setq dotemacs "~/.emacs.d")
(setq dottpl   "~/.template")
(setq dottmp   (concat dotemacs "/tmp"))
(setq elpa     (concat dotemacs "/elpa"))
(setq dotinit  (concat dotemacs "/init")) ;; initload files
(setq initlib  (concat dotinit  "/lib"))  ;; library
(setq initini  (concat dotinit  "/init")) ;; initload-initload
(setq initmode (concat dotinit  "/mode")) ;; initload mode plugin
(setq initelpa (concat dotinit  "/elpa")) ;; initload local elpa

;; path
(add-to-list 'load-path initelpa)
(add-to-list 'load-path initmode)

;;;;;; auto backup: off
(setq make-backup-files nil)
(setq auto-save-default nil)
(setq auto-save-list-file-prefix nil)
(setq create-lockfiles nil)
(setq backup-directory-alist
      (cons (cons ".*" (expand-file-name dottmp)) backup-directory-alist))
(setq auto-save-file-name-transforms `((".*", (expand-file-name dottmp) t)))

;;;;;; init load
;; function: load all files in a directory
;;(require 'load-directory) ;; slow
(defun load-directory (dir)
  (let ((load-it (lambda (f) (load-file (concat (file-name-as-directory dir) f)))))
    (mapc load-it (directory-files dir nil "\\.el$"))))
;; load
(load-directory initlib)
(load-directory initini)
(load-directory dotinit)

;;;;;; other
;; bar
(menu-bar-mode -1)
;(line-number-mode t)
;(column-number-mode t)
(setq frame-title-format (format "emacs@%s : %%f" (system-name)))
;; show line-number
(global-linum-mode -1)
;; tab
(setq-default tab-width 2)
(setq-default indent-tabs-mode nil)
;; autoinsert
(add-hook 'find-file-hooks 'auto-insert)
(setq auto-insert-directory dottpl)
(setq auto-insert-alist
      '(
        ("\\.f90"  . "tpl.f90")
        ))
;; line wrap
(setq-default truncate-lines nil)
(setq-default truncate-partial-width-windows nil)
;; scroll
(setq scroll-preserve-screen-position t
      scroll-conservatively 35
      scroll-margin 0
      scroll-step 1)
;; startup
(setq inhibit-startup-message t)
(setq initial-scratch-message "")
(blink-cursor-mode -1)
(electric-indent-mode -1)
(show-paren-mode t)
(setq-default transient-mark-mode t)
(setq require-final-newline t)
(setq next-line-add-newlines nil)
(fset 'yes-or-no-p 'y-or-n-p)
(setq ring-bell-function 'ignore)
;; (setq x-select-enable-clipboard t)
;; (setq-default indicate-empty-lines t)
(delete-selection-mode t)
;; org-mode
(setq org-src-fontify-natively t)

;; end (settings after end are written by packages)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   (quote
    ("830877f4aab227556548dc0a28bf395d0abe0e3a0ab95455731c9ea5ab5fe4e1" default)))
 '(package-selected-packages
   (quote
    (counsel shell-pop shackle viewer gnuplot neotree powerline elscreen bm swap-buffers company use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
