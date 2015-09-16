"hi MatchParen ctermfg=black ctermbg=lightmagenta
hi MatchParen ctermfg=yellow ctermbg=black

function! <SID>ExecCurrentBuffer()
    :stopinsert
    if &modified
        :w!
    endif
    :exe '! ~/bin/clj '.expand("%:p")
endf

command! ExecCurrentBuffer -nargs 0 :call <SID>ExecCurrentBuffer()<cr>

nmap <F5> :call <SID>ExecCurrentBuffer()<cr>
imap <F5> <esc><F5>

imap <buffer> ( ()<left>
imap <buffer> [ []<left>
imap <buffer> { {}<left>
