;;;;;; mode

;; fortran
(add-hook 'fortran-mode-hook (lambda() (load "fortran-mh.el")))
;; enhanced f90 mode:ef90-mode
;; (use-package ef90
;;   :mode (("\\.f90" . ef90-mode))
;;   :init (add-hook 'ef90-mode-hook (lambda() (load "ef90-mh.el"))))
;; tex
(add-hook 'tex-mode-hook (lambda() (load "latex-mh.el")))

;; end
