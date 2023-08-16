;; sourced in fortran-mode-hook

;; abbrev-mode
(setq abbrev-mode t)
(setq abbrev-file-name "~/.emacs.d/abbrev-defs/table")
(setq save-abbrevs 'silently)
;; hs-minor-mode
;; A ~ endA region collapse
(hs-minor-mode 1)
;; (quietly-read-abbrev-file)
;; compile + execute
(define-key fortran-mode-map "\C-c\C-p" (kbd "M-! ./fca.sh &"))
;; fortran command unset
(define-key fortran-mode-map "\C-c\C-r" nil) ; window-resizer   
;; --- abbrev-mode-list (default + my def) ---
;; extend command C-q
(define-abbrev-table 'fortran-mode-abbrev-table 
                     '(
                       (";opd"   "!$omp parallel do" nil 0)
                       (";oepd"  "!$omp end parallel do" nil 0)
                       (";opv"   "!$omp&private()" nil 0)
                       (";ord"   "!$omp&reduction(:)" nil 0)
                       (";pi" "real *8 :: pi ; parameter (pi=3.1415926535897932384626433832795d0)" nil 0)
                       (";zi" "complex *16 :: zi ; parameter (zi=(0.0d0,1.0d0))" nil 0)
                       ))
;; -------------------------------------------
;; --- font-lock-keywords --------------------
;; (font-lock-add-keywords nil
(font-lock-add-keywords 'fortran-mode
                        '(("dimag" . 'font-lock-builtin-face)
                          ("dconjg" . 'font-lock-builtin-face)
                          ("cdabs" . 'font-lock-builtin-face)
                          ("cdexp" . 'font-lock-builtin-face)
                          ))
;; -------------------------------------------
;; do-loop indent : def 3
(setq fortran-do-indent 3)
;; if indent : def 3
(setq fortran-if-indent 3)
;; else indent : def 3
(setq fortran-else-indent 3)
;; elseif indent : def 3
(setq fortran-elseif-indent 3)
;; continuation line indent : def 5
(setq fortran-continuation-indent 3)
;; comment-out
(setq fortran-comment-region "!")
;; continuation line word
; (setq fortran-continuation-string "$")
(setq fortran-continuation-string "&")
;; comment indent
(setq fortran-comment-indent-style 'relative)
(setq fortran-comment-line-extra-indent 0)
;; blink-match
(setq fortran-blink-matching-do 'nil)
(setq fortran-blink-matching-if 'nil)
;;=========;;
;; company ;;
;;=========;;
;; complete - company-keywords.el only
(setq company-backends `(company-keywords))
;; word change
(setq company-keywords-alist
      `(
        (fortran-mode .
                      ;; ".AND." ".GE." ".GT." ".LT." ".LE." ".NE." ".OR." ".TRUE." ".FALSE."
                      ,(company-keywords-upper-lower
                         "program" "end program" "subroutine" "end subroutine" "return" "stop"
                         ;; dec
                         "implicit none" "integer :: " "real *8 :: " "complex *16 :: "
                         "character" "parameter"
                         ;; exe
                         "do" "enddo" "exit" "if" "else" "elseif" "endif" "then" "cycle" 
                         "goto" "continue"
                         "call" "print"
                         ;; file
                         "open(unit=,file=)" "close(unit=)" "write(unit=,fmt=)" "read(unit=,fmt=*)" 
                         "rewind" "backspace"
                         ;; openmp
                         "!$omp parallel do" "!$omp end parallel do"
                         "!$omp&private()" "!$omp&reduction(:)"
                         ;; math function
                         "mod" "dble" "int" "dint"
                         "dcos" "dsin" "dtan"
                         "dsqrt" "dlog" "dimag" "dconjg" "cdabs" "cdexp"
                         "max" "min" 
                         ))))

;; end
