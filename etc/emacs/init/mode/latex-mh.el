;; tex/latex/TeX/LaTeX-mode-hook

;;   ;; Force tex map
;; (bind-keys*
;;   ;; tex to pdf
;;   ("C-c C-c" . enaga-tex-shellpop-tex-to-pdf)
;;   ;; other-window revert
;;   ("C-c C-p" . enaga-tex-other-window-revert))
;; ;; tex map
;; (bind-keys :map LaTeX-mode-map
;;            ;; ;; tex to pdf
;;            ;; ("C-c C-c" . enaga-tex-shellpop-tex-to-pdf)
;;            ;; ;; other-window revert
;;            ;; ("C-c C-p" . enaga-tex-other-window-revert)
;;            ;; template insert
;;            ("C-c t a" . enaga-tex-insert-align)
;;            ("C-c t A" . enaga-tex-insert-alignat)
;;            ("C-c t c" . enaga-tex-insert-cases)
;;            ("C-c t f" . enaga-tex-insert-figure)
;;            ("C-c t F" . enaga-tex-insert-wrapfigure)
;;            ("C-c t s" . enaga-tex-insert-subequations)
;;            ("C-c t T" . enaga-tex-insert-wraptable)
;;            ;; ("C-c t c" . )
;;            ;; math
;;            ("C-c m w" . enaga-tex-insert-math-contline)
;;            ;; ("C-c t c" . )
;;            ;; line
;;            ("C-c l a" . enaga-tex-insert-editline)
;;            )

;;;;;; keybindings
(defvar texinsPrefix "i") (defvar texinsMap (make-sparse-keymap))
(defsubst texinsDefkey (key command) (define-key texinsMap (kbd key) command))
(pefDefkey texinsPrefix texinsMap)
(texinsDefkey "b" '(lambda () (interactive) (e-latex-insert-begin-end-block "")))
(texinsDefkey "a" '(lambda () (interactive) (e-latex-insert-begin-end-block "align")))

;; function: insert begin/end block
(defun e-latex-insert-begin-end-block (string)
  (interactive)
  (if (= (length string) 0)
      (setq string (read-from-minibuffer "begin/end command: ")))
  (insert "\\begin{" string  "}")
  (newline)
  (insert "\\end{" string "}")
  (previous-line 1)
  (move-end-of-line nil))



;; ;; tex to pdf
;; (setq enaga-TeX-shell-name "lts.sh")
;; (defun enaga-tex-shellpop-tex-to-pdf ()
;;   "compile tex, use shell-pop.el and my-shell"
;;   (interactive)
;;   (shell-pop nil)
;;   (insert "./" enaga-TeX-shell-name)
;;   (comint-send-input)
;;   (comint-delchar-or-maybe-eof nil))
;; ;; other-window revert
;; (defun enaga-tex-other-window-revert ()
;;   "other-window 1, revert-buffer-no-confirm, other-window 1"
;;   (interactive)
;;   (other-window 1)
;;   (revert-buffer-no-confirm)
;;   (other-window 1))
;; ;;====================;;
;; ;; template
;; ;;====================;;
;; (defun enaga-TeX-ret-tab (arg)
;;   "RET + TAB in auctex LaTeX-mode"
;;   (interactive)
;;   ;;==============;;
;;   (setq count 1)
;;   (while (<= count arg)
;;          (TeX-newline)
;;          (indent-for-tab-command)
;;          (setq count (1+ count))))
;; (defun enaga-latex-tab-downarg-tab (arg)
;;   "RET + TAB in auctex LaTeX-mode"
;;   (interactive)
;;   ;;==============;;
;;   (indent-for-tab-command)
;;   (setq count 1)
;;   (while (<= count arg)
;;          (next-line 1)
;;          (indent-for-tab-command)
;;          (setq count (1+ count))))
;; (defun enaga-TeX-begin-end-template (arg)
;;   ;; \begin{arg}
;;   ;;   (cursur)
;;   ;; \end{arg}
;;   "insert template begin/end{align} in auctex LaTeX-mode"
;;   (interactive)
;;   ;;==============;;
;;   (insert "\\begin{" arg "}")
;;   (TeX-newline)
;;   (TeX-newline)
;;   (insert "\\end{" arg "}")
;;   (previous-line 2)
;;   (enaga-latex-tab-downarg-tab 2)
;;   (previous-line 1)
;;   (move-end-of-line nil))
;; (defun enaga-latex-ret-ins (arg)
;;   (interactive)
;;   "RET + insert arg"
;;   (TeX-newline)
;;   (insert arg)
;;   (indent-for-tab-command))
;; ;; align
;; (defun enaga-tex-insert-align ()
;;   "e-tex , insert align"
;;   (interactive)
;;   (enaga-TeX-begin-end-template "align"))
;; ;; alignat
;; (defun enaga-tex-insert-alignat ()
;;   "e-tex , insert alignat"
;;   (interactive)
;;   (enaga-TeX-begin-end-template "alignat")
;;   (previous-line 1)
;;   (move-end-of-line nil)
;;   (insert "{}")
;;   (next-line 1)
;;   (move-end-of-line nil))
;; ;; cases
;; (defun enaga-tex-insert-cases ()
;;   "e-tex , insert cases"
;;   (interactive)
;;   (enaga-TeX-begin-end-template "cases"))
;; ;; subequations
;; (defun enaga-tex-insert-subequations ()
;;   "e-tex , insert subequations"
;;   (interactive)
;;   (enaga-TeX-begin-end-template "subequations"))
;; ;; figure
;; (defun enaga-tex-insert-figure ()
;;   "e-tex , insert figure"
;;   (interactive)
;;   (enaga-TeX-begin-end-template "figure")
;;   (previous-line 1)
;;   (move-end-of-line nil)
;;   (insert "[htbp]")
;;   (next-line 1)
;;   (indent-for-tab-command)
;;   (insert "\\centering")
;;   (enaga-TeX-ret-tab 1)
;;   (insert "\\includegraphics[]{}")
;;   (enaga-TeX-ret-tab 1)
;;   (insert "\\caption{}")
;;   (enaga-TeX-ret-tab 1)
;;   (insert "\\label{fg:}")
;;   (previous-line 2)
;;   (move-end-of-line nil)
;;   (backward-char 3))
;; ;; wrapfigure
;; (defun enaga-tex-insert-wrapfigure ()
;;   "e-tex , insert wrapfigure"
;;   (interactive)
;;   (enaga-TeX-begin-end-template "wrapfigure")
;;   (previous-line 1)
;;   (move-end-of-line nil)
;;   (insert "[htbp]")
;;   (next-line 1)
;;   (indent-for-tab-command)
;;   (previous-line 1)
;;   (move-end-of-line nil)
;;   (insert "{}{}")
;;   (next-line 1)
;;   (indent-for-tab-command)
;;   (insert "\\centering")
;;   (enaga-TeX-ret-tab 1)
;;   (insert "\\includegraphics[]{}")
;;   (enaga-TeX-ret-tab 1)
;;   (insert "\\caption{}")
;;   (enaga-TeX-ret-tab 1)
;;   (insert "\\label{fg:}")
;;   (previous-line 4)
;;   (move-end-of-line nil)
;;   (backward-char 3))
;; ;; wraptable
;; (defun enaga-tex-insert-wraptable ()
;;   "e-tex , insert wraptable"
;;   (interactive)
;;   (enaga-TeX-begin-end-template "wraptable")
;;   (previous-line 1)
;;   (move-end-of-line nil)
;;   (insert "{}{}")
;;   (next-line 1)
;;   (move-end-of-line nil)
;;   (insert "\\centering")
;;   (enaga-latex-ret-ins "\\begin{tabular}")
;;   (enaga-latex-ret-ins "\\end{tabular}")
;;   (enaga-latex-ret-ins "\\caption{}")
;;   (enaga-latex-ret-ins "\\label{}")
;;   (previous-line 4)
;;   (enaga-latex-tab-downarg-tab 4)
;;   (previous-line 5)
;;   (move-end-of-line nil)
;;   (backward-char 3))
;; ;;======;;
;; ;; math ;;
;; ;;======;;
;; (defun enaga-tex-insert-math-contline ()
;;   "tab + nonumber + continuation-line"
;;   (interactive)
;;   (indent-for-tab-command)
;;   (insert " \\nonumber \\\\")
;;   (TeX-newline))
;; ;;======;;
;; ;; line ;;
;; ;;======;;
;; (defun enaga-tex-insert-editline ()
;;   "insert editline"
;;   (interactive)
;;   (insert "AAA Editline Begin \\\\ \\\\ \\\\ \\\\ \\\\ AAA Editline End"))
;; ;; comment-out
;; ;; (setq latex-comment-or-uncomment-region "%")
;; ;; complete - company-keywords.el only
;; (setq company-backends `(company-keywords))
;; ;; word change (non-working ?)
;; (setq company-keywords-alist
;;       `(
;;         ;; (LaTeX-mode
;;         (latex-mode ;; why ? tex-mode ) latex-mode ) LaTeX-mode ?
;;           ;; use-package,auctex-init. non-LaTeX-mode
;;           ;; maked by Enaga
;;           ;; === begin-end ===
;;           ;; "begin{}" "end{}"
;;           ;; "document" "center" "align" "alignat" "subequations"
;;           ;; "figure" "wrapfigure"
;;           "thebibliography" "itemize" "enumerate"
;;           ;; === math ===
;;           "sum_{}" "dag" "bar{}" "hat{}" "braket{}" "bra{}" "ket{}"
;;           ;; "uparrow" "downarrow" "rightarrow" "leftarrow"
;;           "frac{}{}" "cdots" "vdots" "ddots" "array" "times"
;;           "quad" "qquad"
;;           ;; === other{}, [] ===
;;           ;; "documentclass[]{}"
;;           ;; "usepackage{}"
;;           "section{}" "subsection{}" "subsubsection{}"
;;           "newcommand{}{}" "renewcommand{}{}"
;;           "color{}"
;;           "label{}" "ref{}" "eqref{}"
;;           "vspace{}" "hspace{}" "vspace*{}" "hspace*{}"
;;           "includegraphics[]{}" "caption{}"
;;           ;; === greek letters ===
;;           "alpha" "beta" "gamma" "Gamma" "delta" "Delta" "epsilon" "varepsilon"
;;           "zeta" "theta" "vartheta" "Theta" "kappa" "lambda" "Lambda" "sigma" "Sigma"
;;           "varphi" "chi" "omega" "Omega"
;;           ;; other
;;           "tableofcontents" "nonumber" "centering" "par" "appendix" "newpage"
;;           "bibitem{}" "cite{}"
;;           ;; === my-def ===
;;           "vt{}"
;;           ;; "pp{}{}"
;;           "mrm{}" "mca{}" "dif{}{}" "pdif{}{}" "fdif{}{}" "intg{}{}{}"
;;           "refeq{}" "reffg{}" "reftb{}" "etal" "ql{}"
;;           "abs{}" "absl{}" "absr{}"
;;           "spa{}" "spal{}" "spar{}"
;;           "bpa{}" "bpal{}" "bpar{}"
;;           "lpa{}" "lpal{}" "lpar{}"
;;           )))

;; end
