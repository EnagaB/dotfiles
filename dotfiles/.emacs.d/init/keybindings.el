;;;;;; keybindings

;; no-available: C-g, C-i, C-j, C-m, C-[,M-x,C-x,M-:
;;;;;; prefix and map
(defvar  pefPrefix "C-t") (defvar  pefMap (make-sparse-keymap)) ; pef
(defvar  bufPrefix "b"  ) (defvar  bufMap (make-sparse-keymap)) ; buffer
(defvar panePrefix "s"  ) (defvar paneMap (make-sparse-keymap)) ; pane
(defvar  tabPrefix "t"  ) (defvar  tabMap (make-sparse-keymap)) ; tab
(defvar  cmdPrefix "C-t") (defvar  cmdMap (make-sparse-keymap)) ; cmd
;;;;;; define-key function
(defsubst     defkey (key map command) (define-key        map (kbd key) command))
(defsubst globDefkey (key     command) (define-key global-map (kbd key) command))
(defsubst  pefDefkey (key     command) (define-key     pefMap (kbd key) command))
(defsubst  bufDefkey (key     command) (define-key     bufMap (kbd key) command))
(defsubst paneDefkey (key     command) (define-key    paneMap (kbd key) command))
(defsubst  tabDefkey (key     command) (define-key     tabMap (kbd key) command))
(defsubst  cmdDefkey (key     command) (define-key     cmdMap (kbd key) command))
;;;;;; core keybindings
;;                   char:C-p,paragraph:M-p,page:M-v
;;                                ^
;; char:C-b,word:M-b,line:C-a < cursor > char:C-f,word:M-f,line:C-e
;;                                v
;;                   char:C-n,paragraph:M-n,page:C-v
;; backspace:C-h,delete:C-d
(bind-keys* ("C-f" . forward-char        )
            ("C-b" . backward-char       )
            ("C-n" . next-line           )
            ("C-p" . previous-line       )
            ("M-f" . right-word          )
            ("M-b" . left-word           )
            ("M-n" . forward-paragraph   )
            ("M-p" . backward-paragraph  )
            ("C-a" . beginning-of-line   )
            ("C-e" . end-of-line         )
            ("C-v" . scroll-up           )
            ("M-v" . scroll-down         )
            ("C-h" . delete-backward-char)
            ("C-d" . delete-char         ))
;;;;;; importance keybindings
;; tmux prefix
(bind-key* "C-z" 'nil)

(bind-key* "M-c" 'comment-dwim)

;;;;;; prefix keybindings
;; pef
(bind-key* pefPrefix pefMap)
(pefDefkey "f"   'counsel-find-file)
(pefDefkey "g"   'goto-line)
(pefDefkey "q"   'query-replace)
(pefDefkey "S"   'swiper)
(pefDefkey "v"   'set-mark-command)
(pefDefkey "C-v" 'rectangle-mark-mode)
(pefDefkey "p"   'symbol-overlay-put)
(pefDefkey "P"   'symbol-overlay-remove-all)
(pefDefkey "w"   'toggle-truncate-lines)
;; buffer
(pefDefkey bufPrefix bufMap)
(bufDefkey "l" 'ibuffer)
(bufDefkey "d" 'kill-buffer)
(bufDefkey "x" 'kill-buffer)
;; pane
(pefDefkey panePrefix paneMap)
(paneDefkey "h" 'split-window-below)
(paneDefkey "v" 'split-window-right)
(paneDefkey "s" 'other-window)
(paneDefkey "S" 'swap-window)
(paneDefkey "d" 'delete-window)
(paneDefkey "x" 'delete-window)
(paneDefkey "D" 'delete-other-windows)
(paneDefkey "X" 'delete-other-windows)
(paneDefkey "z" 'toggle-split-windows-size)
(defun toggle-split-windows-size()
  (interactive)
  (if (or (not (boundp 'spToggleWinsize))  (= spToggleWinsize 0))
    (progn
      (maximize-window)
      (setq spToggleWinsize 1)
      :)
    (balance-windows)
    (setq spToggleWinsize 0)))

;; tab
(pefDefkey tabPrefix tabMap)
(tabDefkey "c" 'elscreen-create)
(tabDefkey "d" 'elscreen-kill)
(tabDefkey "x" 'elscreen-kill)
(tabDefkey "0" 'elscreen-jump-0)
(tabDefkey "1" 'elscreen-jump)
(tabDefkey "2" 'elscreen-jump)
(tabDefkey "3" 'elscreen-jump)
(tabDefkey "4" 'elscreen-jump)
(tabDefkey "5" 'elscreen-jump)
(tabDefkey "6" 'elscreen-jump)
(tabDefkey "7" 'elscreen-jump)
(tabDefkey "8" 'elscreen-jump)
(tabDefkey "9" 'elscreen-jump-9)
;; cmd
(pefDefkey cmdPrefix cmdMap)
(cmdDefkey "m" 'describe-bindings)
(cmdDefkey "M" 'describe-key)
(cmdDefkey "r" 'resource-initfiles)
(defun resource-initfiles()
  (interactive)
  (load-file "~/.emacs.d/init.el")
  (message "resource ~/.emacs.d/init.el"))

;;;;;; other
;; delete/copy/paste
(bind-key* "M-m" 'set-mark-command) ;; instead of C-Spc
(bind-keys* ("C-w" . kill-region   )
            ("M-w" . kill-ring-save)
            ("C-y" . yank          ))
;; counsel.el
(bind-key* "M-x" 'counsel-M-x)
;; pane
(bind-key* "C-o" 'other-window)
;; undo/redo, redo+ (in locelpa)
(require 'redo+)
(bind-key* "M-u" 'undo)
(bind-key* "M-r" 'redo)
;; keyboard macro
(globDefkey "M-a" 'toggle-kbd-macro-recording-on)
(bind-key*  "M-q" 'call-last-kbd-macro)
(defun toggle-kbd-macro-recording-on ()
  (interactive)
  (define-key global-map (this-command-keys) 'toggle-kbd-macro-recording-off)
  (start-kbd-macro nil))
(defun toggle-kbd-macro-recording-off ()
  (interactive)
  (define-key global-map (this-command-keys) 'toggle-kbd-macro-recording-on)
  (end-kbd-macro))

;; end
