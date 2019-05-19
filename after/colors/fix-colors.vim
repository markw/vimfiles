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
    hi normal ctermfg=247
    "hi LineNr ctermbg=235
    hi CursorLineNr ctermfg=142
    hi MatchParen ctermfg=142 ctermbg=NONE
    hi Comment ctermfg=242
    hi Special ctermfg=67 guifg=palegreen3
    hi ErrorMsg cterm=none ctermbg=88 ctermfg=15
    hi PreProc guifg=darkyellow
endif

if g:colors_name == 'codedark'
    hi Folded cterm=NONE ctermbg=NONE ctermfg=66
endif

if g:colors_name == 'basic-dark'
    hi Normal guibg=#1A2020
endif

if g:colors_name == 'oceandeep'
    hi normal guibg=#081620
    hi nontext guibg=#081620
    hi cursorline cterm=NONE
    hi MatchParen guifg=yellow guibg=bg cterm=none
    hi Comment guifg=#808080
"    hi CursorLineNr  ctermfg=White  ctermbg=19    cterm=None  guifg=White    guibg=#005faf
"    hi special ctermfg=30
"    hi keyword ctermfg=31
"    hi identifier ctermfg=28
endif

if g:colors_name == 'pablo'
    hi CursorLineNr  ctermfg=White  ctermbg=22    cterm=None  guifg=White    guibg=#005faf
    hi cursorline cterm=NONE ctermbg=233
    hi LineNr  ctermfg=243  ctermbg=None    cterm=None
    hi MatchParen ctermfg=226 ctermbg=none term=bold
endif

