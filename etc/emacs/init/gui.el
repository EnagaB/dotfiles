;;;;;; gui

(when window-system
  ;; default size
  (add-to-list 'default-frame-alist '(width  . 80))
  (add-to-list 'default-frame-alist '(height . 40))
  ;; font
  ;; (add-to-list 'default-frame-alist '(font . "Myrica M-13.5"))
  (add-to-list 'default-frame-alist '(font . "HackGenNerd Console-12"))
  ;; bar
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  ;; transparency
  ;; (set-frame-parameter nil 'alpha '50)
  )

;; end
