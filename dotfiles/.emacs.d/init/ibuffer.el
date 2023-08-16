;; ibuffer

(add-hook 'ibuffer-hook
          (lambda ()
            (ibuffer-vc-set-filter-groups-by-vc-root)
            (unless (eq ibuffer-sorting-mode 'alphabetic)
              (ibuffer-do-sort-by-alphabetic))))

(define-ibuffer-column
  coding
  (:name " coding ")
  (if (coding-system-get buffer-file-coding-system 'mime-charset)
      (format " %s" (coding-system-get buffer-file-coding-system 'mime-charset))
    " undefined"
    ))

(setq ibuffer-formats
      '((mark modified read-only
              (coding 10 10) " "
              (name 45 45) " "
              (size 10 -1) " "
              (mode 16 16) " "
              filename)
        (mark (coding 15 15) " "
              (name 30 -1) " "
              filename)))

;; end
