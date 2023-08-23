if g:CONFIG['auto_completion_condition']
    call ddc#custom#patch_global('completionMenu', 'pum.vim')
    call ddc#custom#patch_global('sources', [
                \ 'around',
                \ 'vim-lsp',
                \ 'file'
                \ ])
    call ddc#custom#patch_global('sourceOptions', {
                \ '_': {
                \   'matchers': ['matcher_head'],
                \   'sorters': ['sorter_rank'],
                \   'converters': ['converter_remove_overlap'],
                \ },
                \ 'around': {'mark': 'Around'},
                \ 'vim-lsp': {
                \   'mark': 'LSP', 
                \   'matchers': ['matcher_head'],
                \   'forceCompletionPattern': '\.|:|->|"\w+/*'
                \ },
                \ 'file': {
                \   'mark': 'file',
                \   'isVolatile': v:true, 
                \   'forceCompletionPattern': '\S/\S*'
                \ }})
    call ddc#enable()
endif