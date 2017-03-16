if g:colors_name == 'desert' 
    hi visual ctermfg=20
    hi matchparen ctermfg=red ctermbg=none
    hi comment ctermfg=242
    hi normal  guifg=#BBBBBB guibg=#162428
    hi nontext  guibg=#162428
    hi cursorline cterm=NONE ctermbg=17 guibg=Grey24 
    hi folded ctermfg=darkyellow ctermbg=none guibg=Grey24
    hi ToDo ctermfg=red ctermbg=white

    hi Keyword ctermfg=12
    hi Search ctermfg=black
    "hi Preproc ctermfg=14
    "hi Special ctermfg=13
    hi SyntasticWarning      ctermbg=yellow ctermfg=black
    hi SyntasticStyleWarning ctermbg=yellow ctermfg=black
endif

if g:colors_name == 'solarized'
    hi Folded cterm=NONE ctermbg=NONE ctermfg=95
    "hi normal ctermfg=247
    "hi LineNr ctermbg=235
    hi CursorLineNr ctermfg=142
    hi Comment ctermfg=232
    hi Special ctermfg=67 guifg=palegreen3
    hi ErrorMsg cterm=none ctermbg=88 ctermfg=15
endif
