;; package manager

;; package.el: default package manager
(setq package-user-dir elpa)
(cond ((and (>= emacs-major-version 26) (>= emacs-minor-version 3))
       (setq package-archives
             '(("gnu"   . "http://elpa.gnu.org/packages/")
               ("melpa" . "http://melpa.org/packages/"   )
               ("org"   . "http://orgmode.org/elpa/"     ))))
      (t
       (setq package-archives
             '(("melpa" . "http://melpa.org/packages/"   )
               ("org"   . "http://orgmode.org/elpa/"     )))))

;; autoinstall use-package by package.el
(when (not (package-installed-p 'use-package))
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)

;;;;;; install packages

;;;;;; counsel.el ivy.el+swiper.el, complement system
;; counsel includes ivy, swiper
(use-package counsel :ensure t
  :config
  (ivy-mode 1)
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t))

;;;;;; bind-key.el: simple and multifunctional define-key
(use-package bind-key :ensure t)

;;;;;; swap-buffers.el: swap pane
(use-package swap-buffers :ensure t
  :config
  (defun swap-buffers-keep-focus ()
    (interactive)
    (swap-buffers t)))

;;;;;; elscreen.el: tab editor
(use-package elscreen :ensure t
  :config
  (elscreen-start)
  (setq elscreen-tab-display-kill-screen nil)
  (setq elscreen-tab-display-control nil)
  (setq elscreen-buffer-to-nickname-alist
        '(("^dired-mode$" . (lambda () (format "Dired(%s)" dired-directory)))
          ("^Info-mode$" . (lambda () (format "Info(%s)" (file-name-nondirectory Info-current-file))))
          ("^mew-draft-mode$" . (lambda () (format "Mew(%s)" (buffer-name (current-buffer)))))
          ("^mew-" . "Mew")
          ("^irchat-" . "IRChat")
          ("^liece-" . "Liece")
          ("^lookup-" . "Lookup")))
  (setq elscreen-mode-to-nickname-alist
        '(("[Ss]hell" . "shell")
          ("compilation" . "compile")
          ("-telnet" . "telnet")
          ("dict" . "OnlineDict")
          ("*WL:Message*" . "Wanderlust")))
  (set-face-attribute 'elscreen-tab-background-face nil
                      :background "grey10" :foreground "grey90")
  (set-face-attribute 'elscreen-tab-control-face nil
                      :background "grey20" :foreground "grey90")
  (set-face-attribute 'elscreen-tab-current-screen-face nil
                      :background "grey20" :foreground "grey90")
  (set-face-attribute 'elscreen-tab-other-screen-face nil
                      :background "grey30" :foreground "grey60")
  )

;;;;;; symbol-overlay
(use-package symbol-overlay :ensure t)

;;;;;; theme
;; (use-package solarized-theme :ensure t
;;   :config
;;   (load-theme 'solarized-gruvbox-dark t)
;;   ;; (load-theme 'solarized-gruvbox-light t)
;;   ;; (load-theme 'solarized-dark t)
;;   )
(use-package flatland-theme :ensure t
  :config
  (load-theme 'flatland t))

;; end
