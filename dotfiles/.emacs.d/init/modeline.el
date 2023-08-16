;; modeline

;; change showing CR-code-name
(set 'eol-mnemonic-dos "-dos")
(set 'eol-mnemonic-unix "-unix")
(set 'eol-mnemonic-mac "-mac")
(set 'eol-mnemonic-undecided "-?")

;; set mode-line
(setq-default mode-line-format
              '(
                " %b " mode-line-modified " "
                "%p " "%3l:%2c "
                "%e " "["default-directory"] "
                mode-line-mule-info " "
                mode-name
                ))

;; end
