" show syntax information under cursor
" cohama, http://cohama.hateblo.jp/entry/2013/08/11/020849
function! syntax_cmds#ShowSyntaxInfo()
    let baseSyn = s:show_syntax_attr(s:show_syntax_id(0))
    echo "name: " . baseSyn.name .
                \ " ctermfg: " . baseSyn.ctermfg .
                \ " ctermbg: " . baseSyn.ctermbg .
                \ " guifg: " . baseSyn.guifg .
                \ " guibg: " . baseSyn.guibg
    let linkedSyn = s:show_syntax_attr(s:show_syntax_id(1))
    echo "link to"
    echo "name: " . linkedSyn.name .
                \ " ctermfg: " . linkedSyn.ctermfg .
                \ " ctermbg: " . linkedSyn.ctermbg .
                \ " guifg: " . linkedSyn.guifg .
                \ " guibg: " . linkedSyn.guibg
endfunction

function! s:show_syntax_id(transparent)
    let synid = synID(line("."), col("."), 1)
    if a:transparent
        return synIDtrans(synid)
    else
        return synid
    endif
endfunction

function! s:show_syntax_attr(synid)
    let name = synIDattr(a:synid, "name")
    let ctermfg = synIDattr(a:synid, "fg", "cterm")
    let ctermbg = synIDattr(a:synid, "bg", "cterm")
    let guifg = synIDattr(a:synid, "fg", "gui")
    let guibg = synIDattr(a:synid, "bg", "gui")
    return {
                \ "name": name,
                \ "ctermfg": ctermfg,
                \ "ctermbg": ctermbg,
                \ "guifg": guifg,
                \ "guibg": guibg}
endfunction
